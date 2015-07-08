#!/usr/bin/ruby
#coding: utf-8
require_relative 'output'

#素材
$material=Hash.new
#[編號]=[名稱,圖檔,價格,敘述,其他]
$material[10]=['強化鋼','icon/mat_tkl001/mat_001.png',350,'',{id: 2}]
$material[11]=['硬化鋼','icon/mat_tkl001/mat_002.png',350,'',{id: 3}]
$material[12]=['附魔強化鋼','icon/mat_tkl001/mat_005.png',350,'',{id: 5}]
$material[13]=['附魔硬化鋼','icon/mat_tkl001/mat_003.png',350,'',{id: 7}]
$material[14]=['羽化鋼','icon/mat_tkl001/mat_004.png',350,'',{id: 11}]

$material[15]=['蠻力鋼','icon/tklre03/food_021.png',300,'',{id: 13}]
$material[16]=['堅忍鋼','icon/tklre03/food_021c.png',300,'',{id: 17}]
$material[17]=['技巧鋼','icon/tklre03/food_021g.png',300,'',{id: 19}]
$material[18]=['睿智鋼','icon/tklre03/food_021b.png',300,'',{id: 23}]
$material[19]=['迅捷鋼','icon/tklre03/food_021h.png',300,'',{id: 29}]
$material[19.1]=['能量鋼','icon/tklre03/mat_034.png',2100,'',{id: 13*17*19*23*29}]

$material[20]=['生命鋼','icon-1_2.png@[4,4]-[0,40,20]',900,'',{id: 31}]
$material[21]=['法力鋼','icon-1_2.png@[5,4]+[20,20,20]',650,'',{id: 37}]
$material[22]=['再生鋼','icon-1_2.png@[5,4]#[4.0]:[0,0]',650,'',{id: 41}]
$material[23]=['回魔鋼','icon-1_2.png@[5,4]-[20,20,0]+[0,0,40]',650,'',{id: 43}]

$material[24]=['鴕鳥羽毛','icon/mat_tkl001/mat_006.png',650,'',{id: 47}]
$material[25]=['隼鳥羽毛','icon/mat_tkl001/mat_007.png',650,'',{id: 53}]
$material[26]=['吸血牙','icon/mat_tkl001/mat_021.png',900,'',{id: 59}]
$material[27]=['附魔吸血牙','icon/mat_tkl001/mat_020.png',900,'',{id: 61}]
$material[28]=['物理潛力寶石','item/2011-12-23_1-131.gif:[0,0]B[255,0,0]',2100,'',{id: 67}]
$material[29]=['魔法潛力寶石','item/2011-12-23_1-132.gif:[0,0]B[255,0,0]',2100,'',{id: 71}]

$material[30]=['石化骨頭','icon/mat_tkl001/mat_016.png',1900,'',{id: 73}]
$material[31]=['稚雞羽毛','icon/mat_tkl001/mat_008.png',1900,'',{id: 79}]
$material[32]=['彈性黏液','icon/mat_tkl001/item_014.png',1900,'',{id: 83}]
$material[33]=['殘破卷軸','icon/mat_tklre001/book_003.png',1900,'',{id: 89}]

$material[37]=['清水','item/2011-12-23_2-005.gif:[0,0]B[255,0,0]',600,'',{id: 109}]
$material[38]=['黏液','item/2011-12-23_2-006.gif:[0,0]B[255,0,0]',600,'',{id: 113}]



Output('material')