#coding: utf-8
class Skill::Base::MototadaR
  def self.call(info)
    caster=info[:caster]
    data=info[:data]

    Map.add_friend_circle(
      caster.ally,
      Bullet.new(
        Attack.new(caster,
          type: :acid,
          cast_type: :skill,
          attack: info[:attack]*info[:args][0]/100),
        nil,
        :col,
        caster: caster,
        live_cycle: :frame,
        r: info[:args][1],
        h: info[:args][2],
        x: caster.position.x,
        y: caster.position.y,
        z: caster.position.z,
        surface: :horizon
      )
    )
    return info[:attack]
  end
end