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
    money=Game.player.attrib[:money]
    if money>=10_000_000_000
      @font_size=12
      money="%.4E"%money
      money_draw_y=@y+3
    elsif money>=100_000_000
      @font_size=12
      money=money.to_s
      money_draw_y=@y+3
    elsif money>=10_000_000
      @font_size=15
      money=money.to_s
      money_draw_x=@x+@text_pic_w
      money_draw_y=@y+2
    else
      @font_size=15
      money=money.to_s
      money_draw_y=@y+2
    end
    Font.draw_texture(money,@font_size,
      money_draw_x,money_draw_y,*Color[:item_money_font])
  end
end