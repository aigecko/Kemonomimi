#coding: utf-8
class StatusWindow::MidBar < StatusWindow::Bar
  def value_init(win_x,win_y)
    @val_back_w=70
    super
    @val_font_x=@x+37
  end
  def pic_init(skeleton)
    @val=->{sprintf("%5.2f",@value)}
    super
  end
end