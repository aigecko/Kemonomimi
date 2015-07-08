#coding: utf-8
class DropList
  require_relative 'DropList_DropItem'
  def initialize(list)
    @list=list.collect{|pack|
      rate,type,index=pack
      DropItem.new(rate,type,index)
    }
  end
  def drop(position,drop_rate)
    @list.each{|item|
      item.drop(position,drop_rate)
    }
  end
end