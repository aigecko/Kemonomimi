#coding: utf-8
class Surface < SDL::Surface
  def initialize(w,h,format)
    super(SDL::SWSURFACE,w,h,format)
  end
  def set_color_key(color)
    super(SDL::SRCCOLORKEY,color)
  end
  def self.load_with_colorkey(path)
    pic=Surface.load(path)
    pic.set_color_key(SDL::SRCCOLORKEY,pic[0,0])
    return pic
  end
  def self.flag
    SDL::OPENGLBLIT|SDL::SWSURFACE|SDL::SRCCOLORKEY
  end
end