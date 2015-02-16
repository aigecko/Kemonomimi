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
    return Attribute.name_table
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