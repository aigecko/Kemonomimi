#coding: utf-8
class BaseWindow
 attr_accessor :enable,:visible,:alone
  def initialize(x,y,w,h)
    @base=Input.load_ui_pic
    @enable=true
	@visible=true
	
    @ske_w=@ske_h=32
    @ske_mv=5
    @win_w=w
    @win_h=h
    @win_x=x
    @win_y=y
    
    row=(@win_w/@ske_w.to_f).ceil
    column=(@win_h/@ske_h.to_f).ceil
    
    skeketon=Hash.new
    skeketon[:loca7]=@base.copy_rect(0, 0, @ske_w,@ske_h)
    skeketon[:loca8]=@base.copy_rect(32,0,@ske_w,@ske_h)
    skeketon[:loca9]=@base.copy_rect(64,0,@ske_w,@ske_h)
    skeketon[:loca4]=@base.copy_rect(0,32,@ske_w,@ske_h)
    skeketon[:loca5]=@base.copy_rect(32,32,@ske_w,@ske_h)
    skeketon[:loca6]=@base.copy_rect(64,32,@ske_w,@ske_h)
    skeketon[:loca1]=@base.copy_rect(0,64,@ske_w,@ske_h)
    skeketon[:loca2]=@base.copy_rect(32,64,@ske_w,@ske_h)
    skeketon[:loca3]=@base.copy_rect(64,64,@ske_w,@ske_h)
    for i in 1..9
      skeketon["loca#{i}".to_sym].set_color_key(SDL::SRCCOLORKEY,@base.colorkey)
      skeketon["loca#{i}".to_sym].display_format_alpha
    end
    
    right_margin=@win_w-@ske_w
    down_margin=@win_h-@ske_h
    
    @surface=SDL::Surface.new(SDL::SWSURFACE|SDL::SRCCOLORKEY,@win_w,@win_h,32,
                              0x000000FF, 0x0000FF00, 0x00FF0000,0xFF000000)    
    
    row_draw_times=row-2
    column_draw_times=column-2
    for row in 1..row_draw_times
      x=row<<@ske_mv
      SDL::Surface.transform_draw(skeketon[:loca8],@surface,0,1,1,0,0,x,0,0)
      SDL::Surface.transform_draw(skeketon[:loca2],@surface,0,1,1,0,0,x,down_margin,0)
    end
    for column in 1..column_draw_times
      y=column<<@ske_mv
      SDL::Surface.transform_draw(skeketon[:loca4],@surface,0,1,1,0,0,0,y,0)
      SDL::Surface.transform_draw(skeketon[:loca6],@surface,0,1,1,0,0,right_margin,y,0)
    end
    @surface.fill_rect(@ske_w,@ske_h,
                               row_draw_times<<@ske_mv,
                               column_draw_times<<@ske_mv,
                               [70,163,255])
    SDL::Surface.transform_draw(skeketon[:loca7],@surface,0,1,1,0,0,0,0,0)
    SDL::Surface.transform_draw(skeketon[:loca1],@surface,0,1,1,0,0,0,down_margin,0)    
    SDL::Surface.transform_draw(skeketon[:loca9],@surface,0,1,1,0,0,right_margin,0,0)
    SDL::Surface    .transform_draw(skeketon[:loca3],@surface,0,1,1,0,0,right_margin,down_margin,0)
    
	@surface.set_color_key(SDL::SRCCOLORKEY,@surface[0,0])
    @surface.display_format#_alpha
    
    @alone=false
    @font_size=20
    
    @border=10
  end
  
  def close
    @visible=false
    @enable=false
  end
  def open
    @visible=true
    @enable=true
  end
  def draw
    @surface.draw(@win_x,@win_y)
  end
  def draw_corner(color)
    w=h=10
    Screen.fill_rect(@win_x,@win_y,w,h,Color[color])
    Screen.fill_rect(@win_x+@win_w-w,@win_y,w,h,Color[color])
    Screen.fill_rect(@win_x,@win_y+@win_h-h,w,h,Color[color])
    Screen.fill_rect(@win_x+@win_w-w,@win_y+@win_h-h,w,h,Color[color])
  end
end
