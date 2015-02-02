#coding: utf-8
class StatusWindow::MidBar < StatusWindow::Bar
  def value_init
    @val_back_w=70
    super
    @val_font_x=@str_font_x+35
  end
  def pic_init
    @val=->{sprintf("%5.2f",@value)}
    super
  end
end