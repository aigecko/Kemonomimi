#coding: utf-8
class ItemWindow::MoneyBar
  def initialize(x,y)
    @w,@h=148,20
    @font_size=15
    @text="持有金錢："
    update_coord(x,y)
  end
  def update_coord(x,y)
    @x=x
    @y=y
  end
  def update
  end
  def draw_back(dst)
    dst.fill_rect(10,308,@w,@h,Color[:item_page])
    text_pic=Font.render_solid(@text,@font_size,*Color[:item_tag_font])
    text_pic.draw(12,310,dst)
    @text_pic_w=text_pic.w
  end
  def draw
    money_draw_x=@x+2+@text_pic_w
    money_draw_y=@y+2
    Font.draw_texture(Game.player.attrib[:money].to_s,@font_size,
      money_draw_x,money_draw_y,*Color[:item_money_font])
  end
end