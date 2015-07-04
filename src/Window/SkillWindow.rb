#coding: utf-8
class SkillWindow < DragWindow
  def initialize
    win_x,win_y=100,100
    win_w,win_h=300,200
    super(win_x,win_y,win_w,win_h)
    
    skeleton_initialize
    title_initialize('角色技能')
    
    @box_w=@box_h=24
    @box_border_w=@box_border_h=26
    
    @comment='滑鼠左鍵: 選擇技能, ctrl+按鍵:設定快捷鍵'
    @comment_pic=Font.render_texture(@comment,12,*Color[:comment])
    
    gen_skeleton_texture
  end
  def start_init
    @skill=Game.player.skill
    click_box=@click_skill=nil
  end
  def interact
    Event.each{|event|
      case event
      when Event::KeyDown
        case key=event.sym
        when Key::LCTRL,Key::RCTRL
          HotKey.bind_mode=true
        else
          bind_skill(event.sym)
        end
      when Event::MouseButtonDown
        case event.button
        when Mouse::BUTTON_LEFT
          if click_on_skill?(event.x,event.y)
            @click_box=(event.x-@win_x-@border)/@box_border_w
          else
            @click_box=@click_skill=nil
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
private
  def bind_skill(sym)
    HotKey.bind_mode and
    @click_skill and
    @skill[@click_skill].can_bind? and
    HotKey.can_bind?(sym) and
    HotKey.bind(sym,@skill[@click_skill].type,:repeat,@click_skill)
  end
  def click_on_skill?(x,y)
    (x-@win_x-@border)/@box_border_w<@skill.size&&
    (y-@win_y-24).between?(0,@box_h-1)
  end
  def draw_comment
    @comment_pic.draw(@win_x+@border,@win_y+@win_h-25)
  end
  def draw_box
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
  end
  def draw_click_skill
    skill=@skill[@click_skill]
    skill.invisible and return
    x=skill.draw_name(@win_x+@border,@win_y+85)[0]
    skill.draw_cd(@win_x+@border+x,@win_y+85)
    skill.draw_comment(@win_x+@border,@win_y+100)
  end
  def draw_click_box(skill,draw_x,draw_y)
    skill.draw_click_back(draw_x,draw_y)
    # @hotkey_set=
    return draw_x+@box_border_w
  end
  def draw_unclick_box(skill,draw_x,draw_y)
    skill.draw_back(draw_x,draw_y)
    return draw_x+@box_border_w
  end
public
  def close
    super
    @click_box=@click_skill=nil
  end
  def draw
    super
    draw_comment
    draw_box
    @click_skill and draw_click_skill
  end
end