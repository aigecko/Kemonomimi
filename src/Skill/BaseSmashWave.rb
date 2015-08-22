#coding: utf-8
class Skill::Base::SmashWave
  def self.call(info)
  caster=info[:caster]

  attack=info[:args][0]+(caster.attrib[info[:data][:sym]]*info[:data][:coef]).to_i
  probability=info[:args][1]

  rand(100)<probability and
  Map.add_friend_bullet(
    caster.ally,
    Bullet.new(
      Attack.new(
        caster,type: info[:data][:type],cast_type: :skill,attack: attack),
        nil,
        :col,
        caster: caster,
        x: caster.position.x,
        y: caster.position.y,
        z: caster.position.z,
        r: 75,h: 50,
        live_cycle: :frame)
  )
  end
end