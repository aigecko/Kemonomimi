#coding: utf-8
class BigTexture < Texture
  def initialize(surface)
    super
    @surface.fill_rect(0,0,@surface.w,@surface.h,[0,0,0])
    SDL::Surface.blit(surface,0,0,@origin_w,@origin_h,@surface,0,0)
    gen_texture
    @surface.destroy
  end
  def gen_texture
    @id=glGenTextures(1)
    glBindTexture(GL_TEXTURE_2D,@id[0])
    mask=@surface.format.Rmask|
      @surface.format.Gmask|
      @surface.format.Bmask
    Glu::gluBuild2DMipmaps(GL_TEXTURE_2D,
      GL_RGBA,@surface.w,@surface.h,
      GL_RGBA,GL_UNSIGNED_BYTE,
      @surface.pixels)
  end
end