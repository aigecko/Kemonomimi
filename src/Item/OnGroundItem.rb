#coding: utf-8
class OnGroundItem
  attr_reader :position
  def initialize(origin)
    @origin=origin
    @position=Position.new(0,0,0)
    @pic=@origin.pic
  end
  def under_cursor?(offset_x)
    draw_x,draw_y,* =Mouse.state
    x=draw_x-@draw_x+offset_x
    y=draw_y-@draw_y
    return x.between?(0,@pic.w)&&
       y.between?(0,@pic.h)&&
       @pic[x,y]!=@pic.colorkey
  end
  def pickup
    return @origin
  end
  def draw
    @pic.draw(@draw_x,@draw_y,@position.z)
  end
  def draw_shadow
    @draw_x=@position.x-@pic.w/2
    @draw_y=Map.h-@position.y-@position.z/2
    Shadow.draw(@position.x-10,@draw_y+@pic.h-5,@position.z)
  end
end