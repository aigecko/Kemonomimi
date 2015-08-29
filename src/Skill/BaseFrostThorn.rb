#coding: utf-8
class Skill::Base::FrostThorn
  def self.call(info)
    caster=info[:caster]
    target=info[:target]
    data=info[:data]
    base_attack,slow_atkspd,slow_wlkspd=*info[:args]
    
    attack=base_attack+(data[:coef]*caster.attrib[:atk]).to_i
    Attack.new(caster,
      type: :umag,attack: attack
    ).affect(target,target.position)
    
    target.add_state(caster,
      name: data[:name],sym: data[:sym],
      icon: data[:icon],
      magicimu_keep: true,
      attrib: {atkspd: -slow_atkspd/100.0,wlkspd: -slow_wlkspd/100.0},
      last: data[:last_time].to_sec
    )
  end
end