class ColorString
  attr_reader :h
  def initialize(str,size,default_color,limit_len=nil)
    @size=size
    @default_color=default_color
    @limit_len=limit_len
    @ary=[]
    ary=color_initialize(str,size)

    if @limit_len
      cut_initialize(ary)
    else
      nocut_initialize(ary)
    end
    
    calculate_height
  end  
  def color_initialize(str,size)
    ary=[]
    sentence=str.split(/(\n)/)
    sentence.each{|str|
      ary+=str.split(/(#.{6,6}\|)/)
    }    
    for i in 0...ary.size
      if (m=ary[i].match(/#(..)(..)(..)\|/))
        ary[i]=m[1..3].collect{|n| n.hex}
      end
    end
    unless ary.first.respond_to? :take
      ary.unshift(@default_color)
    end
    return ary
  end
  def nocut_initialize(ary)
    @ary=ary
    @ary.reject!{|str| str=="\n"}
  end
  def cut_initialize(ary)
    accum=0;str=''
    for i in 0...ary.size
      if ary[i].respond_to?(:take)          
        @ary<<str<<ary[i]
        str='';accum=0
        next
      end
      ary[i].empty? and next
      ary[i].each_char{|char|
        if char=="\n"      
          @ary<<str<<:endl
          str='';accum=0
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
  end
  def calculate_height
    @h=0
    @ary.each{|pack|
      pack.respond_to? :take and next
      pack.empty? and next
      @h+=@size
    }
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
        pack.empty? or     
        x+=Font.draw_texture(pack,@size,x,y,*color)[0]
        if @limit_len
          accum+=pack.size
          accum<@limit_len and next
          accum=0
        end
        x=start_x            
        y+=@size
      end
    }
  end
end