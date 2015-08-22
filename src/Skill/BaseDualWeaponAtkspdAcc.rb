#coding: utf-8
class Skill::Base::DualWeaponAtkspdAcc
  def self.call(info)
      caster=info[:caster]
      right_hand=caster.equip[:right]
      left_hand=caster.equip[:left]
      if right_hand&&left_hand&&
         right_hand.part==:dual&&
         left_hand.part==:dual
        if caster.var[:dual_weapon_right]!=right_hand||
           caster.var[:dual_weapon_left]!=left_hand
          atkspd=right_hand.attrib[:atkspd]*Math.log10(caster.attrib[:str])
          atkspd+=left_hand.attrib[:atkspd]*Math.log10(caster.attrib[:str])
          caster.add_state(caster,
            name:'',sym: :dual_weapon_atkpsd,
            icon: nil,
            attrib: {atkspd: atkspd.to_i},
            magicimu_keep: true,
            last: nil)
          caster.var[:dual_weapon_right]=right_hand
          caster.var[:dual_weapon_left]=left_hand
        end
      else
        caster.var[:dual_weapon_right]=nil
        caster.var[:dual_weapon_left]=nil
        caster.del_state(:dual_weapon_atkpsd)
      end
  end
end