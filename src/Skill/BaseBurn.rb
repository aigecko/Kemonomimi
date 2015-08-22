#coding: utf-8
class Skill::Base::Burn
  def self.call(info)
    args=info[:args]
    data=info[:data]
    caster=info[:caster]
    attack=args[0]+(args[1]*info[:caster].attrib[:matk]).to_i
    info[:target].add_state(caster,
      name: data[:name],sym: data[:sym],
      icon: data[:icon],
      attrib: {},
      effect: Attack.new(info[:caster],type: :acid,attack: attack),
      effect_amp: 0.5,
      last: 2.to_sec)
  end
end