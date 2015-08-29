#coding: utf-8
class Skill::Base::FreezingRain
  def self.call(info)
    caster=info[:caster]
    percent=info[:args]
    percent/=-100.0
    info[:target].add_state(caster,
      name: info[:data][:name],
      sym: :freezing_rain,
      icon: info[:data][:icon],
      attrib: {atk: percent,ratk: percent},
      magicimu_keep: true,
      last: info[:data][:last_time].to_sec
    )
    return info[:attack]
  end
end