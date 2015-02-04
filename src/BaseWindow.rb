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
  end
  self.init
  def skeleton_initialize
    @skeleton=SDL::Surface.new_32bpp(@win_w,@win_h)
    @skeleton.fill_rect(0,0,@win_w,@win_h,@@colorkey)
    tmp_x,tmp_y=@win_x,@win_y
    @win_x=@win_y=0
    stat_init
    dst=@skeleton
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
    dst.fill_rect(@win_x+@ske_w,@win_y+@ske_h,
                  @row_draw_times<<@ske_mv,
                  @column_draw_times<<@ske_mv,
                  [r,g,b])
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
    @skeleton.set_color_key(SDL::SRCCOLORKEY,@skeleton[0,0])
    
    @win_x,@win_y=tmp_x,tmp_y
  end
  def gen_skeleton_texture
    @skeleton=WindowTexture.new(@skeleton)
  end
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
    @visible=@enable=false
  end
  def open
    @visible=@enable=true
  end
  def close?
    not open?
  end
  def open?
    return @visible&&@enable
  end
  def draw(dst=Screen.render)
    @skeleton.draw(@win_x,@win_y)
  end
  def draw_corner(color)
    w=h=10
    @rect||=Rectangle.new(0,0,w,h,Color[color])
    @rect.draw_at(@win_x,@win_y)
    @rect.draw_at(@win_x+@win_w-w,@win_y)
    @rect.draw_at(@win_x,@win_y+@win_h-h)
    @rect.draw_at(@win_x+@win_w-w,@win_y+@win_h-h)
  end
end
