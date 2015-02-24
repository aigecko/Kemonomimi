#coding:utf-8
module MEvent
  KeyDown=SDL::Event::KeyDown
  KeyUp=SDL::Event::KeyUp
  MouseMotion=SDL::Event::MouseMotion
  MouseButtonDown=SDL::Event::MouseButtonDown
  MouseButtonUp=SDL::Event::MouseButtonUp
  Quit=SDL::Event::Quit
end
class Event
  include MEvent
  def self.init
    @event={
      KeyDown: [],
      KeyUp: [],
      MouseMotion: [],
      MouseButtonDown:[ ],
      MouseButtonUp: [],
      Quit: []
    }
    @event=[]
  end
  def self.poll
    @event.clear
    begin
      event=SDL::Event.poll
      @event<<event
    end while event
  end
  def self.each
    @event.each{|e| yield e}
  end
  def self.[](sym)
    @event.each{|e|
      eval("e.instance_of?(SDL::Event::#{sym}) and return true")
    }
    return false
  end
end