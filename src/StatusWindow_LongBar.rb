#coding: utf-8
class StatusWindow::LongBar < StatusWindow::Bar
  def value_init
    @val_back_w=96
    @str_back_w=@font_size*4+8
    super
    @val_font_x=@str_font_x+56
    @val_back_x=@str_back_x+@str_back_w
  end
  def pic_init
    @val=->{sprintf("%5d",@value)}
    super
  end
end