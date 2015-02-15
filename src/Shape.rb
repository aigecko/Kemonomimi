#coding: utf-8
class Shape
  require_relative 'ShapeSingleton'
  def initialize(shape,info)
    @shape=shape
    @info=info
    
    case @shape
    when :col
      @info[:r]=info[:r]
      @info[:h]=info[:h]
    when :box
      @info[:w]=info[:w]
      @info[:h]=info[:h]
      @info[:t]=info[:t]
    end
  end
  def [](sym)
    @info[sym]
  end
  def box?
    @shape==:box ? true : false
  end
  def col?
    @shape==:col ? true : false
  end
  def marshal_dump
    [@shape,@info]
  end
  def marshal_load(array)
    @shape,@info=array
  end
end