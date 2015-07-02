#coding: utf-8
class<<Attack
  def formula(attack,defense)
    defense=defense.confine(0,defense)
    return (attack**2/(attack+defense)).to_i
  end
  alias create new
  def new(caster,info)
    case info[:dmg_type]
    when :const
      return ConstAttack.new(caster,info)
    when :max,:cur,:lose
      return PercentAttack.new(caster,info)
    when :const_max,:const_cur,:const_lose
      return ConstMixAttack.new(caster,info)
    else
      return ConstAttack.new(caster,info)
    end
  end
end