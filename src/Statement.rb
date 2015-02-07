#coding: utf-8
class Statement
  attr_reader :attrib,:sym,:multi,:num_limit,:negative
  @@border_box=Rectangle.new(0,0,26,26,Color[:statement_border])
  @@back_box=Rectangle.new(0,0,24,24,Color[:statement_back])
  def initialize(caster,info)
    @caster=caster
    
    @name=info[:name]||""
    @sym=info[:sym]
    
    info[:icon] and @icon=Icon.load(info[:icon])
    
    @attrib=info[:attrib]
    @effect=info[:effect]
    @effect_amp=info[:effect_amp]||1
    @interval=info[:interval]
    
    @multi=info[:multi]
    @num_limit=info[:num_limit]
    
    @start_time=SDL.get_ticks
    @last_time=info[:last]    
    @last_time and @end_time=@start_time+@last_time
    
    @magicimu_keep=info[:magicimu_keep]
    @negative=info[:negative]
  end
  def refresh
    @end_time=SDL.get_ticks+@last_time
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
    return @last_time&&@end_time<SDL.get_ticks
  end
  def draw_icon(x,y)
    @icon or return false
    @@border_box.draw_at(x-1,y-1)
    @@back_box.draw_at(x,y)
    @icon.draw(x,y)
  end
  def draw_name
  end
end