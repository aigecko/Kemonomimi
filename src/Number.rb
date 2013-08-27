#coding: utf-8
class Number
  @@src=Hash.new(Hash.new(Hash.new(nil)))
  def initialize(value,size,x,y,color)
    @value=value
	@size=size
	@x,@y=x,y
	@color=color
	unless @@src[@size][@value][@color]
	  @@src[@size][@value][@color]=Font.render_solid(value,*color)
	end	
  end
  def draw
    @@src[@size][@value][@color].draw(@x,@y)
  end
end