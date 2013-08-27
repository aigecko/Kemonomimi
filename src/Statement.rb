#coding: utf-8
class Statement
  attr_reader :attrib,:sym
  def initialize(caster,info)
    @caster=caster
    
    @name=info[:name]||""
    @sym=info[:sym]
    
    @icon=SDL::Surface.load(info[:icon])
    @attrib=info[:attrib]
    
    @start_time=SDL.get_ticks
    @last_time=info[:last]
    @end_time=@start_time+@last_time     
  end
  def update
  end
  def end?
    @end_time<SDL.get_ticks ? true : false
  end
  def draw_icon(x,y)
    @icon.draw(x,y)
  end
  def draw_name
  end
end