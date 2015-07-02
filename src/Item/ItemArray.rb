#coding: utf-8
class ItemArray <Array
  class Pack
    @@limit=99
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
    def self.limit
      return @@limit
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
        if pack.item.id==obj.id&&pack.num<Pack.limit
          (pack.num+=1)==Pack.limit and @vac.delete(idx)
          return true
        end
      }
      return false
    else
      (vac=@vac.sort!.first) or return false
      self[vac]=obj
      @vac.delete(vac)
      return true
    end
  end
  def swap(a,b)
    a==b and return
    box_a=self[a]
    box_b=self[b]
    if !box_a||box_a.empty?
      @vac.delete(a)
      @vac<<b
      @vac.sort!
    else
      @vac.delete(b)
      @vac<<a
      @vac.sort!
    end
    exchange(a,b)
  end
  def exchange(a,b)
    a==b and return
    self[a],self[b]=self[b],self[a]
  end
  def add(a,b)
    a==b and return
    box_a=self[a]
    box_b=self[b]
    if box_a.item.id==box_b.item.id
      num=box_a.num+box_b.num
      if num>Pack.limit
        box_a.num=Pack.limit
        box_b.num=num-Pack.limit
      else
        box_a.num=num
        box_b.item=nil
        box_b.num=0
      end
    end
  end
  def delete(obj)
    delete_at(index(obj))
  end
  def delete_at(idx)
    @vac<<idx
    self[idx]=nil
  end
end