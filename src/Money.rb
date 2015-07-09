#coding: utf-8
class Money
  @@Pic=Input.load_icon('icon-1_2.png@[0,0]#[5.5]')
  def initialize(value)
    @money=value
  end
  def value
    return @money
  end
  def drop
    return OnGroundItem.new(self)
  end
  def pic
    return @@Pic
  end
  def draw(x,y,z)
    @@Pic.draw(x,y,z)
  end
end