#coding: utf-8
class Shadow
  def self.init
    img=SDL::Surface.new_32bpp(20,10)
    img.fill_rect(0,0,20,10,[255,255,255])
    img.draw_ellipse(10,5,10,5,Color[:shadow],true,true)
    img.set_color_key(SDL::SRCCOLORKEY,img[0,0])
    @@shadow=HorizonSurfaceTexture.new(img)
  end
  self.init
  def self.draw(x,y,z)
    @@shadow.draw(x,y,z,0.5)
  end
end