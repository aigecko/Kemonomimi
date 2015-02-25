class ColorString
  attr_reader :h
  @@SplitRegexp=/(\n|#[\da-fA-F]{6,6}\|)/
  @@FetchColor=/#(..)(..)(..)\|/
  def initialize(str,size,default_color)
    @size=size
    @default_color=default_color
    @ary=[]
    ary=color_initialize(str,size)
    cut_initialize(ary)
    calculate_height
  end  
  def color_initialize(str,size)
    ary=str.split(@@SplitRegexp)
    for i in 0...ary.size
      if (m=ary[i].match(@@FetchColor))
        ary[i]=m[1..3].collect{|n| n.hex}
      end
    end
    ary.first.respond_to?(:take) or
    ary.unshift(@default_color)
    return ary
  end
  def calculate_height
    @h=0
    @ary.each{|pack|
      pack.respond_to? :take and next
      pack.empty? and next
      @h+=@size
    }
  end
end
class<<ColorString
  alias create new
  def new(str,size,default_color,limit_len=nil)
    limit_len and 
    return CutColorString.new(str,size,default_color,limit_len)
    return NoCutColorString.new(str,size,default_color)
  end
end
require_relative 'NoCutColorString'
require_relative 'CutColorString'