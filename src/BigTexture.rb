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
  def draw_part(dst_x,dst_y,z,x,y,w,h)
    vx,vy=x/@w.to_f,y/@h.to_f
    vu,vv=vx+w/@w.to_f,vy+h/@h.to_f
    x,y=-1+dst_x/320.0,1-dst_y/240.0
    w,h=w/(Game.Width.to_f/2),h/(Game.Height.to_f/2)
    
    glEnable GL_BLEND
    glBindTexture(GL_TEXTURE_2D,@id[0])
    glColor4d 1.0,1.0,1.0,1.0
    glBegin(GL_QUADS)
    glTexCoord2d(vx,vy)
    glVertex3f x,y,z
    glTexCoord2d(vu,vy)
    glVertex3f x+w,y,z
    glTexCoord2d(vu,vv)
    glVertex3f x+w,y-h,z
    glTexCoord2d(vx,vv)
    glVertex3f x,y-h,z
    glEnd
  end
end