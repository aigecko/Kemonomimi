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
    @draw_w=@origin_w/(Game.Width.to_f/2)
    @draw_h=@origin_h/(Game.Height.to_f/2)
    @text_w=@origin_w/@w.to_f
    @text_h=@origin_h/@h.to_f
    gen_texture
  end
  def gen_texture
    @id=Gl::glGenTextures(1)
    Gl::glBindTexture(Gl::GL_TEXTURE_2D,@id[0])
    mask=@surface.format.Rmask|
      @surface.format.Gmask|
      @surface.format.Bmask
    for x in 0...@surface.w
      for y in 0...@surface.h
        @surface[x,y]==@surface.colorkey and @surface[x,y]&&=mask
      end
    end
    Glu::gluBuild2DMipmaps(Gl::GL_TEXTURE_2D,
      Gl::GL_RGBA,@surface.w,@surface.h,
      Gl::GL_RGBA,Gl::GL_UNSIGNED_BYTE,
      @surface.pixels)
  end
  def w;return @origin_w;end
  def h;return @origin_h;end
  def destroy
    Gl::glDeleteTexrues @id
  end
  def draw(dst_x,dst_y,z=0)
    $queue<<self
    @data=[@id[0],
      -1+dst_x/320.0,1-dst_y/240.0,
      @draw_w,@draw_h,
      @text_w,@text_h,
      z]
  end
  def display
    id,x,y,w,h,vx,vy=*@data
    Gl::glBindTexture(Gl::GL_TEXTURE_2D,id)
    Gl::glBegin(Gl::GL_QUADS)
    Gl::glColor3d 1.0,1.0,1.0
    Gl::glTexCoord2d(0,0)
    Gl::glVertex3f x,y,-1
    Gl::glTexCoord2d(vx,0)
    Gl::glVertex3f x+w,y,-1
    Gl::glTexCoord2d(vx,vy)
    Gl::glVertex3f x+w,y-h,-1
    Gl::glTexCoord2d(0,vy)
    Gl::glVertex3f x,y-h,-1
    Gl::glEnd
  end
end