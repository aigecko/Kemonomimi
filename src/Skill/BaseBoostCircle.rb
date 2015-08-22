#coding: utf-8
class Skill::Base::BoostCircle
  def self.call(info)
      caster=info[:caster]
      args=info[:args]
      data=info[:data]

      healhp=args[0]+(caster.attrib[:matk]*0.3).to_i

      atkspd=args[1]+(caster.attrib[:int]*0.1).to_i
      Map.add_enemy_circle(
        caster.ally,
        Bullet.new(
          [Heal.new(caster,hp: healhp),
           Effect.new(caster,
             name: data[:name],sym: data[:sym],
             icon: data[:icon],
             magicimu_keep: true,
             attrib:{atkspd: atkspd},
             last: data[:last].to_sec)],
          nil,
          :col,
          caster: caster,
          x: caster.position.x,
          y: caster.position.y,
          z: caster.position.z,
          r: 100,h: 50,
          live_cycle: :frame)
      )
  end
end