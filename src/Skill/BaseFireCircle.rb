#coding: utf-8
class Skill::Base::FireCircle
  def self.call(info)
    caster=info[:caster]
    base_attack,attrib=info[:args]
    data=info[:data]
    
    attack=base_attack+data[:coef]*caster.attrib[data[:coef_sym]]
    
    Map.add_friend_circle(
      caster.ally,
      Bullet.new(
        [Attack.new(caster,type: data[:type],cast_type: :skill,attack: attack),
         Effect.new(caster,
           name: data[:name],sym: data[:sym],effect_type: data[:effect_type],
           icon: data[:icon],
           attrib: attrib,
           last: data[:last_time].to_sec)],
        Animation.new(:follow,
          {img:['./rc/pic/battle/fire_circle.png'],
            w: 120,h: 60,horizon: true,
            limit: 1
          },
          [[[:blit,0,4]]]),
        :col,
        caster: caster,
        x: caster.position.x,
        y: 0,
        z: caster.position.z,
        r: data[:r],
        h: data[:h],
        live_cycle: :frame,
        surface: :horizon,
        broken_draw: true)
    )
  end
end