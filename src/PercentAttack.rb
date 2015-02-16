#coding: utf-8
class PercentAttack < FixAttack
  def affect(target,position,scale=1)
    @percent||=@info[:attack]
    case @info[:dmg_type]
    when :max
      attack=target.attrib[:maxhp]*@percent/100
    when :cur
      attack=target.attrib[:hp]*@percent/100
    when :lose
      attack=(target.attrib[:maxhp]-target.attrib[:hp])*@percent/100
    end
    @info[:attack]=attack.to_i
    @info[:attack]==0 and @info[:attack]=1
    super(target,position,scale)
  end
  def marshal_dump
    array=super
    array[0][:p]=@percent
    return array
  end
  def marshal_load(array)
    super
    @percent=array[0][:p]
  end
end