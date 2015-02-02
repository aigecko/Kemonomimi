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
    @draw_w=@origin_w/(Game.Width.to_f/2)
    @draw_h=@origin_h/(Game.Height.to_f/2)
    @text_w=@origin_w/@w.to_f
    @text_h=@origin_h/@h.to_f
  end
  def gen_texture
    @id=glGenTextures(1)
    glBindTexture(GL_TEXTURE_2D,@id[0])
    mask=@surface.format.Rmask|
      @surface.format.Gmask|
      @surface.format.Bmask
    for x in 0...@surface.w
      for y in 0...@surface.h
        @surface[x,y]==@surface.colorkey and @surface[x,y]&=mask
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
  def draw(dst_x,dst_y,z=0)
    $queue<<self
    @data=[@id[0],
      -1+dst_x/320.0,1-dst_y/240.0,
      @draw_w,@draw_h,
      @text_w,@text_h,
      z]
  end
  def direct_draw(dst_x,dst_y,z=0)
    @data=[@id[0],
      -1+dst_x/320.0,1-dst_y/240.0,
      @draw_w,@draw_h,
      @text_w,@text_h,
      z]
    display
  end
  def display
    id,x,y,w,h,vx,vy=*@data
    glEnable GL_BLEND
    glBindTexture(GL_TEXTURE_2D,id)
    glColor4d 1.0,1.0,1.0,1.0
    glBegin(GL_QUADS)
    glTexCoord2d(0,0)
    glVertex3f x,y,-1
    glTexCoord2d(vx,0)
    glVertex3f x+w,y,-1
    glTexCoord2d(vx,vy)
    glVertex3f x+w,y-h,-1
    glTexCoord2d(0,vy)
    glVertex3f x,y-h,-1
    glEnd
  end
end