#coding: utf-8
class Drawable
end
class Rectangle
  def initialize(x,y,w,h,color)
    @x,@y,@w,@h=x,y,w,h
    @r,@g,@b=*color
    
    @x=-1+@x/(Game.Width.to_f/2)
    @y=1-@y/(Game.Height.to_f/2)
    @w/=(Game.Width.to_f/2)
    @h/=(Game.Height.to_f/2)
    
    @r/=255.0
    @g/=255.0
    @b/=255.0
  end
  def draw(z)
    @z=z
    $queue<<self
  end
  def display
    Gl::glLoadIdentity
    Gl::glDisable Gl::GL_BLEND
    Gl::glBegin(Gl::GL_QUADS)
    Gl::glColor3d @r,@g,@b
    Gl::glVertex3f @x,@y,@z
    Gl::glVertex3f @x+@w,@y,@z
    Gl::glVertex3f @x+@w,@y-@h,@z
    Gl::glVertex3f @x,@y-@h,@z
    Gl::glEnd
    Gl::glEnable Gl::GL_BLEND
  end
end