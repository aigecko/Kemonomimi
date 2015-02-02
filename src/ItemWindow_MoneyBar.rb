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
    @bar_back||=Rectangle.new(@x,@y,@w,@h,Color[:item_page])
    @bar_back.x=@x=x
    @bar_back.y=@y=y
  end
  def update
  end
  def draw
    @bar_back.draw
    Font.draw_texture(Game.player.attrib[:money].to_s,@font_size,
      @x+2+Font.draw_texture(@text,@font_size,@x+1,@y+2,*Color[:item_tag_font])[0],
      @y+2,*Color[:item_money_font])
    
  end
end