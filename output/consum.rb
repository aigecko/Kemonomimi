#coding: utf-8
require_relative 'output'

#消耗品
$consum=Hash.new
#[編號]=[名稱,圖檔,屬性,價格,敘述]
$consum[10]=['小罐生命藥水','icon-2_1.png@[2,0]:[0,0]',
  {name:'生命藥水',type: :active,table:[0,{hp: 100}],icon: nil,base: :heal},
  100,'自身回復100HP']
$consum[11]=['中罐生命藥水','icon-2_1.png@[9,0]:[0,0]',
  {name:'生命藥水',type: :active,table:[0,{hp: 300}],icon: nil,base: :heal},
  100,'自身回復300HP']
$consum[12]=['大罐生命藥水','icon-2_1.png@[15,0]:[0,0]',
  {name:'生命藥水',type: :active,table:[0,{hp: 900}],icon: nil,base: :heal},
  100,'自身回復900HP']
$consum[13]=['濃縮生命藥水','icon-2_1.png@[12,0]:[0,0]',
  {name:'生命藥水',type: :active,table:[0,{hp: 2700}],icon: nil,base: :heal},
  100,'自身回復2700HP']
$consum[14]=['精煉生命藥水','icon-2_1.png@[15,5]:[0,0]',
  {name:'生命藥水',type: :active,table:[0,{hp: 8100}],icon: nil,base: :heal},
  100,'自身回復8100HP']
$consum[15]=['生命藥丸','icon-2_1.png@[6,1]:[0,0]',
  {name:'生命藥水',type: :active,table:[0,{hp: 0.5}],data:{type: :percent},icon: nil,base: :heal},
  100,'自身回復50%HP']
$consum[16]=['生命果凍','icon-2_1.png@[15,2]:[0,0]',
  {name:'生命藥水',type: :active,table:[0,{hp: 1}],data:{type: :percent},icon: nil,base: :heal},
  100,'自身回復100%HP']

$consum[:"反服貿黑箱"]=['服貿疝液','icon/tklre04/skill_058.png',{name:'即死',type: :active,icon: nil,base: :none},1/0.0,'由鬼開的藥單經過黑箱得到的疝液~~']

$consum[20]=['小罐法力藥水','icon-2_1.png@[6,0]:[0,0]',
  {name:'法力藥水',type: :active,table:[0,{sp: 100}],icon: nil,base: :heal},
  100,'自身回復100SP']
$consum[21]=['中罐法力藥水','icon-2_1.png@[8,0]:[0,0]',
  {name:'法力藥水',type: :active,table:[0,{sp: 300}],icon: nil,base: :heal},
  100,'自身回復300SP']
$consum[22]=['大罐法力藥水','icon-2_1.png@[14,0]:[0,0]',
  {name:'法力藥水',type: :active,table:[0,{sp: 900}],icon: nil,base: :heal},
  100,'自身回復900SP']
$consum[23]=['濃縮法力藥水','icon-2_1.png@[11,0]:[0,0]',
  {name:'法力藥水',type: :active,table:[0,{sp: 2700}],icon: nil,base: :heal},
  100,'自身回復2700SP']
$consum[24]=['精煉法力藥水','icon-2_1.png@[14,5]:[0,0]',
  {name:'法力藥水',type: :active,table:[0,{sp: 8100}],icon: nil,base: :heal},
  100,'自身回復8100SP']
$consum[25]=['法力藥丸','icon-2_1.png@[7,1]:[0,0]',
  {name:'法力藥水',type: :active,table:[0,{sp: 0.5}],data:{type: :percent},icon: nil,base: :heal},
  100,'自身回復50%SP']
$consum[26]=['法力果凍','icon-2_1.png@[14,2]:[0,0]',
  {name:'法力藥水',type: :active,table:[0,{sp: 1}],data:{type: :percent},icon: nil,base: :heal},
  100,'自身回復100%SP']

Output('consum')