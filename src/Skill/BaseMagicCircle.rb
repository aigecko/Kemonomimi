#coding: utf-8
class Skill::Base::MagicCircle
  def self.call(info)
    caster=info[:caster]
    data=info[:data]
    
    base_attack,r,h,attrib,effect_attack=*info[:args]
    attack=base_attack+(caster.attrib[data[:coef_sym]]*data[:coef]).to_i
    
    effect_attack and 
      effect_attack=Attack.new(caster,effect_attack)
    
    data[:sym] and 
      effect=Effect.new(caster,
        name: data[:name],sym: data[:sym],
        icon: data[:icon],
        effect: effect_attack,
        magicimu_keep: data[:magicimu_keep],
        attrib: attrib,
        last: data[:last].to_sec)
        
    attack=Attack.new(caster,
      type: data[:type],
      cast_type: :skill,
      append: data[:append],
      before: data[:before],
      attack: attack)
    
    case data[:start]
    when :cursor
      x=info[:x]
      y=info[:y]
      z=info[:z]
    when :caster
      x=caster.position.x
      y=caster.position.y
      z=caster.position.z
    end
    
    Map.add_friend_bullet(
      caster.ally,
        Bullet.new(
          (effect)? [attack,effect] : attack ,
        pic=Animation.new(*data[:pic]),
        :col,
        caster: caster,
        live_cycle: data[:live_cycle],
        live_count: data[:live_count],
        r: r,h: h,
        x: x,y: y,z: z,
        vx: (data[:vx]||0)*caster.face_side
      )
    )
  end
end