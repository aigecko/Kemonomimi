#coding: utf-8
require 'pp'
weapon={
  :dual=>%w[雙劍(atk,atkspd) 雙斧(atk,healhp)],
  :single=>%w[長槍(atk,con) 大斧(atk,str)],
  :right=>%w[單手劍(atk,def) 單手鎚(atk,maxhp)],
  :ward=>%w[法杖(atk,matk,int) 魔法劍(atk,matk,wis)],
  :sheild=>%w[重盾(def,block) 魔法盾(def,mdef) 輕盾(def,tough,wlkspd)],
  :book=>%w[魔法書(atk,def,mdef,-consum_amp)]
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
  :catear=>'減傷n%並且物理輸出增加m%',
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
    能量吸收:減少n%受到傷害並轉成m倍法力#attack_dendese->soul_of_Leyasu
    岩石護盾:開啟後產生n+m*maxsp盾持續r秒#rock_shield
    
    回復靈氣:範圍r友軍增加n+s*con回血m+t*wis回魔
    加速靈氣:範圍r友軍增加n%攻速m%跑速#aura
    降傷靈氣:範圍r友軍增加n+s*con物防m+t*wis魔防#aura
    
    大地杖擊:開啟後普攻帶n+m*sp無視魔免魔傷#append->energy_arrow
    震地重擊:開啟後周圍敵人範圍n+r*matk魔法傷害暈m+s*int秒#explode
    銳利飛石:前方敵人受到範圍n+r*matk魔法傷害#magic_arrow

    法杖儲能:增加法杖魔攻n倍的最大法力#ward_power

    大地之力:開啟後增加n%攻速及普攻奪取m*matk生命持續r秒#metamorphosis
  ],
  :mage=>%w[
    吹雪護盾:開啟後n%傷害交由m法力承受#switch_attack_defnese->soul_of_Masayuki
    凍雨凝結:造成攻擊者降低n+m*int近攻遠攻持續r秒#freezing_rain
    寒冰之軀:開啟後提升n雙防及降低m%sp消耗持續r秒#boost

    霜刺:普攻附加n+m*wis無視魔免魔傷以及強緩m跑速r攻速n秒#append->energy_arrow
    法力汲取:普攻吸取目標n+m*wis法力為己用

    寒冰爆彈:指定敵人受到範圍n+m*matk魔法傷害#missile
    冰柱戳刺:指定敵人受到範圍n+m*matk魔傷暈r秒#missile
    寒冰噴吐:前方敵人受到範圍n+m*matk魔傷緩r攻速跑速#magic_arrow
    寒冰凍破:法術命中後造成範圍n+m*int絕對傷害#explode

    法杖聚焦:增加法杖魔攻n倍的int#ward_power

    寒冰之力:開啟後增加n%技吸及m最大生命s最大法力並持續r秒#metamorphosis
  ],
  :fighter=>%w[
    #20+反擊之火:受到普攻反彈(10*lv)+(0.1+0.2*lv)*def絕對傷害#attack_defnese->counter_attack
    #20+堅忍不拔:最大生命增幅(5+0.75*lv)%且格檔增幅(6+lv)%#auto->amplify
    #20+無畏衝鋒:魔法免疫(1+lv*0.25)秒並增加(20*lv)近攻#magic_immunity

    #20+破甲斬擊:普攻造成目標降低(5*lv)*log(matk)雙防#break_armor
    #20+流動之火:普攻造成目標每秒(15*lv)+0.55*matk絕對傷害持續2秒#burn
    #20+烈火猛攻:在(4+0.2*lv)秒內有100%機率普攻暈0.4秒並帶(20*lv)傷害#boost
    #20+火圈迸裂:普攻造成範圍(0.01+0.002*lv)*maxhp物傷#switch_append->explode

    #20+熾焰焚身:每秒造成(40*lv)+0.3*matk魔法傷害並降低(10+lv)%跑速#switch_auto->fire_circle

    輕巧雙刀:雙手裝備雙刀時額外增加雙刀攻速xLog(str)的攻速#auto->dual_weapon_atkspd_acc
    再生之盾:增加盾0.2物防的回復生命以及0.2魔防的回復法力#auto->rl_weapon

    火焰之力:開啟後增加n跑速m%魔法減傷且基礎攻速變為r持續s秒#metamorphosis
    
    #隱藏技能:爆裂連斬:對指定敵人進行n次斬擊
  ],
  :paladin=>%w[
    神聖庇護:n%機率無視攻擊並增加m%雙防#auto->amplify
    聖光反射:受攻擊n%造成範圍m+r*mdef魔傷及暈眩s秒#attack_defense->counter_beam
    聖光庇佑:魔法免疫n秒並增加m物防魔防r秒#magic_immunuty
    
    輝煌聖光:範圍產生n+m*mdef護盾並增加r+s*int攻速
    聖光波動:普攻帶範圍n+m*atk物理傷害#smash_wave
    神聖祝福:自身每秒回複n+m*mdef生命並增加r+s*def攻擊持續t秒#recover

    一瞬閃光:前方直線n+m*matk魔法傷害#magic_arrow
    光束打擊:指定範圍n+m*matk魔法傷害#explode
    自我奉獻:施展法術時範圍回復n%最大生命法力#attach->contribute

    平衡之盾:增加盾n倍def最大生命及m倍mdef最大法力#auto->rl_weapon
    平衡之槍:增加長槍n倍atk魔攻#auto->single_weapon

    神聖之力:開啟後增加n最大生命m%跑速且基礎攻速變為s持續r秒#metamorphosis
  ],
  :darkknight=>%w[
    血殤靈光:反彈n%絕對傷害給周圍敵人#attack_defense->soul_of_Mototada
    血債血償:無視傷害時吸收其n%傷害外加m*con之生命值#ignore
    能量黑洞:n%無視傷害並增加m%雙吸血#attack_defense->amplify
    
    血性狂怒:魔法免疫r秒並增加n攻速m跑速s秒#magic_immunity
    淬毒武器:普通攻擊附加n+s*matk魔法傷害並緩m%攻速持續r秒
    不死戰魂:生命每減少n增加m近攻r物防#soul_of_Nobufusa

    黑暗爆發:範圍n+m*int絕對傷害並緩r%跑速持續s秒(skl_vamp)#explode
    黑暗侵蝕:開啟後範圍n+m*maxhp絕對傷害(skl_vamp)#fire_circle
    黑暗衝擊:直線造成n+m*int絕對傷害暈s秒(skl_vamp)#arrow

    長槍:paladin
    劍盾:paladin
    
    黑暗之力:開啟後增加n韌性魔防及m最大生命且基礎攻速變為r持續s秒#metamorphosis
    
    #隱藏技能:萬歲衝鋒:消耗n生命並同時造成範圍m傷害且r秒內增加s近攻t受到之傷害
  ],
  :crossbowman=>%w[
    能量轉化:降低受到魔傷n%#auto->amplify
    巨人外皮:增加r最大生命並降低受到的n普通攻擊#pre_attack_defense->soul_of_Yoshimoto
    動如雷霆:開啟後增加n%跑速m韌性
    
    積蓄能量:n%機率m倍爆擊並提升r%攻擊速度#auto->amplify
    負電位差:弓箭命中後消減敵方n+m*int法力並造成等量魔法傷害#append->soul_of_Muneshige
    閃電噴發:開啟後弓箭命中後產生範圍n+m*agi物理傷害#switch_append->explode
    雷神之箭:增加m弓箭射程以及n弓箭生命值
    
    天雷怒擊:指定範圍n+m*matk魔法傷害緩m跑速#explode
    暴怒雷擊:射出讓敵方受到n+m*matk魔法傷害暈眩r秒的弓箭#magic_arrow

    魔法之弩:增加弩n倍ratk魔攻#auto->magic_bow

    閃電之力:開啟後遠攻提升n%並增加m雙防持續r秒#metamorphosis
  ],
  :archer=>%w[
    身輕如燕:瞬間移動到指定的地點#flash
    旋風護盾:每n秒自動產生m+r*mdef魔法護盾持續s秒#soul_of_Ittetsu

    疾風祝福:開啟後回復n+m*matk生命並增加s+r*ratk%攻速持續t秒#boost
    精準命中:n%機率m倍爆擊並提升r敏捷#auto->amplify
    氣流爆發:n%機率暈m秒額外r傷害#auto->amplify
    無形之箭:弓箭可穿透n敵人並提升弓箭速度m#auto->amplify

    望風披靡:射出可以造成n+m*matk魔法傷害並沉默r秒的弓箭#magic_arrow
    狂風之襲:直線造成n+m*matk魔法傷害並降低閃避r%持續s秒#explode

    暴風之弓:弓的攻速強化n倍#magic_bow

    烈風之力:增加n閃避m魔法抗性且基礎攻速變為s持續r秒#metamorphosis
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