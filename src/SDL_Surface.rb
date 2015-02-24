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
  def reverse
    pic=transform_surface(get_pixel(0,0),0,-1,1,SDL::TRANSFORM_SAFE)
    return pic
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
  def draw(dst_x,dst_y,dst)
    SDL::Surface.blit(self,0,0,0,0,dst,dst_x,dst_y)
  end
  def to_texture
    return SurfaceTexture.new(self)
  end
  
end
