#coding: utf-8
class ConstMixAttack < FixAttack 
  def affect(target,position,scale=1)
    @percent||=@info[:attack][1]
    @const||=@info[:attack][0]
    attack=@const
    case @info[:dmg_type]
    when :const_max
      attack+=target.attrib[:maxhp]*@percent/100
    when :const_cur
      attack+=(target.attrib[:hp]*@percent/100)
    when :const_lose
      attack+=(target.attrib[:maxhp]-target.attrib[:hp])*@percent/100
    end
    @info[:attack]=attack.to_i
    @info[:attack]==0 and @info[:attack]=1
    super(target,position,scale)
  end
  def marshal_dump
    array=super
    data=array[0]
    data[:p]=@percent
    data[:C]=@const
    return array
  end
  def marshal_load(array)
    super
    data=array[0]
    @const=data[:C]
    @percent=data[:p]
  end
end