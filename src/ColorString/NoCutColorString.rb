#coding: utf-8
class NoCutColorString < ColorString
  class<<self
    undef :new
    alias new create
  end
  def cut_initialize(ary)
    @ary=ary
    @ary.collect!{|str| str=="\n" ? :endl : str }
    @ary.reject!{|str| str.empty?}
  end
  def draw(start_x,start_y)
    x=start_x
    y=start_y
    color=@default_color
    accum=0
    @ary.each{|pack|
      if pack.respond_to?(:take)
        color=pack
      elsif pack==:endl
        y+=@size
        x=start_x
        accum=0
      else
        x+=Font.draw_texture(pack,@size,x,y,*color)[0]
      end
    }
  end
end