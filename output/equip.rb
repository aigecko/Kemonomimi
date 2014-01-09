#coding: utf-8
require_relative 'output'

#裝備
$equip=Hash.new
[:head,:neck,:body,:back,:hand,
 :range,:finger,:feet,:deco].each{|sym|
   $equip[sym]=[]
}
#[部位][編號]=[名稱,圖檔,屬性,價格,敘述]
$equip[:head][0]=['測試用頭盔','test/head.png',{def:5,mdef:5},500,'保護頭部的頭盔']

$equip[:neck][0]=['測試用項鍊','test/neck.png',{int:5,wis:5},500,'超硬質的金屬項鍊']

$equip[:body][0]=['測試用盔甲','test/body.png',{str:5,con:5,def:15,mdef:15},1000,'硬梆梆的盔甲']

$equip[:back][0]=['測試用披風','test/back.png',{def:2,jump:5},600,'能跳比較高']

$equip[:hand][0]=['測試用短劍','test/sword.png',{atk:15,maxhp:10},1000,'可以造成一些傷害']
$equip[:hand][1]=['勝利寶劍','icon/mat_tkl002/we_sword018d.png',
  {str:10,con:10,wlkspd:100,atkspd:200,atk_vamp: 0.2,
   skill:{sym: :burn,name:'燒毀',type: :append,table:[0,0],
     icon: './rc/icon/icon/mat_tkl002/we_sword018d.png',
     base: :burn,comment:'就是點燃啦= ='}},
  65535,"MJ勝利寶劍\n附帶#ff0000|燒毀#00327d|技能"]
$equip[:hand][2]=['蜻蛉切‧銘槍','icon/mat_tkl002/we_spear006.png',
  {str:25,con:25,wlkspd: 0.25,
   skill:{
     sym: :smash_wave,name:'蜻切',type: :append,level:1,table:[0,[300,20]],
     icon:'./rc/icon/icon/mat_tkl002/we_spear006.png:[0,5]',
     base: :smash_wave,comment:'普通攻擊20%機率產生300魔法傷害'}},
  8450,'攻擊附帶粉碎波']
$equip[:hand][3]=['妖刀‧村正','icon/mat_tkl002/we_sword021.png',{atk_vamp: 0.52,atk:150},9850,'妖刀村正~~很猛~~']

$equip[:range][0]=['測試用弩弓','test/crsbow.png',{ratk:10,agi:5},1000,'輕型遠距離武器']

$equip[:finger][0]=['測試用戒指','test/ring.png',{matk:5,mdef:5},400,'金光閃閃~~']

$equip[:feet][0]=['測試用重靴','test/feet.png',{str:2,def:2,mdef:2},400,'保護腳底']

$equip[:deco][0]=['測試用徽章','test/deco.png',{agi:5},700,'徽章']
$equip[:deco][1]=['1.5跑速','test/deco.png',{wlkspd:0.5},700,'1.5跑速']
$equip[:deco][2]=['1.5HP','test/deco.png',{maxhp:0.5},700,'1.5HP']
$equip[:deco][3]=['1.5倍atk加成','test/deco.png',{atk:0.5},700,'atk變為原先的1.5倍']#}
$equip[:deco][4]=['1.5閃避','test/deco.png',{dodge:0.5},700,'1.5閃避']

Output('equip')