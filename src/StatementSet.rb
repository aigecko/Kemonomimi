#coding: utf-8
class StatementSet
  def initialize
    @arr=[]
  end
  def [](index)
    return @arr[index]
  end
  def []=(index,value)
    @arr[index]=value
  end
  def <<(statement)
    @arr<<statement
  end
  def each(&block)
    @arr.each(&block)
  end
  def reject!(&block)
    @arr.reject!(&block)
  end
  def empty?
    return @arr.empty?
  end
  def keep_when_magicimmunity?
    return @arr[0].keep_when_magicimmunity?
  end
  def size
    return @arr.size
  end
  def attrib
    begin 
      @arr.size>1 and
      raise "attrib_get_on_array"
    rescue =>e
      Message.show(:attrib_get_on_array)
      Message.show_backtrace(e)
    end
    return @arr[0].attrib
  end
  def replace(statement)
    @arr[0]=statement
  end
end