#coding: utf-8
class SurfaceTexture < Texture
  require_relative 'HorizonSurfaceTexture'
  def initialize(surface)
    @origin_w,@origin_h=surface.w,surface.h
    @surface=SDL::Surface.new_2N_length(@origin_w+2,@origin_h+2)
    
    @w=@surface.w
    @h=@surface.h
    @draw_w=@origin_w
    @draw_h=@origin_h
    @text_w=(@origin_w+1)/@w.to_f
    @text_h=(@origin_h+1)/@h.to_f
    @slide_x=1.0/@w
    @slide_y=1.0/@h
    
    @surface.set_color_key(SDL::SRCCOLORKEY,surface.colorkey)
    @surface.fill_rect(0,0,@surface.w+2,@surface.h+2,@surface.colorkey)
    SDL::Surface.blit(surface,0,0,@origin_w,@origin_h,@surface,1,1)
    
    gen_texture
  end
  def gen_texture
    @id=glGenTextures(1)
    glBindTexture(GL_TEXTURE_2D,@id[0])
    mask=@surface.format.Rmask|
      @surface.format.Gmask|
      @surface.format.Bmask
    colorkey=@surface.colorkey
    @map=Array.new(@origin_w+2){Array.new(@origin_h+2){true}}
    for x in 0...@origin_w+2
      for y in 0...@origin_h+2
        if @surface[x,y]==colorkey
          @surface[x,y]&=mask
          @map[x][y]=false
        end
      end
    end
    Glu::gluBuild2DMipmaps(GL_TEXTURE_2D,
      GL_RGBA,@surface.w,@surface.h,
      GL_RGBA,GL_UNSIGNED_BYTE,
      @surface.pixels)
    @surface.destroy
  end
  def [](x,y);return @map[x][y+1];end
  def draw_direct(x,y,z,reverse)
    w,h=@draw_w,@draw_h
    glEnable GL_BLEND
    glBindTexture(GL_TEXTURE_2D,@id[0])
    glColor4d 1.0,1.0,1.0,1.0
    glBegin(GL_QUADS)
    unless reverse
      glTexCoord2d(@slide_x,@slide_y)
      glVertex3f x,y,z
      glTexCoord2d(@text_w,@slide_y)
      glVertex3f x+w,y,z
      glTexCoord2d(@text_w,@text_h)
      glVertex3f x+w,y+h,z
      glTexCoord2d(@slide_x,@text_h)
      glVertex3f x,y+h,z
    else
      glTexCoord2d(@text_w,@slide_y)
      glVertex3f x,y,z
      glTexCoord2d(@slide_x,@slide_y)
      glVertex3f x+w,y,z
      glTexCoord2d(@slide_x,@text_h)
      glVertex3f x+w,y+h,z
      glTexCoord2d(@text_w,@text_h)
      glVertex3f x,y+h,z
    end
    glEnd
  end
  def draw_float(x,y,z=0,alpha=1.0)
    w,h=@draw_w,@draw_h
    
    glEnable GL_BLEND
    glBindTexture(GL_TEXTURE_2D,@id[0])
    glColor4d 1.0,1.0,1.0,alpha
    glBegin(GL_QUADS)
    glTexCoord2d(@slide_x,@slide_y)
    glVertex3f x,y,z
    glTexCoord2d(@text_w,@slide_y)
    glVertex3f x+w,y,z
    glTexCoord2d(@text_w,@text_h)
    glVertex3f x+w,y+h,z
    glTexCoord2d(@slide_x,@text_h)
    glVertex3f x,y+h,z
    glEnd
  end
end