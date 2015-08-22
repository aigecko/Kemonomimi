#coding: utf-8
class Skill::Base::IceWave
  def self.call(info)
    caster=info[:caster]
    attack=info[:args]
    info[:data][:coef].each{|sym,val|
      attack+=(caster.attrib[sym]*val).to_i
    }
    Map.add_friend_circle(
      caster.ally,
      Bullet.new(
        Attack.new(caster,type: :acid,attack: attack),
        Animation.new(:follow,
          {img:['./rc/pic/battle/ice_wave.png'],
            w: 120,h: 60,horizon: true,
            limit: 1
          },
          [[[:blit,0,24]]]),
        :col,
        caster: caster,
        x: info[:x],y: 0,z: info[:z],
        r: 60,h: 1000,
        live_cycle: :frame,
        surface: :horizon
      )
    )
  end
end