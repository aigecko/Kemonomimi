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
$equip[:range][0]=['測試用弩弓','test/crsbow.png',{ratk:10,agi:5},1000,'輕型遠距離武器']
$equip[:finger][0]=['測試用戒指','test/ring.png',{matk:5,mdef:5},400,'金光閃閃~~']
$equip[:feet][0]=['測試用重靴','test/feet.png',{str:2,def:2,mdef:2},400,'保護腳底']
$equip[:deco][0]=['測試用徽章','test/deco.png',{agi:5},700,'徽章']

Output('equip')