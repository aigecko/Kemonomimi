#coding: utf-8
class ButtonWindow < BaseWindow
  def initialize
    win_w,win_h=197,50
    win_x=Game.Width-win_w
    win_y=Game.Height-win_h
    super(win_x,win_y,win_w,win_h)
    @icons_name=[:status,:item,:skill,:equip,:save,:tool]
    @icons_draw_x=[]
    @icons_name.size.times{|i|
      @icons_draw_x[i]=@win_x+@border+i*30+2
    }
    @icons_draw_y=@win_y+@border+2
    @icons=Input.load_window_icon_pic
    
    @select=nil
    @click=false
  end
  def start_init
  end
  def interact
    Event.each{|event|
      case event
      when Event::MouseMotion
        detect_mouse_motion
      when Event::MouseButtonDown
        detect_mouse_motion
        case event.button
        when SDL::Mouse::BUTTON_LEFT
          @select or next
          @click=true
          case @icons_name[@select]
          when :status
            switch_window(:StatusWindow)
          when :item
            switch_window(:ItemWindow)
          when :skill
            switch_window(:SkillWindow)
          when :equip
            switch_window(:EquipWindow)
          when :save
          when :tool
          end
        end
      when Event::MouseButtonUp
        case event.button
        when SDL::Mouse::BUTTON_LEFT
          @click=false
        end
      end
    }
  end
  def switch_window(name)
    Game.window(:GameWindow).switch_window(name)
  end
  def detect_mouse_motion
    x,y,* =SDL::Mouse.state
    icon_w=24
    icon_h=24
    for i in 0..@icons.size-1
      if y.between?(@icons_draw_y,@icons_draw_y+icon_w)&&
         x.between?(@icons_draw_x[i],@icons_draw_x[i]+icon_h)
        @select=i
        return
      end
    end
    @select=nil
  end
  def draw_select
    @select or return
    draw_up=@icons_draw_y-1
    draw_left=@icons_draw_x[@select]-1
    rect_w=rect_h=26
    draw_down=draw_up+rect_h
    draw_right=draw_left+rect_w
    if @click
      color_up_left=Color[:icon_dark]
      color_down_right=Color[:icon_light]
    else
      color_up_left=Color[:icon_light]
      color_down_right=Color[:icon_dark]
    end
    Screen.draw_line(draw_left,draw_up,draw_right,draw_up,color_up_left)
    Screen.draw_line(draw_left,draw_up,draw_left,draw_down,color_up_left)
    Screen.draw_line(draw_left,draw_down,draw_right,draw_down,color_down_right)
    Screen.draw_line(draw_right,draw_down,draw_right,draw_up,color_down_right)    
  end
  def draw
    draw_corner(:clear)
    super
    draw_select
    @icons_name.each_with_index{|name,i|
      @icons[name].draw(@icons_draw_x[i],@icons_draw_y)
    }
  end
end