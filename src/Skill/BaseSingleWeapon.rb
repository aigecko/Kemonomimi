#coding: utf-8
class Skill::Base::SingleWeapon
  def self.call(info)
    caster=info[:caster]
    right_hand=caster.equip[:right]
    left_hand=caster.equip[:left]
    if right_hand&&!left_hand&&
       right_hand.part==:single
      if caster.var[:single_weapon]!=right_hand
        value=(right_hand.attrib[info[:data][:sym]]*info[:data][:coef]).to_i
        caster.add_state(caster,
          name:'',sym: :single_weapon,
          icon: nil,
          attrib:{info[:data][:conv]=>value},
          magicimu_keep: true,
          last: nil)
        caster.var[:single_weapon]=right_hand
      end
    else
      caster.var[:single_weapon]=nil
      caster.del_state(:single_weapon)
    end
  end
end