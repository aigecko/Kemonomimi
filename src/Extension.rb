#coding: utf-8
class SDL::Surface  
  def save_cmp(filename)    
    Zlib::GzipWriter.open(filename){|file|
      file.print (
        Marshal.dump([self.pixels,self.w,self.h,
                      self.bpp,self.pitch,
                      self.format.Rmask,
                      self.format.Gmask,
                      self.format.Bmask,
                      self.format.Amask]))
    }
  end
  def self.load_cmp(filename)
    Zlib::GzipReader.open(filename){|file|
      data=file.read
      ary=Marshal.load(data)
      return SDL::Surface.new_from(*ary)
    }
  end
  def reverse
    pic=transform_surface(get_pixel(0,0),0,-1,1,SDL::TRANSFORM_SAFE)
    return pic
  end
  def render_blend(mode,color)
    
  end
  [:add,:sub].each{|func| eval "
  def #{func}_blend(color)
    rm=self.format.Rmask
    gm=self.format.Gmask
    bm=self.format.Bmask
    am=self.format.Amask

    roffset=goffset=boffset=0
    while(rm&1==0&&rm>0);rm>>=1;roffset+=1;end
    while(gm&1==0&&gm>0);gm>>=1;goffset+=1;end
    while(bm&1==0&&bm>0);bm>>=1;boffset+=1;end

    rm=self.format.Rmask
    gm=self.format.Gmask
    bm=self.format.Bmask
    
    color=(color[0]<<roffset)+(color[1]<<goffset)+(color[2]<<boffset)
    x=0
    while(x<self.w)
      y=0
      while(y<self.h)
        pxl=self[x,y]
        (r=(pxl&rm)"+((func==:add)? '+':'-')+"(color&rm))"+((func==:add)? '>rm and r=rm':'<=0 and r=0')+ "
        (g=(pxl&gm)"+((func==:add)? '+':'-')+"(color&gm))"+((func==:add)? '>gm and g=gm':'<=0 and g=0')+ "
        (b=(pxl&bm)"+((func==:add)? '+':'-')+"(color&bm))"+((func==:add)? '>bm and b=bm':'<=0 and b=0')+ "
        self[x,y]=r|g|b|am
        y+=1
      end
      x+=1
    end
  end"}
  def draw(dst_x,dst_y,dst=Screen.render)
    SDL::Surface.blit(self,0,0,0,0,dst,dst_x,dst_y)
  end
  def draw_rotate(angle,pivot_x,pivot_y,dst_x,dst_y)
    SDL::Surface.transform_blit(self,Screen.render,angle,1,1,
                                pivot_x,pivot_y,dst_x,dst_y,0)
  end
  def draw_scale(dst_x,dst_y,scale_x,scale_y,dst=Screen.render)
    SDL::Surface.transform_blit(self,dst,0,scale_x,scale_y,0,0,dst_x,dst_y,0)
  end
end

class Surface < SDL::Surface
  def initialize(w,h,format)
    super(SDL::SWSURFACE,w,h,format)
  end
  def set_color_key(color)
    super(SDL::SRCCOLORKEY,color)
  end
  def self.load_with_colorkey(path)
    pic=Surface.load(path)
    pic.set_color_key(SDL::SRCCOLORKEY,pic[0,0])
    pic.display_format_alpha
    return pic
  end
  def self.flag
    SDL::SWSURFACE
  end
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
