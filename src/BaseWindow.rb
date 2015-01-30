#coding: utf-8
class BaseWindow
  attr_accessor :enable,:visible,:alone
  def initialize(x,y,w,h)
    @ske_w=@ske_h=32
    @ske_mv=5
    @win_w=w
    @win_h=h
    @win_x=x
    @win_y=y
    #@
    #pic_init
    stat_init
  end
private
  def self.init
    @ske_w=@ske_h=32
    base=Input.load_ui_pic
    @@skeleton=Hash.new
    @@skeleton[:loca7]=base.copy_rect(0, 0, @ske_w,@ske_h)
    @@skeleton[:loca8]=base.copy_rect(32,0,@ske_w,@ske_h)
    @@skeleton[:loca9]=base.copy_rect(64,0,@ske_w,@ske_h)
    @@skeleton[:loca4]=base.copy_rect(0,32,@ske_w,@ske_h)
    @@skeleton[:loca5]=base.copy_rect(32,32,@ske_w,@ske_h)
    @@skeleton[:loca6]=base.copy_rect(64,32,@ske_w,@ske_h)
    @@skeleton[:loca1]=base.copy_rect(0,64,@ske_w,@ske_h)
    @@skeleton[:loca2]=base.copy_rect(32,64,@ske_w,@ske_h)
    @@skeleton[:loca3]=base.copy_rect(64,64,@ske_w,@ske_h)
    @@colorkey=@@skeleton[:loca7][0,0]
	  @@skeleton.each_value{|ske|
	  ske.set_color_key(SDL::SRCCOLORKEY,@@colorkey)
	  ske.display_format_alpha
	}
  end
  self.init
  def stat_init
    @enable=false
    @visible=false
    
    @alone=false
     
    @row=(@win_w/@ske_w.to_f).ceil
    @column=(@win_h/@ske_h.to_f).ceil
    
    @right_margin=@win_x+@win_w-@ske_w
    @down_margin=@win_y+@win_h-@ske_h
    
    @row_draw_times=@row-2
    @column_draw_times=@column-2
    
    @font_size=20
    
    @border=10
  end
public
  def close
    @visible=false
    @enable=false
  end
  def open
    @visible=true
    @enable=true
  end
  def close?
    not open?
  end
  def open?
    if @visible and @enable
      true
    else
      false
    end
  end
  def pre_draw
    range_x=(@win_x/32+1)..(@win_x+@win_w)/32
    range_y=(@win_y/32+1)..(@win_y+@win_h)/32
  end
  def draw(dst=Screen.render)
    for row in 1..@row_draw_times-1
      x=@win_x+(row<<@ske_mv)
      @@skeleton[:loca8].draw(x,@win_y,dst)
      @@skeleton[:loca2].draw(x,@down_margin,dst)
    end
    for column in 1..@column_draw_times-1
      y=@win_y+(column<<@ske_mv)
      @@skeleton[:loca4].draw(@win_x,y,dst)
      @@skeleton[:loca6].draw(@right_margin,y,dst)
    end
    r=(@@skeleton[:loca5][0,0]&0xff0000)>>16
    g=(@@skeleton[:loca5][0,0]&0xff00)>>8
    b=@@skeleton[:loca5][0,0]&0xff
    dst.draw_rect(@win_x+@ske_w,@win_y+@ske_h,
                  @row_draw_times<<@ske_mv,
                  @column_draw_times<<@ske_mv,
                  r|g<<8|b<<16,true,255)
    @@skeleton[:loca8].draw(@right_margin-@ske_w,@win_y,dst)
    @@skeleton[:loca2].draw(@right_margin-@ske_w,@down_margin,dst)
    if @win_y<@down_margin-@ske_h
      @@skeleton[:loca4].draw(@win_x,@down_margin-@ske_h,dst)
      @@skeleton[:loca6].draw(@right_margin,@down_margin-@ske_h,dst)
    end
    @@skeleton[:loca7].draw(@win_x,@win_y,dst)
    @@skeleton[:loca1].draw(@win_x,@down_margin,dst)
    @@skeleton[:loca9].draw(@right_margin,@win_y,dst)
    @@skeleton[:loca3].draw(@right_margin,@down_margin,dst)
  end
  def draw_corner(color)
    w=h=10
    Screen.fill_rect(@win_x,@win_y,w,h,Color[color])
    Screen.fill_rect(@win_x+@win_w-w,@win_y,w,h,Color[color])
    Screen.fill_rect(@win_x,@win_y+@win_h-h,w,h,Color[color])
    Screen.fill_rect(@win_x+@win_w-w,@win_y+@win_h-h,w,h,Color[color])
  end
end
