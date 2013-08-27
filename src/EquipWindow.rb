#coding: utf-8
class EquipWindow < DragWindow
  def initialize
    win_w,win_h=150,310
    win_x=377
    win_y=50
    super(win_x,win_y,win_w,win_h)
    
    title_initialize('角色裝備')    
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
          if event.x.between?(@win_x+10,@win_x+@win_w-10)
            y=(event.y-@win_y-22)/27
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
          if (event.y-@win_y-22)/27==@click_equip_y
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
  def draw(dst)
    super(dst)
    draw_title(dst)
    (0...@Parts.size).each{|n|
       dst.fill_rect(@win_x+10,@win_y+22+n*27,26,26,Color[:equip_pic_back])    
       dst.fill_rect(@win_x+36,@win_y+22+n*27,105,26,Color[:equip_str_back])
    }
    def draw
      @skeleton.draw(@win_x,@win_y)
      
      @click_equip_y and
      Screen.fill_rect(@win_x+10,@win_y+22+@click_equip_y*27,26,26,Color[:click_box_back])
      
      x,y=@border+1,23
      @equip.each{|part,equip|
        if equip
          equip.draw(@win_x+x,@win_y+y)
          equip.draw_name(@win_x+x+28,@win_y+y+4)
        else
          Font.draw_solid(@part_table[part],15,@win_x+x+28,@win_y+y+4,*Color[:part_str_font])
        end
        y+=27
      }
      
      @click_equip_y and
      @show_equip_detail and 
      @equip[@Parts[@click_equip_y]].draw_detail(@win_x+37,@win_y+22+@click_equip_y*27)
    end
  end
end