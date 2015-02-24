#coding: utf-8
class WindowTexture < Texture
  def initialize(surface)
    super
    @surface.set_color_key(SDL::SRCCOLORKEY,surface.colorkey)
    @surface.fill_rect(0,0,@surface.w,@surface.h,surface[0,0])
    SDL::Surface.blit(surface,0,0,@origin_w,@origin_h,@surface,0,0)
    gen_texture
  end
  def gen_texture
    @id=glGenTextures(1)
    glBindTexture(GL_TEXTURE_2D,@id[0])
    mask=@surface.format.Rmask|
      @surface.format.Gmask|
      @surface.format.Bmask
    colorkey=@surface.colorkey
    for x in 0...10
      for y in 0...10
        @surface[x,y]==colorkey and @surface[x,y]&=mask
      end
      for y in @origin_h-10...@origin_h
        @surface[x,y]==colorkey and @surface[x,y]&=mask
      end
    end
    for x in @origin_w-10...@origin_w
      for y in 0...10
        @surface[x,y]==colorkey and @surface[x,y]&=mask
      end
      for y in @origin_h-10...@origin_h
        @surface[x,y]==colorkey and @surface[x,y]&=mask
      end
    end
    Glu::gluBuild2DMipmaps(GL_TEXTURE_2D,
      GL_RGBA,@surface.w,@surface.h,
      GL_RGBA,GL_UNSIGNED_BYTE,
      @surface.pixels)
  end
end