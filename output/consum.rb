#coding: utf-8
require_relative 'output'

#消耗品
$consum=Hash.new
#[編號]=[名稱,圖檔,屬性,價格,敘述]
$consum[10]=['紅藥水','item/2011-12-23_2-003.gif',{name:'紅藥水',type: :active,table:[0,{hp: 100}],icon: nil,base: :heal},100,'指定目標回復100HP']
$consum[:"反服貿黑箱"]=['服貿疝液','icon/tklre04/skill_058.png',{name:'即死',type: :active,icon: nil,base: :none},1/0.0,'由鬼開的藥單經過黑箱得到的疝液~~']
$consum[20]=['藍藥水','',{skill: :mana,type: :vlaue,icon: 'zzz',sp:100},200,'指定目標回復100SP']
$consum[30]=['爆裂彈','',{skill: :bomb,type: :value,hp:500},5000,'範圍內敵人減少500HP']

Output('consum')