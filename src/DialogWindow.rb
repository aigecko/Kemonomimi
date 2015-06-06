#coding: utf-8
class DialogWindow < DragWindow
  def initialize
    win_w,win_h=640,160
    win_x,win_y=0,320
    super(win_x,win_y,win_w,win_h)
    
    skeleton_initialize
    gen_skeleton_texture
  end
  def start_init
  end
  def interact
    Event.each{|event|
      case event
      when Event::KeyDown
        case event.sym
        when Key::CHECK
          close
        end
      end
    }
  end
  def draw
    super
  end
end