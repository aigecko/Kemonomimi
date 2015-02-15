#coding: utf-8
class<<Shape
  def inside_rect?(position1,position2,w,h)
    (position1.x-position2.x).abs < w&&
    (position1.z-position2.z).abs < h
  end
  def inside_height?(position1,position2,h1,h2)
    position1.y-position2.y < h2&&
    position2.y-position1.y < h1
  end
  def inside_circle?(x1,z1,x2,z2,r)
    Math.distance(x1,z1,x2,z2) < r
  end
  def collision?(one,other)
    shape1,shape2=one.shape,other.shape
    position1,position2=one.position,other.position
    if shape1.col?
      if shape2.col?
        #shape1:col shape2:col
        if Shape.inside_rect?(position1,position2,
                              shape1[:r]+shape2[:r],shape1[:r]+shape2[:r])&&
           Shape.inside_height?(position1,position2,shape1[:h],shape2[:h])&&
           Shape.inside_circle?(position1.x,position1.z,position2.x,position2.z,shape1[:r]+shape2[:r])
          return true          
        end
        return false
      elsif shape2.box?
        #shape1:col shape2:box
        half_w,half_h=shape2[:w]/2,shape2[:h]/2
        if Shape.inside_height?(position1,position2,shape1[:h],shape2[:t])&&
           Shape.inside_rect?(position1,position2,shape1[:r]+half_w,half_h)&&
           Shape.inside_rect?(position1,position2,half_w,shape1[:r]+half_h)&&
           Shape.inside_circle?(position1.x,position1.z,position2.x-half_w,position2.z-half_h,shape1[:r])||
           Shape.inside_circle?(position1.x,position1.z,position2.x+half_w,position2.z+half_h,shape1[:r])||
           Shape.inside_circle?(position1.x,position1.z,position2.x-half_w,position2.z-half_h,shape1[:r])||
           Shape.inside_circle?(position1.x,position1.z,position2.x+half_w,position2.z+half_h,shape1[:r])
          return true 
        end   
        return false
      end
    elsif shape1.box?
      if shape2.box?
        #shape1:box shape2:box
        if Shape.inside_height?(position1,position2,shape1[:t],shape2[:t])&&
           Shape.inside_rect?(position1,position2,(shape1[:w]+shape2[:w])/2,(shape1[:h]+shape2[:h])/2)
          return true
        end
        return false
      elsif shape2.col?
        #shape1:box shape2:col
        if Shape.collision?(shape2,shape1)
          return true
        end
        return false
      end
    end
  end
end