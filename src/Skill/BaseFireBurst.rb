#coding: utf-8
class Skill::Base::FireBurst
  def self.call(info)
      caster=info[:caster]
      target=info[:target]
      if caster.var[:fire_burst_count]< 2
        caster.var[:fire_burst_count]+=1
        return
      else
        caster.var[:fire_burst_count]=0
      end
      attack=info[:args][0]+(info[:args][1]*caster.attrib[:matk]).to_i
      Map.add_friend_bullet(
        caster.ally,
        Bullet.new(
          [Attack.new(caster,type: :mag,cast_type: :skill,attack: attack),
           Effect.new(caster,
             name:'暈眩',sym: :circle_burst_stun,effect_type: :stun,
             icon: nil,
             attrib:{},
             last: info[:args][2].to_sec)],
          nil,
          :col,
          caster: caster,
          x: caster.position.x,
          y: caster.position.y,
          z: caster.position.z,
          r: 80,h:50,
          live_cycle: :frame))
  end
end