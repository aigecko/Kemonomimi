class ColorString
  @@regexp=/(#.{6,6}\|)/
  def initialize(str,size,default_color,limit_len=0)
    @size=size
    @ary=[]
    
    r=default_color[0]
    g=default_color[1]
    b=default_color[2]
    @default_color="#%02x%02x%02x|"%[r,g,b]
    
    if limit_len>0&&
       str.size>limit_len      
      endl=str.size/7
      if str.size%7==0
        endl-=1
      end
      endl.times{|n|
        n+=1
        str.insert(7*n+n-1,"\n")
      }
    end
    
    sentences=str.split(/\n/)    
    sentences.each{|s| @ary<<s.split(@@regexp)}
    
    unless @ary[0][0].match(@@regexp)
      @ary[0].unshift(@default_color)
    end
    
    sentences.size>0 and
    for line in 1...sentences.size
      forward_line=line-1
      while(forward_line>=0)
        @ary[forward_line].reverse.each do |word|
          if word.match(@@regexp)
  	        @ary[line].unshift($~.to_s)
		    forward_line=-1
		    break
	      end
	    end
	  forward_line-=1
      end
    end
    
    @ary.each do |pack| 
      (pack.size/2).times do |i|
        color=pack[i*2]
        r=color[1..2].to_i(16)
        g=color[3..4].to_i(16)
        b=color[5..6].to_i(16)
        pack[i*2]=[r,g,b]
      end
    end
  end
  def h
    @ary.size*@size
  end
  def draw(start_x,start_y)
    x=start_x
    y=start_y
    @ary.each do |pack| 
      (pack.size/2).times do |i|
        color=pack[i*2]
        str=pack[i*2+1]
        if str.size>0
          x+=Font.draw_solid(str,@size,x,y,*color)[0]
        end
      end
      x=start_x
      y+=@size
    end
  end
end