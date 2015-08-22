#coding: utf-8
class Skill::Base::CounterBeam
  def self.call(info)
    caster=info[:caster]
    possibility=info[:data][:possibility]
    unless rand(100)<possibility
      return info[:attack]
    end
    if Game.get_ticks>caster.var[:counter_beam_endtime]
      caster.var[:counter_beam_endtime]=Game.get_ticks+info[:data][:cd].to_sec
    else
      return info[:attack]
    end
    attack=info[:args][0]+caster.attrib[:def]
    last=info[:args][1].to_sec

    Map.add_friend_circle(
      caster.ally,
      Bullet.new(
        [Attack.new(caster,type: :mag,attack: attack),
         Effect.new(caster,
           name:'暈眩',sym: :counter_beam_stun,effect_type: :stun,
           icon: nil,attrib:{},last: last)],
        nil,
        :col,
        caster: caster,
        x: caster.position.x,
        y: caster.position.y,
        z: caster.position.z,
        r: 90,h: 50,
        live_cycle: :frame
      )
    )
    return info[:attack]
  end
end