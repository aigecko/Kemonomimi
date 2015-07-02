#coding: utf-8
class Texture
  include Gl
  require_relative 'FontTexture'
  require_relative 'SurfaceTexture'
  require_relative 'BigTexture'
  require_relative 'WindowTexture'
  def initialize(surface)
    @origin_w,@origin_h=surface.w,surface.h
    @surface=SDL::Surface.new_2N_length(@origin_w,@origin_h)
    @w=@surface.w
    @h=@surface.h
    @draw_w=@origin_w
    @draw_h=@origin_h
    @text_w=(@origin_w)/@w.to_f
    @text_h=(@origin_h)/@h.to_f
  end
  def gen_texture
    @id=glGenTextures(1)
    glBindTexture(GL_TEXTURE_2D,@id[0])
    mask=@surface.format.Rmask|
      @surface.format.Gmask|
      @surface.format.Bmask
    colorkey=@surface.colorkey
    for x in 0...@origin_w
      for y in 0...@origin_h
        @surface[x,y]==colorkey and @surface[x,y]&=mask
      end
    end
    Glu::gluBuild2DMipmaps(GL_TEXTURE_2D,
      GL_RGBA,@surface.w,@surface.h,
      GL_RGBA,GL_UNSIGNED_BYTE,
      @surface.pixels)
  end
  def [](x,y);return @surface[x,y];end
  def colorkey;return @surface.colorkey;end
  def w;return @origin_w;end
  def h;return @origin_h;end
  def draw(dst_x,dst_y,dst_z=0,alpha=1.0)
    draw_float(dst_x,dst_y,dst_z,alpha)
  end  
  def draw_float(x,y,z=0,alpha=1.0)
    w,h=@draw_w,@draw_h
    vx,vy=@text_w,@text_h
    glEnable GL_BLEND
    glBindTexture(GL_TEXTURE_2D,@id[0])
    glColor4d 1.0,1.0,1.0,alpha
    glBegin(GL_QUADS)
    glTexCoord2d(0,0)
    glVertex3f x,y,z
    glTexCoord2d(vx,0)
    glVertex3f x+w,y,z
    glTexCoord2d(vx,vy)
    glVertex3f x+w,y+h,z
    glTexCoord2d(0,vy)
    glVertex3f x,y+h,z
    glEnd
  end
  def self.load_with_colorkey(filename)
    return Surface.load_with_colorkey(filename).to_texture
  end
end