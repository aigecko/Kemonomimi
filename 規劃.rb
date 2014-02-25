#coding: utf-8
require 'pp'
weapon={ 
  :dual=>%w[雙刀(atk,atkspd)],
  :single=>%w[長槍(atk,con%,-ratk%)],
  :right=>%w[單手劍(atk,wlkspd) 單手斧(atk,-wlkspd) 單手槌(atk,def)],
  :ward=>%w[法杖(matk,mdef)],
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
  :deco=>%w[鋼(def,mdef,atk,matk,ratk) 寶石(str,con,int,wis,agi) 
            羽毛(atkspd,wlkspd) 牙齒(atk_vamp,skl_vamp)紅寶石(all)]
}
race={
  :catear=>'目標格檔或閃避時可以造成n%傷害',
  :foxear=>'最大法力及消耗法力增加n%但魔法輸出增加m%',
  :dogear=>'目標血量<90+5%,<70+10%,<50+20%,<30+30%,<20+40%,<10+50%,<5%60%',
  :wolfear=>'自身每秒回復n%損失生命並回復m倍等量法力'
}
klass={
  :cleric=>%w[
	能量吸收:減少n%受到傷害並轉成2倍法力
	土岩之牆:開啟後獲得物理免疫n秒
	岩石護盾:開啟後產生n+m*maxsp盾持續r秒
	
	能量補充:增加n%攻速並有m%機率回r%總法力
	大地杖擊:開啟後普攻帶n+m*maxsp無視魔免魔傷
	堅守陣地:普攻後內增加m回血和雙防可疊r層持續n秒
	
	土壤液化:可持續造成指定範圍n+r*matk魔法傷害並強緩m%跑速
	震地重擊:周圍敵人受到範圍n+r*matk魔法傷害暈m秒
	銳利飛石:前方敵人受到範圍n+r*matk魔法傷害
	
	法杖儲能:增加法杖魔攻n倍的maxsp
    
    大地之力:開啟後增加n%攻速及m%雙防持續r秒
  ],
  :mage=>%w[
    吹雪護盾:開啟後n%傷害交由m法力承受
	凍雨凝結:造成攻擊者降低n+m*int近攻魔攻持續r秒
	寒冰之軀:開啟後提升n雙防及m%魔攻持續r秒
		
	水流衝擊:普攻附加n+m*int魔傷
	凍雲爆發:開啟後普攻n%機率範圍強緩m跑速n秒可觸發寒冰凍破
	
	寒冰爆彈:指定敵人受到範圍n+m*matk魔法傷害
	冰柱戳刺:指定敵人受到範圍n+m*matk魔傷暈n秒
	寒冰噴吐:前方敵人受到範圍n+m*matk魔傷緩r攻速跑速
	寒冰凍破:法術命中後造成範圍n+m*int絕對傷害
	
	法杖聚焦:增加法杖魔攻n倍的int
    
    寒冰之力:開啟後增加n%技能吸血m智力s雙防持續r秒
  ],
  :fighter=>%w[
    反擊之火:受到普攻反彈n+m*def絕對傷害
	堅忍不拔:最大生命增幅n%且格檔增幅m%
	無畏衝鋒:魔法免疫n秒並增加m近攻
	
	毀滅烈焰:普攻造成目標降低n*log(matk)雙防
	血量壓制:普攻造成目標n*hp絕對傷害
	猛攻之火:增加n+m*matk攻速m跑速持續r秒
	火焰升溫:對同目標攻擊增加n近攻最多m層
	火圈迸裂:普攻造成範圍n*atk物傷
	
	熾焰焚身:每秒造成n+m*matk魔法傷害並降低r跑速s攻速
	
	輕巧雙刀:雙手裝備雙刀時額外增加雙刀攻速xLog(str)的攻速
	再生之盾:增加盾n物防的回復生命以及m魔防的回復法力
    
    火焰之力:開啟後增加n%跑速m最大生命且基礎攻速變為r持續s秒
  ],
  :paladin=>%w[
    神聖守護:n%機率無視攻擊並增幅m%物防魔防
	聖光反射:受攻擊n%造成範圍m+r*def魔傷及暈眩s秒
	逆壓之盾:開啟後吸收傷害並在n秒後造成等量物理傷害
	聖光庇佑:魔法免疫n秒並增加m物防魔防
	
	聖光波動:開啟後普攻帶範圍n+m*matk魔傷並增加n%攻速m%跑速
	神聖祝福:增加n%近攻及m%魔攻
	
	一瞬閃光:前方直線n+m*matk魔法傷害緩r%跑速
	光束打擊:指定範圍n+m*matk魔法傷害並中斷動作
	自我奉獻:施展法術時範圍增加n+m*int回血回魔持續r秒
	
	平衡之盾:增加盾n倍def最大生命及m倍mdef最大法力
	平衡之槍:增加長槍n倍atk魔攻	
    
    神聖之力:開啟後增加n減傷及m最大生命且基礎攻速變為s持續r秒
  ],
  :darkknight=>%w[
    血殤靈光:反彈n%絕對傷害給周圍敵人
	血債血償:n%吸收m%傷害並增幅m%最大生命#先反彈再吸收
	血性狂怒:魔法免疫r秒並增加n攻速m跑速s秒
    
    能量黑洞:開啟增加n+m*atk普攻吸血r+s*matk技能吸血
    真靈切割:普攻n%奪取m%現有生命(s+r*matk)
	不死戰魂:生命每減少n增加m近攻r物防
	
	黑暗爆發:範圍n+m*maxhp絕對傷害緩r%跑速持續s秒(技)
	黑暗狂潮:開啟後範圍n+m*maxhp絕對傷害持續r秒(技)
	虛空重擊:造成n+m*matk絕對傷害中斷動作並提升n%攻速m秒(技)
	
    長槍:paladin
	劍盾:paladin
    
    黑暗之力:開啟後增加n輸出傷害及m最大生命且基礎攻速變為r持續s秒
  ],
  :crossbowman=>%w[
    能量轉化:降低受到魔傷n%並增幅物攻輸出m%
	壓電效應:受到傷害獲得n+m*agi跑速r+s*con回血持續t秒
	反應裝甲:降低受到的n+m*con普通攻擊
		
	震盪輸出:n%機率m倍爆擊並提升r%攻擊速度
	電力充能:增加n弓箭射程m攻擊速度
	負電位差:弓箭命中後消減敵方n+m*int法力並造成等量魔法傷害	
	閃電噴發:開啟後弓箭命中後產生範圍n+m*matk魔法傷害
    
	天雷怒擊:指定範圍n+m*matk魔法傷害緩m跑速
	暴怒雷擊:射出讓敵方受到n+m*matk魔法傷害暈眩r秒的弓箭
	
	魔法之弩:增加弩n倍ratk魔攻
    
    閃電之力:開啟後魔攻遠攻提升n倍並增加m雙防持續r秒
  ],
  :archer=>%w[
    迅捷之風:降低受到魔傷並增幅閃躲m%跑速m
	身輕如燕:瞬間移動到指定的地點
	
	疾風祝福:開啟後回復n+m*matk生命並增加m+r*ratk%攻速
	精準命中:n%機率m倍爆擊
	氣流爆發:n%機率暈m秒額外r傷害
	無形之箭:弓箭可穿透n敵人並提升弓箭速度m
	
	望風披靡:射出可以造成n+m*matk魔法傷害並沉默r秒的弓箭
	狂風之襲:直線造成n+m*matk魔法傷害並降低閃避r%持續s秒
	逆風陷阱:施放可以造成n+m*matk魔法傷害並緩跑速r%的陷阱
	
	神風弓術:弓的弓速強化n倍
    
    烈風之力:開啟後隱形並增加n跑速且基礎攻速變為s持續r秒
  ]
}