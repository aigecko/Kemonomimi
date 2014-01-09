#coding: utf-8
require_relative 'output'

#消耗品
$consum=Hash.new
#[編號]=[名稱,圖檔,屬性,價格,敘述]
$consum[10]=['紅藥水','item/2011-12-23_2-003.gif',{name:'紅藥水',type: :active,table:[0,{hp: 100}],icon: nil,base: :heal},100,'指定目標回復100HP']
$consum[20]=['藍藥水','',{skill: :mana,type: :vlaue,icon: 'zzz',sp:100},200,'指定目標回復100SP']
$consum[30]=['爆裂彈','',{skill: :bomb,type: :value,hp:500},5000,'範圍內敵人減少500HP']

Output('consum')