#coding: utf-8
class<<SDL::Surface
  def load_cmp(filename)
    Zlib::GzipReader.open(filename){|file|
      data=file.read
      ary=Marshal.load(data)
      return SDL::Surface.new_from(*ary)
    }
  end
  def new_32bpp(w,h)
    return SDL::Surface.new(SDL::SRCCOLORKEY|SDL::OPENGLBLIT,
      w,h,32,
      0xff,0xff00,0xff0000,0xff000000)
  end
  def new_2N_length(w,h)
    w=2**(Math.log2(w).ceil.to_i)
    h=2**(Math.log2(h).ceil.to_i)
    return SDL::Surface.new_32bpp(w,h)
  end
end