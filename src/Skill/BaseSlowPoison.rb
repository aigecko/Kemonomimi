#coding: utf-8
class Skill::Base::SlowPoison
  def self.call(info)
    args=info[:args]
    data=info[:data]
    caster=info[:caster]
    attack=args[0]+(args[1]*info[:caster].attrib[data[:attrib]]).to_i
    info[:target].add_state(caster,
      name: data[:name],sym: data[:sym],
      icon: data[:icon],
      magicimu_keep: true,
      negative: true,
      attrib: {atkspd: -args[2]/100.0,wlkspd: -args[3]/100.0},
      effect: Attack.new(info[:caster],type: data[:type],attack: attack),
      effect_amp: 0.5,
      last: data[:last_time].to_sec)
  end
end