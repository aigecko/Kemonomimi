#coding: utf-8
require 'pp'
weapon={ 
  :dual=>%w[雙刀(atk,atkspd)],
  :single=>%w[長槍(atk,con%,-ratk%)],
  :right=>%w[單手劍(atk,wlkspd) 單手斧(atk,-wlkspd,healhp) 單手槌(atk,def)],
  :ward=>%w[法杖(matk,mdef,healsp)],
  :sheild=>%w[盾(def,mdef,-wlkspd,-ratk%) 魔法盾(def,mdef,-wlkspd,-ratk%)],
  :book=>%w[魔法書(atk,def,int%,wis%)]
}
armor={
  :head=>%w[頭盔(def) 頭巾(def,ratk) 魔法帽(def,matk)],
  :neck=>%w[項鍊(maxhp,maxsp)],
  :body=>%w[鎧甲(def,mdef,maxhp) 法袍(def,mdef,maxsp) 輕甲(def,mdef,dodge)],
  :back=>%w[披風(mdef)],
  :range=>%w[弩(ratk,agi) 弓(ratk,agi,atkspd) 鐵砲(ratk,agi,-atkspd)],
  :finger=>%w[戒指(atk%,matk%,ratk%)],
  :feet=>%w[鞋(wlkspd) 靴(wlkspd,def)],
  :deco=>%w[鋼(def,mdef,atk,matk,ratk) 寶石(str,con,int,wis,agi) 花朵(healhp healsp)
            羽毛(atkspd,wlkspd) 牙齒(atk_vamp,skl_vamp)紅寶石(all)]
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
  smash_wave:{table:['I_base','F_coef','H_attrib'],data:{last:'F_second'}}
  soul_of_Mototada:{table:'I_percent'},
  soul_of_Nagayoshi:{table:['I_base','F_coef'],data:{base:'F_min_base',coef:'F_max_coef'}},
  soul_of_Nobufusa:{table:['I_hp_unit',{'S_symbol'=>'FI_attrib'}]},,
  soul_of_Kiyomasa:{table:['I_base','F_coef'],data:{last:'I_second'}},
  soul_of_Yasumasa:{table:['I_base','F_coef','I_atkspd'],data:{last:'I_second'}},
  piezoelectric_effect:{table:{'S_dst_attrib'=>['I_base','F_coef']},data:{conv:{'S_dst_symbol'=>'S_src_symbol'},last:'I_second'}},
  soul_of_Yoshimoto:{table:['I_base','F_coef'],data:{conv:'S_symbol'}},
  soul_of_Muneshige:{table:['I_base','F_coef'],data:{conv:'S_symbol'}}
  flash:{table:'I_limit_length'},
  soul_of_Ittetsu:{table:['I_base','F_coef','I_cd_second'],data:{sym:'S_symbol',last:'I_last_second'}}
  
  ward_power:{table:['S_dst_attrib','S_src_symbol','F_coef']},
  dual_weapon_atkspd_acc:{},
  rl_weapon:{def_coef:'FI_attrib',mdef_coef:'FI_attrib',def_conv:'S_symbol',mdef_conv:'S_symbol'},
  single_weapon:{data:{sym:'S_src_attrib',coef:'F_coef',conv:'S_dst_attrib'}},
  magic_bow:{data:{weapon:'S_type',sym:'S_src_attrib',coef:'FI_coef',conv:'S_dst_attrib'}},
  
  metamorphosis:[]
}
race={
  :catear=>'目標格檔或閃避時可以造成n%傷害',
  :foxear=>'最大法力及消耗法力增加n%但魔法輸出增加m%',
  :dogear=>'目標血量<90+5%,<70+10%,<50+20%,<30+30%,<20+40%,<10+50%,<5%60%',
  :wolfear=>'自身每秒回復n%損失生命並回復m倍等量法力'
  :leopardcatear=>'受到攻擊有n%機率減傷m%持續r秒'
}
klass={
  :cleric=>%w[
    能量吸收:減少n%受到傷害並轉成m倍法力#attack_dendese->soul_of_Leyasu
    土岩之牆:開啟後獲得物理免疫n秒#physical_immunity
    岩石護盾:開啟後產生n+m*maxsp盾持續r秒#rock_shield
	
    能量補充:開啟後有n%機率回m%總法力持續r秒#auto->soul_of_Yoshitsugu
    大地杖擊:開啟後普攻帶n+m*sp無視魔免魔傷#append->energy_arrow
    堅守陣地:普攻後內增加m回血和雙防可疊r層持續n秒#append->solid_defense
	
    土壤液化:可持續造成指定範圍n+r*matk魔法傷害並強緩m%跑速#explode
    震地重擊:周圍敵人受到範圍n+r*matk魔法傷害暈m秒#explode
    銳利飛石:前方敵人受到範圍n+r*matk魔法傷害#magic_arrow
	
    法杖儲能:增加法杖魔攻n倍的wis#ward_power
    
    大地之力:開啟後增加n%攻速及m%雙防附帶沙塵暴持續r秒#metamorphosis
    沙塵暴:周圍受到範圍n+m*wis傷害
  ],
  :mage=>%w[
    吹雪護盾:開啟後n%傷害交由m法力承受#switch_attack_defnese->soul_of_Masayuki
    凍雨凝結:造成攻擊者降低n+m*int近攻遠攻持續r秒#freezing_rain
    寒冰之軀:開啟後提升n雙防及m%魔攻持續r秒#boost
		
    水流衝擊:普攻附加n+m*int魔傷#append->energy_arrow
    凍雲爆發:開啟後普攻n%機率範圍強緩m跑速n秒可觸發寒冰凍破#switch_append->itegumo_erupt
	
    寒冰爆彈:指定敵人受到範圍n+m*matk魔法傷害#missile
    冰柱戳刺:指定敵人受到範圍n+m*matk魔傷暈n秒#missile
    寒冰噴吐:前方敵人受到範圍n+m*matk魔傷緩r攻速跑速#magic_arrow
    寒冰凍破:法術命中後造成範圍n+m*int絕對傷害#explode
	
    法杖聚焦:增加法杖魔攻n倍的int#ward_power
    
    寒冰之力:開啟後增加n%技吸及m雙防並降低m%sp消耗持續r秒#metamorphosis
  ],
  :fighter=>%w[
    反擊之火:受到普攻反彈n+m*def絕對傷害#attack_defnese->counter_attack
    堅忍不拔:最大生命增幅n%且格檔增幅m%#auto->amplify
    無畏衝鋒:魔法免疫n秒並增加m近攻#magic_immunity
	
    毀滅烈焰:普攻造成目標降低n*log(matk)雙防#break_armor
    血量壓制:普攻造成目標n*hp絕對傷害#append->energy_arrow
    猛攻之火:增加n+m*matk攻速m跑速持續r秒#boost
    火焰升溫:對同目標攻擊增加n近攻最多m層#append->solid_defense
    火圈迸裂:普攻造成範圍n*atk物傷#switch_append->explode
	
    熾焰焚身:每秒造成n+m*matk魔法傷害並降低r%跑速#switch_auto->fire_circle
	
    輕巧雙刀:雙手裝備雙刀時額外增加雙刀攻速xLog(str)的攻速#auto->dual_weapon_atkspd_acc
    再生之盾:增加盾n物防的回復生命以及m魔防的回復法力#auto->rl_weapon
    
    火焰之力:開啟後增加n%跑速m最大生命且基礎攻速變為r持續s秒#metamorphosis
  ],
  :paladin=>%w[
    神聖守護:n%機率無視攻擊並增幅m%物防魔防#auto->amplify
    聖光反射:受攻擊n%造成範圍m+r*def魔傷及暈眩s秒#attack_defense->counter_beam
    逆壓之盾:開啟後吸收傷害並在n秒後造成等量物理傷害#pressure_erupt->switch_auto
    聖光庇佑:魔法免疫n秒並增加m物防魔防#magic_immunuty
	
    聖光波動:開啟後普攻帶範圍n+m*matk魔傷#smash_wave
    神聖祝福:開啟後增加n%近攻及m%魔攻持續r秒#boost
	
    一瞬閃光:前方直線n+m*matk魔法傷害#magic_arrow
    光束打擊:指定範圍n+m*matk魔法傷害並中斷動作#explode
    自我奉獻:施展法術時範圍增加n+m*int回血回魔持續r秒#attach->contribute
	
    平衡之盾:增加盾n倍def最大生命及m倍mdef最大法力#auto->rl_weapon
    平衡之槍:增加長槍n倍atk魔攻#auto->single_weapon
    
    神聖之力:開啟後增加n減傷及m最大生命且基礎攻速變為s持續r秒#metamorphosis
  ],
  :darkknight=>%w[
    血殤靈光:反彈n%絕對傷害給周圍敵人#attack_defense->soul_of_Mototada
    血債血償:n%吸收m%傷害並增幅m%最大生命#先反彈再吸收attack_defense->amplify
    血性狂怒:魔法免疫r秒並增加n攻速m跑速s秒#magic_immunity
      
    能量黑洞:開啟增加n+m*atk普攻吸血r+s*matk技能吸血#boost
    真靈切割:普攻n%奪取m%現有生命(s+r*matk)#soul_of_Nagayoshi
    不死戰魂:生命每減少n增加m近攻r物防#soul_of_Nobufusa
    
    黑暗爆發:範圍n+m*matk絕對傷害緩r%跑速攻速持續s秒(skl_vamp)#explode    
    黑暗侵蝕:開啟後範圍n+m*maxhp絕對傷害持續r秒(skl_vamp)#soul_of_Kiyomasa
    虛空重擊:造成n+m*matk絕對傷害中斷動作並提升n%攻速持續r秒(skl_vamp)#soul_of_Yasumasa
	
    長槍:paladin
    劍盾:paladin
    
    黑暗之力:開啟後增加n%輸出傷害及m最大生命且基礎攻速變為r持續s秒#metamorphosis
  ],
  :crossbowman=>%w[
    能量轉化:降低受到魔傷n%並增加n弓箭射程#auto->amplify
    壓電效應:受到傷害獲得n+m*agi跑速r+s*con回血持續t秒#attack_defense->piezoelectric_effect
    反應裝甲:降低受到的n+m*con普通攻擊#pre_attack_defense->soul_of_Yoshimoto
		
    震盪輸出:n%機率m倍爆擊並提升r%攻擊速度#auto->amplify
    深藏不漏:開啟後隱形並提升n%跑速現行造成m額外物理傷害#invisible
    負電位差:弓箭命中後消減敵方n+m*int法力並造成等量魔法傷害#append->soul_of_Muneshige
    閃電噴發:開啟後弓箭命中後產生範圍n+m*matk魔法傷害#switch_append->explode
    
    天雷怒擊:指定範圍n+m*matk魔法傷害緩m跑速#explode
    暴怒雷擊:射出讓敵方受到n+m*matk魔法傷害暈眩r秒的弓箭#magic_arrow
	
    魔法之弩:增加弩n倍ratk魔攻#auto->magic_bow
    
    閃電之力:開啟後魔攻遠攻提升n倍並增加m雙防持續r秒#metamorphosis
  ],
  :archer=>%w[
    迅捷之風:降低受到魔傷並增幅閃躲m%#auto->amplify
    身輕如燕:瞬間移動到指定的地點#flash
    旋風護盾:每n秒自動產生m+r*mdef護盾持續s秒#soul_of_Ittetsu
	
    疾風祝福:開啟後回復n+m*matk生命並增加m+r*ratk%攻速#boost
    精準命中:n%機率m倍爆擊並提升r敏捷#auto->amplify
    氣流爆發:n%機率暈m秒額外r傷害#auto->amplify
    無形之箭:弓箭可穿透n敵人並提升弓箭速度m#auto->amplify
	
    望風披靡:射出可以造成n+m*matk魔法傷害並沉默r秒的弓箭#magic_arrow
    狂風之襲:直線造成n+m*matk魔法傷害並降低閃避r%持續s秒#explode
	
    暴風之弓:弓的攻速強化n倍#magic_bow
    
    烈風之力:開啟後隱形並增加n跑速且基礎攻速變為s持續r秒#metamorphosis
  ]
}