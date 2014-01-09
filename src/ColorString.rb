class ColorString
  @@regexp=/#(..)(..)(..)\|/
  attr_reader :h
  def initialize(str,size,default_color,limit_len=0)
    @size=size
    @default_color=default_color
    @limit_len=limit_len
    @ary=[]
    ary=[]
    sentence=str.split(/(\n)/)
    sentence.each{|str|
      ary+=str.split(/(#.{6,6}\|)/)
    }    
    for i in 0...ary.size
      if (m=ary[i].match(@@regexp))
        ary[i]=m[1..3].collect{|n| n.to_i(16)}
      end
    end
    unless ary.first.respond_to? :take
      ary.unshift(@default_color)
    end
    #p ary
    if limit_len==0
      @ary=ary
      @ary.reject!{|str| str=="\n"}
    else
      accum=0
      str=''
      for i in 0...ary.size
        if ary[i].respond_to?(:take)          
          @ary<<str
          @ary<<ary[i]          
          str=''
          next
        end
        ary[i].empty? and next
        ary[i].each_char{|char|
          if char=="\n"      
            @ary<<str
            @ary<<:endl
            str=''
          else
            str<<char
            if str.size>=7
              @ary<<str
              str=''
            end
          end
        }
      end
      @ary<<str
    end
    
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
        x+=Font.draw_solid(pack,@size,x,y,*color)[0]
        accum+=pack.size
        if @limit_len>0
          if accum>=@limit_len
            accum=0
            x=start_x            
            y+=@size
          end
        else
          x=start_x
          y+=@size
        end
      end
    }
  end
end