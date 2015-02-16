#coding: utf-8
class Actor
  def self.set_map_size(w,h)
    ActorAni.set_map_size(w,h)
  end
  def self.init
    AI.init
  
    @class_table={
      crossbowman: "弩箭手",
      archer: "弓箭手",
      mage: "魔法師",
      cleric: "牧師",
      fighter: "戰士",
      paladin: "聖騎士",
      darkknight: "暗騎士",
      none: "初心者"
    }
    
    @race_table={
      catear:'貓耳',
      foxear:'狐耳',
      wolfear:'狼耳',
      dogear:'狗耳',
      leopardcatear:'石虎'
    }

    @exp=Array.new(201){|n|
      #lv=n-1
      #200+lv*100+lv**2*100
      600+200*n*(n-1)
    }

    @attrib_table={
      str:'力量',con:'體質',
      int:'智力',wis:'智慧',
      agi:'敏捷',

      hp:'生命',sp:'法力',
      maxhp:'最大生命',maxsp:'最大法力',
      healhp:'生命回復',healsp:'法力回復',

      atk:'近攻',def:'物防',#}
      matk:'魔攻',mdef:'魔防',
      ratk:'遠攻',

      block:'格檔',dodge:'閃避',ignore:'忽略傷害',
      wlkspd:'跑速',atkspd:'攻速',
      jump:'跳躍',tough:'韌性',
      extra:'剩餘點數',

      atk_vamp:'普攻吸血',
      skl_vamp:'技能吸血',

      mag_outamp:'魔法輸出強化',phy_outamp:'物理輸出強化',
      mag_resist:'魔法抗性',phy_resist:'物理抗性',atk_resist:'傷害抗性',
      mag_decatk:'減少魔傷',phy_decatk:'減少物傷',
      mag_shield:'魔法護盾',atk_shield:'傷害護盾',

      consum_amp:'消耗係數',heal_amp:'治癒係數',

      attack_amp:'輸出強化',

      critical:'爆擊',
      bash:'暈眩'
    }

    @part_table={
      head:'頭部',neck:'頸部',body:'軀幹',back:'背部',right:'主手',
      left:'副手',range:'遠距',finger:'手指',feet:'足部',deco:'裝飾'
    }
    
    @@marshal_table={
      :a=>:@ally,:r=>:@race,:c=>:@class,:f=>:@face,
      :p=>:@position,:sh=>:@shape,:v=>:@var,
      :ach=>:@accum_hp,:acs=>:@accum_sp,
      :at=>:@attrib,:an=>:@animation,
      :st=>:@state,:sk=>:@skill
    }
  end
  def self.attrib_table
    return @attrib_table
  end
  def self.class_table
    return @class_table
  end
  def self.race_table
    return @race_table
  end
  def self.part_table
    return @part_table
  end
  def self.get_need_exp(level)
    return @exp[level]
  end
end