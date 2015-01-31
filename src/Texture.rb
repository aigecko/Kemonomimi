#coding: utf-8
class Texture;end
require_relative 'FontTexture'
require_relative 'SurfaceTexture'
class Texture
  def initialize(surface)
    @origin_w,@origin_h=surface.w,surface.h
    @surface=SDL::Surface.new_2N_length(@origin_w,@origin_h)
    @w=@surface.w
    @h=@surface.h
    gen_texture
  end
  def gen_texture
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
  def destroy
    Gl::glDeleteTexrues @id
  end
  def draw(dst_x,dst_y)
    $queue<<[@id[0],
      # -1+dst_x/320.0,1-dst_y/240.0,
      # @w/320.0,-@h/240.0,
      dst_x,dst_y,@origin_w,@origin_h,
      @origin_w/@w.to_f,@origin_h/@h.to_f,
      0]
  end
end