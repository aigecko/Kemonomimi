#coding: utf-8
class Actor
  class Position
    attr_accessor :x,:y,:z
    def initialize(x,y,z)
	  @x,@y,@z=x,y,z
    end
  end
end