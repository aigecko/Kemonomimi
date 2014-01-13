#coding: utf-8
class SkillWindow < DragWindow
  def initialize
    win_x,win_y=100,100
    win_w,win_h=300,200
    super(win_x,win_y,win_w,win_h)
    
    title_initialize('角色技能')
    pic_initialize
  end
  def start_init
    @skill=Game.player.skill
  end
  def interact
    Event.each{|event|
      case event
      when Event::MouseButtonDown
      when Event::MouseMotion
        keep_drag(event.x,event.y)
      when Event::MouseButtonUp
        case event.button
        when SDL::Mouse::BUTTON_LEFT
          end_drag
        when SDL::Mouse::BUTTON_RIGHT
        end
      end
    }
  end
  def draw(dst)   
    super(dst)    
    def draw
      @skeleton.draw(@win_x,@win_y)
      i=0
      @skill.each_value{|skill|
        skill.invisible and next
        skill.draw_icon(@win_x+10,@win_y+32+35*i)
        skill.draw_name(@win_x+40,@win_y+27+35*i)
        skill.draw_comment(@win_x+40,@win_y+42+35*i)
        i+=1
      }
    end
  end
end