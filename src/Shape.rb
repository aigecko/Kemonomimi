#coding: utf-8
class Shape
  def initialize(shape,info)
    @shape=shape
    @info=info
    
    case @shape
    when :col
      @info[:r]=info[:r]
      @info[:h]=info[:h]
    when :box
      @info[:w]=info[:w]
      @info[:h]=info[:h]
      @info[:t]=info[:t]
    end
  end
  def [](sym)
    @info[sym]
  end
  def box?
    @shape==:box ? true : false
  end
  def col?
    @shape==:col ? true : false
  end
  def self.collision?(one,other)
    shape1,shape2=one.shape,other.shape
	position1,position2=one.position,other.position
    if shape1.col?
      if shape2.col?
        if (position1.x-position2.x).abs < shape1[:r]+shape2[:r]&&
           (position1.z-position2.z).abs < shape1[:r]+shape2[:r]&&
           position1.y-position2.y < shape2[:h]&&           
           position2.y-position1.y < shape1[:h]&&
           Math.distance(position1.x,position1.z,position2.x,position2.z)<shape1[:r]+shape2[:r]
          return true          
        end
        return false
      elsif shape2.box?
        
      end
    elsif shape1.box?
      if shape2.box?
        if (position1.x-position2.x).abs < (shape1[:w]+shape2[:w])/2&&
           (position1.z-position2.z).abs < (shape1[:h]+shape2[:h])/2&&
           position1.y-position2.y < shape2[:t]&&
           position2.y-position1.y < shape1[:t]
          return true
        end
        return false
      elsif shape2.col?
      end
    end
  end
end