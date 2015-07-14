#coding: utf-8
class TransitionWindow < BaseWindow
  def initialize
    @frame=0
    @rect=Rectangle.new(0,0,640,480,[0,0,0])
  end
  def open
    super
    @frame=0
  end
  def interact
    @frame+=1
    if @frame>48
      close
      Game.window(:GameWindow).open_contral
    end
  end
  def draw
    @rect.a=1-@frame/48.0
    @rect.draw
  end
end