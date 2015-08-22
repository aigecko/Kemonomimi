#coding: utf-8
class Skill::Base::CounterAttack
  def self.call(info)
      attack=info[:args][0]+(info[:caster].attrib[:def]*info[:args][1]).to_i
      Attack.new(info[:caster],
        type: :acid,
        attack: attack).affect(info[:target],info[:target].position)
      return info[:attack]
  end
end