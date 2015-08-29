#coding: utf-8
class Actor
    %w{Actor/Attrib Actor/ActorAni Actor/Equip 
     Actor/State Actor/AI Actor/Action Actor/Singleton}.each{|actor_lib|
    require_relative actor_lib
  }
  attr_reader :position,:attrib,:ally,:race,:class
  attr_reader :equip_list,:item_list,:comsumable_list,:pledge_list
  attr_reader :equip,:skill,:target,:action
  attr_reader :shape,:var
  def initialize(comment,pos,attrib,pics)
    str=comment.split
    
    @ally=str[0].to_sym
    @race=str[1].to_sym
    @class=str[2].to_sym

    @face=1
    @position=Position.new(pos[0],pos[1],pos[2])
      
    @attrib=Attrib.new(attrib,@race,@class)
    
    @animation=ActorAni.new(self,pics)
    @action=Action.new(self)
    
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

    add_base_skill(:NormalAttack,
      name:'普通攻擊',type: :attack,cd: attack_cd,
      icon:'./rc/icon/skill/2011-12-23_3-034.gif:[0,0]B[255,255,0]',
      base: :NormalAttack,consum: 0,level: 1,table:[0,0],
      common_cd: :arrow,
      comment:'對點擊的敵人攻擊 追著目標窮追猛打')
    add_base_skill(:arrow,
      name:'弓箭射擊',type: :shoot,cd: arrow_cd,
      icon:'./rc/icon/skill/2011-12-23_3-047.gif:[0,0]B[255,255,0]',
      base: :Arrow,table:[0,[50,25]],
      data:{sym: :ratk,coef: 1,type: :phy,cast_type: :attack,
        launch_y: :center,
        live_cycle: :time,
        pic: [:follow,
          {img:['./rc/pic/battle/arrow.png:[0,0]C[50,11]'],cut:[[50,11]],w: 50,h: 11},
          [[[:blit,0,5],[:blit,1,5],[:blit,2,5],[:blit,1,5]]] ],
        velocity: 20,shape_w: 50,shape_h: 12,shape_t: 11},
      equip_need: :range,
      common_cd: :NormalAttack,
      comment:'快速射出一隻箭造成#{#T[0]}+ratk的傷害')
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
      [:paladin_chop,:paladin_beam,:contribute].each{|skill|
        add_class_skill(:skill,skill,Database.get_skill(skill))
      }
      [:rl_weapon_hpsp,:single_weapon_matk].each{|skill|
        add_class_skill(:weapon,skill,Database.get_skill(skill))
      }
    when :darkknight
      add_class_skill(:defense,:bloody_curse,
        name:'血殤靈光',type: :attack_defense,
        icon:'./rc/icon/icon/tklre04/skill_056.png:[0,0]B[255,0,0]',
        base: :MototadaR,table:[nil,[15,75,50]],
        comment:'反彈受到傷害之#{#T[0]}%絕對傷害給範圍#{#T[1]}之敵人')
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
        name:'實念之盾',type: :switch_attack_defense,
        icon:'./rc/icon/skill/2011-12-23_3-054.gif:[0,0]B[255,0,0]',
        base: :SnowShield,table:[nil,
          [21,1.2],[22,1.4],[23,1.6],[24,1.8],[25,2.0],
          [26,2.2],[27,2.4],[28,2.6],[29,2.8],[30,3.0],
          [31,3.2],[32,3.4],[33,3.6],[34,3.8],[35,4.0],
          [36,4.2],[37,4.4],[38,4.6],[39,4.8],[40,5.0]
        ],
        comment:'開啟後將#{#T[0]}%傷害轉換成1/#{#T[1]}的法力消耗')
      add_class_skill(:defense,:freezing_rain,
        name:'凍雨凝結',type: :switch_attack_defense,consum: 10,
        icon:'./rc/icon/icon/mat_tkl001/skill_005b.png:[0,0]',
        base: :FreezingRain,table:[nil,
          11,12,13,14,15,16,17,18,19,20,
          21,22,23,24,25,26,27,28,29,30],
        data: {name:'凍雨凝結',icon:'./rc/icon/icon/mat_tkl001/skill_005b.png',last_time: 3},
        comment:'降低攻擊者#{#T}%近攻魔攻持續#{#D[:last_time]}秒')
      add_class_skill(:defense,:ice_body,
        name:'寒冰之軀',type: :switch_auto,consum: 10,cd: 1,
        icon:'./rc/icon/skill/2011-12-23_3-187.gif:[0,0]B[255,0,0]',
        base: :Amplify,table:[nil,
          {def:  11,mdef:  11,consum_amp: -3},{def:  22,mdef:  22,consum_amp: -4},
          {def:  33,mdef:  33,consum_amp: -5},{def:  44,mdef:  44,consum_amp: -6},
          {def:  55,mdef:  55,consum_amp: -7},{def:  66,mdef:  66,consum_amp: -8},
          {def:  77,mdef:  77,consum_amp: -9},{def:  88,mdef:  88,consum_amp:-10},
          {def:  99,mdef:  99,consum_amp:-11},{def: 110,mdef: 110,consum_amp:-12},
          {def: 121,mdef: 121,consum_amp:-13},{def: 132,mdef: 132,consum_amp:-14},
          {def: 143,mdef: 143,consum_amp:-15},{def: 154,mdef: 154,consum_amp:-16},
          {def: 165,mdef: 165,consum_amp:-17},{def: 176,mdef: 176,consum_amp:-18},
          {def: 187,mdef: 187,consum_amp:-19},{def: 198,mdef: 198,consum_amp:-20},
          {def: 209,mdef: 209,consum_amp:-21},{def: 220,mdef: 220,consum_amp:-22}
        ],
        data:{name:'寒冰之軀',sym: :ice_body},
        comment:'提升#{#T[:def]}雙防及降低#{-#T[:consum_amp]}%之SP消耗')
      add_class_skill(:attack,:frost_thorn,
        name:'霜刺',type: :switch_append,consum: 5,
        icon:'./rc/icon/skill/2011-12-23_3-053.gif:[0,0]B[255,0,0]',
        base: :FrostThorn,table: [nil,
          [ 25,12,28],[ 50,14,31],[ 75,16,34],[100,18,37],[125,20,40],
          [150,22,43],[175,24,46],[200,26,49],[225,28,52],[250,30,55],
          [275,32,58],[300,34,61],[325,36,64],[350,38,67],[375,40,70],
          [400,42,73],[425,44,76],[450,46,79],[475,48,82],[500,50,85]
        ],
        data:{
          name:'霜刺',sym: :forst_thorn,coef: 0.2,
          icon:'./rc/icon/skill/2011-12-23_3-053.gif:[0,0]B[255,0,0]',
          last_time: 2
        },
        comment:'普攻附加#{#T[0]}+#{#D[:coef]}atk無視魔免魔傷\n並強緩#{#T[1]}%跑速#{#T[2]}%攻速持續#{#D[:last_time]}秒'
        )
      add_class_skill(:magic,:ice_arrow,
        name:'寒冰球',type: :active,
        icon:'./rc/icon/skill/2011-12-23_3-053.gif:[0,0]B[255,0,0]',
        base: :Missile,consum: 5,cd: 3,table:[0,[100]],
        data: {coef:{matk: 0.9},type: :mag,append: :ice_wave,
          pic:'./rc/pic/battle/ice_ball.bmp',
          live_cycle: :time,live_count: 20,velocity: 15},
        comment:'對指定地點發射冰塊造成#{#T[0]}+#{#D[:coef][:matk]}matk魔法傷害')
      add_class_skill(:magic,:ice_wave,
        name:'寒霜結界',type: :skill_append,
        icon:'./rc/icon/skill/2011-12-23_3-052.gif:[0,0]B[255,0,0]',
        base: :IceWave,consum: 0,table:[0,20],
        data:{coef:{int: 0.8}},
        comment:'魔法命中造成#{#T}+#{#D[:coef][:int]}int範圍絕對傷害')
    when :cleric
      add_skill(:enegy_arrow,
        name:'碎石杖擊',type: :switch_append,
        icon:'./rc/icon/skill/2011-12-23_3-125.gif:[0,0]B[255,0,0]',
        base: :EnergyArrow,consum: 5,level: 1,table:[0,[40,10]],
        comment:'開啟後普攻帶#{#T[0]}+#{#T[1]}%現有法力之無視魔免魔傷')
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
  def set_target(target,action=:standby)
    @action.set_action(action)
    @action.set_target(target)
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
      
      @face= (@vector_x>0)? 1 : -1
      @animation.rotate(@face)
      
      @act_affect=true
    else
      @act_affect=false
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
  def moving?
    return @act_affect
  end
  def update
    @state.update
    recover
    @skill.update
    @action.update
  end
  def wear_equip(index)
    hp=@attrib[:hp]
    sp=@attrib[:sp]

    part=@equip_list[index].part
    equip=@equip_list[index]
    @equip_list.delete_at(index)
    takeon_equip(part,equip)

    hp < @attrib[:maxhp] and @attrib[:hp]<hp and @attrib[:hp]=hp
    sp < @attrib[:maxsp] and @attrib[:sp]<sp and @attrib[:sp]=sp
    hp > @attrib[:maxhp] and @attrib[:hp]=@attrib[:maxhp]
    sp > @attrib[:maxsp] and @attrib[:sp]=@attrib[:maxsp]
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
  def gain_money(money)
    case money
    when Money
      @attrib[:money]+=money.value
    when Integer
      @attrib[:money]+=money
    end
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
    died? or
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
  def died?
    return @die
  end
  def lose_sp(sp)
    if @attrib[:sp]-sp>0
      @attrib[:sp]-=sp
    else
      @attrib[:sp]=0
    end
  end
  def can_cast?(end_time,consum)
    (has_state?(:stun)) and return false
    (Game.get_ticks>end_time) or return false
    return consum.effective?(self)
  end
  def can_cast_auto?(end_time,consum)
    Game.get_ticks>end_time or return false
    return consum.effective?(self)
  end
  def cast(name,target,x,y,z)
    unless @skill[name]
      Message.show_format("使用不存在的技能#{name}",'錯誤',:ASTERISK)
      return
    end
    skill=@skill[name]
    if skill.type==:attack
      skill.cast_attack(self,target,@attrib[:atkcd])
    elsif skill.type==:shoot
      skill.cast_attack(self,target,@attrib[:shtcd])
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
  def draw_state(x,y)
    mx,my,* =Mouse.state
    @state.draw(x,y,mx,my)
  end
  def draw
    @animation.update
    @animation.draw
    @animation.draw_hpbar
  end
  def marshal_dump
    data={}
    @@MarshalTable.each{|abbrev,sym|
      data[abbrev]=instance_variable_get(sym)
    }
    #, :@equip
    #:@comsumable_list, :@equip_list, :@item_list, :@pledge_list
    #:@skill, 
    # p instance_variables#.each{|sym|
      # data[sym]=instance_variable_get(sym)
    # }
    # pp data[:skill]
    return [data]
  end
  def marshal_load(array)
    data=array[0]
    @@MarshalTable.each{|abbrev,sym|
      instance_variable_set(sym,data[abbrev])
    }
    # pp data
    #data[:state].bind_actor(self)
  end
end
require_relative 'Actor/Player'
require_relative 'Actor/Friend'
require_relative 'Actor/Enemy'