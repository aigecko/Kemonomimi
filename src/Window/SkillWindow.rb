#coding: utf-8
class SkillWindow < DragWindow
  def initialize
    win_x,win_y=100,100
    win_w,win_h=300,250
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
          @click_skill=@skill.check_click(event.x-@win_x-@border,event.y-@win_y-@drag_h)
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
  def draw_comment
    @comment_pic.draw(@win_x+@border,@win_y+@win_h-25)
  end
  def draw_click_skill
    skill=@skill[@click_skill]
    skill.invisible and return
    Font.draw_texture("技能說明:",15,@win_x+@border,@win_y+@drag_h+135,0,0,0)
    x=skill.draw_name(@win_x+@border,@win_y+@drag_h+151)[0]
    skill.draw_cd(@win_x+@border+x,@win_y+@drag_h+151)
    skill.draw_comment(@win_x+@border,@win_y+@drag_h+165)
  end
  def draw_click_box(skill,draw_x,draw_y)
    skill.draw_click_back(draw_x,draw_y)
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
    draw_x,draw_y=@win_x+@border,@win_y+24
    @skill.draw(draw_x,draw_y)
    draw_comment
    @click_skill and draw_click_skill
  end
end