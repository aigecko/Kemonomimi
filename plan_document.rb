#coding: utf-8
require 'pp'
weapon={
  :dual=>{
    :雙劍=>{atk:"40*L",atkspd:"10*L"},
    :雙斧=>{atk:"45*L",healhp:"5*L"}
  },
  :single=>{
    :長槍=>{atk:"60*L",con:"20*L"},
    :大斧=>{atk:"60*L",str:"20*L"}
  },
  :right=>{
    :單手劍=>{atk:"40*L",def:"20*L"},#}
    :單手鎚=>{atk:"40*L",maxhp:"100*L"}
  },
  :ward=>{
    :法杖=>{atk:"20*L",matk:"40*L",int:"15*L"},
    :魔法劍=>{atk:"35*L",matk:"25*L",wis:"15*L"}
  },
  :sheild=>{
    :重盾=>{def:"20*L",block:"3*L"},#}
    :魔法盾=>{def:"15*L",mdef:"15*L"},#}
    :輕盾=>{def:"15*L",tough:"4*L",wlkspd:"2"}#}
  },
  :book=>{
    :魔法書=>{atk:"4*L",def:"10*L",mdef:"20*L"}#}
  }
}
armor={
  :head=>%w[頭盔(def) 角盔(def,atk) 頭巾(def,mdef) 圓帽(def,matk,ratk) 魔法帽(def,mdef,matk)],
  :neck=>%w[項鍊(str)(int)(agi) 護頸(def,atk)(def,matk)(mdef,matk)(mdef,atk)],
  :body=>%w[重甲(def,mdef,maxhp) 法袍(def,mdef,maxsp) 輕甲(def,mdef,dodge)],
  :back=>%w[
    夾克(def,healhp,phy_resist)(healhp,phy_resist)(def,atk,phy_resist)(def,matk,phy_resist)(def,ratk,phy_resist)
    背心(mdef,healsp,mag_resist)(healsp,mag_resist)(mdef,atk,mag_resist)(mdef,matk,mag_resist)(mdef,ratk,mag_resist)
  ],
  :range=>%w[弩(ratk,atkspd,def) 弓(ratk,atkspd,wlkspd%) 鐵砲(ratk)],
  :finger=>%w[戒指(str%)(int%)(agi%)(healhp,heapsp)(con%)(wis%)(wlkspd%)(atkspd%)],
  :feet=>%w[鞋(wlkspd) 靴(wlkspd,con)],
  :deco=>%w[茶具(healhp,healsp) 平蜘蛛釜(healhp,heapsp) 抗擊護符(phy_decatk,御守) 禦魔護符(mag_decatk,御守) 鬼面(atk_vamp,str) 能面(skl_vamp,int) 短甲(phy_decatk) 抗魔短甲(mag_decatk) 御守]
}
material={
  #L1
  :紙Paper=>{wlkspd: 2}, #pc4
  #L2
  :布Cloth=>{mdef: 5}, #pc6
  :皮hide=>{def: 5},#} #pc6
  #L3
  :木Wood=>{phy_decatk: 2}, #pc8
  #L4
  :鋁Aluminum =>{atkspd: 5},    #pc16
  :青銅Bronze=>{mag_decatk: 5}, #pc12
  #L5
  :鐵Iron=>{wis: 5}, #pc32
  :錫Tin=>{int: 5},  #pc32
  #L6
  :鈦Titanium =>{con: 5}, #pc64
  :銀silver=>{agi: 5},    #pc96
  :金gold=>{str: 5},      #pc128
  #L7
  :藍寶石Sapphire=>{maxsp: 0.02}, #pc160
  :紅寶石Ruby=>{maxhp: 0.02},     #pc160
  #L8
  :鑽石Dimond=>{atk: 8}, #pc192
  :以太Ether=>{matk: 8}  #pc256
}
base={
  soul_of_Leyasu:{table:['I_percent','F_conv_coeff']},#德川D
  physical_immunity:{table:['F_second']},#物免
  magic_immunity:{table:{#魔免
      base:{'S_symbol'=>'I_value'},add:{'S_symbol'=>['S_symbol','F_coeff']},
      immunity_last:'F_last',attrib_last:'F_last'}},
  rock_shield:{table:['I_base','F_coeff'],data:{sym:'S_symbol',last:'F_last'}},#上盾
  soul_of_Yoshitsugu:{table:['I_possibility','I_coeff'],data:{last:'F_last'}},#大谷E
  energy_arrow:{table:['I_base','F_coeff'],#普攻帶n+m*type的X類型傷害
    data:{sym:'S_symbol',type:'S_damage_type'}},
  solid_defense:{table:[attrib:'Attrib',level:'I_level'],#普攻自身疊屬性
    data:{last:'F_last'}},
  explode:{table:['I_base'],#指定範圍n+m*type的X類型傷害
    data:{
      sym:'S_symbol',coef:'F_coeff',type:'S_damage_type',cast_type:'S_cast_type',
      attack_defense:'Array',append:'Array',pic:'s_filename'}},
  magic_arrow:{table:['I_base','I_live_count'],#前方範圍n+m*type的X類型傷害
    data:{
      sym:'S_symbol',coef:'F_coeff',type:'S_damage_type',cast_type:'S_cast_type',
      attack_defense:'Array',append:'Array',pic:'s_filename',
      live_cycle:'S_live_cycle',launch_y:'S_position',velocity:'I_velocity'}},
  missile:{table:['I_damage'],#指定方向範圍n+m*type的X類型傷害
    data:{coef:{'S_symbol'=>'F_coef'},type:'S_type',append:'Array',
    live_cycle:'S_cycle',live_count:'I_count',velocity:'I_velocity'}},
  soul_of_Masayuki:{table:['I_reduce_percent','F_convert_coef']},#法力盾
  freezing_rain:{table:['I_base','F_second'],table:{coef:'F_coef',icon:'s_filename'}},#降低敵人%屬性
  boost:{table:{base:{'S_symbol'=>'I_value'},add:{'S_symbol'=>['S_symbol','F_coeff']},last:'F_last'}},#暫時增加屬性
  counter_attack:{table:['I_base','F_coef']},#反彈n+m*def的絕對傷害
  amplify:{table:{'S_symbol'=>'FI_attrib'},data:{name:'s_skill_name',sym:'S_state_symbol'}},
  break_armor:{table:'I_base'},
  invisible:{talbe:{last:'I_last',damage:'I_damage',wlkspd:'F_wlkspd'}},
  fire_circle:{table:['I_base','F_slow']},
  counter_beam:{table:['I_base','F_coef'],data:{possibility:'I_pos',cd:'F_second'}},
  pressure_erupt:{data:'I_last'},
  contribute:{table:['I_base','F_coef','I_second'],data:{sym:'S_symbol'}},
  smash_wave:{table:['I_base','F_coef','H_attrib'],data:{last:'F_second'}},
  soul_of_Mototada:{table:'I_percent'},
  soul_of_Nagayoshi:{table:['I_base','F_coef'],data:{base:'F_min_base',coef:'F_max_coef'}},
  soul_of_Nobufusa:{table:['I_hp_unit',{'S_symbol'=>'FI_attrib'}]},
  soul_of_Kiyomasa:{table:['I_base','F_coef'],data:{last:'I_second'}},
  soul_of_Yasumasa:{table:['I_base','F_coef','I_atkspd'],data:{last:'I_second'}},
  piezoelectric_effect:{table:{'S_dst_attrib'=>['I_base','F_coef']},data:{conv:{'S_dst_symbol'=>'S_src_symbol'},last:'I_second'}},
  soul_of_Yoshimoto:{table:['I_base','F_coef'],data:{conv:'S_symbol'}},
  soul_of_Muneshige:{table:['I_base','F_coef'],data:{conv:'S_symbol'}},
  flash:{table:'I_limit_length'},
  soul_of_Ittetsu:{table:['I_base','F_coef','I_cd_second'],data:{sym:'S_symbol',last:'I_last_second'}},

  ward_power:{table:['S_dst_attrib','S_src_symbol','F_coef']},
  dual_weapon_atkspd_acc:{},
  rl_weapon:{def_coef:'FI_attrib',mdef_coef:'FI_attrib',def_conv:'S_symbol',mdef_conv:'S_symbol'},
  single_weapon:{data:{sym:'S_src_attrib',coef:'F_coef',conv:'S_dst_attrib'}},
  magic_bow:{data:{weapon:'S_type',sym:'S_src_attrib',coef:'FI_coef',conv:'S_dst_attrib'}},

  metamorphosis:[]
}
race={
  :catear=>'增加n跑速及降低m基礎攻速s基礎射速',
  :foxear=>'最大法力及消耗法力增加n%但魔法輸出增加m%',
  :dogear=>'目標血量<90+5%,<70+10%,<50+20%,<30+30%,<20+40%,<10+50%,<5%60%',
  :wolfear=>'自身每秒回復n%損失生命並回復m倍等量法力',
  :leopardcatear=>'受到攻擊有n%機率減傷m%持續r秒'
}
common={
  :attack=>%w{
    屹立不搖:普通攻擊回復HP,SP#heal
    力拔山河:增加n%力量#amplify
    足智多謀:增加n%智力#amplify
    百步穿楊:增加n%敏捷#amplify
    賭性堅強:n%m倍爆擊#amplify
  },
  :defense=>%w{
    忍辱負重:增加n%體質#amplify
    識途老馬:增加n%智慧#amplify
    疾風勁草:增加n韌性#amplify
  },
  :other=>%w{
    趁火打劫:增加掉落n%金錢#amplify
    精打細算:降低消費n%金錢#amplify
    貪生怕死:增加n跑速#amplify
    速戰速決:增加n攻速#amplify
    自我治癒:增加n的healhp#amplify
    心平氣和:增加n的healsp#amplify
  }
}
klass={
  :cleric=>%w[
    #15+能量吸收:減少(3+lv)%受到傷害並轉成(1.4+4*lv)倍法力#attack_dendese->soul_of_Leyasu
    #15+岩石護盾:開啟後產生(50*lv)+0.2*maxsp盾持續5秒#rock_shield
    
    #20+回復靈氣:範圍200友軍增加(5*lv)+0.01*con回血(5+lv)+0.015*wis回魔#aura
    #20+加速靈氣:範圍200友軍增加(10+lv)+0.2*atkspd%攻速(5+0.5*lv)%跑速#aura
    #20+降傷靈氣:範圍200友軍增加(12*lv)+0.1*con物防(14*lv)+0.1*wis魔防#aura
    #20+振奮靈氣:範圍200友軍增加(12*lv)+0.1*matk近攻魔攻遠攻
    
    #15+大地凈化:消除範圍75內之魔法效果並額外造成(10*lv)魔法傷害
    #15+大地杖擊:開啟後普攻帶(24*lv)+0.15*sp無視魔免魔傷#append->energy_arrow
    #20+震地重擊:開啟後周圍敵人範圍(25*lv)+0.9*matk魔法傷害暈2秒#explode

    法杖儲能:增加法杖魔攻5倍的最大法力#ward_power

    大地之力:開啟後增加400%攻速(100/200/300)智力智慧及普攻回復0.1*matk生命持續(10/16/22)秒#metamorphosis
  ],
  :mage=>%w[
    V#20+實念之盾:開啟後(20+lv)%傷害交由(1+lv*0.2)法力承受#switch_attack_defnese->soul_of_Masayuki
    V#20+凍雨凝結:造成攻擊者降低(10+lv)%近攻遠攻持續3秒#attack_defense->freezing_rain
    V#20+寒冰之軀:提升(11*lv)雙防及降低(2+lv)%sp消耗#switch_auto->amplify

    V#20+霜刺:普攻附加(25*lv)+0.2*atk無視魔免魔傷以及強緩(10+2*lv)%跑速(25+3*lv)%攻速2秒#switch_append->energy_arrow

    V#20+寒冰彈:指定方向敵人受到(20*lv)+0.9*matk魔法傷害#missile
    V#20+冰凍術:指定敵人受到範圍(20*lv)+0.5*matk魔傷暈2.5秒#missile
    V#20+水龍捲:直線敵人受到範圍(15*lv)+0.6*matk魔傷並付帶(10*lv)魔傷及緩(5+lv)%跑速持續6秒#magic_arrow
    V#20+寒冰凍破:法術命中後額外造成(10*lv)+0.3*int絕對傷害#explode

    法杖聚焦:增加法杖魔攻20%的int#ward_power

    寒冰之力:開啟後增加(15/18/21)%技吸及(800/1200/1600)最大生命(1000/1400/1800)最大法力並持續20秒#metamorphosis
  ],
  :fighter=>%w[
    #20+反擊之火:受到普攻反彈(10*lv)+0.5*def絕對傷害#attack_defnese->counter_attack
    #20+堅忍不拔:最大生命增幅(5+0.75*lv)%且格檔增幅(6+lv)%#auto->amplify
    #20+無畏衝鋒:魔法免疫(1+lv*0.25)秒並增加(20*lv)近攻#magic_immunity

    #20+破甲斬擊:普攻造成目標降低(5*lv)*log(matk)雙防#break_armor
    #20+流動之火:普攻造成目標每秒(15*lv)+0.55*matk絕對傷害持續2秒#burn
    #20+烈火猛攻:在(4+0.2*lv)秒內有100%機率普攻暈0.32秒並帶(20*lv)傷害#boost
    #20+火圈迸裂:普攻造成範圍(0.01+0.002*lv)*maxhp物傷#switch_append->explode

    #20+熾焰焚身:每秒造成(40*lv)+0.3*matk魔法傷害並降低(10+lv)%跑速#switch_auto->fire_circle

    輕巧雙刀:雙手裝備雙刀時額外增加雙刀0.1近攻的攻速#auto->dual_weapon_atkspd_acc
    再生之盾:增加盾0.2物防的回復生命以及0.2魔防的回復法力#auto->rl_weapon

    火焰之力:開啟後增加40跑速(15/30/45)%魔法減傷且基礎攻速變為1.0持續(20/26/32)秒#metamorphosis
    
    #隱藏技能:爆裂連斬:對指定敵人進行(5/6/7)次斬擊
  ],
  :paladin=>%w[
    #15+神聖庇護:(7+lv)%機率無視攻擊並增加(5+lv)%雙防#auto->amplify
    #20+聖光反射:受攻擊(14+lv)%造成範圍(20*lv)+0.3*mdef魔傷及暈眩0.2秒#attack_defense->counter_beam
    #15+聖光庇佑:魔法免疫(2+0.2*lv)秒並增加(20*lv)雙防#magic_immunuty
    
    #15+輝煌聖光:範圍產生(40*lv)+1.1*mdef護盾並增加(35+2*lv)攻速持續4秒
    #20+神聖波動:普攻帶範圍(20*lv)+0.6*atk物理傷害#switch_append->smash_wave
    #20+神聖祝福:自身每秒回複(10*lv)+0.2*matk生命並增加(20*lv)+0.1*def攻擊持續t秒#recover

    #20+一瞬閃光:前方直線(20*lv)+0.5*matk魔法傷害#magic_arrow
    #20+光束打擊:指定範圍(20*lv)+0.8*matk魔法傷害#explode
    #15+自我奉獻:施展法術時範圍回復(10*lv)+3%最大生命法力#attach->contribute

    平衡之盾:增加盾8倍def最大生命及8倍mdef最大法力#auto->rl_weapon
    平衡之槍:增加長槍90%atk的魔攻#auto->single_weapon

    神聖之力:開啟後增加(1000/1500/2000)最大生命跑速30%且基礎攻速變為(1.1/1.0/0.9)持續(40/50/60)秒#metamorphosis
  ],
  :darkknight=>%w[
    V#15+血殤靈光:反彈受到的(15+2*lv)%絕對傷害給範圍(75+5*lv)敵人#attack_defense->soul_of_Mototada
    V#15+以血償血:無視傷害時吸收其(20+lv)%傷害之生命值#ignore
    V#20+能量黑洞:(5+lv)%無視傷害並增加(2+lv)%雙吸血#auto->amplify
    
    V#20+血性狂怒:魔法免疫(2+0.2*lv)秒並增加(50+5*lv)攻速16%跑速18秒#magic_immunity
    V#20+淬毒武器:普通攻擊附加(10*lv)+0.5*matk魔法傷害並降低(30+3*lv)%攻速持續4秒

    V#15+威壓靈氣:降低範圍敵人(10+lv)%物理抗性(15+lv)%魔法抗性
    V#15+衰弱靈氣:降低範圍敵人(5*lv)降低物魔傷並增加(10+2*lv)法力消耗
    V#20+黑暗侵蝕:開啟後範圍(10*lv)+0.05*maxhp絕對傷害並降低(10+5*lv)HPSP回復持續2秒(skl_vamp)#fire_circle
    V#20+致命脈衝:直線造成(30*lv)+0.6*matk絕對傷害暈1.5秒(skl_vamp)#arrow

    長槍:paladin
    劍盾:paladin
    
    黑暗之力:開啟後增加(200/300/400)韌性魔防及(1000/1500/2000)最大生命且基礎攻速變為1.2持續40秒#metamorphosis
    
    #隱藏技能:萬歲衝鋒:消耗50%生命並同時造成範圍等量傷害且10秒內增加25%近攻20%受到之傷害
  ],
  :crossbowman=>%w[
    #15+能量轉化:降低受到魔傷(8+lv)%#auto->amplify
    #20+巨人外皮:增加(50*lv)最大生命並降低受到的(5*lv)普通攻擊#pre_attack_defense->soul_of_Yoshimoto
    #15+動如雷霆:開啟後增加(10+lv*2)%跑速(100+10*lv)韌性持續5秒
    
    #20+積蓄能量:20%機率(1.5+0.1*lv)倍爆擊並提升(40+2*lv)%攻擊速度#auto->amplify
    #15+負電位差:弓箭命中後消減敵方(30*lv)+0.4*int法力並造成等量魔法傷害#append->soul_of_Muneshige
    #20+閃電噴發:開啟後弓箭命中後產生範圍(20*lv)+0.2*agi物理傷害#switch_append->explode
    #15+雷神之箭:增加(80+8*lv)弓箭射程以及(1+lv)弓箭生命值
    
    #20+天雷怒擊:指定範圍(40*lv)+0.5*matk魔法傷害緩(15+lv)%跑速#explode
    #20+暴怒雷擊:射出讓敵方受到(20*lv)+0.4*matk魔法傷害暈眩2秒的弓箭#magic_arrow

    魔法之弩:增加弩0.75倍ratk魔攻#auto->magic_bow

    閃電之力:開啟後遠攻提升(170/180/190)%並增加(250/350/500)雙防持續10秒#metamorphosis
  ],
  :archer=>%w[
    #20+身輕如燕:瞬間移動(150+10*lv)#flash
    #15+旋風護盾:每15秒自動產生(30*lv)+1.2*mdef魔法護盾持續(lv)秒#soul_of_Ittetsu

    #20+疾風祝福:開啟後回復(20*lv)+0.2*matk生命並增加(40+4*lv)%攻速持續20秒#boost
    #15+精準命中:40%機率(1.3+0.04*lv)倍爆擊%#auto->amplify
    #20+氣流爆發:(10+lv)%機率暈0.4秒額外(25*lv)傷害#auto->amplify
    #20+無形之箭:弓箭可穿透(1+0.25*lv)敵人並提升弓箭速度(lv)#auto->amplify

    #15+氣流擾動:指定地點敵人受到範圍(40*lv)魔法傷害並降低(15+lv)%跑速持續3秒
    #15+望風披靡:射出可以造成(40*lv)+0.8*matk魔法傷害並沉默2.5秒的弓箭#magic_arrow
    #20+狂風之襲:直線造成(25*lv)+0.5*matk魔法傷害並降低閃避(5+lv)持續6秒#explode

    暴風之弓:弓的攻速強化為1.6倍#magic_bow

    烈風之力:增加20%閃避(20/25/30)%魔法抗性且基礎攻速變為1.2持續28秒#metamorphosis
  ]
}
monster={
  :迷你始萊姆=>%w[ 普通攻擊 ],
  :火焰始萊姆=>%w[ 普通攻擊,
    灼傷:普攻帶r物傷降低n攻速持續m秒 ],
  :寒冰始萊姆=>%w[ 普通攻擊
    凍傷:普攻帶r魔傷降低n跑速持續m秒 ],
  :中型始萊姆=>%w[ 普通攻擊
    痛擊:n%m倍爆擊],
  :大型始萊姆=>%w[ 普通攻擊
    重擊:n%造成m額外傷害並暈眩r秒],

  :屏風級靈石=>%w[
    緩速靈氣:範圍降低敵人n%跑速m攻速
    魔力砲擊:射出砲彈n物理傷害
    魔方陣近迫系統:對來襲物體每秒發射n顆子彈攔截
  ],
  :次高級靈石=>%w[
    治癒靈氣:範圍增加n回血
    魔力砲擊:射出砲彈造成n物理傷害
    聚焦光束:射出光束造成直線n物理傷害

    魔彈近迫系統:鎖定來襲物體並發射導向飛彈攔截
  ],
  :能高級靈石=>%w[
    防禦靈氣:範圍增加n物防m魔防
    多重魔力砲擊:射出m顆砲彈造成n物理傷害

    魔方陣近迫系統:對來襲物體每秒發射n顆子彈攔截
    魔彈近迫系統:鎖定來襲物體並發射導向飛彈攔截
  ],
  :新高級靈石=>%w[
    指揮靈氣:範圍增加n遠攻m格檔
    魔方陣近迫系統:對來襲物體每秒發射n顆子彈攔截

    多重魔力砲擊:射出m顆砲彈造成n物理傷害
    魔力風暴:砲彈爆炸造成範圍n魔法傷害
    魔力振盪:砲彈爆炸範圍暈眩n秒
  ],
  :奇萊級靈石=>%w[ 
    干擾靈氣:範圍降低敵人n%物攻遠攻
    
    魔力導彈:發射飛彈自動導向並垂直落下造成n物理傷害
    魔力震波:遭飛彈命中沈默n秒
  ]
}