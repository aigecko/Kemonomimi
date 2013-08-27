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
      darkknight: "暗騎士"
    }
    
    @race_table={
      catear:'貓耳',
      foxear:'狐耳',
      wolfear:'狼耳',
      dogear:'狗耳'
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
    
      atk:'近攻',def:'物防',
      matk:'魔攻',mdef:'魔防',
      ratk:'遠攻',
      
      block:'格檔',dodge:'閃避',
      wlkspd:'跑速',jump:'跳躍',
      extra:'剩餘點數'
    }#}
    
    @part_table={
      head:'頭部',neck:'頸部',body:'軀幹',back:'背部',right:'主手',
      left:'副手',range:'遠距',finger:'手指',feet:'足部',deco:'裝飾'
    }
  end  
  def self.attrib_table
    @attrib_table
  end
  def self.class_table
    @class_table
  end
  def self.race_table
    @race_table
  end
  def self.part_table
    @part_table
  end
  def self.get_need_exp(level)
    @exp[level]
  end
end