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
          {img:['./rc/pic/battle/arrow.png:[0,0]C[50,11]'],cut: true,w: 50,h: 11},
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
        base: :MototadaR,table:[nil,
          [17, 80,50],[19, 85,50],[21, 90,50],[23, 95,50],[25,100,50],
          [27,105,50],[29,110,50],[31,115,50],[33,120,50],[35,125,50],
          [37,130,50],[39,135,50],[41,140,50],[43,145,50],[45,150,50]
        ],
        comment:'反彈受到傷害之#{#T[0]}%絕對傷害給範圍#{#T[1]}的敵人')
      add_class_skill(:defense,:black_hole,
        name:'能量黑洞',type: :auto,
        icon:'./rc/icon/skill/2011-12-23_3-069.gif:[0,0]B[255,0,0]',
        base: :Amplify,table:[nil,
          {ignore:  6,atk_vamp: 0.03,skl_vamp: 0.03},{ignore:  7,atk_vamp: 0.04,skl_vamp: 0.04},
          {ignore:  8,atk_vamp: 0.05,skl_vamp: 0.05},{ignore:  9,atk_vamp: 0.06,skl_vamp: 0.06},
          {ignore: 10,atk_vamp: 0.07,skl_vamp: 0.07},{ignore: 11,atk_vamp: 0.08,skl_vamp: 0.08},
          {ignore: 12,atk_vamp: 0.09,skl_vamp: 0.09},{ignore: 13,atk_vamp: 0.10,skl_vamp: 0.10},
          {ignore: 14,atk_vamp: 0.11,skl_vamp: 0.11},{ignore: 15,atk_vamp: 0.12,skl_vamp: 0.12},
          {ignore: 16,atk_vamp: 0.13,skl_vamp: 0.13},{ignore: 17,atk_vamp: 0.14,skl_vamp: 0.14},
          {ignore: 18,atk_vamp: 0.15,skl_vamp: 0.15},{ignore: 19,atk_vamp: 0.16,skl_vamp: 0.16},
          {ignore: 20,atk_vamp: 0.17,skl_vamp: 0.17},{ignore: 21,atk_vamp: 0.18,skl_vamp: 0.18},
          {ignore: 22,atk_vamp: 0.19,skl_vamp: 0.19},{ignore: 23,atk_vamp: 0.20,skl_vamp: 0.20},
          {ignore: 24,atk_vamp: 0.21,skl_vamp: 0.21},{ignore: 25,atk_vamp: 0.22,skl_vamp: 0.22}
        ],
        data:{name:'能量黑洞',sym: :black_hole},
        comment:'#{#T[:ignore]}%機率無視攻擊並增加#{(#T[:atk_vamp]*100).to_i}%普攻吸血及#{(#T[:skl_vamp]*100).to_i}%技能吸血')
      add_class_skill(:attack,:darkknight_rage,
        name:'血性狂怒',type: :active,consum: 105,cd: 29,
        icon:'./rc/icon/icon/tklre04/skill_058.png:[0,0]B[0,255,0]',
        base: :MagicImmunity,table:[nil,
          {base:{atkspd:  55,wlkspd: 0.16},magic_last: 2.2,attrib_last: 18},
          {base:{atkspd:  60,wlkspd: 0.16},magic_last: 2.4,attrib_last: 18},
          {base:{atkspd:  65,wlkspd: 0.16},magic_last: 2.6,attrib_last: 18},
          {base:{atkspd:  70,wlkspd: 0.16},magic_last: 2.8,attrib_last: 18},
          {base:{atkspd:  75,wlkspd: 0.16},magic_last: 3.0,attrib_last: 18},
          {base:{atkspd:  80,wlkspd: 0.16},magic_last: 3.2,attrib_last: 18},
          {base:{atkspd:  85,wlkspd: 0.16},magic_last: 3.4,attrib_last: 18},
          {base:{atkspd:  90,wlkspd: 0.16},magic_last: 3.6,attrib_last: 18},
          {base:{atkspd:  95,wlkspd: 0.16},magic_last: 3.8,attrib_last: 18},
          {base:{atkspd: 100,wlkspd: 0.16},magic_last: 4.0,attrib_last: 18},
          {base:{atkspd: 105,wlkspd: 0.16},magic_last: 4.2,attrib_last: 18},
          {base:{atkspd: 110,wlkspd: 0.16},magic_last: 4.4,attrib_last: 18},
          {base:{atkspd: 115,wlkspd: 0.16},magic_last: 4.6,attrib_last: 18},
          {base:{atkspd: 120,wlkspd: 0.16},magic_last: 4.8,attrib_last: 18},
          {base:{atkspd: 125,wlkspd: 0.16},magic_last: 5.0,attrib_last: 18},
          {base:{atkspd: 130,wlkspd: 0.16},magic_last: 5.2,attrib_last: 18},
          {base:{atkspd: 135,wlkspd: 0.16},magic_last: 5.4,attrib_last: 18},
          {base:{atkspd: 140,wlkspd: 0.16},magic_last: 5.6,attrib_last: 18},
          {base:{atkspd: 145,wlkspd: 0.16},magic_last: 5.8,attrib_last: 18},
          {base:{atkspd: 150,wlkspd: 0.16},magic_last: 6.0,attrib_last: 18}
        ],
        data:{sym: :darkknight_magic_immunity},
        comment:'魔法免疫#{#T[:magic_last]}秒並增加#{#T[:base][:atkspd]}%攻速#{"%d"%(#T[:base][:wlkspd]*100)}%跑速持續#{#T[:attrib_last]}秒')
      add_class_skill(:attack,:slow_poison,
        name:'淬毒武器',type: :append,
        icon:'./rc/icon/icon/mat_tklre002/skill_024.png:[0,0]',
        base: :SlowPoison,table:[nil,
          [ 10,0.5,33,0],[ 20,0.5,36,0],[ 30,0.5,39,0],[ 40,0.5,42,0],[ 50,0.5,45,0],
          [ 60,0.5,48,0],[ 70,0.5,51,0],[ 80,0.5,54,0],[ 90,0.5,57,0],[100,0.5,60,0],
          [110,0.5,63,0],[120,0.5,66,0],[130,0.5,69,0],[140,0.5,72,0],[150,0.5,75,0],
          [160,0.5,78,0],[170,0.5,81,0],[180,0.5,84,0],[190,0.5,87,0],[200,0.5,90,0]
        ],
        data:{
          name:'淬毒武器',sym: :slow_poison,
          icon:'./rc/icon/icon/mat_tklre002/skill_024.png:[0,0]',
          attrib: :matk,type: :mag,last_time: 4},
        comment:'普通攻擊附加持續的傷害\n造成每秒#{#T[0]}+#{#T[1]}*matk魔法傷害\n並降低#{#T[2]}%攻速持續#{#D[:last_time]}秒')
      add_class_skill(:magic,:darkknight_coercion,
        name:'威壓靈氣',type: :auto,
        icon:'./rc/icon/icon/tklre04/skill_065.png:[0,0]B[255,0,0]',
        base: :Aura,table:[nil,
          {attrib:{phy_resist: -11,mag_resist: -16},r: 100,h: 100},{attrib:{phy_resist: -12,mag_resist: -17},r: 100,h: 100},
          {attrib:{phy_resist: -13,mag_resist: -18},r: 100,h: 100},{attrib:{phy_resist: -14,mag_resist: -19},r: 100,h: 100},
          {attrib:{phy_resist: -15,mag_resist: -20},r: 100,h: 100},{attrib:{phy_resist: -16,mag_resist: -21},r: 100,h: 100},
          {attrib:{phy_resist: -17,mag_resist: -22},r: 100,h: 100},{attrib:{phy_resist: -18,mag_resist: -23},r: 100,h: 100},
          {attrib:{phy_resist: -19,mag_resist: -24},r: 100,h: 100},{attrib:{phy_resist: -20,mag_resist: -25},r: 100,h: 100},
          {attrib:{phy_resist: -21,mag_resist: -26},r: 100,h: 100},{attrib:{phy_resist: -22,mag_resist: -27},r: 100,h: 100},
          {attrib:{phy_resist: -23,mag_resist: -28},r: 100,h: 100},{attrib:{phy_resist: -24,mag_resist: -29},r: 100,h: 100},
          {attrib:{phy_resist: -25,mag_resist: -30},r: 100,h: 100}
        ],
        data:{target: :enemy,name:'威壓',sym: :darkknight_coercion},
        comment:'降低範圍#{#T[:r]}內敵人#{-#T[:attrib][:phy_resist]}%物理抗性#{-#T[:attrib][:mag_resist]}%魔法抗性')
      add_class_skill(:magic,:darkknight_weaken,
        name:'衰弱靈氣',type: :auto,
        icon:'./rc/icon/icon/tklre04/skill_066.png:[0,0]B[255,0,0]',
        base: :Aura,table:[nil,
          {attrib:{phy_decatk:  -5,mag_decatk:  -5,consum_amp: 12},r: 100,h: 100},
          {attrib:{phy_decatk: -10,mag_decatk: -10,consum_amp: 14},r: 100,h: 100},
          {attrib:{phy_decatk: -15,mag_decatk: -15,consum_amp: 16},r: 100,h: 100},
          {attrib:{phy_decatk: -20,mag_decatk: -20,consum_amp: 18},r: 100,h: 100},
          {attrib:{phy_decatk: -25,mag_decatk: -25,consum_amp: 20},r: 100,h: 100},
          {attrib:{phy_decatk: -30,mag_decatk: -30,consum_amp: 22},r: 100,h: 100},
          {attrib:{phy_decatk: -35,mag_decatk: -35,consum_amp: 24},r: 100,h: 100},
          {attrib:{phy_decatk: -40,mag_decatk: -40,consum_amp: 26},r: 100,h: 100},
          {attrib:{phy_decatk: -45,mag_decatk: -45,consum_amp: 28},r: 100,h: 100},
          {attrib:{phy_decatk: -50,mag_decatk: -50,consum_amp: 30},r: 100,h: 100},
          {attrib:{phy_decatk: -55,mag_decatk: -55,consum_amp: 32},r: 100,h: 100},
          {attrib:{phy_decatk: -60,mag_decatk: -60,consum_amp: 34},r: 100,h: 100},
          {attrib:{phy_decatk: -65,mag_decatk: -65,consum_amp: 36},r: 100,h: 100},
          {attrib:{phy_decatk: -70,mag_decatk: -70,consum_amp: 38},r: 100,h: 100},
          {attrib:{phy_decatk: -75,mag_decatk: -75,consum_amp: 40},r: 100,h: 100},
        ],
        data:{target: :enemy,name:'衰弱',sym: :darkknight_weaken},
        comment:'降低範圍#{#T[:r]}內敵人之#{-#T[:attrib][:phy_decatk]}降低物魔傷並增加#{#T[:attrib][:consum_amp]}法力消耗')
      add_class_skill(:magic,:darkknight_erosion,
        name:'黑暗侵蝕',type: :switch_auto,consum: 15,cd: 0.5,
        icon:'./rc/icon/icon/tklre04/skill_061.png:[0,0]B[255,0,0]',
        base: :FireCircle,table:[nil,
          [ 10,{healhp:  -15,healsp:  -15}],[ 20,{healhp:  -20,healsp:  -20}],
          [ 30,{healhp:  -25,healsp:  -25}],[ 40,{healhp:  -30,healsp:  -30}],
          [ 50,{healhp:  -35,healsp:  -35}],[ 60,{healhp:  -40,healsp:  -40}],
          [ 70,{healhp:  -45,healsp:  -45}],[ 80,{healhp:  -50,healsp:  -50}],
          [ 90,{healhp:  -55,healsp:  -55}],[100,{healhp:  -60,healsp:  -60}],
          [110,{healhp:  -65,healsp:  -65}],[120,{healhp:  -70,healsp:  -70}],
          [130,{healhp:  -75,healsp:  -75}],[140,{healhp:  -80,healsp:  -80}],
          [150,{healhp:  -85,healsp:  -85}],[160,{healhp:  -90,healsp:  -90}],
          [170,{healhp:  -95,healsp:  -95}],[180,{healhp: -100,healsp: -100}],
          [190,{healhp: -105,healsp: -105}],[200,{healhp: -110,healsp: -110}]
        ],
        data:{
          coef: 0.05,coef_sym: :maxhp,type: :acid,
          name:'黑暗侵蝕',sym: :darkknight_erosion,
          icon: nil,last_time: 2,r: 80,h: 100
        },
        comment:'開啟後範圍#{#T[0]}+#{#D[:coef]}*#{#D[:coef_sym]}絕對傷害\n並降低#{-#T[1][:healhp]}HP,SP回復持續#{#D[:last_time]}秒')
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
      [:snow_shield,:freezing_rain,:ice_body].each{|skill|
        add_class_skill(:defense,skill,Database.get_skill(skill))
      }
      [:frost_thorn].each{|skill|
        add_class_skill(:attack,skill,Database.get_skill(skill))
      }
      [:ice_arrow,:freeze,:ice_tornado,:ice_wave].each{|skill|
        add_class_skill(:defense,skill,Database.get_skill(skill))
      }
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
    (Game.get_ticks>=end_time) or return false
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