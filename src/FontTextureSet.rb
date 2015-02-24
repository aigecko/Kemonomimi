#coding: utf-8
class FontTextureSet
  def initialize(text,size,r,g,b)
    @array=text.split(//)
    @array.collect!{|char| Font.render_character(char,size,r,g,b) }
    sum=0
    @array.each{|surface| sum+=surface.w}
    @w=sum
    @h=@array.max_by{|surface| surface.h}.h
  end
  def w;return @w;end
  def h;return @h;end
  def draw(dst_x,dst_y,z=0)
    @array.each{|surface|
      surface.draw(dst_x,dst_y,z)
      dst_x+=surface.w
    }
  end
end