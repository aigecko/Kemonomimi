#coding: utf-8
class Consumption
  def initialize(data)
    @data=data
  end
  def [](key)
    return @data[key]
  end
  def effective?(actor)
    attrib=actor.attrib
    @data.each{|key,val|
      if Attribute.name_table[key]
        attrib[key]<val and return false
      end
    }
    return true
  end
  def affect(actor)
    attrib=actor.attrib
    @data.each{|key,val|
      if Attribute.name_table[key]
        val=val*(100+attrib[:consum_amp])/100
        attrib[key]-=val
      end
    }
  end
end