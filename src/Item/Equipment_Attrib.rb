#coding: utf-8
class Equipment::Attrib
  attr_reader :part,:attrib
  def initialize(part,attrib)
    @part=part
    @attrib=Hash.new(0)
    attrib.each{|sym,value|
      sym!=:skill and
      @attrib[sym]=value
    }
  end
  def [](key)
    @attrib[key]
  end
  def size
    @attrib.size
  end
  def each
    @attrib.each{|key,val| yield key,val}
  end
end