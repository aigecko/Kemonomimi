#coding: utf-8
class Skill::Base::Missile 
  def self.call(info)
    caster=info[:caster]
    attack=info[:args][0]
    info[:data][:coef].each{|sym,val|
      attack+=(caster.attrib[sym]*val).to_i
    }

    pic=Surface.load_with_colorkey(info[:data][:pic])
    distance=Math.distance(info[:x],info[:z],caster.position.x,caster.position.z).to_i
    delta_x=info[:x]-caster.position.x
    delta_z=info[:z]-caster.position.z
    Map.add_friend_bullet(
      caster.ally,
      Bullet.new(
        Attack.new(caster,
          type: info[:data][:type],
          cast_type: :skill,
          attack: attack,
          append: info[:data][:append],
          assign: true),
        Animation.new(:follow,
          {img:[info[:data][:pic]],w: pic.w,h: pic.h},
          [[[:blit,0]]]),
        :col,
        caster: caster,
        live_cycle: info[:data][:live_cycle],
        live_count: info[:data][:live_count],
        x: caster.position.x,
        y: caster.position.y+caster.pic_h/4-pic.h/2,
        z: caster.position.z,
        r: pic.w/2,
        h: pic.h,
        vx: info[:data][:velocity]*delta_x/distance,
        vz: info[:data][:velocity]*delta_z/distance
      )
    )
  end
end