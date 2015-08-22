#coding: utf-8
class Skill::Base::EnergyArrow
  def self.call(info)
    const,percent= *info[:args]
    attack=const+info[:caster].attrib[:sp]*percent/100
    Attack.new(info[:caster],type: :umag,attack: attack).affect(info[:target],info[:target].position)
  end
end