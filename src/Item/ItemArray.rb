#coding: utf-8
class ItemArray
  require_relative 'Item/ItemArray_Pack'
  def initialize(size,superposed=false)
    if superposed
      @arr=Array.new(size){Pack.new(nil,0)}
    else
      @arr=Array.new(size)
    end
    @vac=Array.new(size){|i| i}
  end
  def [](idx,limit=1)
    limit>1 and return @arr[idx,limit]
    return @arr[idx]
  end
  def size
    return @arr.size
  end
  def <<(obj)
    if obj.superposed #可疊
      @vac.each{|idx|
        pack=@arr[idx]
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
      @arr[vac]=obj
      @vac.delete(vac)
      return true
    end
  end
  def swap(a,b)
    a==b and return
    box_a=@arr[a]
    if !box_a||box_a.empty?
      @vac.delete(a)
      @vac<<b
    else
      @vac.delete(b)
      @vac<<a
    end
    @vac.sort!
    exchange(a,b)
  end
  def exchange(a,b)
    a==b and return
    @arr[a],@arr[b]=@arr[b],@arr[a]
  end
  def add(a,b)
    a==b and return
    box_a=@arr[a]
    box_b=@arr[b]
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
    @arr[idx]=nil
  end
end