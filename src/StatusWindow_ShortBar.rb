#coding: utf-8
class StatusWindow::ShortBar < StatusWindow::Bar
  def value_init
    @val_back_w=65
    super
    @val_font_x=@str_font_x+33
  end
  def pic_init
    @val=->{sprintf("%4d",@value)}
    super
  end
end