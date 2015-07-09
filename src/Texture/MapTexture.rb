#coding: utf-8
class MapTexture < BigTexture
  def draw_part(dst_x,dst_y,x,y,w,h)
    vx,vy=x/@w.to_f,y/@h.to_f
    vu,vv=vx+w/@w.to_f,vy+h/@h.to_f
    x,y=dst_x,dst_y
    zf,zb=400,0
    
    glEnable GL_BLEND
    glBindTexture(GL_TEXTURE_2D,@id[0])
    glColor4d 1.0,1.0,1.0,1.0
    glBegin(GL_QUADS)
    glTexCoord2d(vx,vy)
    glVertex3f x,y+h,zb
    glTexCoord2d(vu,vy)
    glVertex3f x+w,y+h,zb
    glTexCoord2d(vu,vv)
    glVertex3f x+w,y,zf
    glTexCoord2d(vx,vv)
    glVertex3f x,y,zf
    glEnd
  end
end