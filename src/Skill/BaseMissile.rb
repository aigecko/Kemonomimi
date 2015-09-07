#coding: utf-8
class Skill::Base::Missile 
  def self.call(info)
    caster=info[:caster]
    attack=info[:args][0]
    data=info[:data]
    data[:coef].each{|sym,val|
      attack+=(caster.attrib[sym]*val).to_i
    }

    pic=Surface.load_with_colorkey(data[:pic])
    distance=Math.distance(info[:x],info[:z],caster.position.x,caster.position.z).to_i
    delta_x=info[:x]-caster.position.x
    delta_z=info[:z]-caster.position.z
    Map.add_friend_bullet(
      caster.ally,
      Bullet.new(
        Attack.new(caster,
          type: data[:type],
          cast_type: :skill,
          attack: attack,
          before: data[:before],
          append: data[:append],
          assign: true),
        Animation.new(:follow,
          {img:[data[:pic]],w: pic.w,h: pic.h},
          [[[:blit,0]]]),
        :col,
        caster: caster,
        live_cycle: data[:live_cycle],
        live_count: data[:live_count],
        x: caster.position.x,
        y: caster.position.y+caster.pic_h/4-pic.h/2,
        z: caster.position.z,
        r: data[:r],
        h: data[:h],
        vx: data[:velocity]*delta_x/distance,
        vz: data[:velocity]*delta_z/distance
      )
    )
  end
end