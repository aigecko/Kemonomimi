#coding: utf-8
class DropList
  class DropItem
    def initialize(rate,type,index)
      @rate=rate
      @type=type
      @index=index
    end
    def drop(position,drop_rate)
      @rate*=drop_rate
      num=@rate.to_i
      rate=@rate-num
      rand()<rate and num+=1
      
      num.times{
        case @type
        when :Consumable
          item=Database.get_consum(@index).drop
        when :Equipment
          item=Database.get_equip(*@index).drop
        else
          item=Database.get_item(@index).drop
        end
        angle=rand(360)
        item.position.x=position.x+30*Math.cos(angle)
        item.position.z=position.z+30*Math.cos(angle)
        item.position.y=0
        Map.add_onground_item(item)
      }
    end
  end
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