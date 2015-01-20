#coding: utf-8
%w{Actor_Attrib Actor_ActorAni Actor_Equip 
   Actor_State Actor_AI
   ActorSingleton}.each{|actor_lib|
  require_relative actor_lib
}
class Actor
  attr_reader :position,:attrib,:ally,:race,:class
  attr_reader :equip_list,:item_list,:comsumable_list,:pledge_list
  attr_reader :equip,:skill,:target
  #dbg
  attr_accessor :shape  
  attr_accessor :var
  def initialize(comment,pos,attrib,pics)
    str=comment.split
    
    @ally=str[0].to_sym
    @race=str[1].to_sym
    @class=str[2].to_sym

    @face=:right
    @position=Position.new(pos[0],pos[1],pos[2])
      
    @attrib=Attrib.new(attrib,@race,@class)
    
    @animation=ActorAni.new(pics,(@ally==:player)? :player : :actor)
    
    @state=State.new(self)
    @equip=Equip.new
    
    @comsumable_list=ItemArray.new(100,:superposed)
    @equip_list=ItemArray.new(100)
    @item_list=ItemArray.new(100,:superposed)
    @pledge_list=ItemArray.new(100)
    
    @attrib[:hp]=@attrib[:maxhp]
    @attrib[:sp]=@attrib[:maxsp]

    @skill=SkillTree.new(self)
        
    @shape=Shape.new(:col,
      r: @animation.w/2,
      h: @animation.h)
    class_initialize
    skill_initialize
    
    @var=Hash.new(0)
  end
  def class_initialize
    class_data=Database.get_class(@class)
    attack_cd=class_data[:attack_cd]
    arrow_cd=class_data[:arrow_cd]
	
    add_base_skill(:normal_attack,
      name:'普通攻擊',type: :attack,cd: attack_cd,
      icon:'./rc/icon/skill/2011-12-23_3-034.gif',
      base: :normal_attack,consum: 0,level: 1,table:[0,0],
      common_cd: :arrow,
      comment:'對點擊的敵人攻擊 追著目標窮追猛打')
    add_base_skill(:attack,
      name:'',type: :attack,
      icon: nil,
      base: :attack,table:[0,0],
      comment: nil)
	  add_base_skill(:arrow,
      name:'弓箭射擊',type: :shoot,cd: arrow_cd,
      icon:'./rc/icon/skill/2011-12-23_3-047.gif',
      base: :arrow,table:[0,[50,25]],
      data:{sym: :ratk,coef: 1,type: :phy,cast_type: :attack,
        attack_defense:[:counter_beam,:counter_attack,:freezing_rain],
        append:[:enegy_arrow,:fire_burn,:break_armor],
        launch_y: :center,
        live_cycle: :time,
        pic:'./rc/pic/battle/arrow.png',
        velocity: 20},
      equip_need: :range,
      common_cd: :normal_attack,
      comment:'快速射出一隻箭造成#{@table[@level][0]}+ratk的傷害')
  end  
  def skill_initialize    
    case @class
    when :paladin
      [:counter_beam,:holy_protect,:paladin_magic_immunity].each{|skill|
        add_class_skill(:defense,skill,Database.get_skill(skill))
      }
      [:paladin_boost,:paladin_smash_wave,:paladin_recover].each{|skill|
        add_class_skill(:attack,skill,Database.get_skill(skill))
      }
      add_skill(:ignore,
        name:'',type: :none,
        icon: nil,
        base: :heal,table:[0,{sp: 0}],
        data:{spsym: :def,spcoef: 0.1})
      [:paladin_chop,:paladin_beam,:contribute].each{|skill|
        add_class_skill(:skill,skill,Database.get_skill(skill))
      }
      [:rl_weapon_hpsp,:single_weapon_matk].each{|skill|
        add_class_skill(:weapon,skill,Database.get_skill(skill))
      }
    when :darkknight
      add_skill(:smash_wave,
      name:'粉碎波',type: :append,
      icon:'./rc/icon/skill/2011-12-23_3-037.gif',
      base: :smash_wave,consum: 0,level: 1,table:[0,[100,20]],
      comment:'攻擊時#{@table[@level][1]}%產生#{@table[@level][0]}範圍魔法傷害')
    when :fighter
      [:counter_attack,:amplify_hp_block,:fighter_magic_immunity].each{|skill|
        add_class_skill(:defense,skill,Database.get_skill(skill))
      }
      [:break_armor,:fire_boost,:attack_increase].each{|skill|
        add_class_skill(:attack,skill,Database.get_skill(skill))
      }
      [:fire_burn,:fire_circle,:fire_burst].each{|skill|
        add_class_skill(:skill,skill,Database.get_skill(skill))
      }
      [:dual_weapon_atkspd,:rl_weapon_heal].each{|skill|
        add_class_skill(:weapon,skill,Database.get_skill(skill))
      }
   when :mage
      add_class_skill(:defense,:snow_shield,
        name:'吹雪護盾',type: :switch_attack_defense,
        icon:'./rc/icon/skill/2011-12-23_3-054.gif',
        base: :snow_shield,table:[0,[50,1]],
        comment:'開啟後將#{@table[@level][0]}%傷害轉換成1/#{@table[@level][1]}的法力消耗')
      add_class_skill(:defense,:freezing_rain,
        name:'凍雨凝結',type: :pre_attack_defense,
        icon:'./rc/icon/icon/mat_tkl001/skill_005b.png:[0,0]',
        base: :freezing_rain,table:[0,[12,10]],
        data: {coef: 0.02,icon:'./rc/icon/icon/mat_tkl001/skill_005b.png'},
        comment:'降低攻擊者#{@table[@level][0]}+#{@data[:coef]}int百分比的近攻魔攻持續#{@table[@level][1]}秒')
      add_class_skill(:defense,:ice_body,
        name:'寒冰之軀',type: :active,consum: 40,cd: 30,
        icon:'./rc/icon/skill/2011-12-23_3-187.gif',
        base: :ice_body,table:[0,[20,5,20]],
        data:{icon:'./rc/icon/skill/2011-12-23_3-187.gif'},
        comment:'開啟後提升#{@table[@level][0]}雙防及#{@table[@level][1]}%魔攻持續#{@table[@level][2]}秒')
      add_class_skill(:attack,:water_smash,
        name:'水流衝擊',type: :append,
        icon:'./rc/icon/icon/mat_tkl001/skill_003b.png:[0,0]',
        base: :water_smash,table:[0,[20,0.7]],
        comment:'普攻附加#{@table[@level][0]}+#{@table[@level][1]}*int魔傷')
      add_class_skill(:attack,:itegumo_erupt,
        name:'凍雲爆發',type: :append,
        icon:'./rc/icon/skill/2011-12-23_3-057.gif',
        base: :itegumo_erupt,table:[0,[20,20,6]],
        comment:'普攻#{@table[@level][0]}%爆發範圍強緩#{@table[@level][1]}%跑速攻速#{@table[@level][2]}秒')
      
      add_skill(:ice_arrow,
        name:'寒冰球',type: :active,
        icon:'./rc/icon/skill/2011-12-23_3-053.gif',
        base: :missile,consum: 5,cd: 3,table:[0,[100]],
        data: {coef:{matk: 0.9},type: :mag,append: :ice_wave,
          pic:'./rc/pic/battle/ice_ball.bmp',
          live_cycle: :time,live_count: 20,velocity: 15},
        comment:'對指定地點發射冰塊造成#{@table[@level][0]}+#{@data[:coef][:matk]}matk魔法傷害')
      add_skill(:ice_wave,
        name:'寒霜結界',type: :append,
        icon:'./rc/icon/skill/2011-12-23_3-052.gif',
        base: :ice_wave,consum: 0,table:[0,20],
        data:{coef:{int: 0.8}},
        comment:'魔法命中造成#{@table[@level]}+#{@data[:coef][:int]}int範圍絕對傷害')
    when :cleric
      add_skill(:enegy_arrow,
        name:'碎石杖擊',type: :switch_append,
        icon:'./rc/icon/skill/2011-12-23_3-125.gif',
        base: :enegy_arrow,consum: 5,level: 1,table:[0,[40,10]],
        comment:'開啟後普攻帶#{@table[@level][0]}+#{@table[@level][1]}%現有法力之無視魔免魔傷')
    end    
  end
  def rotate(side)
    @animation.rotate(side)
  end
  def face_side
    @animation.side
  end
  def pic_w
    @animation.w
  end
  def pic_h
    @animation.h
  end
  def under_cursor?(offset_x)
    @animation.under_cursor?(offset_x)
  end
  def get_equip_list
    @equip_list
  end
  def set_target(target,action=nil)
    @target=target
    @action=action
  end
  def set_move_dst(x,y,z)
    x||=@position.x
    y||=@position.y
    z||=@position.z
    
    z=z.confine(0,400)
    distance=Math.distance(@position.x,@position.z,x,z)
    if distance>0
      @dst_x=x
      @dst_z=z
      delta_x=x-@position.x
      delta_z=z-@position.z
      @wlkstep=@attrib[:wlkstep]
      @vx_scalar=(delta_x)/distance
      @vz_scalar=(delta_z)/distance
      @vector_x=@wlkstep*@vx_scalar
      @vector_z=@wlkstep*@vz_scalar
      
      @face= (@vector_x>0)? :right : :left
      @animation.rotate(@face)
      
      @act_affect=true
    end
  end
  def move2dst
    @act_affect or return
    if @wlkstep!=@attrib[:wlkstep]
      @wlkstep=@attrib[:wlkstep]
      @vector_x=@attrib[:wlkstep]*@vx_scalar
      @vector_z=@attrib[:wlkstep]*@vz_scalar
    end
    next_x=@position.x+@vector_x
    next_z=@position.z+@vector_z
    if (next_x>@dst_x&&@vector_x>0)||
       (next_x<@dst_x&&@vector_x<0)||
       (next_z<@dst_z&&@vector_z<0)||
       (next_z>@dst_z&&@vector_z>0)
      @position.x=@dst_x
      @position.z=@dst_z
      @act_affect=false
    else
      @position.x=next_x
      @position.z=next_z
    end
  end
  def get_dst
    [@dst_x,@dst_y,@dst_z]
  end
  def reach_target?
    case @action
    when :attack
      return (@position.x-@target.position.x).abs<=(pic_w+@target.pic_w)/2&&
             (@position.z-@target.position.z).abs<=20
    when :pickup
      return Math.distance(@position.x,@position.z,
                           @target.position.x,@target.position.z)<=51
    end
  end
  def interact_target    
    @target and reach_target? and
    case @action
    when :attack
      if !@target.died?
        @position.x>@target.position.x ? rotate(:left) : rotate(:right)
        @skill[:normal_attack].cast_attack(self,@target,@attrib[:atkspd])
      end
    when :pickup
      func=nil
      case @target
      when Equipment
        func=:gain_equip
      when Consumable
        func=:gain_consumable
      when Item
        func=:gain_item
      end
      if send(func,@target)
        @target.pickup
        Map.render_onground_item.delete(@target)
      end
      set_target(nil)
    end
  end
  def chase_target
    @target and not reach_target? and
    case @action
    when :attack
      if @target.position.x>@position.x
        rotate(:right)		
        dst_x=@target.position.x-(@target.pic_w+pic_w)/2+1
      else
        rotate(:left)
        dst_x=@target.position.x+(@target.pic_w+pic_w)/2-1
      end      
      dst_x=dst_x.confine(0,Map.w)
      dst_z=@target.position.z
      set_move_dst(dst_x,0,dst_z)
    when :pickup
      item_x=@target.position.x
      item_z=@target.position.z
      dis=Math.distance(item_x,item_z,
                        @position.x,@position.z)
      delta_x=item_x-@position.x
      delta_z=item_z-@position.z
      dst_x=@position.x+delta_x*(dis-50)/dis
      dst_z=@position.z+delta_z*(dis-50)/dis
      set_move_dst(dst_x,nil,dst_z)
    end
  end
  def moving?
    @act_affect ? true : false
  end
  def update
    @state.update
    recover
    @skill.update    
    unless has_state?(:stun)
      chase_target
      move2dst
      interact_target
    end
  end
  def wear_equip(index)
    part=@equip_list[index].part
    equip=@equip_list[index]
    @equip_list.delete_at(index)
    takeon_equip(part,equip)
  end
  def takeon_equip(part,equip)
    @equip.wear(self,part,equip)
	  @attrib.gain_equip_attrib(equip.attrib)
    if equip.skill
      add_skill(equip.sym,equip.skill)
    end
  end
  def takeoff_equip(part)
    @equip_list<<@equip[part]
    @attrib.lose_equip_attrib(@equip[part].attrib)
    if @equip[part].skill
      del_skill(@equip[part].sym,@equip[part].skill)
    end
    @equip[part]=nil
  end
  def has_state?(name)
    @state.include?(name)
  end
  def add_state(caster,info)
    if info[:sym]==:magic_immunity
      @state.keep_if{|state| state.keep_when_magicimmunity?}
    end
    @state.add(Statement.new(caster,info))
  end
  def del_state(sym)
    @state.delete(sym)
  end
  def has_skill?(name)
    @skill.has?(name)
  end
  def add_base_skill(skill,info)
    @skill.add_base(skill,info)
  end
  def add_class_skill(type,skill,info)
    @skill.add_class(type,skill,info)
  end
  def add_skill(skill,info)
    @skill.add_other(skill,info)
  end
  def del_skill(skill,info)
    @skill.delete(skill,info)
  end
  def attack_defense_skill
    return @skill_list[:attack_defense]
  end
  def pre_attack_defense_skill
    return @skill_list[:pre_attack_defense]
  end
  def gain_equip(equip)
    return @equip_list<<equip
  end
  def gain_equip_from_database(equips)
    equips.each{|equip|
	    part,index=equip
      @equip_list<<Database.get_equip(part,index)
	  }
  end
  def gain_consumable(consumable)
    return @comsumable_list<<consumable
  end
  def gain_consumable_from_database(index)
    @item_list<<Database.get_consum(index)
  end
  def gain_item(item)
    return @item_list<<item
  end
  def gain_hp(hp)
    @attrib[:hp]+=hp
    @attrib[:hp]=[@attrib[:hp],@attrib[:maxhp]].min
  end
  def gain_sp(sp)
    @attrib[:sp]+=sp
    @attrib[:sp]=[@attrib[:sp],@attrib[:maxsp]].min
  end
  def gain_exp(exp)
    @attrib.gain_exp(exp)
  end
  def recover
    @accum_hp||=0
    @accum_sp||=0
    
    if @attrib[:hp]<@attrib[:maxhp]        
      @accum_hp+=@attrib[:hlhpstep]
      hp=@accum_hp.to_i
      gain_hp(hp)
      @accum_hp-=hp
    end
    if @attrib[:sp]<@attrib[:maxsp]
      @accum_sp+=@attrib[:hlspstep]      
      sp=@accum_sp.to_i
      gain_sp(sp)      
      @accum_sp-=sp
    end
  end
  def lose_hp(hp)
    if @attrib[:hp]-hp>0
      @attrib[:hp]-=hp
    else
      hp=@attrib[:hp]
      @attrib[:hp]=0
      die
    end
    return hp
  end
  def die
    @die=true
  end
  def died?;return @die;end
  def lose_sp(sp)
    if @attrib[:sp]-sp>0
      @attrib[:sp]-=sp
    else
      @attrib[:sp]=0
    end
  end
  def can_cast?(end_time,consum)
    (has_state?(:stun)) and return false
    (SDL.get_ticks>end_time) or return false
    (@attrib[:sp]>=consum) ? true : false
  end
  def can_cast_auto?(end_time,consum)
    SDL.get_ticks>end_time or return false
    @attrib[:sp]>=consum ? true : false
  end
  def cast(name,target,x,y,z)
    unless @skill[name]
      #Message.show_format("使用不存在的技能#{name}",'錯誤',:ASTERISK)
      return
    end
    if (skill=@skill[name]).type==:attack||
       skill.type==:shoot
      skill.cast_attack(self,target,@attrib[:atkspd])
    else      
      skill.cast(self,target,x,y,z)
    end
  end
  def gain_attrib(attrib)
    @attrib.gain_base_attrib(attrib)
  end
  def lose_attrib(attrib)
    @attrib.lose_base_attrib(attrib)
  end
  def draw_hpbar(dst)
    percent=@attrib[:hp]/@attrib[:maxhp].to_f
    @animation.draw_hpbar(@position,percent,dst)
  end
  def draw_state(x,y)
    @state.draw(x,y)
  end
  def draw(dst)
    @animation.draw(@position,dst)
    draw_hpbar(dst)
  end
end