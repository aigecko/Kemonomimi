#coding: utf-8
class FixedArray <Array
  def initialize(size,&block)
    super
    @vac=Array.new(size){|i| i}
  end
  def <<(obj)
    if obj.superposed #可疊
      @vac.each{|idx|
        pack=self[idx]
        unless pack[0]
          pack[0]=obj
          pack[1]=1
          return
        end
        if pack[0].name==obj.name&&pack[1]<10
          (pack[1]+=1)==10 and @vac.delete(idx)
          return
        end
      }
    else
      (vac=@vac.min) or return    
      self[vac]=obj
      @vac.delete(vac)
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