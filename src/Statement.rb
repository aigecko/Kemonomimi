#coding: utf-8
class Statement
  attr_reader :attrib,:sym,:multi,:num_limit,:negative
  @@border_box=Rectangle.new(0,0,26,26,Color[:statement_border])
  @@back_box=Rectangle.new(0,0,24,24,Color[:statement_back])
  @@name_back_box=Rectangle.new(0,0,0,15,Color[:statement_name_back])
  @@marshal_table={
    :n=>:@name,:s=>:@sym,
    :i=>:@icon_string,:a=>:@attrib,
    :ea=>:@effect_amp,:e=>:@effect,
    :iv=>:@interval,:mu=>:@multi,
    :nl=>:@num_limit,:mk=>:@magicimu_keep,
    :ne=>:@negative
  }
  def initialize(caster,info)
    @caster=caster
    
    @name=info[:name]
    @sym=info[:sym]
    
    info[:icon] and @icon=Icon.load(info[:icon])
    @icon_string=info[:icon]
    
    @attrib=info[:attrib]
    @effect=info[:effect]
    @effect_amp=info[:effect_amp]||1
    @interval=info[:interval]
    
    @multi=info[:multi]
    @num_limit=info[:num_limit]
    
    @start_time=Game.get_ticks
    @last_time=info[:last]
    @last_time and @end_time=@start_time+@last_time
    
    @magicimu_keep=info[:magicimu_keep]
    @negative=info[:negative]
  end
  def refresh
    @end_time=Game.get_ticks+@last_time
  end
  def update(actor)
    @effect or return
    @effect.affect(actor,actor.position,@effect_amp)
  end
  def keep_when_magicimmunity?
    @magicimu_keep
  end
  def tough_compute(tough)
    @last_time-=@last_time*tough/100
    @last_time<0 and @last_time=0
  end
  def end?
    return @last_time&&@end_time<Game.get_ticks
  end
  def draw_icon(x,y,mx,my)
    @icon or return false
    @@border_box.draw_at(x-1,y-1)
    @@back_box.draw_at(x,y)
    @icon.draw(x,y)
    draw_name(x,y,mx,my)
  end
  def draw_name(x,y,mx,my)
    @name and (mx.between?(x,x+24)&&my.between?(y,y+24)) or return 
    font=Font.render_texture(@name,15,*Color[:statement_name_font])
    @@name_back_box.w=font.w
    @@name_back_box.draw_at(x,y-15)
    font.draw(x,y-15)
  end
  def marshal_dump
    data={}
    data[:c]=Map.find_actor(@caster)
    data[:st]=@start_time-Game.saving_time
    @end_time and data[:et]=@end_time-Game.saving_time
    @last_time and data[:lt]=@last_time-Game.saving_time

    @@marshal_table.each{|abbrev,sym|
      var=instance_variable_get(sym) and
      data[abbrev]=var
    }
    return [data]
  end
  def marshal_load(array)
    data=array[0]
    @caster=Map.load_actor(data[:c])
    @@marshal_table.each{|abbrev,sym|
      var=data[abbrev] and
      instance_variable_set(sym,var)
    }
    data[:i] and @icon=Icon.load(data[:i])
    #dbg
    @start_time
    @end_time
    @last_time
  end
end