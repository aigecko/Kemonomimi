#coding: utf-8
class SkillWindow < DragWindow
  def initialize
    win_x,win_y=100,100
    win_w,win_h=300,200
    super(win_x,win_y,win_w,win_h)
    
    title_initialize('角色技能')
    pic_initialize
    
    @comment='滑鼠左鍵: 選擇技能, ctrl+按鍵:設定快捷鍵'
    @comment_pic=Font.render_solid(@comment,12,*Color[:comment])
  end
  def start_init
    @skill=Game.player.skill
  end
  def interact
    Event.each{|event|
      case event
      when Event::KeyDown
        case key=event.sym
        when Key::LCTRL
          HotKey.bind_mode=true
        else
          if HotKey.bind_mode
            @click_box and
            HotKey.can_bind?(event.sym) and
            HotKey.bind(event.sym,@skill[@click_skill].type,:repeat,@click_skill)
          end
        end
      when Event::MouseButtonDown
        case event.button
        when Mouse::BUTTON_LEFT
          if (event.x-@win_x-10)/26<@skill.size&&
             (event.y-@win_y-24).between?(0,23)
            @click_box=(event.x-@win_x-10)/26
          else
            @click_box=nil
            @click_skill=nil
          end
        when Mouse::BUTTON_RIGHT
        end
      when Event::MouseMotion
        keep_drag(event.x,event.y)
      when Event::MouseButtonUp
        case event.button
        when Mouse::BUTTON_LEFT
          end_drag
        when Mouse::BUTTON_RIGHT
        end
      end
    }
  end
  def draw(dst)   
    super(dst)
    def draw
      @skeleton.draw(@win_x,@win_y)      
      @comment_pic.draw(@win_x+@border,@win_y+@win_h-25)
      i=0
      @skill.each{|sym,skill|
        skill.invisible and next
        if i==@click_box
          case skill.type
          when :none,:append,:before,:auto,:attack
            Screen.fill_rect(@win_x+@border+26*i,@win_y+24,24,24,[128,128,128])
            @click_box=nil
            @click_skill=nil
          else
            Screen.fill_rect(@win_x+@border+26*i,@win_y+24,24,24,[255,0,0])
            @click_skill=sym
          end
        else
          case skill.type
          when :none,:append,:before,:auto,:attack
            Screen.fill_rect(@win_x+@border+26*i,@win_y+24,24,24,[128,128,128])
          else
            Screen.fill_rect(@win_x+@border+26*i,@win_y+24,24,24,[80,128,255])
          end
        end
        skill.draw_icon(@win_x+@border+26*i,@win_y+24)
        #skill.draw_name(@win_x+40,@win_y+27+35*i)
        #skill.draw_comment(@win_x+40,@win_y+42+35*i)
        i+=1
      }
    end
  end
end