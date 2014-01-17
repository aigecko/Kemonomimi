#coding: utf-8
class SkillWindow < DragWindow
  def initialize
    win_x,win_y=100,100
    win_w,win_h=300,200
    super(win_x,win_y,win_w,win_h)
    
    title_initialize('角色技能')
    pic_initialize
    
    @box_w=@box_h=24
    @box_border_w=@box_border_h=26
    
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
        when Key::LCTRL,Key::RCTRL
          HotKey.bind_mode=true
        else
          if HotKey.bind_mode
            @click_skill and
            @hotkey_set and
            HotKey.can_bind?(event.sym) and
            HotKey.bind(event.sym,@skill[@click_skill].type,:repeat,@click_skill)
          end
        end
      when Event::MouseButtonDown
        case event.button
        when Mouse::BUTTON_LEFT
          if (event.x-@win_x-10)/@box_border_w<@skill.size&&
             (event.y-@win_y-24).between?(0,@box_h-1)
            @click_box=(event.x-@win_x-10)/@box_border_w
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
  def close
    super
    @click_box=nil
    @click_skill=nil
  end
  def draw(dst)   
    super(dst)
    def draw
      @skeleton.draw(@win_x,@win_y)
      @comment_pic.draw(@win_x+@border,@win_y+@win_h-25)
      i=0
      draw_x,draw_y=@win_x+@border,@win_y+24
      @skill.each{|sym,skill|
        skill.invisible and next
        if i==@click_box         
          draw_x=draw_click_box(skill,draw_x,draw_y)        
          @click_skill=sym
        else
          draw_x=draw_unclick_box(skill,draw_x,draw_y)
        end
        skill.draw_icon(@win_x+@border+@box_border_w*i,@win_y+24)
        i+=1
      }
      if @click_skill
        skill=@skill[@click_skill]
        x=skill.draw_name(@win_x+@border,@win_y+85)[0]
        skill.draw_cd(@win_x+@border+x,@win_y+85)
        skill.draw_comment(@win_x+@border,@win_y+100)
      end
    end
  end
  def draw_click_box(skill,draw_x,draw_y)
    Screen.fill_rect(draw_x,draw_y,@box_w,@box_h,[255,0,0])
    if [:none,:append,:before,:auto,:attack,:defense,:pf_defense].include?(skill.type)
      @hotkey_set=false
    else
      @hotkey_set=true
    end  
    return draw_x+@box_border_w
  end
  def draw_unclick_box(skill,draw_x,draw_y)
    if [:none,:append,:before,:auto,:attack,:defense,:pf_defense].include?(skill.type)
      Screen.fill_rect(draw_x,draw_y,@box_w,@box_h,[128,128,128])
    else
      Screen.fill_rect(draw_x,draw_y,@box_w,@box_h,[80,128,255])
    end
    return draw_x+@box_border_w
  end
end