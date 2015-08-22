#coding: utf-8
class Skill::Base::Arrow
  def self.call(info)
    caster=info[:caster]
    data=info[:data]
    attack=info[:args][0]+(caster.attrib[data[:sym]]*data[:coef]).to_i
    Map.add_friend_bullet(
      caster.ally,
      Bullet.new(
        Attack.new(caster,
          type: data[:type],
          cast_type: data[:cast_type],
          attack: attack,
          attack_defense: data[:attack_defense],
          append: data[:append],
          assign: true),
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