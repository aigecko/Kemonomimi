#coding: utf-8
class Skill::Base::FreezingRain
  def self.call(info)
    percent=info[:args][0]+info[:caster].attrib[:int]*info[:data][:coef]
    percent/=-100.0
    info[:target].add_state(info[:caster],
      name:'凍雨凝結',sym: :freezing_rain,
      icon: info[:data][:icon],
      attrib: {atk: percent,matk: percent},
      magicimu_keep: true,
      last: info[:args][1].to_sec
    )
    return info[:attack]
  end
end