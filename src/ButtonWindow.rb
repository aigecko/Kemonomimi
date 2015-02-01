#coding: utf-8
class ButtonWindow < BaseWindow
  class Button
    @@icon_w=@@icon_h=24
    @@rect_w=@@rect_h=26
    def initialize(icon,x,y)
      @icon,@x,@y=icon,x,y
      
      draw_up=@y-1
      draw_left=@x-1
      draw_down=draw_up+@@rect_h
      draw_right=draw_left+@@rect_w
      
      @lines=[
        Line.new(draw_left,draw_up,draw_right,draw_up),
        Line.new(draw_left,draw_up,draw_left,draw_down),
        Line.new(draw_left,draw_down,draw_right,draw_down),
        Line.new(draw_right,draw_down,draw_right,draw_up) 
      ]
    end
    def select?(x,y)
      return x.between?(@x,@x+@@icon_w)&&
        y.between?(@y,@y+@@icon_h)
    end
    def draw
      @icon.draw(@x,@y)
    end
    def draw_select(click)
      if click
        color_up_left=Color[:icon_dark]
        color_down_right=Color[:icon_light]
      else
        color_up_left=Color[:icon_light]
        color_down_right=Color[:icon_dark]
      end
      @lines[0].color=@lines[1].color=color_up_left
      @lines[2].color=@lines[3].color=color_down_right
      @lines.each{|line| line.draw}
    end
  end
  def initialize
    win_w,win_h=197,50
    win_x=Game.Width-win_w
    win_y=Game.Height-win_h
    super(win_x,win_y,win_w,win_h)
    @icons_name=[:status,:item,:skill,:equip,:save,:tool]
    @icons=Input.load_window_icon_pic
    @icons_list={}
    @icons_name.each_with_index{|name,i|
      @icons_list[name]=Button.new(@icons[name],@win_x+@border+i*30+2,@win_y+@border+2)
    }    
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
          case @select
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
    @icons_list.each{|name,icon|
      if icon.select?(x,y)
        @select=name
        return
      end
    }
    @select=nil
  end
  def draw_select
    @select or return
    @icons_list[@select].draw_select(@click)
  end
  def draw
    draw_corner(:clear)
    super
    draw_select
    @icons_list.each_value{|icon| icon.draw}
  end
end