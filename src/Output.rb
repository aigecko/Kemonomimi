#coding: utf-8
require 'openssl'
require 'digest'
require 'zlib'

#加密設定
Encrypt=true
#裝備
_equip=Hash.new
[:head,:neck,:body,:back,:left,:right,
 :range,:finger,:feet,:decoration].each{|sym|
   _equip[sym]=[]
}
#[部位][編號]=[名稱,圖檔,屬性,價格,敘述]
_equip[:left][10]=['匕首','',{atk:100,hp:10},1000,'nothing']
#_equip[:left][11]=['長劍','',{},,'']
#_equip[:right][10]=['','',{},,'']
_equip[:range][10]=['鐵弩','',{ratk:100,agi:100},1000,'nothing']

#消耗品
_consum=Hash.new
#[編號]=[名稱,圖檔,屬性,價格,敘述]
_consum[10]=['紅藥水','',{skill: :heal,type: :value,hp:100},100,'指定目標回復100HP']
_consum[20]=['藍藥水','',{skill: :mana,type: :vlaue,sp:100},200,'指定目標回復100SP']
_consum[30]=['爆裂彈','',{skill: :bomb,type: :value,hp:500},5000,'範圍內敵人減少500HP']

#職業
_class=Hash.new
#[種類]=[str,con,int,wis,agi]
_class[:crossbowman]=[10,16, 5, 9,30]
_class[:archer]=     [10,15, 5,10,30]

_class[:mage]=       [ 5,13,30,15, 7]
_class[:cleric]=     [10,14,21,20, 5]
_class[:sorcerer]=   [10,13,25,13, 9]

_class[:fighter]=    [30,18, 5, 8, 9]
_class[:paladin]=    [25,18, 7,10,10]
_class[:darknight]=  [27,19, 5, 9,10]
_class[:warmage]=    [18,17,18,11, 6]

#種族
_race=Hash.new
#[種類]=[]
_race[:catear]= [20,20,15,15,30]
_race[:foxear]= [15,15,30,25,15]
_race[:wolfear]=[25,20,15,15,25]
_race[:dogear]= [15,25,20,20,20]

#輸出設定
name='race'
eval("Output=_#{name}")
#檔案輸出
Zlib::GzipWriter.open("#{name}.data"){|file|
  data=Marshal.dump(Output)
  if Encrypt
    cipher=OpenSSL::Cipher::Cipher.new('bf-cbc')
    cipher.encrypt
    cipher.key=Digest::SHA1.hexdigest('')
    str=cipher.update(data)<<cipher.final
  else
    str=data
  end
  file.write str
}
puts "#{name} OK"
gets