#coding: utf-8
class Statement
  attr_reader :attrib,:sym,:multi,:num_limit,:negative,:flag
  @@BorderBox=Rectangle.new(0,0,26,26,Color[:statement_border])
  @@BackBox=Rectangle.new(0,0,24,24,Color[:statement_back])
  @@NameBackBox=Rectangle.new(0,0,0,15,Color[:statement_name_back])

  @@DefaultEffectAmp=1
  @@EffectInterval=500

  @@FontSize=15
  @@IconSize=24
  
  @@Marshal_table={
    :n=>:@name,:s=>:@sym,
    :i=>:@icon_string,:a=>:@attrib,
    :ea=>:@effect_amp,:e=>:@effect,
    :iv=>:@interval,:mu=>:@multi,
    :nl=>:@num_limit,:mk=>:@magicimu_keep,
    :ne=>:@negative,:f=>@flag
  }
  def initialize(caster,info)
    @caster=caster
    
    @name=info[:name]
    @sym=info[:sym]
    
    info[:icon] and @icon=Input.load_icon(info[:icon])
    @icon_string=info[:icon]
    
    @attrib=info[:attrib]
    @effect=info[:effect]
    @effect_amp=info[:effect_amp]||@@DefaultEffectAmp
    @interval=info[:interval]
    
    @multi=info[:multi]
    @num_limit=info[:num_limit]
    
    @start_time=Game.get_ticks
    @last_time=info[:last]
    @last_time and @end_time=@start_time+@last_time
    @cur_effect_count=0
    if @effect
      @next_affect_time=@start_time
      @total_effect_count=@last_time/@@EffectInterval
      @cur_effect_count=@total_effect_count
    end
    
    @magicimu_keep=info[:magicimu_keep]
    @negative=info[:negative]
    @flag=info[:flag]
    @prev_compute_time=Game.get_ticks
  end
  def refresh
    @end_time=Game.get_ticks+@last_time
  end
  def update(actor)
    tough_compute(actor.attrib[:tough])
    @effect or return
    @next_affect_time<Game.get_ticks or return
    @effect.affect(actor,actor.position,@effect_amp)
    @next_affect_time+=@@EffectInterval
    @cur_effect_count-=1
  end
  def keep_when_magicimmunity?
    return @magicimu_keep
  end
  def tough_compute(tough)
    @last_time or return
    @negative or return
    delta=(Game.get_ticks-@prev_compute_time)*
        tough/
        (100+tough)
    @end_time-=delta
    @last_time-=delta
    @prev_compute_time=Game.get_ticks
  end
  def end?
    if @negative
      return @last_time&&@end_time<Game.get_ticks
    else
      return @last_time&&@end_time<Game.get_ticks&&@cur_effect_count==0
    end
  end
  def draw_icon(x,y,mx,my)
    @icon or return false
    @@BorderBox.draw_at(x-1,y-1)
    @@BackBox.draw_at(x,y)
    @icon.draw(x,y)
    draw_name(x,y,mx,my)
  end
  def draw_name(x,y,mx,my)
    @name and (mx.between?(x,x+@@IconSize)&&my.between?(y,y+@@IconSize)) or return 
    font=Font.render_texture(@name,@@FontSize,*Color[:statement_name_font])
    @@NameBackBox.w=font.w
    @@NameBackBox.draw_at(x,y-@@FontSize)
    font.draw(x,y-@@FontSize)
  end
  def marshal_dump
    data={}
    data[:c]=Map.find_actor(@caster)
    data[:st]=@start_time-Game.saving_time
    @end_time and data[:et]=@end_time-Game.saving_time
    @last_time and data[:lt]=@last_time-Game.saving_time

    @@MarshalTable.each{|abbrev,sym|
      var=instance_variable_get(sym) and
      data[abbrev]=var
    }
    return [data]
  end
  def marshal_load(array)
    data=array[0]
    @caster=Map.load_actor(data[:c])
    @@MarshalTable.each{|abbrev,sym|
      var=data[abbrev] and
      instance_variable_set(sym,var)
    }
    data[:i] and @icon=Input.load_icon(data[:i])
    #dbg
    @start_time
    @end_time
    @last_time
  end
end