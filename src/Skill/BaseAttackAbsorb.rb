#coding: utf-8
class Skill::Base::AttackAbsorb
  def self.call(info)
      attack=info[:attack]
      caster=info[:caster]
      Heal.new(caster,
        hp: (attack*info[:args]).to_i
      ).affect(caster,caster.position)
  end
end