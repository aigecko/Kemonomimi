#coding: utf-8
class Shadow
  @@shadow=SDL::Surface.new_32bpp(20,10)
  @@shadow.fill_rect(0,0,20,10,[255,0,0])
  @@shadow.draw_ellipse(10,5,10,5,Color[:shadow],true,false)
  @@shadow.set_color_key(SDL::SRCCOLORKEY,@@shadow[0,0])
  @@shadow.set_alpha(SDL::SRCALPHA,150)
  @@shadow=HorizonSurfaceTexture.new(@@shadow)
  def self.draw(x,y,z)
    @@shadow.draw(x,y,z)
  end
end