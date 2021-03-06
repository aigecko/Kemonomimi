#coding: utf-8
class HorizonSurfaceTexture < SurfaceTexture
   def draw(dst_x,dst_y,z=0,alpha=1.0)
    x,y=dst_x,dst_y
    w,h=@draw_w,@draw_h
    zf,zb=z+@origin_h/2,z-@origin_h/2
    glEnable GL_BLEND
    glBindTexture(GL_TEXTURE_2D,@id[0])
    glColor4d 1.0,1.0,1.0,alpha
    glBegin(GL_QUADS)
    glTexCoord2d(@slide_x,@slide_y)
    glVertex3f x,y,zb
    glTexCoord2d(@text_w,@slide_y)
    glVertex3f x+w,y,zb
    glTexCoord2d(@text_w,@text_h)
    glVertex3f x+w,y-h,zf
    glTexCoord2d(@slide_x,@text_h)
    glVertex3f x,y-h,zf
    glEnd
  end
end