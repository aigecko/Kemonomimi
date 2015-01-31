#coding: utf-8
class Texture
  def initialize(surface)
    @origin_w,@origin_h=surface.w,surface.h
    @w=2**(Math.log2(@origin_w).ceil.to_i)
    @h=2**(Math.log2(@origin_h).ceil.to_i)
    @surface=SDL::Surface.new(SDL::SRCCOLORKEY|SDL::OPENGLBLIT,
      @w,@h,32,
      0xff,0xff00,0xff0000,0xff000000)
    @surface.fill_rect(0,0,@w,@h,[0,0,0])
    SDL::Surface.blit(surface,0,0,@origin_w,@origin_h,@surface,0,0)
    @surface.set_color_key(SDL::SRCCOLORKEY,surface.colorkey)
    
    @id=Gl::glGenTextures(1)
    Gl::glBindTexture(Gl::GL_TEXTURE_2D,@id[0])
    for x in 0...@surface.w
      for y in 0...@surface.h
        @surface[x,y]==@surface.colorkey and @surface[x,y]&&=0xffffff
      end
    end
    Glu::gluBuild2DMipmaps(Gl::GL_TEXTURE_2D,
      Gl::GL_RGBA,@surface.w,@surface.h,
      Gl::GL_RGBA,Gl::GL_UNSIGNED_BYTE,
      @surface.pixels)
  end
  def draw(dst_x,dst_y)
    $queue<<[@id[0],dst_x,dst_y,@origin_w,@origin_h,0]
  end
end