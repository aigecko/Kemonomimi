#coding: utf-8
class Consumption
  def initialize(data)
    @data=data
  end
  def [](key)
    return @data[key]
  end
  def each
    for attrib,val in @data
      yield attrib,val
    end
  end
end