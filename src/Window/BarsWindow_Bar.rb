#coding: utf-8
class BarsWindow::Bar
  attr_reader :ske_x,:ske_y
  def initialize(type,x,y,w,h)
    @type=type
   
    @ske_x=x
    @ske_y=y
    @bar_x=@ske_x+1
    @bar_y=@ske_y+1
    @max_w=w
    @max_h=h
    @bar_w=@max_w-2
    @bar_h=@max_h-2
    
    @color_back_sym=:"bar_#{@type}_back"
    @color_leave_sym=:"bar_#{@type}_leave"
    @color_sym=:"bar_#{@type}"
    
    @back_bar=Rectangle.new(@ske_x,@ske_y,@max_w,@max_h,Color[@color_back_sym])
    @leave_bar=Rectangle.new(@bar_x,@bar_y,@bar_w,@bar_h,Color[@color_leave_sym])
    @solid_bar=Rectangle.new(@bar_x,@bar_y,@bar_w,@bar_h,Color[@color_sym])
  end
  def draw(percent)
    @back_bar.draw
    @leave_bar.draw
    @solid_bar.w=@bar_w*percent
    @solid_bar.draw
  end
end