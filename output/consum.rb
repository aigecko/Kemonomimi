#coding: utf-8
require_relative 'output'


#消耗品
$consum=Hash.new
#[編號]=[名稱,圖檔,屬性,價格,敘述]
$consum[10]=['紅藥水','',{skill: :heal,type: :value,hp:100},100,'指定目標回復100HP']
$consum[20]=['藍藥水','',{skill: :mana,type: :vlaue,sp:100},200,'指定目標回復100SP']
$consum[30]=['爆裂彈','',{skill: :bomb,type: :value,hp:500},5000,'範圍內敵人減少500HP']

Output('consum')