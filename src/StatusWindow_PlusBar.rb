#coding: utf-8
class StatusWindow::PlusBar < StatusWindow::Bar
  def value_init
    @val_back_w=65
    super
    @val_font_x=@str_font_x+33
    @plus_x=@str_back_x+@val_back_w+@str_back_w
    @plus_y=@val_back_y
    @plus_w=@plus_h=18
    @plus_val||=0
    
    @plus_back||=Rectangle.new(@plus_x,@plus_y,@plus_w,@plus_h,[125,125,125])
    @plus_back.x=@plus_x
    @plus_back.y=@plus_y
  end
  def pic_init
    @val=->{sprintf("%4d",@value)}
    super
  end
  def draw
    super
    @plus_back.draw
  end
end