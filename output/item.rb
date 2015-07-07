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

Output('item')