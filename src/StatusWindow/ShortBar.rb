#coding: utf-8
class StatusWindow::ShortBar < StatusWindow::Bar
  def value_init(win_x,win_y)
    @val_back_w=65
    super
    @val_font_x=@x+35
  end
  def pic_init(skeleton)
    @val=->{sprintf("%4d",@value)}
    super
  end
end