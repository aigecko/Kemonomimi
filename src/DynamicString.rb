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
      eval("Font.draw_solid(#{@value}.to_s,12,#{x},#{y},*Color[:#{@color}])",@binding)
    end
  end
  def initialize(str,color,binding)
    regexp=/(\#\{[a-zA-Z0-9\[\]\:\@_\.\*\+]*\})/
    @ary=str.split(regexp)
    @ary.collect!{|str|
      if regexp=~str
        Variable.new(str,color,binding)
      else
        Font.render_solid(str,12,*Color[color])
      end
    }
  end
  def draw(x,y)
    @ary.each{|str|
      str.draw(x,y)
      #result=(result[0]==0)? str.w : result[0]
      x+=str.w
    }
  end
end