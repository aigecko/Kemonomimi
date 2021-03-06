#coding: utf-8
class DropList::DropItem
  @@AngleLimit=360
  @@SpreadRadius=50
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
      when :Money
        item=Money.new(@index).drop
      else
        item=Database.get_item(@index).drop
      end
      angle=rand(@@AngleLimit)
      x=position.x+@@SpreadRadius*rand()*Math.cos(angle)
      z=position.z+@@SpreadRadius*rand()*Math.sin(angle)
      item.position.x=x.to_i.confine(0,Map.w)
      item.position.z=z.to_i.confine(0,Map.h)
      item.position.y=0
      Map.add_onground_item(item)
    }
  end
end