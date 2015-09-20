#codingL utf-8
class ItemArray::Pack
  LIMIT=@@LIMIT=99
  attr_accessor :item,:num
  def initialize(item,num)
    @item=item
    @num=num
  end
  def empty?
    return @num==0||(@item==nil)
  end
  def draw(x,y)
    @item.draw(x,y)
  end
  # def self.limit
    # return @@LIMIT
  # end
end