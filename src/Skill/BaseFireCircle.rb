#coding: utf-8
class Skill::Base::FireCircle
  def self.call(info)
    attack=info[:args][0]+info[:caster].attrib[:matk]
    if Game.get_ticks>info[:caster].var[:fire_circle_triger]
      info[:caster].var[:fire_circle_triger]=Game.get_ticks+1.to_sec
    else
      return
    end

    Map.add_friend_circle(
      info[:caster].ally,
      Bullet.new(
        [Attack.new(info[:caster],type: :mag,cast_type: :skill,attack: attack),
         Effect.new(info[:caster],
           name:'燃燒',sym: :circle_burn,effect_type: :slow,
           icon:'./rc/icon/skill/2011-12-23_3-049.gif',
           attrib:{wlkspd: info[:args][1]},
           last: 5.to_sec)],
        Animation.new(:follow,
          {img:['./rc/pic/battle/fire_circle.png'],
            w: 120,h: 60,horizon: true,
            limit: 1
          },
          [[[:blit,0,24]]]),
        :col,
        caster: info[:caster],
        x: info[:caster].position.x,
        y: 0,
        z: info[:caster].position.z,
        r: 75,
        h: 50,
        live_cycle: :frame,
        surface: :horizon,
        broken_draw: true)
    )
  end
end