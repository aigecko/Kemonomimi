#coding: utf-8
class Skill::Base::Arrow
  def self.call(info)
    caster=info[:caster]
    data=info[:data]
    attack=info[:args][0]+(caster.attrib[data[:sym]]*data[:coef]).to_i
    
    effect=data[:effect_sym] and
    effect=Effect.new(caster,
      name: data[:effect_name],sym: data[:effect_sym],
      icon: data[:effect_icon],
      magicimu_keep: data[:magicimu_keep],
      effect_type: data[:effect_type],
      attrib: data[:attrib]||{},
      last: data[:effect_last].to_sec)
      
    attack=Attack.new(caster,
      type: data[:type],
      cast_type: data[:cast_type],
      attack: attack,
      attack_defense: data[:attack_defense],
      append: data[:append]||effect,
      assign: true)
    
    Map.add_friend_bullet(
      caster.ally,
      Bullet.new(
        attack,
        (pic=Animation.new(*data[:pic])),
        :box,
        caster: caster,
        live_cycle: data[:live_cycle],
        live_count: info[:args][1],
        x: caster.position.x+
          case data[:launch_x]
          when Numeric
            data[:launch_x]*caster.face_side
          when :face
            caster.pic_w/2*caster.face_side
          else
            0
          end,
        y: caster.position.y+
          case data[:launch_y]
          when Numeric
            data[:launch_y]
          when :center
            caster.pic_h/4
          when :ground
            0
          end,
        z: caster.position.z,
        w: data[:shape_w],
        h: data[:shape_h],
        t: data[:shape_t],
        vx: data[:velocity]*caster.face_side,
        collidable: data[:collidable],
        collide_count: info[:args][2]||caster.var[data[:collide_count_var]]
        )
    )
  end
end