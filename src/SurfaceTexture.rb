#coding: utf-8
class SurfaceTexture < Texture
  def initialize(surface)
    super
    @surface.set_color_key(SDL::SRCCOLORKEY,surface.colorkey)
    @surface.fill_rect(0,0,@surface.w,@surface.h,[0,0,0])
    SDL::Surface.blit(surface,0,0,@origin_w,@origin_h,@surface,0,0)
    gen_texture
  end
end