#coding: utf-8
class StatusWindow::Button
  def initialize(str,name,x,y)
    @str=str
    @name=name
    @x=x
    @y=y
    @str_pic=Font.render_texture(str,20,*Color[:attrib_font])
    @w,@h=@str_pic.w,@str_pic.h
    
    @button=Rectangle.new(@x,@y,@w,@h,Color[:attrib_val])
  end
  def update_coord(x,y)
    @button.x=@x=x
    @button.y=@y=y
  end
  def detect_click(x,y)
    return x.between?(@x,@x+@w)&&y.between?(@y,@y+@h)
  end
  def draw
    @button.draw
    @str_pic.draw(@x,@y)
  end
end