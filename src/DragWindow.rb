#coding : utf-8
class DragWindow < BaseWindow
  def initialize(x,y,w,h)
    super(x,y,w,h)
    @drag_x=@win_x+@border
    @drag_y=@win_y
    @drag_w=@win_w-@border*2
    @drag_h=20
  end
  def title_initialize(title)
    @title=title
    @title_pic=Font.render_solid(@title,@font_size,*Color[:drag_title])
    
    @title_x=@drag_x+(@drag_w-@title_pic.w)/2
    @title_y=@drag_y+1
  end
  def pic_initialize    
    surface=Surface.new(Surface.flag,Game.Width,Game.Height,Screen.format)
    draw(surface)
    draw_title(surface)
    
    @skeleton=surface.copy_rect(@win_x,@win_y,@win_w,@win_h)
    @skeleton.set_color_key(SDL::SRCCOLORKEY|SDL::RLEACCEL,@skeleton[0,0])
    @skeleton.display_format_alpha
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
      @drag_start=false
      return :drag
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
  end
  def keep_drag(x,y)
    if @drag
      window_move(x,y)
      update_coord
    end
  end
  def end_drag
    if @drag
      Game.window(:GameWindow).open_contral
      update_coord
      @drag=false
      @drag_start=false
    end
  end
  def window_move(x,y)
    @win_x=x-@delta_x
    @win_y=y-@delta_y
  end
  def draw(dst=Screen.render)
    super
    dst.draw_rect(@drag_x,@drag_y,@drag_w,@drag_h,Color[:drag_bar],true,100)
  end
  def draw_title(dst=Screen.render)
    @title_pic.draw(@title_x,@title_y,dst)
  end
end