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
    if x.between?(0,@pic.w)&&
       y.between?(0,@pic.h)&&
       @pic[x,y]!=@pic.colorkey
      return true
    else
      return false
    end
  end
  def pickup
    return @origin
  end
  def draw
    @draw_x=@position.x-@pic.w/2
    @draw_y=Map.h-@position.y-@position.z/2
    @pic.draw(@draw_x,@draw_y,@position.z/401.0)
  end
  def draw_shadow(dst)
    dst.draw_ellipse(@position.x,@draw_y+@pic.h,10,5,Color[:shadow],true,false,150)
  end
end