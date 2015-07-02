#coding: utf-8
class HintWindow < BaseWindow
  def initialize
    win_w,win_h=100,300
    win_x,win_y=10,150
    super(win_x,win_y,win_w,win_h)
    
    @font_size=12
    @wait_time=5.to_sec
    @buff_show=10
    
    @buff=[]
  end
  def start_init
  end
  def add(string)
    @timer=Game.get_ticks+@wait_time
    @buff<<ColorString.new(string,@font_size,[255,255,255])
    open
  end
  def interact
    @timer and
    @timer<Game.get_ticks and close
  end
  def draw
    @buff.last(@buff_show).each_with_index{|color_string,i|
      color_string.draw(@win_x,@win_y+@font_size*i)
    }
  end
end