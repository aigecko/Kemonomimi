#coding: utf-8
class CutColorString < ColorString
  class<<self
    undef :new
    alias new create
  end
  def initialize(str,size,default_color,limit_len)
    @limit_len=limit_len
    super(str,size,default_color)
  end
  def cut_initialize(ary)
    accum=0;str=''
    for i in 0...ary.size
      if ary[i].respond_to?(:take)
        @ary<<str<<ary[i]
        str=''
        accum=0
        next
      end
      ary[i].empty? and next
      ary[i].each_char{|char|
        if char=="\n"
          @ary<<str<<:endl
          str=''
          accum=0
        else
          str<<char
          accum+=(char.bytesize>1)? 1 : 0.67
          if accum>=@limit_len
            @ary<<str
            str=''
            accum=0
          end
        end
      }
    end
    @ary<<str
    @ary.reject!{|str| str.empty?}
  end
  def draw(start_x,start_y)
    x=start_x
    y=start_y
    color=@default_color
    accum=0
    @ary.each{|pack|
      if pack.respond_to? :take
        color=pack
      elsif pack==:endl
        y+=@size
        x=start_x
        accum=0
      else
        x+=Font.draw_texture(pack,@size,x,y,*color)[0]
        accum+=pack.size
        accum<@limit_len or accum=0
      end
    }
  end
end