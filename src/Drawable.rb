#coding: utf-8
class Drawable
  include Gl
  @@max=255.0
  def initialize(x,y,color)
    self.x=x
    self.y=y
    self.color=color
  end
  def x=(x)
    @x=-1+x/(Game.Width.to_f/2)
  end
  def y=(y)
    @y=1-y/(Game.Height.to_f/2)
  end
  def color=(color)
    @r,@g,@b=*color
    @r/=@@max
    @g/=@@max
    @b/=@@max
    @a=(color[3]||@@max)/@@max
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
    @w=w/(Game.Width.to_f/2)
  end
  def h=(h)
    @h=h/(Game.Height.to_f/2)
  end
  def display
    glDisable GL_TEXTURE_2D
    glBegin(GL_QUADS)
    glColor4d @r,@g,@b,@a
    glVertex3f @x,@y,@z
    glVertex3f @x+@w,@y,@z
    glVertex3f @x+@w,@y-@h,@z
    glVertex3f @x,@y-@h,@z
    glEnd
    glEnable GL_TEXTURE_2D
  end
end
class Line < Drawable
  def initialize(x1,y1,x2,y2,color=[0,0,0],width=1)
    super(x1,y1,color)
    @x1,@y1=@x,@y
    @x2=-1+x2/(Game.Width.to_f/2)
    @y2=1-y2/(Game.Height.to_f/2)
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
    @a=(alpha||255)/255.0
    @texture=surface.to_texture
  end
  def x=(x)
    @x=-1+(x-@r)/(Game.Width.to_f/2)
  end
  def y=(y)
    @y=1-(y-@r)/(Game.Height.to_f/2)
  end
  def display
    @texture.draw_float(@x,@y,@z||0,@a)
  end
end