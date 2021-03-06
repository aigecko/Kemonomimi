#coding : utf-8
class DragWindow < BaseWindow
  def initialize(x,y,w,h)
    super(x,y,w,h)
    @drag_x=@win_x+@border
    @drag_y=@win_y
    @drag_w=@win_w-@border*2
    @drag_h=20
    
    @close_x=@drag_x+@drag_w
    @close_y=@win_y
    @close_w=9
    @close_h=10
  end
  def title_initialize(title)
    @title=title
    @title_pic=Font.render_solid(@title,@font_size,*Color[:drag_title])
    title_x=@border+(@drag_w-@title_pic.w)/2
    title_y=1
    
    @skeleton.draw_rect(@border,0,@drag_w,@drag_h,Color[:drag_bar],true,Color[:drag_bar][3])
    close_x=@border+@drag_w
    close_y=0
    @skeleton.draw_rect(close_x,close_y,@close_w,@close_h,Color[:drag_close_back],true)
    @skeleton.draw_rect(close_x,close_y,@close_w,@close_h,Color[:drag_close_border])
    cross_x=close_x+2
    cross_y=2
    cross_h=cross_w=@border-4
    @skeleton.draw_line(cross_x,cross_y,cross_x+cross_w,cross_y+cross_h,Color[:drag_close_border])
    @skeleton.draw_line(cross_x,cross_y+cross_h,cross_x+cross_w,cross_y,Color[:drag_close_border])
    @title_pic.draw(title_x,title_y,@skeleton)
  end
  def detect_click_window(event)
    @enable or return false
    x=event.x
    y=event.y
    if x.between?(@drag_x,@drag_x+@drag_w)&&
       y.between?(@drag_y,@drag_y+@drag_h)&&
       event.button==SDL::Mouse::BUTTON_LEFT
      @rec_x=@win_x
      @rec_y=@win_y
      @delta_x=x-@win_x
      @delta_y=y-@win_y
      @drag=true
      Mouse.set_cursor(:drag)
      return :drag
    elsif x.between?(@close_x,@close_x+@close_w)&&
          y.between?(@close_y,@close_y+@close_h)
      close
      return :click
    elsif x.between?(@win_x,@win_x+@win_w)&&
          y.between?(@win_y,@win_y+@win_h)
      return :click
    else
      return false
    end
  end
  def update_coord
    @win_x=[0,@win_x].max
    @win_x=[Game.Width-@win_w,@win_x].min
    @win_y=[0,@win_y].max
    @win_y=[Game.Height-@win_h-50,@win_y].min
    
    @right_margin=@win_x+@win_w-@ske_w
    @down_margin=@win_y+@win_h-@ske_h
    
    @drag_x=@win_x+@border
    @drag_y=@win_y
    
    @close_x=@drag_x+@drag_w
    @close_y=@win_y
  end
  def close
    super
    end_drag
  end
  def keep_drag(x,y)
    @drag or return
    window_move(x,y)
    update_coord
  end
  def end_drag
    @drag or return
    Game.window(:GameWindow).open_contral
    update_coord
    @drag=false
    Mouse.set_cursor(:move)
  end
  def window_move(x,y)
    @win_x=x-@delta_x
    @win_y=y-@delta_y
  end
end