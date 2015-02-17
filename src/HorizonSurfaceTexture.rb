#coding: utf-8
class HorizonSurfaceTexture < SurfaceTexture
   def draw(dst_x,dst_y,z=0)
    id=@id[0]
    x,y=-1+dst_x/320.0,1-dst_y/240.0
    w,h=@draw_w,@draw_h
    vx,vy=@text_w,@text_h
    zf,zb=z,z+@draw_h
    
    glEnable GL_BLEND
    glBindTexture(GL_TEXTURE_2D,id)
    glColor4d 1.0,1.0,1.0,1.0
    glBegin(GL_QUADS)
    glTexCoord2d(0,0)
    glVertex3f x,y,zb
    glTexCoord2d(vx,0)
    glVertex3f x+w,y,zb
    glTexCoord2d(vx,vy)
    glVertex3f x+w,y-h,zf
    glTexCoord2d(0,vy)
    glVertex3f x,y-h,zf
    glEnd
  end
end