#coding: utf-8
class Skill::Base::RightLeftWeapon
  def self.call(info)
    caster=info[:caster]
    right_hand=caster.equip[:right]
    left_hand=caster.equip[:left]
    if right_hand&&left_hand&&
       right_hand.part==:right&&
       left_hand.part==:left
      if caster.var[:rl_weapon_right]!=right_hand||
         caster.var[:rl_weapon_left]!=left_hand
        def_conv=left_hand.attrib[:def]*info[:data][:def_coef]
        mdef_conv=left_hand.attrib[:mdef]*info[:data][:mdef_coef]
        caster.add_state(caster,
          name:'',sym: :rl_weapon,
          icon: nil,
          attrib: {info[:data][:def_conv]=>def_conv,info[:data][:mdef_conv]=>mdef_conv},
          magicimu_keep: true,
          last: nil)
        caster.var[:rl_weapon_right]=right_hand
        caster.var[:rl_weapon_left]=left_hand
      end
    else
      caster.var[:rl_weapon_right]=nil
      caster.var[:rl_weapon_left]=nil
      caster.del_state(:rl_weapon)
    end
  end
end