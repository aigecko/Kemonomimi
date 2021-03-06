#coding: utf-8
class Drawable
  include Gl
  @@Max=255.0
  def initialize(x,y,color)
    self.x=x
    self.y=y
    self.color=color
  end
  def x=(x)
    @x=x
  end
  def y=(y)
    @y=y
  end
  def a=(a)
    @a=a
  end
  def color=(color)
    @r,@g,@b=*color
    @r/=@@Max
    @g/=@@Max
    @b/=@@Max
    @a=(color[3]||@@Max)/@@Max
  end
  def draw_at(x,y,z=0)
    self.x=x
    self.y=y
    @z=z
    display
  end
  def draw(z=0)
    @z=z
    display
  end
end
class Rectangle < Drawable
  attr_reader :w,:h
  def initialize(x,y,w,h,color)
    super(x,y,color)
    self.w=w
    self.h=h
  end
  def w=(w)
    @w=w
  end
  def h=(h)
    @h=h
  end
  def display
    glDisable GL_TEXTURE_2D
    glBegin(GL_QUADS)
    glColor4d @r,@g,@b,@a
    glVertex3f @x,@y,@z
    glVertex3f @x+@w,@y,@z
    glVertex3f @x+@w,@y+@h,@z
    glVertex3f @x,@y+@h,@z
    glEnd
    glEnable GL_TEXTURE_2D
  end
end
class Line < Drawable
  def initialize(x1,y1,x2,y2,color=[0,0,0],width=1)
    super(x1,y1,color)
    @x1,@y1=@x,@y
    @x2=x2
    @y2=y2
    @width=width
  end
  def display
    glDisable GL_TEXTURE_2D
    glLineWidth(@width)
    glBegin(GL_LINES)
    glColor4d @r,@g,@b,@a
    glVertex3f @x1,@y1,@z
    glVertex3f @x2,@y2,@z
    glEnd
    glEnable GL_TEXTURE_2D
  end
end
class Circle < Drawable
  def initialize(x,y,r,color,alpha=nil)
    @r=r
    super(x,y,color)
    surface=SDL::Surface.new_32bpp((r<<1)+1,(r<<1)+1)
    background=color.collect{|c| (c+1)%255}
    surface.fill_rect(0,0,surface.w,surface.h,background)
    surface.set_color_key(SDL::SRCCOLORKEY,surface[0,0])
    surface.draw_circle(r,r,r,color,true,true)
    @a=(alpha||@@Max)/@@Max
    @texture=surface.to_texture
  end
  def x=(x)
    @x=x-@r
  end
  def y=(y)
    @y=y-@r
  end
  def display
    @texture.draw_float(@x,@y,@z||0,@a)
  end
end
class Ellipse < Drawable
  def initialize(x,y,rx,ry,color,alpha=nil)
    @rx,@ry=rx,ry
    super(x,y,color)
    surface=SDL::Surface.new_32bpp((rx<<1)+1,(ry<<1)+1)
    background=color.collect{|c| (c+1)%255}
    surface.fill_rect(0,0,surface.w,surface.h,background)
    surface.set_color_key(SDL::SRCCOLORKEY,surface[0,0])
    surface.draw_ellipse(rx,ry,rx,ry,color,true,false)
    @a=(alpha||@@Max)/@@Max
    @texture=surface.to_texture
  end
  def x=(x)
    @x=x-@rx
  end
  def y=(y)
    @y=y-@ry
  end
  def display
    @texture.draw_float(@x,@y,@z||0,@a)
  end
end