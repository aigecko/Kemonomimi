#!/usr/bin/ruby
#coding: utf-8
require_relative 'output'

#素材
$item=Hash.new
#[編號]=[名稱,圖檔,屬性,價格,敘述,其他]
$item[10]=['強化鋼','icon/mat_tkl001/mat_001.png',350,'',{id: 2}]
$item[11]=['硬化鋼','icon/mat_tkl001/mat_002.png',350,'',{id: 3}]
$item[12]=['附魔強化鋼','icon/mat_tkl001/mat_005.png',350,'',{id: 5}]
$item[13]=['附魔硬化鋼','icon/mat_tkl001/mat_003.png',350,'',{id: 7}]
$item[14]=['羽化鋼','icon/mat_tkl001/mat_004.png',350,'',{id: 11}]

$item[15]=['蠻力鋼','icon/tklre03/food_021.png',300,'',{id: 13}]
$item[16]=['堅忍鋼','icon/tklre03/food_021c.png',300,'',{id: 17}]
$item[17]=['技巧鋼','icon/tklre03/food_021g.png',300,'',{id: 19}]
$item[18]=['睿智鋼','icon/tklre03/food_021b.png',300,'',{id: 23}]
$item[19]=['迅捷鋼','icon/tklre03/food_021h.png',300,'',{id: 29}]

$item[20]=['生命鋼','icon-1_2.png@[4,4]-[0,40,20]',900,'',{id: 31}]
$item[21]=['法力鋼','icon-1_2.png@[5,4]+[20,20,20]',650,'',{id: 37}]
$item[22]=['再生鋼','icon-1_2.png@[5,4]#[4.0]:[0,0]',650,'',{id: 41}]
$item[23]=['回魔鋼','icon-1_2.png@[5,4]-[20,20,0]+[0,0,40]',650,'',{id: 43}]

$item[24]=['鴕鳥羽毛','icon/mat_tkl001/mat_006.png',650,'',{id: 47}]
$item[25]=['隼鳥羽毛','icon/mat_tkl001/mat_007.png',650,'',{id: 53}]
$item[26]=['吸血牙','icon/mat_tkl001/mat_021.png',900,'',{id: 59}]
$item[27]=['附魔吸血牙','icon/mat_tkl001/mat_020.png',900,'',{id: 61}]
$item[28]=['物理潛力寶石','item/2011-12-23_1-131.gif:[0,0]B[255,0,0]',2100,'',{id: 67}]
$item[29]=['魔法潛力寶石','item/2011-12-23_1-132.gif:[0,0]B[255,0,0]',2100,'',{id: 71}]


Output('item')