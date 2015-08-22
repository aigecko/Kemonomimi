#coding: utf-8
class Skill::Base::Flash 
  def self.call(info)
    limit=info[:args]
    caster=info[:caster]
    x,z=caster.position.x,caster.position.z
    dis=Math.distance(x,z,info[:x],info[:z])
    if dis>limit
      delta_x=(info[:x]-x)*limit/dis
      delta_z=(info[:z]-z)*limit/dis

      dst_x=x+delta_x
      dst_z=z+delta_z
      caster.set_move_dst(info[:x],0,info[:z])
      caster.position.x=dst_x
      caster.position.z=dst_z
    else
      caster.set_move_dst(info[:x],0,info[:z])
      caster.position.x=info[:x]
      caster.position.z=info[:z]
    end
  end
end