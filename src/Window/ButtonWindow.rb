#coding: utf-8
class ButtonWindow < BaseWindow
  require_relative 'Window/ButtonWindow_Button'
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

    skeleton_initialize
    gen_skeleton_texture
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