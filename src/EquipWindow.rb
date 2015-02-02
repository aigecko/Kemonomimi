#coding: utf-8
class EquipWindow < DragWindow
  def initialize
    win_w,win_h=156,310
    win_x=377
    win_y=50
    super(win_x,win_y,win_w,win_h)
    
    title_initialize('角色裝備')
    @edge=27
    @box_w=@box_h=26
    
    @pic_back=Rectangle.new(0,0,@box_w,25,Color[:equip_pic_back])
    @str_back=Rectangle.new(0,0,110,25,Color[:equip_str_back])
  end
  def start_init
    @equip=Game.player.equip
    @Parts=@equip.parts
    @part_table=Actor.part_table
    @skeleton or pic_initialize
  end
  def update_coord
    super
  end
  def interact
    Event.each{|event|
      case event
      when Event::MouseButtonDown
        case event.button
        when SDL::Mouse::BUTTON_LEFT
          if event.x.between?(@win_x+@border,@win_x+@win_w-@border)
            y=(event.y-@win_y-22)/@edge
            if y.between?(0,@Parts.size-1)&&@equip[@Parts[y]]
              if @first_click_time&&
                 @first_click_time+0.22.to_sec>SDL.get_ticks&&
                 @click_equip_y==y
                Game.player.takeoff_equip(@Parts[y])
                @click_equip_y=nil
                @first_click_time=nil
              else 
                @show_equip_detail=true
                @first_click_time=SDL.get_ticks
                @click_equip_y=y
              end
            else
              @click_equip_y=nil
            end
          end
        when SDL::Mouse::BUTTON_RIGHT
          if (event.y-@win_y-22)/@edge==@click_equip_y
            @show_equip_detail=false
          end
        end
      when Event::MouseMotion
        keep_drag(event.x,event.y)
      when Event::MouseButtonUp
        case event.button
        when SDL::Mouse::BUTTON_LEFT
          end_drag
        end
      end      
    }
  end
  def close
    super
    @click_equip_y=nil
    @show_equip_detail=false
  end
  def draw
    dst=Screen.render
    super
    draw_title
    (0...@Parts.size).each{|n|
       @pic_back.x=@win_x+@border
       @str_back.x=@win_x+@border+@box_w
       @pic_back.y=@str_back.y=@win_y+22+n*@edge
       @pic_back.draw
       @str_back.draw
       #dst.draw_rect(@win_x+@border,@win_y+22+n*@edge,@box_w,25,Color[:equip_pic_back],true,255)    
       #dst.draw_rect(@win_x+36,@win_y+22+n*@edge,110,25,Color[:equip_str_back],true,255)
    }
    
    @click_equip_y and
    Screen.draw_rect(@win_x+@border,@win_y+22+@click_equip_y*@edge,@box_w,@box_h,Color[:click_box_back],true,255)
    
    draw_x,draw_y=@win_x+39,@win_y+@edge
    icon_x=@win_x+11
    @equip.each{|part,equip|
      if equip
        equip.draw_name(draw_x,draw_y)
        equip.draw(icon_x,draw_y-4)
      else
        Font.draw_texture(@part_table[part],15,draw_x,draw_y,*Color[:part_str_font])
      end
      draw_y+=@edge
    }
    
    if @click_equip_y&&@show_equip_detail
      unless @equip[@Parts[@click_equip_y]]
        @show_equip_detail=@click_equip_y=nil
        return
      end
      equip=@equip[@Parts[@click_equip_y]]
      draw_x,draw_y=@win_x+@border,@win_y+22+@click_equip_y*@edge
      if @click_equip_y>5
        draw_y=equip.draw_detail(draw_x,draw_y,:above)
      else
        draw_y=equip.draw_detail(draw_x,draw_y,:below)
      end
      equip.draw_comment(draw_x,draw_y)
    end
  end
end