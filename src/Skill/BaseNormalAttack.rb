#coding: utf-8
class Skill::Base::NormalAttack < Skill::Base
  def self.call(info)
    attack=info[:caster].attrib[:atk]
    Attack.new(info[:caster],
      type: :phy,
      cast_type: :attack,
      attack: attack,
      before: :attack_increase,
    ).affect(info[:target],info[:target].position)
  end
end