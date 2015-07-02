#coding: utf-8
class StatusWindow::LongBar < StatusWindow::Bar
  def value_init(win_x,win_y)
    @val_back_w=96
    @str_back_w=@font_size*4+8
    super
    @val_font_x=@x+58
    @val_back_x=@str_back_x+@str_back_w
  end
  def pic_init(skeleton)
    @val=->{sprintf("%5d",@value)}
    super
  end
end