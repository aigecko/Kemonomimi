#coding: utf-8
class ItemArray <Array
  class Pack
    attr_accessor :item,:num
    def initialize(item,num)
      @item=item
      @num=num
    end
    def empty?
      return !@item||@num==0
    end
    def draw(x,y)
      @item.draw(x,y)
    end
  end
  def initialize(size,superposed=false)    
    if superposed
      super(size){Pack.new(nil,0)}
    else
      super(size)
    end
    
    @vac=Array.new(size){|i| i}
  end
  def <<(obj)
    if obj.superposed #可疊
      @vac.each{|idx|
        pack=self[idx]
        if pack.empty?
          pack.item=obj
          pack.num=1
          return true
        end
        if pack.item.name==obj.name&&pack.num<1
          (pack.num+=1)==1 and @vac.delete(idx)
          return true
        end
      }
      return false
    else
      (vac=@vac.min) or return false
      self[vac]=obj
      @vac.delete(vac)
      return true
    end
  end
  def swap(a,b)
    vac_idx_a=@vac.index(a)
    vac_idx_b=@vac.index(b)
    if vac_idx_a&&vac_idx_b
      #都空的
    elsif vac_idx_a
      #a空換b空
      @vac<<b
    elsif vac_idx_b
      @vac<<a
    end
    self[a],self[b]=self[b],self[a]
  end
  def delete(obj)
    delete_at(index(obj))
  end
  def delete_at(idx)
    @vac<<idx
    self[idx]=nil
  end
end