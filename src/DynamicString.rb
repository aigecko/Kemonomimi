#coding: utf-8
class DynamicString
  class Variable
    @@GetContentRegExp=/\#\{(?<content>(.*))\}/
    attr_reader :w,:h
    def initialize(str,color,binding)
      @value=str.match(@@GetContentRegExp)[:content]
      @value.gsub!(/#[P|p]/,"Game.player.attrib")
      @value.gsub!(/#[T|t]/,"@table[@level]")
      @value.gsub!(/#[D|d]/,"@data")
      @color=color
      @binding=binding
    end
    def draw(x,y)
      @w,@h=
      Font.draw_texture(eval(@value,@binding).to_s,12,x,y,*@color)
    end
  end
  @@VariableRegExp=/(\#\{[a-zA-Z0-9\[\]#\:\@_\.\*\+\-\"\%]*\})/
  @@ColorRegExp=/(#[\da-fA-F]{6,6}\|)|(#default\|)/
  @@GetColorRegExp=/#(..)(..)(..)\|/
  @@DefaultColorRegExp=/#default\|/
  def initialize(str,color,binding)
    ary=str.split(@@VariableRegExp)
    default_color=color
    queue=[]
    ary.each{|substr| queue+=substr.split(@@ColorRegExp)}
    @list=[]
    queue.each{|str|
      case str
      when @@VariableRegExp
        @list<<Variable.new(str,color,binding)
      when @@DefaultColorRegExp
        color=default_color
      when @@GetColorRegExp
        color=[$1.hex,$2.hex,$3.hex]
      else
        str.empty? or
        @list<<Font.render_texture(str,12,*color)
      end
    }
  end
  def draw(x,y)
    @list.each{|str|
      str.draw(x,y)
      x+=str.w
    }
  end
end