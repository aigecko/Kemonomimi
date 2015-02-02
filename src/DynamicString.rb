#coding: utf-8
class DynamicString
  class Variable
    attr_reader :w,:h
    def initialize(str,color,binding)
      /\#\{(.*)\}/=~str
      @value=$1
      @color=color
      @binding=binding
    end
    def draw(x,y)
      @w,@h=
      Font.draw_texture(eval(@value,@binding).to_s,12,x,y,*Color[@color])
    end
  end
  def initialize(str,color,binding)
    regexp=/(\#\{[a-zA-Z0-9\[\]\:\@_\.\*\+\-\"\%]*\})/
    @ary=str.split(regexp)
    @ary.collect!{|str|
      if regexp=~str
        Variable.new(str,color,binding)
      else
        Font.render_texture(str,12,*Color[color])
      end
    }
  end
  def draw(x,y)
    @ary.each{|str|
      str.draw(x,y)
      x+=str.w
    }
  end
end