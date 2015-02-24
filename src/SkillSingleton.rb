#coding: utf-8
class Skill  
  @@SwitchTypeList=
    [:switch,:switch_auto,:switch_append,:switch_attack_defense]
  @@TypeList=
    [:none,:auto,:switch,:active,:append,:before,:attach,
     :attack,:shoot,
     :pre_attack_defense,:attack_defense,:skill_defense,
     :switch_auto,:switch_append,:switch_attack_defense]
  def self.all_type_list
    return @@TypeList
  end
end