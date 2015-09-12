#coding: utf-8
class Skill::Base::Aura
  def self.call(info)
    caster=info[:caster]
    args=info[:args]
    data=info[:data]
    aura=Bullet.new(
      Effect.new(caster,
        name: data[:name],sym: data[:sym],
        icon: data[:icon],
        attrib: args[:attrib],
        last: 1.to_sec),
      data[:ani],
      :col,
      caster: caster,
      live_cycle: :frame,
      r: args[:r],
      h: args[:h],
      x: caster.position.x,
      y: caster.position.y,
      z: caster.position.z
    )
    case data[:target]
    when :enemy
      Map.add_friend_circle(caster.ally,aura)
    when :friend
      Map.add_enemy_circle(caster.ally,aura)
    else
      raise "UnkownAuraTarget"
    end
  end
end