#coding: utf-8
class Skill::Base::SnowShield
  def self.call(info)
    reduce_percent=info[:args][0]
    convert_coeff=info[:args][1]
    caster=info[:caster]

    damage=info[:attack]-info[:attack]*reduce_percent/100
    consum=damage/convert_coeff.to_i

    if consum>caster.attrib[:sp]
      consum=caster.attrib[:sp]
      damage=info[:attack]-consum*convert_coeff
    end
    info[:caster].lose_sp(consum)
    return damage
  end
end