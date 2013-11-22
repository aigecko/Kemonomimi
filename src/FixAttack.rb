#coding: utf-8
class FixAttack <Attack  
  class<<self
    undef :new
    alias new create
  end
end
class ConstAttack < FixAttack;end
class ConstMixAttack < FixAttack 
  def affect(target)
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
    super(target)
  end
end
class PercentAttack < FixAttack
  def affect(target)    
    @percent||=@info[:attack]
    case @info[:dmg_type]
    when :max      
      attack=target.attrib[:maxhp]*percent/100
    when :cur
      attack=target.attrib[:hp]*percent/100
    when :lose
      attack=(target.attrib[:maxhp]-target.attrib[:hp])*percent/100
    end
    @info[:attack]=attack.to_i
    super(target)
  end
end