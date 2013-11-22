#coding: utf-8
class Statement
  attr_reader :attrib,:sym,:delta_hp
  def initialize(caster,info)
    @caster=caster
    
    @name=info[:name]||""
    @sym=info[:sym]
    
	info[:icon] and
    @icon=SDL::Surface.load(info[:icon])
    @attrib=info[:attrib]
    @delta_hp=info[:delta_hp]||0
    
    @start_time=SDL.get_ticks
    @last_time=info[:last]
    
    @last_time and @end_time=@start_time+@last_time     
  end
  def update
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