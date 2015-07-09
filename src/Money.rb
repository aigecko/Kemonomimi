#coding: utf-8
class Money
  @@Pic=[
    Input.load_icon('./rc/icon/icon/mat_tkl003/acce_005c.png'),
    Input.load_icon('./rc/icon/icon/mat_tkl003/acce_005b.png'),
    Input.load_icon('./rc/icon/icon/mat_tkl003/acce_005.png'),
    Input.load_icon('./rc/icon/icon/mat_tklre002/other_002.png')
  ]
  def initialize(value)
    @money=value
    if @money<100
      @pic=@@Pic[0]
    elsif @money<1_000
      @pic=@@Pic[1]
    elsif @money<10_000
      @pic=@@Pic[2]
    else
      @pic=@@Pic[3]
    end
  end
  def value
    return @money
  end
  def drop
    return OnGroundItem.new(self)
  end
  def pic
    return @pic
  end
  def draw(x,y,z)
    @pic.draw(x,y,z)
  end
end