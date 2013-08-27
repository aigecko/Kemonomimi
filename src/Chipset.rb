#coding: utf-8
class ChipSet
  def initialize
    @name='templete'
    @pic=SDL::Surface.load_bmp("./rsrc/pic/chipset/#{@name}.bmp")
    @pic.set_color_key(SDL::SRCCOLORKEY,@pic[0,0])
    @type=[]
    @type[1]=[:flat]
    @type[2]=[:flat]
  end
  def load
  end
  def save
  end
  def chip_type
  end
  def draw
  end
end