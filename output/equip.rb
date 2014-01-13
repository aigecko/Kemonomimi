#coding: utf-8
require_relative 'output'

#裝備
$equip=Hash.new
[:head,:neck,:body,:back,
 :right,:left,:single,:dual,
 :range,:finger,:feet,:deco].each{|sym|
   $equip[sym]=[]
}
#[部位][編號]=[名稱,圖檔,屬性,價格,敘述]
$equip[:head][ 0]=['測試用頭盔','test/head.png',
  {def:5,mdef:5},500,'保護頭部的頭盔']#}
$equip[:head][ 1]=['紙製頭盔','icon/mat_tklre002/helm_003b.png:[0,0]',
  {def: 2,mdef: 1},100,'薄弱的頭盔提供些許防禦']#}
  
$equip[:head][10]=['紙製頭巾','item/2011-12-23_1-065.gif',
  {def: 1,mdef: 1,ratk: 1},100,'輕飄飄的頭巾微幅增加遠攻']#}
  
$equip[:head][20]=['紙製魔法帽','icon/mat_tklre002/helm_005.png:[0,0]',
  {def: 1,mdef: 1,matk: 1},100,'微幅增加魔攻的魔法帽']#}


$equip[:neck][0]=['測試用項鍊','test/neck.png',
  {int:5,wis:5},500,'超硬質的金屬項鍊']


$equip[:body][ 0]=['測試用盔甲','test/body.png',
  {str:5,con:5,def:15,mdef:15},1000,'硬梆梆的盔甲']#}
$equip[:body][ 1]=['紙製鎧甲','icon/mat_tkl003/armor_007.png:[0,0]',
  {def: 10,mdef: 4,maxhp: 10},1000,'微幅增加生命的薄弱鎧甲']#}

$equip[:body][10]=['紙製法袍','icon/mat_tkl003/armor_006.png:[0,0]',
  {def: 8,mdef: 6,maxsp: 10},1000,'微幅增加法力的輕量法袍']#}

$equip[:body][20]=['紙製輕甲','icon/mat_tkl003/armor_004b.png:[0,0]',
  {def: 9,mdef: 7,dodge: 1},1000,'微幅增加閃避的輕直鎧甲']#}


$equip[:back][0]=['測試用披風','test/back.png',
  {def:2,jump:5},600,'能跳比較高']#}


$equip[:right][0]=['測試用短劍','test/sword.png',
  {atk:15,maxhp:10},1000,'可以造成一些傷害']
$equip[:right][0.1]=['勝利寶劍','icon/mat_tkl002/we_sword018d.png:[0,0]',
  {str:10,con:10,wlkspd:100,atkspd:200,atk_vamp: 0.2,
   skill:{sym: :burn,name:'燒毀',type: :append,table:[0,0],
     icon: './rc/icon/icon/mat_tkl002/we_sword018d.png',
     base: :burn,comment:'就是點燃啦= ='}},
  65535,"MJ勝利寶劍\n附帶#ff0000|燒毀#00327d|技能"]
$equip[:right][0.2]=['蜻蛉切‧銘槍','icon/mat_tkl002/we_spear006.png:[5,0]',
  {str:25,con:25,wlkspd: 0.25,
   skill:[{
     sym: :smash_wave,name:'蜻切',type: :append,table:[0,[300,20]],
     icon:'./rc/icon/icon/mat_tkl002/we_spear006.png:[0,5]',
     base: :smash_wave,comment:'20%300粉碎波'},{
     sym: :Tonbogiri,name:'蜻切',type: :auto,
     table:[0,{coef: 1,attrib:{}}],
     data:{type: :max,name:'蜻切',icon:nil,sym: :Tonbogiri},
     icon: nil,
     base: :recover,comment:'回血'}]},
  8450,"每秒回復生命上限1%生命普通攻擊有20%機率產生300魔法傷害"]
$equip[:right][0.3]=['妖刀‧村正','icon/mat_tkl002/we_sword021.png:[5,0]',
  {atk_vamp: 0.52,atk:150},9850,'大名鼎鼎的妖刀村正!!']
$equip[:right][0.4]=['長船‧太刀','icon/mat_tkl002/we_sword018d.png:[5,0]',
  {atk:80,critical:[[25,3]]},
  7700,'普通攻擊以及弓箭射擊會有25%機率產生3倍爆擊']
$equip[:right][0.5]=['紅雪左文字','icon/mat_tkl002/we_sword018b.png:[5,0]',
  {atk: 60,str: 10,con: 10,agi: 10,critical:[[27,2]]},
  6150,'普通攻擊以及弓箭射擊會有27%機率產生2倍爆擊']
$equip[:right][0.6]=['葵紋越前康繼','icon/mat_tkl002/we_sword018.png:[5,0]',
  {atk: 40,str: 30,con: 30,int: 30,wis: 30,agi: 30},
  9150,'稱高各種屬性~~']
$equip[:right][0.7]=['野太刀','item/2011-12-23_1-011.gif',
  {atk: 21,agi: 10,critical:[[20,2]]},
  6150,'普通攻擊以及弓箭射擊會有20%機率產生2倍爆擊']
$equip[:right][0.8]=['長曾彌虎撤','icon/mat_tkl002/we_sword018c.png:[0,0]',
  {atk: 50,str: 25,con: 25,bash:[[30,0.4,20]]},
  8600,'普通攻擊以及弓箭射擊會有30%機率擊暈0.4秒並增加該下普攻20傷害']
$equip[:right][1]=['紙製單手斧','icon/mat_tkl002/we_axe002.png:[0,0]',
  {atk: 10},400,'強調攻擊的紙製斧頭']
  
$equip[:dual][1]=['紙製雙劍','icon/mat_tkl002/we_sword006.png:[5,0]',
  {atk: 8,atkspd: 10},400,'輕薄短小的紙製雙劍']

$equip[:left][1]=['紙製圓盾','icon/mat_tkl003/shield_001.png:[0,0]',
  {def: 5,mdef: 4,wlkspd: -10},300,'薄弱的紙製盾牌']#}
  
$equip[:single][1]=['紙製長槍','icon/tklre05/we_spear020c.png',
  {atk: 10,def: 3,mdef: 3},650,'弱弱的長槍聊勝於無~~']#}
  

$equip[:range][0]=['測試用弩弓','test/crsbow.png',
  {ratk: 10,agi: 5},1000,'輕型遠距離武器']
$equip[:range][1]=['紙製弓','icon/mat_tkl002/we_bow001b.png:[0,0]',
  {ratk: 7,agi: 3,atkspd: 10},500,'微幅提高攻速的輕量弓']
  
$equip[:range][10]=['紙製弩','icon/mat_tkl002/we_bow013.png:[0,0]',
  {ratk: 10,agi: 3},500,'威力比弓略高的紙製弩']
  

$equip[:finger][0]=['測試用戒指','test/ring.png',
  {matk:5,mdef:5},400,'金光閃閃~~']
$equip[:finger][1]=['白銅戒指','icon/mat_tkl003/acce_004b.png:[0,0]',
  {matk: 0.1},10000,'微量增幅魔攻的山寨戒指']
$equip[:finger][2]=['白銀戒指','item/2011-12-23_1-108.gif',
  {matk: 0.2},20000,'少量增幅魔攻的銀製戒指']

#$equip[:finger][]
  
$equip[:feet][0]=['測試用重靴','test/feet.png',
  {str:2,def:2,mdef:2},400,'保護腳底']#}
$equip[:feet][1]=['紙製鞋','icon/mat_tkl003/boots_002.png:[0,0]',
  {wlkspd: 10},100,'微幅增加跑速的鞋子']

$equip[:feet][10]=['紙製靴','icon/mat_tkl003/boots_005b.png:[0,0]',
  {wlkspd: 8,def: 2},100,'微幅增加跑速及防禦的靴子']#}


$equip[:deco][0]=['測試用徽章','test/deco.png',{agi:5},700,'徽章']
$equip[:deco][1]=['1.5跑速','test/deco.png',{wlkspd:0.5},700,'1.5跑速']
$equip[:deco][2]=['1.5HP','test/deco.png',{maxhp:0.5},700,'1.5HP']
$equip[:deco][3]=['1.5倍atk加成','test/deco.png',{atk:0.5},700,'atk變為原先的1.5倍']#}
$equip[:deco][4]=['1.5閃避','test/deco.png',{dodge:0.5},700,'1.5閃避']
$equip[:deco][5]=['茶具','icon/tklre05/food_028c.png',
  {healhp: 5,healsp: 2},1600,'茶具...不解釋...']

Output('equip')