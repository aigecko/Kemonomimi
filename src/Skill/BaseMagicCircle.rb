#coding: utf-8
class Skill::Base::MagicCircle
  def self.call(info)
    caster=info[:caster]
    data=info[:data]
    attack=info[:args][0]+(caster.attrib[data[:coef_sym]]*data[:coef]).to_i

    if data[:sym]
      effect=Effect.new(caster,
        name: data[:name],sym: data[:sym],
        icon: data[:icon],
        magicimu_keep: data[:magicimu_keep],
        attrib: info[:args][3],
        last: data[:last].to_sec)
    else
      effect=nil
    end
    attack=Attack.new(caster,
      type: data[:type],
      cast_type: :skill,
      attack: attack)
    
    Map.add_friend_bullet(
      caster.ally,
        Bullet.new(
          (effect)? [attack,effect] : attack ,
        pic=Animation.new(*data[:pic]),
        :col,
        caster: caster,
        live_cycle: data[:live_cycle],
        live_count: data[:live_count],
        r: info[:args][1],
        h: info[:args][2],
        x: info[:x],
        y: info[:y],
        z: info[:z]
      )
    )
  end
end