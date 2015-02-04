#coding: utf-8
class StatusWindow::PlusBar < StatusWindow::Bar
  def value_init(win_x,win_y)
    @val_back_w=65
    super
    @val_font_x=@x+35
    @plus_x=@x+@val_back_w+@str_back_w
    @plus_y=@y
    @plus_w=@plus_h=18
    @plus_val||=0
  end
  def pic_init(skeleton)
    skeleton.fill_rect(@val_back_x+@val_back_w,@val_back_y,@plus_w,@plus_h,[125,125,125])
    @val=->{sprintf("%4d",@value)}
    super
  end
end