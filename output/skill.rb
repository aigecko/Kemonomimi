#!/usr/bin/ruby
#coding: utf-8
require_relative 'output'

$skill=Hash.new

$skill[:catear]={
  name:'貓耳基里的祝福',type: :none,
  icon:'./rc/icon/icon/mat_tklre002/skill_029.png:[0,0]',
  comment:'與生俱來的靈活動作讓攻擊更快速'}
$skill[:dogear]={
  name:'尾刀狗',type: :before,cd: 0,
  icon:'./rc/icon/icon/mat_tklre002/skill_028.png:[0,0]',
  base: :Dogear,consum: 0,level: 1,table:[0,0],
  comment:'敵人的生命比例越低對其傷害越高'}
$skill[:foxear]={
  name:'狐耳基里的祝福',type: :none,
  icon:'./rc/icon/skill/2011-12-23_3-078.gif:[0,0]B[255,255,255]',
  comment:'最大SP及消耗多1成 魔法輸出多2成'}
$skill[:wolfear]={
  name:'狼耳基里的祝福',type: :auto,cd: 0.5,
  icon:'./rc/icon/skill/2011-12-23_3-079.gif:[0,0]B[255,255,255]',
  base: :Wolfear,consum: 0,level: 1,table:[0,0],
  comment:'生命越少回復的生命和法力會越多'}

$skill[:counter_attack]={
  name:'反擊之火',type: :pre_attack_defense,
  icon:'./rc/icon/skill/2011-12-23_3-049.gif:[0,0]B[0,255,0]',
  base: :CounterAttack,table:[0,[10,0.1]],
  comment:'受攻擊時反彈#{@table[@level][0]}+#{@table[@level][1]}def絕對傷害'}
$skill[:amplify_hp_block]={
  name:'堅忍不拔',type: :auto,
  icon:'./rc/icon/skill/2011-12-23_3-186.gif:[0,0]B[0,255,0]',
  base: :Amplify,table:[0,{maxhp: 0.06,block: 11}],
  data:{name:'堅忍不拔',sym: :amplify_hp_block},
  comment:'最大生命增幅#{@table[@level][:maxhp]*100}% 格檔增幅#{@table[@level][:block]}%'}
$skill[:fighter_magic_immunity]={
  name:'魔法免疫',type: :active,cd: 30,
  icon:'./rc/icon/icon/tklre04/skill_053.png:[0,0]B[0,255,0]',
  data:{sym: :fighter_magic_immunity},
  base: :MagicImmunity,consum: 50,table:[0,{
        base:{atk: 30,def: 10},#}
        add:{atk:[:str,0.1],def:[:con,0.1]},#}
        magic_last: 4,attrib_last: 9}
    ],
  comment:'魔法免疫且增加#{@table[@level][:base][:atk]}+#{@table[@level][:add][:atk][1]}str近攻及#{@table[@level][:base][:def]}+#{@table[@level][:add][:def][1]}con物防'}#}
$skill[:break_armor]={
  name:'破甲斬擊',type: :append,
  icon:'./rc/icon/icon/tklre05/skill_074.png:[0,0]B[0,255,0]',
  base: :BreakArmor,table:[0,-5],
  comment:'命中目標降低#{-@table[@level]}xLog(matk}的雙防2秒'}
$skill[:fire_boost]={
  name:'猛攻之火',type: :active,consum: 40,cd: 20,
  icon: './rc/icon/skill/2011-12-23_3-050.gif:[0,0]B[0,255,0]',
  base: :Boost,
  table:[0,{base:{atkspd: 40,wlkspd: 0.12},add:{atkspd:[:int,0.1],wlkspd:[:int,0.001]}}],
  data:{name:'猛攻',sym: :boost_fire,icon:'./rc/icon/skill/2011-12-23_3-050.gif',last: 16},
  comment:'在#{@data[:last]}秒內增加#{@table[@level][:base][:atkspd]}+#{@table[@level][:add][:atkspd][1]}int%攻速及#{@table[@level][:base][:wlkspd]*100}+#{@table[@level][:add][:wlkspd][1]*100}int%跑速'}
$skill[:attack_increase]={
  name:'烈火戳刺',type: :before,
  icon:'./rc/icon/icon/mat_tkl001/skill_001a.png:[0,0]',
  base: :AttackIncrease,table:[0,6],
  data:{name:'烈火戳刺',sym: :attack_increase,atk: 15},
  comment:'每次攻擊同一目標提高#{@data[:atk]}傷害最多疊加#{@table[@level]}層'}
$skill[:fire_burn]={
  name:'流動之火',type: :append,
  icon:'./rc/icon/skill/2011-12-23_3-051.gif:[0,0]B[0,255,0]',
  base: :Burn,table:[0,[25,0.55]],
  data:{name:'燃燒',sym: :burn,icon:'./rc/icon/skill/2011-12-23_3-051.gif'},
  comment:'普攻造成目標燃燒2秒造成#{@table[@level][0]}+#{@table[@level][1]}matk絕對傷害'}
$skill[:fire_circle]={
  name:'熾焰焚身',type: :switch_auto,cd: 0.5,
  icon:'./rc/icon/skill/2011-12-23_3-072.gif:[0,0]B[0,255,0]',
  base: :FireCircle,consum: 5,table:[0,[20,{wlkspd: -0.1}]],
  data:{
    coef: 0.9,coef_sym: :matk,type: :mag,
    name:'燃燒',sym: :fire_circle,
    icon:'./rc/icon/skill/2011-12-23_3-072.gif:[0,0]B[0,255,0]',
    last_time: 5,r: 75,h: 50
  },
  comment:'每秒造成#{#T[0]}+matk範圍魔法傷害並降低#{"%d"%(-#T[1][:wlkspd]*100)}%跑速'}
$skill[:fire_burst]={
  name:'火圈迸裂',type: :append,
  icon:'./rc/icon/icon/mat_tkl001/skill_005a.png:[0,0]',
  base: :FireBurst,table:[0,[40,0.3,0.3]],
  comment:'第三下普攻造成範圍#{@table[@level][0]}+#{@table[@level][1]}matk魔傷並暈眩#{@table[@level][2]}秒'}
$skill[:dual_weapon_atkspd]={
  name:'輕巧雙刀',type: :auto,
  icon:'./rc/icon/icon/mat_tkl002/we_sword007b.png:[5,0]',
  base: :DualWeaponAtkspdAcc,
  comment:'雙手裝備雙刀時額外增加雙刀攻速xLog(str)的攻速'}
$skill[:rl_weapon_heal]={
  name:'再生之盾',type: :auto,
  icon:'./rc/icon/icon/mat_tkl003/shield_001r.png:[0,0]',
  base: :RightLeftWeapon,
  data:{def_coef: 0.2,mdef_coef: 0.2,def_conv: :healhp,mdef_conv: :healsp},
  comment:'增加盾#{@data[:def_coef]}物防的回復生命以及#{@data[:mdef_coef]}魔防的回復法力'}
  
$skill[:counter_beam]={
  name:'聖光反射',type: :pre_attack_defense,
  icon:'./rc/icon/icon/mat_tklre002/skill_022.png:[0,0]',
  base: :CounterBeam,table:[0,[20,0.1]],
  data:{possibility: 14,cd: 0.8},
  comment:'受攻擊#{@data[:possibility]}%造成範圍#{@table[@level][0]}+def魔法傷害及暈眩#{@table[@level][1]}秒'}
$skill[:holy_protect]={
  name:'神聖庇護',type: :auto,
  icon:'./rc/icon/skill/2011-12-23_3-073.gif:[0,0]B[255,0,0]',
  base: :Amplify,table:[0,{ignore: 9}],
  data:{name:'神聖庇護',sym: :amplify_ignore},
  comment:'有#{@table[@level][:ignore]}%機率忽略受到的攻擊'}
$skill[:paladin_magic_immunity]={
  name:'魔法免疫',type: :active,cd: 30,
  icon:'./rc/icon/icon/tklre04/skill_053.png:[0,0]B[255,0,0]',
  attach: :contribute,
  base: :MagicImmunity,consum: 50,
  data:{sym: :paladin_magic_immunity},
  table:[0,{base:{matk: 10,def: 30},add:{matk:[:int,0.1],def:[:con,0.1]},magic_last: 3,attrib_last: 3}],#}#}#}
  comment:'魔法免疫且增加#{@table[@level][:base][:matk]}+#{@table[@level][:add][:matk][1]}int魔攻及#{@table[@level][:base][:def]}+#{@table[@level][:add][:def][1]}con物防'}#}
$skill[:paladin_boost]={
  name:'輝煌聖光',type: :active,cd: 6,
  icon:'./rc/icon/icon/mat_tkl001/skill_011.png:[0,0]',
  base: :BoostCircle,consum: 10,attach: :contribute,
  table:[0,[30,30]],
  data:{name:'輝煌聖光',sym: :paladin_boost,icon:'./rc/icon/icon/mat_tkl001/skill_011.png',last: 5},
  comment:'範圍回復#{@table[@level][0]}+0.3matk生命並增加#{@table[@level][1]}+0.1int攻速'}
$skill[:paladin_smash_wave]={
  name:'神聖波動',type: :append,
  icon:'./rc/icon/skill/2011-12-23_3-037.gif:[0,0]B[0,255,0]',
  base: :SmashWave,table:[0,[50,50]],
  data:{sym: :atk,coef: 0.6,type: :umag},
  comment:'攻擊時#{@table[@level][1]}%產生#{@table[@level][0]}+#{@data[:coef]}atk範圍魔法傷害'}
$skill[:paladin_recover]={
  name:'神聖祝福',type: :active,cd: 15,
  icon:'./rc/icon/icon/mat_tkl001/skill_012.png:[0,0]B[255,0,0]',
  base: :Recover,consum: 15,attach: :contribute,
  table:[0,{coef: 0,add: 0.2,attrib:{atk: 0.35}}],
  data:{add: :matk,name:'神聖祝福',sym: :paladin_recover,icon:'./rc/icon/icon/mat_tkl001/skill_012.png',last: 10},
  comment:'每秒回復#{@table[@level][:add]}matk生命並增加#{@table[@level][:attrib][:atk]}%攻擊持續#{@data[:last]}秒'}
$skill[:paladin_chop]={
  name:'聖光衝擊',type: :active,
  icon:'./rc/icon/icon/mat_tkl001/skill_002c.png:[0,0]',
  attach: :contribute,
  base: :Arrow,cd: 3,consum: 5,table:[0,[100,18]],
  data: {sym: :matk,coef: 0.8,type: :mag,cast_type: :skill,
    launch_y: :ground,
    pic:[:follow,{img:['./rc/pic/battle/paladin_chop.png'],w: 50,h: 30},[[[:blit,0]]]],
    live_cycle: :time_only,
    velocity: 18,shape_w: 50,shape_h: 30,shape_t: 30},
  comment:'對直線上敵人造成#{@table[@level][0]}+#{@data[:coef]}matk魔法傷害'}
$skill[:paladin_beam]={
  name:'光束打擊',type: :active,
  icon:'./rc/icon/icon/mat_tkl001/skill_003c.png:[0,0]',
  attach: :contribute,
  base: :Explode,cd: 8,consum: 10,table:[0,[200,100,100]],
  data:{sym: :matk,coef: 0.7,type: :mag,
    pic:[:follow,
    {img:['./rc/pic/battle/paladin_beam.png'],
      w: 120,h: 60,horizon: true,
      limit: 1},[[[:blit,0,24]]]]
  },
  comment:'對指定地點造成#{@table[@level]}+#{@data[:coef]}matk範圍魔法傷害'}
$skill[:contribute]={
  name:'自我奉獻',type: :attach,
  icon:'./rc/icon/icon/mat_tkl001/skill_010.png:[0,0]',
  base: :Contribute,table:[0,0.03],
  comment:'施展技能時回復附近友軍#{@table[@level]*100}%最大生命及最大法力'}
$skill[:rl_weapon_hpsp]={
  name:'平衡之盾',type: :auto,
  icon:'./rc/icon/icon/mat_tkl003/shield_001r.png:[0,0]',
  base: :RightLeftWeapon,
  data:{def_coef: 8,mdef_coef: 8,def_conv: :maxhp,mdef_conv: :maxsp},
  comment:'增加盾#{@data[:def_coef]}倍物防的最大生命及#{@data[:mdef_coef]}倍魔防的最大法力'}
$skill[:single_weapon_matk]={
  name:'平衡之槍',type: :auto,
  icon:'./rc/icon/item/2011-12-23_1-033.gif:[0,0]B[0,0,255]',
  base: :SingleWeapon,
  data:{sym: :atk,coef: 1,conv: :matk},
  comment:'增加長槍1倍物攻的魔攻'}

$skill[:snow_shield]={
  name:'實念之盾',type: :switch_attack_defense,
  icon:'./rc/icon/skill/2011-12-23_3-054.gif:[0,0]B[255,0,0]',
  base: :SnowShield,table:[nil,
    [21,1.2],[22,1.4],[23,1.6],[24,1.8],[25,2.0],
    [26,2.2],[27,2.4],[28,2.6],[29,2.8],[30,3.0],
    [31,3.2],[32,3.4],[33,3.6],[34,3.8],[35,4.0],
    [36,4.2],[37,4.4],[38,4.6],[39,4.8],[40,5.0]
  ],
  comment:'開啟後將#{#T[0]}%傷害轉換成1/#{#T[1]}的法力消耗'}
$skill[:freezing_rain]={
  name:'凍雨凝結',type: :switch_attack_defense,consum: 10,
  icon:'./rc/icon/icon/mat_tklre002/skill_019.png:[0,0]',
  base: :FreezingRain,table:[nil,
    11,12,13,14,15,16,17,18,19,20,
    21,22,23,24,25,26,27,28,29,30],
  data: {name:'凍雨凝結',icon:'./rc/icon/icon/mat_tklre002/skill_019.png:[0,0]',last_time: 3},
  comment:'降低攻擊者#{#T}%近攻魔攻持續#{#D[:last_time]}秒'}
$skill[:ice_body]={
  name:'寒冰之軀',type: :switch_auto,consum: 10,cd: 1,
  icon:'./rc/icon/skill/2011-12-23_3-187.gif:[0,0]B[255,0,0]',
  base: :Amplify,table:[nil,
    {:def=>  11,mdef:  11,consum_amp: -3},{:def=>  22,mdef:  22,consum_amp: -4},
    {:def=>  33,mdef:  33,consum_amp: -5},{:def=>  44,mdef:  44,consum_amp: -6},
    {:def=>  55,mdef:  55,consum_amp: -7},{:def=>  66,mdef:  66,consum_amp: -8},
    {:def=>  77,mdef:  77,consum_amp: -9},{:def=>  88,mdef:  88,consum_amp:-10},
    {:def=>  99,mdef:  99,consum_amp:-11},{:def=> 110,mdef: 110,consum_amp:-12},
    {:def=> 121,mdef: 121,consum_amp:-13},{:def=> 132,mdef: 132,consum_amp:-14},
    {:def=> 143,mdef: 143,consum_amp:-15},{:def=> 154,mdef: 154,consum_amp:-16},
    {:def=> 165,mdef: 165,consum_amp:-17},{:def=> 176,mdef: 176,consum_amp:-18},
    {:def=> 187,mdef: 187,consum_amp:-19},{:def=> 198,mdef: 198,consum_amp:-20},
    {:def=> 209,mdef: 209,consum_amp:-21},{:def=> 220,mdef: 220,consum_amp:-22}
  ],
  data:{name:'寒冰之軀',sym: :ice_body},
  comment:'提升#{#T[:def]}雙防及降低#{-#T[:consum_amp]}%之SP消耗'}
$skill[:frost_thorn]={
  name:'霜刺',type: :switch_append,consum: 20,
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
  comment:'普攻附加#{#T[0]}+#{#D[:coef]}atk無視魔免魔傷\n並強緩#{#T[1]}%跑速#{#T[2]}%攻速持續#{#D[:last_time]}秒'}
$skill[:ice_arrow]={
  name:'寒冰彈',type: :active,
  icon:'./rc/icon/icon/tklre04/skill_055.png:[0,0]B[255,0,0]',
  base: :Missile,consum: 80,cd: 3,table:[nil,
    [ 20],[ 40],[ 60],[ 80],[100],
    [120],[140],[160],[180],[200],
    [220],[240],[260],[280],[300],
    [300],[340],[360],[380],[400]
  ],
  data: {
    coef:{matk: 0.9},type: :mag,before: :ice_wave,
    pic:'./rc/pic/battle/ice_ball.bmp',
    live_cycle: :trigger,live_count: 25,
    velocity: 15,r: 60,h: 50},
  comment:'對指定地點發射冰塊造成#{#T[0]}+#{#D[:coef][:matk]}matk魔法傷害'}
$skill[:freeze]={
  name:'冰凍術',type: :active,
  icon:'./rc/icon/icon/tklre03/skill_034.png:[0,0]',
  base: :MagicCircle,cd: 16,consum: 140,table:[nil,
    [ 20,48,100,{}],[ 40,48,100,{}],[ 60,48,100,{}],[ 80,48,100,{}],[100,48,100,{}],
    [120,48,100,{}],[140,48,100,{}],[160,48,100,{}],[180,48,100,{}],[200,48,100,{}],
    [220,48,100,{}],[240,48,100,{}],[260,48,100,{}],[280,48,100,{}],[300,48,100,{}],
    [320,48,100,{}],[340,48,100,{}],[360,48,100,{}],[380,48,100,{}],[400,48,100,{}]
  ],
  data:{
    coef: 0.5,coef_sym: :matk,type: :mag,before: :ice_wave,
    name:'暈眩',sym: :stun,icon: nil,last: 2.5,
    live_cycle: :time_only,live_count: 16,start: :cursor,
    pic:[:follow,
      {img:['./rc/pic/battle/frozen_circle.png:[0,0]C[96,96]'],
      w: 96,h: 96,cut: true},
      [[
        [:blit,0],[:blit,5],[:blit,10],[:blit,15],[:blit,20],
        [:blit,1],[:blit,6],[:blit,11],[:blit,16],[:blit,21],
        [:blit,2],[:blit,7],[:blit,12,5]
      ]]]
  },
  comment:'將踏入指定地點的敵人冰凍#{#D[:last]}秒\n並造成#{#T[0]}+#{#D[:coef]}*#{#D[:coef_sym]}的魔法傷害'}
$skill[:ice_tornado]={
  name:'水龍捲',type: :active,
  icon:'./rc/icon/skill/2011-12-23_3-057.gif:[0,0]B[255,0,0]',
  base: :MagicCircle,cd: 12,consum: 120,table:[nil,
    [ 15,48,100,{wlkspd: -0.06},{type: :mag,attack:  10}],
    [ 30,48,100,{wlkspd: -0.07},{type: :mag,attack:  20}],
    [ 45,48,100,{wlkspd: -0.08},{type: :mag,attack:  30}],
    [ 60,48,100,{wlkspd: -0.09},{type: :mag,attack:  40}],
    [ 75,48,100,{wlkspd: -0.10},{type: :mag,attack:  50}],
    [ 90,48,100,{wlkspd: -0.11},{type: :mag,attack:  60}],
    [105,48,100,{wlkspd: -0.12},{type: :mag,attack:  70}],
    [120,48,100,{wlkspd: -0.13},{type: :mag,attack:  80}],
    [135,48,100,{wlkspd: -0.14},{type: :mag,attack:  90}],
    [150,48,100,{wlkspd: -0.15},{type: :mag,attack: 100}],
    [165,48,100,{wlkspd: -0.16},{type: :mag,attack: 110}],
    [180,48,100,{wlkspd: -0.17},{type: :mag,attack: 120}],
    [195,48,100,{wlkspd: -0.18},{type: :mag,attack: 130}],
    [210,48,100,{wlkspd: -0.19},{type: :mag,attack: 140}],
    [225,48,100,{wlkspd: -0.20},{type: :mag,attack: 150}],
    [240,48,100,{wlkspd: -0.21},{type: :mag,attack: 160}],
    [255,48,100,{wlkspd: -0.22},{type: :mag,attack: 170}],
    [270,48,100,{wlkspd: -0.23},{type: :mag,attack: 180}],
    [285,48,100,{wlkspd: -0.24},{type: :mag,attack: 190}],
    [300,48,100,{wlkspd: -0.25},{type: :mag,attack: 200}]
  ],
  data:{
    coef: 0.6,coef_sym: :matk,type: :mag,before: :ice_wave,
    name:'潮溼',sym: :water_slow,icon: nil,last: 6,
    live_cycle: :time_only,live_count: 24,
    start: :caster,vx: 18,
    pic:[:follow,
      {img:['./rc/pic/battle/3992_1077658210.png:[0,0]C[96,96]'],
      w: 96,h: 96,cut: true},
      [[
        [:blit,0],[:blit,5],[:blit,10],[:blit,15],[:blit,20],
        [:blit,1],[:blit,6],[:blit,11],[:blit,16],[:blit,21],
        [:blit,2],[:blit,7],[:blit,12],[:blit,17],[:blit,22],
        [:blit,3],[:blit,8],[:blit,13],[:blit,18],[:blit,23],
        [:blit,4],[:blit,9],[:blit,14],[:blit,19],[:blit,24]
      ]]]
  },
  comment:'直線敵人受到範圍#{#T[0]}+#{#D[:coef]}*#{#D[:coef_sym]}魔傷\n'+
          '並附加#{#T[4][:attack]}魔傷及緩#{"%d"%(-#T[3][:wlkspd]*100)}%跑速持續6秒'}
$skill[:ice_wave]={
  name:'寒冰凍破',type: :skill_before,
  icon:'./rc/icon/skill/2011-12-23_3-052.gif:[0,0]B[255,0,0]',
  base: :IceWave,cd: 0,consum: 0,table:[nil,
     10, 20, 30, 40, 50, 60, 70, 80, 90,100,
    110,120,130,140,150,160,170,180,190,200],
  data:{coef:{int: 0.3}},
  comment:'魔法命中造成#{#T}+#{#D[:coef][:int]}int範圍絕對傷害'}
  
  
Output('skill')