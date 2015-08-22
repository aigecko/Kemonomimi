#coding: utf-8
class Skill::Base::Contribute
  def self.call(info)
    caster=info[:caster]
    Map.add_enemy_circle(
      caster.ally,
      Bullet.new(
        Heal.new(caster,type: :percent, hp: info[:args],sp: info[:args]),
        nil,
        :col,
        caster: caster,
        x: caster.position.x,
        y: caster.position.y,
        z: caster.position.z,
        r: 100,h: 50,
        live_cycle: :frame
      )
    )
  end
end