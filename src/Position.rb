#coding: utf-8
class Position
  attr_accessor :x,:y,:z
  def initialize(x,y,z)
    @x,@y,@z=x,y,z
  end
  def marshal_dump
    [@x,@y,@z]
  end
  def marshal_load(array)
    @x,@y,@z=array
  end
end