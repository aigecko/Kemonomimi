#!/usr/bin/ruby
#coding: utf-8
require_relative 'output'

#裝備
$equip=Hash.new
[:head,:neck,:body,:back,
 :right,:left,:single,:dual,
 :range,:finger,:feet,:deco].each{|sym|
   $equip[sym]={}
}
#[部位][編號]=[名稱,圖檔,屬性,價格,敘述]
$equip[:head][ 0]=['測試用頭盔','test/head.png',
  {def:5,mdef:5},500,'保護頭部的頭盔']#}
$equip[:head][ 1.01]=['紙製頭盔','icon/mat_tklre002/helm_003b.png:[0,0]',
  {def: 2,mdef: 1},100,'薄弱的頭盔提供些許防禦']#}
$equip[:head][ 1]=['翠綠頭盔','icon/mat_tklre002/helm_003.png+[0,50,0]',
  {def: 5},100,'']#}
$equip[:head][ 2]=['木紋頭盔','icon/mat_tklre002/helm_003.png-[0,40,80]',
  {def: 10},100,'']#}
$equip[:head][ 3]=['湛藍頭盔','icon/mat_tklre002/helm_003.png-[20,0,0]+[0,0,50]',
  {def: 20},100,'']#}
$equip[:head][ 4]=['橘黃頭盔','icon/mat_tklre002/helm_003.png+[100,50,0]',
  {def: 40},100,'']#}
$equip[:head][ 5]=['銀白頭盔','icon/mat_tklre002/helm_003.png',
  {def: 80},100,'']#}
$equip[:head][ 6]=['鐵灰頭盔','icon/mat_tklre002/helm_003.png-[50,50,50]',
  {def: 160},100,'']#}
$equip[:head][ 7]=['血紅頭盔','icon/mat_tklre002/helm_003.png-[0,80,80]',
  {def: 320},100,'']#}

$equip[:head][11]=['翠綠角盔','icon/mat_tklre002/helm_003b.png+[0,50,0]',
  {def: 4,atk: 1},100,'']#}
$equip[:head][12]=['木紋角盔','icon/mat_tklre002/helm_003b.png-[0,40,80]',
  {def: 8,atk: 2},100,'']#}
$equip[:head][13]=['湛藍角盔','icon/mat_tklre002/helm_003b.png-[20,0,0]+[0,0,50]',
  {def: 16,atk: 4},100,'']#}
$equip[:head][14]=['橘黃角盔','icon/mat_tklre002/helm_003b.png+[100,50,0]',
  {def: 32,atk: 8},100,'']#}
$equip[:head][15]=['銀白角盔','icon/mat_tklre002/helm_003b.png',
  {def: 64,atk: 16},100,'']#}
$equip[:head][16]=['鐵灰角盔','icon/mat_tklre002/helm_003b.png-[50,50,50]',
  {def: 128,atk: 32},100,'']#}
$equip[:head][17]=['血紅角盔','icon/mat_tklre002/helm_003b.png-[0,80,80]',
  {def: 256,atk: 64},100,'']#}

$equip[:head][10]=['紙製頭巾','item/2011-12-23_1-065.gif',
  {def: 1,mdef: 1,ratk: 1},100,'輕飄飄的頭巾微幅增加遠攻']#}
$equip[:head][21]=['翠綠頭巾','icon/tklre06/helm_014.png+[0,50,0]',
  {def: 3,mdef: 2},100,'']#}
$equip[:head][22]=['木紋頭巾','icon/tklre06/helm_014.png+[40,40,0]',
  {def: 6,mdef: 4},100,'']#}
$equip[:head][23]=['湛藍頭巾','icon/tklre06/helm_014.png+[0,0,30]-[80,50,50]B[255,0,0]',
  {def: 12,mdef: 8},100,'']#}
$equip[:head][24]=['橘黃頭巾','icon/tklre06/helm_014.png-[20,50,50]+[120,50,0]B[255,0,0]',
  {def: 24,mdef: 16},100,'']#}
$equip[:head][25]=['銀白頭巾','icon/tklre06/helm_014.png',
  {def: 48,mdef: 32},100,'']#}
$equip[:head][26]=['鐵灰頭巾','icon/tklre06/helm_014.png-[50,50,50]B[0,0,255]',
  {def: 96,mdef: 64},100,'']#}
$equip[:head][27]=['血紅頭巾','icon/tklre06/helm_014.png-[0,80,80]',
  {def: 192,mdef: 128},100,'']#}

$equip[:head][31]=['翠綠圓帽','icon/mat_tklre002/helm_004.png-[50,0,50]',
  {def: 2,mdef: 2,ratk: 1},100,'']#}
$equip[:head][32]=['木紋圓帽','icon/mat_tklre002/helm_004.png-[20,50,100]',
  {def: 4,mdef: 4,ratk: 2},100,'']#}
$equip[:head][33]=['湛藍圓帽','icon/mat_tklre002/helm_004.png-[70,50,0]',
  {def: 8,mdef: 8,ratk: 4},100,'']#}
$equip[:head][34]=['橘黃圓帽','icon/mat_tklre002/helm_004.png-[20,50,50]+[120,50,0]',
  {def: 16,mdef: 16,ratk: 8},100,'']#}
$equip[:head][35]=['銀白圓帽','icon/mat_tklre002/helm_004.png',
  {def: 32,mdef: 32,ratk: 16},100,'']#}
$equip[:head][36]=['鐵灰圓帽','icon/mat_tklre002/helm_004.png-[50,50,50]B[0,0,255]',
  {def: 64,mdef: 64,ratk: 32},100,'']#}
$equip[:head][37]=['血紅圓帽','icon/mat_tklre002/helm_004.png-[0,100,100]',
  {def: 128,mdef: 128,ratk: 64},100,'']#}

$equip[:head][20]=['紙製魔法帽','icon/mat_tklre002/helm_005.png:[0,0]',
  {def: 1,mdef: 1,matk: 1},100,'微幅增加魔攻的魔法帽']#}
$equip[:head][41]=['翠綠魔法帽','icon/mat_tklre002/helm_005.png+[0,50,0]',
  {def: 1,mdef: 3,matk: 1},100,'']#}
$equip[:head][42]=['木紋魔法帽','icon/mat_tklre002/helm_005.png-[0,40,80]',
  {def: 2,mdef: 6,matk: 2},100,'']#}
$equip[:head][43]=['湛藍魔法帽','icon/mat_tklre002/helm_005.png+[0,0,50]-[50,0,0]',
  {def: 4,mdef: 12,matk: 4},100,'']#}
$equip[:head][44]=['橘黃魔法帽','icon/mat_tklre002/helm_005.png+[100,50,0]',
  {def: 8,mdef: 24,matk: 8},100,'']#}
$equip[:head][45]=['銀白魔法帽','icon/mat_tklre002/helm_005.png+[50,50,50]',
  {def: 16,mdef: 48,matk: 16},100,'']#}
$equip[:head][46]=['鐵灰魔法帽','icon/mat_tklre002/helm_005.png',
  {def: 32,mdef: 96,matk: 32},100,'']#}
$equip[:head][47]=['血紅魔法帽','icon/mat_tklre002/helm_005.png+[80,0,0]-[0,40,40]',
  {def: 64,mdef: 192,matk: 64},100,'']#}


$equip[:neck][0]=['測試用項鍊','test/neck.png',
  {int:5,wis:5},500,'超硬質的金屬項鍊']


$equip[:body][ 0]=['測試用盔甲','test/body.png',
  {str:5,con:5,def:15,mdef:15},1000,'硬梆梆的盔甲']#}
$equip[:body][ 1.01]=['紙製鎧甲','icon/mat_tkl003/armor_007.png:[0,0]',
  {def: 10,mdef: 4,maxhp: 10},1000,'微幅增加生命的薄弱鎧甲']#}
$equip[:body][ 1]=['鐵灰重甲','icon/mat_tkl003/armor_004b.png',
  {def: 8,mdef: 5,maxhp: 100},1000,'']#}
$equip[:body][ 2]=['木紋重甲','icon/mat_tkl003/armor_004.png',
  {def: 16,mdef: 10,maxhp: 200},1000,'']#}
$equip[:body][ 3]=['鐵灰長重甲','icon/mat_tkl003/armor_005.png',
  {def: 32,mdef: 20,maxhp: 400},1000,'']#}
$equip[:body][ 4]=['金黃長重甲','icon/mat_tkl003/armor_005b.png',
  {def: 64,mdef: 40,maxhp: 700},1000,'']#}
$equip[:body][ 5]=['翠綠單層重甲','icon/mat_tkl003/armor_010.png',
  {def: 128,mdef: 80,maxhp: 1100},1000,'']#}
$equip[:body][ 6]=['翠綠雙層重甲','icon/mat_tkl003/armor_010b.png',
  {def: 256,mdef: 160,maxhp: 1600},1000,'']#}
$equip[:body][ 7]=['翠綠複合重甲','icon/mat_tkl003/armor_010c.png',
  {def: 512,mdef: 320,maxhp: 2200},1000,'']#}
$equip[:body][ 8]=['銀白複合重甲','icon/mat_tkl003/armor_010d.png',
  {def: 1024,mdef: 640,maxhp: 2900},1000,'']#}

$equip[:body][10]=['紙製法袍','icon/mat_tkl003/armor_006.png:[0,0]',
  {def: 8,mdef: 6,maxsp: 10},1000,'微幅增加法力的輕量法袍']#}
$equip[:body][11]=['翠綠法袍','icon/mat_tkl003/armor_011d.png',
  {def: 5,mdef: 8,maxsp: 100},1000,'']#}
$equip[:body][12]=['緋紅法袍','icon/mat_tkl003/armor_011e.png',
  {def: 10,mdef: 16,maxsp: 200},1000,'']#}
$equip[:body][13]=['墨黑法袍','icon/mat_tkl003/armor_011b.png',
  {def: 20,mdef: 32,maxsp: 400},1000,'']#}
$equip[:body][14]=['銀白法袍','icon/mat_tkl003/armor_011c.png',
  {def: 40,mdef: 64,maxsp: 700},1000,'']#}
$equip[:body][15]=['青翼法袍','icon/tklre04/armor_024.png-[80,20,80]B[255,0,0]',
  {def: 80,mdef: 128,maxsp: 1100},1000,'']#}
$equip[:body][16]=['赤翼法袍','icon/tklre04/armor_024.png-[20,80,80]B[0,255,0]',
  {def: 160,mdef: 256,maxsp: 1600},1000,'']#}
$equip[:body][17]=['白翼法袍','icon/tklre04/armor_024.png',
  {def: 320,mdef: 512,maxsp: 2200},1000,'']#}
$equip[:body][18]=['黑翼法袍','icon/tklre04/armor_024b.png',
  {def: 640,mdef: 1024,maxsp: 2900},1000,'']#}

$equip[:body][20]=['紙製輕甲','icon/mat_tkl003/armor_004b.png:[0,0]',
  {def: 9,mdef: 7,dodge: 1},1000,'微幅增加閃避的輕直鎧甲']#}
$equip[:body][21]=['翠綠鱗片輕甲','icon/mat_tkl003/armor_013c.png',
  {def: 5,mdef: 5,dodge: 5},1000,'']#}
$equip[:body][22]=['鐵灰鱗片輕甲','icon/mat_tkl003/armor_013d.png',
  {def: 10,mdef: 10,dodge: 6},1000,'']#}
$equip[:body][23]=['鐵灰輕甲','icon/mat_tkl003/armor_019c.png',
  {def: 20,mdef: 20,dodge: 8},1000,'']#}
$equip[:body][24]=['木紋輕甲','icon/mat_tkl003/armor_019d.png',
  {def: 40,mdef: 40,dodge: 11},1000,'']#}
$equip[:body][25]=['鐵灰長輕甲','icon/mat_tkl003/armor_004f.png',
  {def: 80,mdef: 80,dodge: 14},1000,'']#}
$equip[:body][26]=['木紋長輕甲','icon/mat_tkl003/armor_004e.png',
  {def: 160,mdef: 160,dodge: 17},1000,'']#}
$equip[:body][27]=['鐵灰角輕甲','icon/mat_tkl003/armor_005e.png',
  {def: 320,mdef: 320,dodge: 23},1000,'']#}
$equip[:body][28]=['血紅角輕甲','icon/mat_tkl003/armor_005f.png',
  {def: 640,mdef: 640,dodge: 26},1000,'']#}


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
   skill:[
    {sym: :smash_wave,name:'蜻切',type: :append,table:[0,[300,20]],
     icon:'./rc/icon/icon/mat_tkl002/we_spear006.png:[0,5]',
     base: :smash_wave,comment:'20%300粉碎波'},
    {sym: :Tonbogiri,name:'蜻切',type: :auto,
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
$equip[:right][1.01]=['紙製單手斧','icon/mat_tkl002/we_axe002.png:[0,0]',
  {atk: 10},400,'強調攻擊的紙製斧頭']

$equip[:right][ 1]=['翠綠長劍','icon/mat_tkl002/we_sword018.png',
  {atk: 10,def: 3},1000,'']#}
$equip[:right][ 2]=['木紋長劍','icon/mat_tkl002/we_sword018d.png',
  {atk: 20,def: 6},1000,'']#}
$equip[:right][ 3]=['銀白長劍','icon/mat_tkl002/we_sword006.png:[10,0]',
  {atk: 40,def: 12},1000,'']#}
$equip[:right][ 4]=['湛藍長劍','icon/mat_tkl002/we_sword018c.png',
  {atk: 80,def: 24},1000,'']#}
$equip[:right][ 5]=['緋紅長劍','icon/mat_tkl002/we_sword018b.png',
  {atk: 160,def: 48},1000,'']#}
$equip[:right][ 6]=['鐵灰長劍','icon/mat_tklre002/we_sword028.png:[10,0]',
  {atk: 320,def: 96},1000,'']#}
$equip[:right][ 7]=['蒼灰長劍','icon/mat_tkl002/we_sword008.png:[10,0]',
  {atk: 640,def: 192},1000,'']#}

$equip[:right][11]=['翠綠重鎚','icon/mat_tkl002/we_staff005.png',
  {atk: 10,maxhp: 40},1000,'']
$equip[:right][12]=['木紋重鎚','icon/mat_tkl002/we_staff005b.png',
  {atk: 20,maxhp: 80},1000,'']
$equip[:right][13]=['銀白重鎚','icon/mat_tkl002/we_axe017.png',
  {atk: 40,maxhp: 160},1000,'']
$equip[:right][14]=['湛藍重鎚','icon/mat_tkl002/we_axe017b.png',
  {atk: 80,maxhp: 280},1000,'']
$equip[:right][15]=['緋紅戰鎚','icon/mat_tkl002/we_axe015b.png',
  {atk: 160,maxhp: 440},1000,'']
$equip[:right][16]=['鐵灰戰鎚','icon/mat_tkl002/we_axe015.png',
  {atk: 320,maxhp: 640},1000,'']
$equip[:right][17]=['蒼灰戰鎚','icon/mat_tkl002/we_axe016.png',
  {atk: 640,maxhp: 880},1000,'']

$equip[:right][21]=['翠綠法杖','icon/mat_tkl002/we_staff011d.png:[10,0]',
  {atk: 5,matk: 10,int: 10},1000,'']
$equip[:right][22]=['木紋法杖','icon/mat_tkl002/we_staff011c.png:[10,0]',
  {atk: 10,matk: 20,int: 20},1000,'']
$equip[:right][23]=['銀白法杖','icon/tklre04/we_staff020b.png:[10,0]',
  {atk: 20,matk: 40,int: 35},1000,'']
$equip[:right][24]=['湛藍法杖','icon/mat_tkl002/we_staff011.png:[10,0]',
  {atk: 40,matk: 80,int: 55},1000,'']
$equip[:right][25]=['緋紅法杖','icon/mat_tkl002/we_staff011b.png:[10,0]',
  {atk: 80,matk: 160,int: 80},1000,'']
$equip[:right][26]=['雪白法杖','icon/mat_tkl002/we_staff016.png',
  {atk: 160,matk: 320,int: 110},1000,'']
$equip[:right][27]=['血紅法杖','icon/mat_tkl002/we_staff016b.png',
  {atk: 320,matk: 640,int: 145},1000,'']

$equip[:right][31]=['翠綠魔劍','icon/mat_tkl002/we_sword016c.png',
  {atk: 9,matk: 6,wis: 10},1000,'']
$equip[:right][32]=['木紋魔劍','icon/mat_tkl002/we_sword016b.png',
  {atk: 18,matk: 12,wis: 20},1000,'']
$equip[:right][33]=['鐵灰魔劍','icon/mat_tkl002/we_sword020.png:[10,0]',
  {atk: 36,matk: 24,wis: 35},1000,'']
$equip[:right][34]=['湛藍魔劍','icon/mat_tkl002/we_sword016d.png',
  {atk: 72,matk: 48,wis: 55},1000,'']
$equip[:right][35]=['緋紅魔劍','icon/mat_tkl002/we_sword016.png',
  {atk: 144,matk: 96,wis: 80},1000,'']
$equip[:right][36]=['绛紫魔劍','icon/mat_tklre001/we_sword024b.png:[10,0]',
  {atk: 288,matk: 192,wis: 110},1000,'']
$equip[:right][37]=['血紅魔劍','icon/mat_tklre001/we_sword024.png:[10,0]',
  {atk: 576,matk: 384,wis: 145},1000,'']

  
$equip[:dual][1.01]=['紙製雙劍','icon/mat_tkl002/we_sword006.png:[5,0]',
  {atk: 8,atkspd: 10},400,'輕薄短小的紙製雙劍']
$equip[:dual][ 1]=['翠綠雙斧','icon/mat_tkl002/we_axe002d.png',
  {atk: 10,healhp: 5},1000,'']
$equip[:dual][ 2]=['木紋雙斧','icon/mat_tkl002/we_axe002e.png',
  {atk: 20,healhp: 10},1000,'']
$equip[:dual][ 3]=['銀白雙斧','icon/mat_tkl002/we_axe002.png',
  {atk: 40,healhp: 20},1000,'']
$equip[:dual][ 4]=['湛藍雙斧','icon/mat_tkl002/we_axe002c.png',
  {atk: 80,healhp: 35},1000,'']
$equip[:dual][ 5]=['緋紅雙斧','icon/mat_tkl002/we_axe002b.png',
  {atk: 160,healhp: 55},1000,'']
$equip[:dual][ 6]=['蒼灰雙斧','icon/mat_tkl002/we_axe003.png',
  {atk: 320,healhp: 80},1000,'']
$equip[:dual][ 7]=['血紅雙斧','icon/mat_tkl002/we_axe003b.png',
  {atk: 640,healhp: 110},1000,'']

$equip[:dual][11]=['迷你雙劍','icon/mat_tkl001/we_sword001.png',
  {atk: 10,atkspd: 10},1000,'']
$equip[:dual][12]=['普通雙劍','icon/mat_tkl001/we_sword002.png:[10,0]',
  {atk: 20,atkspd: 20},1000,'']
$equip[:dual][13]=['銀白雙劍','icon/mat_tkl002/we_sword007.png:[10,0]',
  {atk: 40,atkspd: 30},1000,'']
$equip[:dual][14]=['湛藍雙劍','icon/mat_tkl002/we_sword007d.png:[10,0]',
  {atk: 80,atkspd: 40},1000,'']
$equip[:dual][15]=['緋紅雙劍','icon/mat_tkl002/we_sword007c.png:[10,0]',
  {atk: 160,atkspd: 50},1000,'']
$equip[:dual][16]=['鐵灰雙劍','icon/mat_tkl002/we_sword014b.png:[10,0]',
  {atk: 320,atkspd: 60},1000,'']
$equip[:dual][17]=['蒼灰雙劍','icon/mat_tkl002/we_sword014.png:[10,0]',
  {atk: 640,atkspd: 70},1000,'']


$equip[:left][1.01]=['紙製圓盾','icon/mat_tkl003/shield_001.png:[0,0]',
  {def: 5,mdef: 4,wlkspd: -10},300,'薄弱的紙製盾牌']#}
$equip[:left][ 1]=['普通重盾','icon/mat_tkl003/shield_001.png',
  {def: 4,block: 5},1000,'']#}
$equip[:left][ 2]=['強化重盾','icon/mat_tkl003/shield_001b.png',
  {def: 8,block: 6},1000,'']#}
$equip[:left][ 3]=['龍形重盾','icon/mat_tkl003/shield_001b.png',
  {def: 16,block: 8},1000,'']#}
$equip[:left][ 4]=['華麗重盾','icon/mat_tkl003/shield_001d.png',
  {def: 32,block: 11},1000,'']#}
$equip[:left][ 5]=['棘刺重盾','icon/mat_tkl003/shield_001e.png',
  {def: 64,block: 15},1000,'']#}
$equip[:left][ 6]=['球面重盾','icon/mat_tkl003/shield_002.png',
  {def: 128,block: 20},1000,'']#}
$equip[:left][ 7]=['硬化重盾','icon/mat_tkl003/shield_002d.png',
  {def: 256,block: 26},1000,'']#}

$equip[:left][11]=['普通魔盾','icon/mat_tkl003/shield_001h.png',
  {def: 3,mdef: 3},1000,'']#}
$equip[:left][12]=['強化魔盾','icon/mat_tkl003/shield_001i.png',
  {def: 6,mdef: 6},1000,'']#}
$equip[:left][13]=['龍形魔盾','icon/mat_tkl003/shield_001j.png',
  {def: 12,mdef: 12},1000,'']#}
$equip[:left][14]=['華麗魔盾','icon/mat_tkl003/shield_001k.png',
  {def: 24,mdef: 24},1000,'']#}
$equip[:left][15]=['棘刺魔盾','icon/mat_tkl003/shield_001l.png',
  {def: 48,mdef: 48},1000,'']#}
$equip[:left][16]=['球面魔盾','icon/mat_tkl003/shield_002e.png',
  {def: 96,mdef: 96},1000,'']#}
$equip[:left][17]=['硬化魔盾','icon/mat_tkl003/shield_002h.png',
  {def: 192,mdef: 192},1000,'']#}

$equip[:left][21]=['普通輕盾','icon/mat_tkl003/shield_001m.png',
  {def: 3,tough: 5,wlkspd: 5},1000,'']#}
$equip[:left][22]=['強化輕盾','icon/mat_tkl003/shield_001n.png',
  {def: 6,tough: 10,wlkspd: 10},1000,'']#}
$equip[:left][23]=['龍形輕盾','icon/mat_tkl003/shield_001o.png',
  {def: 12,tough: 15,wlkspd: 15},1000,'']#}
$equip[:left][24]=['華麗輕盾','icon/mat_tkl003/shield_001p.png',
  {def: 24,tough: 20,wlkspd: 20},1000,'']#}
$equip[:left][25]=['棘刺輕盾','icon/mat_tkl003/shield_001q.png',
  {def: 48,tough: 25,wlkspd: 25},1000,'']#}
$equip[:left][26]=['球面輕盾','icon/mat_tkl003/shield_002i.png',
  {def: 96,tough: 30,wlkspd: 30},1000,'']#}
$equip[:left][27]=['硬化輕盾','icon/mat_tkl003/shield_002l.png',
  {def: 192,tough: 35,wlkspd: 35},1000,'']#}
  
$equip[:left][31]=['口袋魔法書','icon/mat_tklre001/book_001.png',
  {atk: 2,def: 2,mdef: 4,consum_amp: -5},1000,'']#}
$equip[:left][32]=['翠綠魔法書','icon/tklre06/book_002b.png',
  {atk: 4,def: 4,mdef: 8,consum_amp: -6},1000,'']#}
$equip[:left][33]=['緋紅魔法書','icon/tklre06/book_002c.png',
  {atk: 8,def: 8,mdef: 16,consum_amp: -8},1000,'']#}
$equip[:left][34]=['湛藍魔法書','icon/mat_tklre001/book_002.png',
  {atk: 16,def: 16,mdef: 32,consum_amp: -10},1000,'']#}
$equip[:left][35]=['絳紫魔法書','icon/mat_tklre001/book_004.png',
  {atk: 32,def: 32,mdef: 64,consum_amp: -12},1000,'']#}
$equip[:left][36]=['精裝魔法書','icon/tklre03/book_005.png',
  {atk: 64,def: 64,mdef: 128,consum_amp: -14},1000,'']#}
$equip[:left][37]=['上古魔法石版','icon-1_2.png@[1,6]:[0,0]',
  {atk: 128,def: 128,mdef: 256,consum_amp: -16},1000,'']#}

$equip[:single][1.01]=['紙製長槍','icon/tklre05/we_spear020c.png:[0,10]',
  {atk: 10,def: 3,mdef: 3},650,'弱弱的長槍聊勝於無~~']#}
$equip[:single][ 1]=['翠綠長槍','icon/mat_tkl002/we_spear006d.png:[0,10]',
  {atk: 15,con: 10},1000,'']
$equip[:single][ 2]=['木紋長槍','icon/mat_tkl002/we_spear006e.png:[0,10]',
  {atk: 30,con: 20},1000,'']
$equip[:single][ 3]=['銀白長槍','icon/mat_tkl002/we_spear006.png:[0,10]',
  {atk: 60,con: 35},1000,'']
$equip[:single][ 4]=['湛藍長槍','icon/mat_tkl002/we_spear006c.png:[0,10]',
  {atk: 120,con: 55},1000,'']
$equip[:single][ 5]=['緋紅長槍','icon/mat_tkl002/we_spear006b.png:[0,10]',
  {atk: 240,con: 80},1000,'']
$equip[:single][ 6]=['鐵灰長槍','icon/mat_tkl002/we_spear017.png:[0,10]',
  {atk: 480,con: 110},1000,'']
$equip[:single][ 7]=['蒼灰長槍','icon/mat_tkl002/we_spear017b.png:[0,10]',
  {atk: 960,con: 145},1000,'']

$equip[:single][11]=['翠綠大斧','icon/mat_tkl002/we_axe008e.png',
  {atk: 15,str: 10},1000,'']
$equip[:single][12]=['木紋大斧','icon/mat_tkl002/we_axe008b.png',
  {atk: 30,str: 20},1000,'']
$equip[:single][13]=['銀白大斧','icon/mat_tkl002/we_axe012.png:[0,10]',
  {atk: 60,str: 35},1000,'']
$equip[:single][14]=['湛藍大斧','icon/mat_tkl002/we_axe012c.png:[0,10]',
  {atk: 120,str: 55},1000,'']
$equip[:single][15]=['緋紅大斧','icon/mat_tkl002/we_axe012b.png:[0,10]',
  {atk: 240,str: 80},1000,'']
$equip[:single][16]=['鐵灰大斧','icon/mat_tkl002/we_axe013.png',
  {atk: 480,str: 110},1000,'']
$equip[:single][17]=['血紅大斧','icon/mat_tkl002/we_axe013c.png',
  {atk: 960,str: 145},1000,'']

  
$equip[:range][0]=['測試用弩弓','test/crsbow.png',
  {ratk: 10,agi: 5},1000,'輕型遠距離武器']
$equip[:range][1.01]=['紙製弓','icon/mat_tkl002/we_bow001b.png:[0,0]',
  {ratk: 7,agi: 3,atkspd: 10},500,'微幅提高攻速的輕量弓']
$equip[:range][ 1]=['湛藍短弓','icon/mat_tkl002/we_bow001b.png',
  {ratk: 10,atkspd: 10,wlkspd: 0.02},1000,'']
$equip[:range][ 2]=['木紋短弓','icon/mat_tkl002/we_bow001.png',
  {ratk: 20,atkspd: 20,wlkspd: 0.03},1000,'']
$equip[:range][ 3]=['湛藍長弓','icon/mat_tkl002/we_bow002b.png',
  {ratk: 40,atkspd: 30,wlkspd: 0.04},1000,'']
$equip[:range][ 4]=['木紋長弓','icon/mat_tkl002/we_bow002.png',
  {ratk: 80,atkspd: 40,wlkspd: 0.05},1000,'']
$equip[:range][ 5]=['緋紅長弓','icon/mat_tkl002/we_bow003b.png',
  {ratk: 160,atkspd: 50,wlkspd: 0.06},1000,'']
$equip[:range][ 6]=['銀白機械弓','icon/mat_tkl002/we_bow009.png:[10,0]',
  {ratk: 320,atkspd: 60,wlkspd: 0.07},1000,'']
$equip[:range][ 7]=['血紅機械弓','icon/mat_tkl002/we_bow009b.png:[10,0]',
  {ratk: 640,atkspd: 70,wlkspd: 0.08},1000,'']

$equip[:range][10]=['紙製弩','icon/mat_tkl002/we_bow013.png:[0,0]',
  {ratk: 10,agi: 3},500,'威力比弓略高的紙製弩']
$equip[:range][11]=['翠綠弩弓','icon/mat_tkl002/we_bow015b.png',
  {ratk: 20,atkspd: 5,def: 2},1000,'']#}
$equip[:range][12]=['木紋弩弓','icon/mat_tkl002/we_bow015.png',
  {ratk: 40,atkspd: 10,def: 4},1000,'']#}
$equip[:range][13]=['緋紅弩弓','icon/mat_tkl002/we_bow014b.png',
  {ratk: 70,atkspd: 15,def: 8},1000,'']#}
$equip[:range][14]=['鐵灰弩弓','icon/mat_tkl002/we_bow014.png',
  {ratk: 120,atkspd: 20,def: 16},1000,'']#}
$equip[:range][15]=['木紋連弩','icon/mat_tkl002/we_bow016.png',
  {ratk: 210,atkspd: 25,def: 32},1000,'']#}
$equip[:range][16]=['銀白連弩','icon/mat_tkl002/we_bow016b.png',
  {ratk: 380,atkspd: 30,def: 64},1000,'']#}
$equip[:range][17]=['血紅弩弓','icon/mat_tkl002/we_bow013b.png',
  {ratk: 710,atkspd: 35,def: 128},1000,'']#}

 
$equip[:finger][0]=['測試用戒指','test/ring.png',
  {matk:5,mdef:5},400,'金光閃閃~~']
$equip[:finger][1]=['白銅戒指','icon/mat_tkl003/acce_004b.png:[0,0]',
  {matk: 0.1},10000,'微量增幅魔攻的山寨戒指']
$equip[:finger][2]=['白銀戒指','item/2011-12-23_1-108.gif',
  {matk: 0.2},20000,'少量增幅魔攻的銀製戒指']


$equip[:feet][0]=['測試用重靴','test/feet.png',
  {str:2,def:2,mdef:2},400,'保護腳底']#}
$equip[:feet][1.01]=['紙製鞋','icon/mat_tkl003/boots_002.png:[0,0]',
  {wlkspd: 10},100,'微幅增加跑速的鞋子']
$equip[:feet][ 1]=['茶褐皮鞋','icon-1_1.png@[4,6]',
  {wlkspd: 30},1000,'']
$equip[:feet][ 2]=['土黃皮鞋','icon/mat_tkl003/boots_005.png',
  {wlkspd: 35},1000,'']
$equip[:feet][ 3]=['雪白皮鞋','icon/mat_tkl003/boots_005b.png',
  {wlkspd: 42},1000,'']
$equip[:feet][ 4]=['翠綠皮鞋','icon/mat_tkl003/boots_003.png',
  {wlkspd: 50},1000,'']
$equip[:feet][ 5]=['翠綠羽翼皮鞋','icon/mat_tkl003/boots_003c.png',
  {wlkspd: 60},1000,'']

$equip[:feet][10]=['紙製靴','icon/mat_tkl003/boots_005b.png:[0,0]',
  {wlkspd: 8,def: 2},100,'微幅增加跑速及防禦的靴子']#}
$equip[:feet][11]=['茶褐皮靴','icon-1_1.png@[5,6]',
  {wlkspd: 20,con: 4},1000,'']
$equip[:feet][12]=['土黃皮靴','icon/tklre06/boots_008.png:[0,0]B[255,0,0]',
  {wlkspd: 25,con: 8},1000,'']
$equip[:feet][13]=['土黃長皮靴','icon/mat_tkl003/boots_006.png',
  {wlkspd: 30,con: 12},1000,'']
$equip[:feet][14]=['雙色裝甲靴','icon/mat_tkl003/boots_004b.png',
  {wlkspd: 35,con: 16},1000,'']
$equip[:feet][15]=['銀白裝甲靴','icon/mat_tkl003/boots_004.png',
  {wlkspd: 40,con: 20},1000,'']


$equip[:deco][0]=['測試用徽章','test/deco.png',{agi:5},700,'徽章']
$equip[:deco][0.1]=['1.5跑速','test/deco.png',{wlkspd:0.5},700,'1.5跑速']
$equip[:deco][0.2]=['1.5HP','test/deco.png',{maxhp:0.5},700,'1.5HP']
$equip[:deco][0.3]=['1.5倍atk加成','test/deco.png',{atk:0.5},700,'atk變為原先的1.5倍']#}
$equip[:deco][0.4]=['1.5閃避','test/deco.png',{dodge:0.5},700,'1.5閃避']
$equip[:deco][0.5]=['茶具','icon/tklre05/food_028c.png',
  {healhp: 5,healsp: 2},1600,'茶具...不解釋...']
  
$equip[:deco][1]=['初級茶具','icon-2_1.png@[8,9]',
  {healhp: 5,healsp: 5},1600,'']
$equip[:deco][2]=['普通茶具','icon-2_1.png@[8,9]',
  {healhp: 10,healsp: 10},1600,'']
$equip[:deco][3]=['高級茶具','icon-2_1.png@[8,9]',
  {healhp: 15,healsp: 15},1600,'']
$equip[:deco][4]=['進階茶具','icon-2_1.png@[8,9]',
  {healhp: 20,healsp: 20},1600,'']
$equip[:deco][5]=['完美茶具','icon-2_1.png@[8,9]',
  {healhp: 25,healsp: 25},1600,'']

$equip[:deco][11]=['初級平蜘蛛釜','icon-2_1.png@[9,9]',
  {healhp: 10,healsp: 5},3550,'']
$equip[:deco][12]=['普通平蜘蛛釜','icon-2_1.png@[9,9]',
  {healhp: 20,healsp: 10},3550,'']
$equip[:deco][13]=['高級平蜘蛛釜','icon-2_1.png@[9,9]',
  {healhp: 30,healsp: 15},3550,'']
$equip[:deco][14]=['進階平蜘蛛釜','icon-2_1.png@[9,9]',
  {healhp: 40,healsp: 20},3550,'']
$equip[:deco][15]=['完美平蜘蛛釜','icon-2_1.png@[9,9]',
  {healhp: 50,healsp: 25},3550,'']

'抗擊護符'
'禦魔護符'
'鬼面'
'能面'
$equip[:deco][21]=['初級短甲','icon/mat_tkl003/armor_006.png',{phy_decatk: 5},400,'']
$equip[:deco][22]=['普通短甲','icon/mat_tkl003/armor_006.png',{phy_decatk: 10},800,'']
$equip[:deco][23]=['高級短甲','icon/mat_tkl003/armor_006.png',{phy_decatk: 20},1600,'']
$equip[:deco][24]=['進階短甲','icon/mat_tkl003/armor_006.png',{phy_decatk: 35},3200,'']
$equip[:deco][25]=['完美短甲','icon/mat_tkl003/armor_006.png',{phy_decatk: 55},6400,'']

$equip[:deco][26]=['初級抗魔短甲','icon/mat_tkl003/armor_006c.png',{mag_decatk: 10},400,'']
$equip[:deco][27]=['普通抗魔短甲','icon/mat_tkl003/armor_006c.png',{mag_decatk: 20},800,'']
$equip[:deco][28]=['高級抗魔短甲','icon/mat_tkl003/armor_006c.png',{mag_decatk: 35},1600,'']
$equip[:deco][29]=['進階抗魔短甲','icon/mat_tkl003/armor_006c.png',{mag_decatk: 55},3200,'']
$equip[:deco][30]=['完美抗魔短甲','icon/mat_tkl003/armor_006c.png',{mag_decatk: 80},6400,'']
$equip[:deco][31]=['御守','icon/mat_tklre002/other_003.png',{},650,'']

Output('equip')