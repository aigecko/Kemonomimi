#coding: utf-8
class LoadWindow < BaseWindow
  def initialize
    win_w=Game.Width
    win_h=Game.Height
    win_x=0
    win_y=0
    super(win_x,win_y,win_w,win_h)
    @text=Font.render_solid('施工中',20,255,255,255)
  end
  def interact
    Event.each{|event|
      case event
      when Event::KeyDown
        case event.sym
        when SDL::Key::RETURN,SDL::Key::SPACE
          unless @stop
            @stop=true
            return
          end
        when SDL::Key::RSHIFT,SDL::Key::LSHIFT
          unless @stop
            @stop=true
            return
          end
          close
          Game.set_window(:MenuWindow,:open)
        end    
      when Event::KeyUp
        case event.sym
        when SDL::Key::RETURN,SDL::Key::SPACE
          @stop=true
        end
      end
    }
  end
  def draw
    super
    @text.draw(10,10)
  end
end
