#coding: utf-8
class Statement
  attr_reader :attrib,:sym,:multi
  def initialize(caster,info)
    @caster=caster
    
    @name=info[:name]||""
    @sym=info[:sym]
    
	info[:icon] and
    @icon=SDL::Surface.load(info[:icon])
    
    @attrib=info[:attrib]
    @effect=info[:effect]
    @effect_amp=info[:effect_amp]||1
    @interval=info[:interval]
    
    @multi=info[:multi]
    
    @start_time=SDL.get_ticks
    @last_time=info[:last]    
    @last_time and @end_time=@start_time+@last_time
    
    @magicimu_keep=info[:magicimu_keep]
  end
  def update(actor)
    @effect or return    
    @effect.affect(actor,@effect_amp)
  end
  def keep_when_magicimmunity?
    @magicimu_keep
  end
  def end?
    @last_time and
    @end_time<SDL.get_ticks ? true : false
  end
  def draw_icon(x,y)
    @icon or return false
    Screen.fill_rect(x-1,y-1,26,26,Color[:statement_border])
    Screen.fill_rect(x,y,24,24,Color[:statement_back])
    @icon.draw(x,y)
  end
  def draw_name
  end
end