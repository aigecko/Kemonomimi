#coding: utf-8
class Skill
  @@ActiveTypeList=
    [:active,:shoot]
  @@SwitchTypeList=
    [:switch,:switch_auto,:switck_before,:switch_append,:switch_attack_defense]
  @@TypeList=
    [:none,:auto,:switch,:active,:append,:before,:attach,
     :attack,:shoot,
     :pre_attack_defense,:pre_skill_defense,:attack_defense,
     :skill_defense,:skill_append,:skill_before,
     :switch_auto,:switch_append,:switch_attack_defense,
     :on_block,:on_ignore,:on_dodge]
  @@SkillBacks={}
  @@BindableList=
    [:active,:shoot,:switch_auto,:switch_append,:switch_attack_defense]
  def self.all_type_list
    return @@TypeList
  end
  def self.init
    [:skill_active_cding_back,:skill_active_back,
     :skill_switch_on_back,:skill_switch_off_back,
     :skill_passive_back,:skill_clicked].each{|name|
      @@SkillBacks[name]=Rectangle.new(0,0,24,24,Color[name])
    }
  end
end