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
  def draw(z=0)
    @z=z
    $queue<<self
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