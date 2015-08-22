#coding: utf-8
class Skill::Base::Explode 
  def self.call(info)
    caster=info[:caster]
    data=info[:data]
    attack=info[:args][0]+(caster.attrib[data[:sym]]*data[:coef]).to_i

    Map.add_friend_circle(
      caster.ally,
      Bullet.new(
        Attack.new(caster,
          type: data[:type],
          cast_type: :skill,
          attack: attack),
        pic=Animation.new(*data[:pic]),
        :col,
        caster: caster,
        live_cycle: :frame,
        r: info[:args][1],
        h: info[:args][2],
        x: info[:x],
        y: info[:y],
        z: info[:z],
        surface: :horizon
      )
    )
  end
end