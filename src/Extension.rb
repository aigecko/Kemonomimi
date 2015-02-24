#coding: utf-8
class SDL::Surface
  require_relative 'SDL_Surface'
  require_relative 'SDL_SurfaceSingleton'
  require_relative 'Surface'
end

module Math
  def distance(x1,y1,x2,y2)
    dx=x2-x1
    dy=y2-y1
    Math.sqrt(dx*dx+dy*dy).to_f
  end  
  module_function :distance
  
  alias :cosine :cos
  alias :sine :sin 
  
  @sin=Hash.new
  @cos=Hash.new
  def sin(degree)
    @sin[degree]||=sine(degree/180.0*PI)
  end
  def cos(degree)
    @cos[degree]||=cosine(degree/180.0*PI)
  end
  module_function :sin, :cos, :cosine,:sine  
end
class Numeric
  def confine(min,max)
    self<min and return min
    self>max and return max
    return self
  end
end
class Fixnum
  def to_sec
    self*1000
  end
end
class Float
  def to_sec
    (self*1000).to_i
  end
end
