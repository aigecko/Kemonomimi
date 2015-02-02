#coding: utf-8
class ItemWindow::DragBar
  def initialize(x,y)
    update_coord(x,y)
    @w=11
    @h=268
    @rect_w=9
    @rect_h=133

    @offset_y=0
    @last_y=0
  end
  def offset
    @offset_y/13*5 #13= 133/10
  end
  def reinit
    @offset_y=0
  end
  def check_click(x,y)
    @click and return
    if x.between?(@x,@x+@rect_w)&&
       y.between?(@y+@offset_y,@y+@offset_y+@rect_h)
      @click=true        
      @last_y=y
    end
  end
  def drag(x,y)
    @click or return            
    update_offset(x,y)
  end
  def end_drag(x,y)
    @click or return
    @click=false      
    update_offset(x,y)
  end
  def stop_drag
    @click=false
  end
  def update_offset(x,y)
    offset=y-@last_y
    @offset_y+=offset
    @last_y=y
    @offset_y<0 and @offset_y=0
    @offset_y>@rect_h and @offset_y=@rect_h
    return offset!=0
  end
  def update_coord(x,y)
    @rect_x=(@x=x)+1
    @rect_y=(@y=y)+1      
  end
  def draw
    Screen.fill_rect(@x,@y,@w,@h,Color[:item_drag_bar_back])
    Screen.fill_rect(@rect_x,@rect_y+@offset_y,@rect_w,@rect_h,Color[:item_drag_bar])
  end
end