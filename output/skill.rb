#coding: utf-8
require_relative 'output'

$skill=Hash.new

$skill[:catear]={
  name:'貓耳基里的祝福',type: :none,
  icon:'./rc/icon/icon/mat_tklre002/skill_029.png:[0,0]',
  comment:'敵人格檔時可以產生4成傷害'}
$skill[:dogear]={
  name:'尾刀狗',type: :before,cd: 0,
  icon:'./rc/icon/icon/mat_tklre002/skill_028.png:[0,0]',
  base: :dogear,consum: 0,level: 1,table:[0,0],
  comment:'敵人的生命比例越低對其傷害越高'}
$skill[:foxear]={
  name:'狐耳基里的祝福',type: :none,		
  icon:'./rc/icon/skill/2011-12-23_3-078.gif',
  comment:'最大SP及消耗多1成 魔法輸出多2成'}
$skill[:wolfear]={
  name:'狼耳基里的祝福',type: :auto,cd: 0.5,
  icon:'./rc/icon/skill/2011-12-23_3-079.gif',
  base: :wolfear,consum: 0,level: 1,table:[0,0],
  comment:'生命越少回復的生命和法力會越多'}

$skill[:counter_attack]={
  name:'反擊之火',type: :attack_defense,
  icon:'./rc/icon/skill/2011-12-23_3-049.gif',
  base: :counter_attack,table:[0,[10,0.1]],
  comment:'受攻擊時反彈#{@table[@level][0]}+#{@table[@level][1]}def絕對傷害'}
$skill[:amplify_hp_block]={
  name:'堅忍不拔',type: :auto,
  icon:'./rc/icon/skill/2011-12-23_3-186.gif',
  base: :amplify,table:[0,{maxhp: 0.06,block: 11}],
  data:{name:'堅忍不拔',sym: :amplify_hp_block},
  comment:'最大生命增幅#{@table[@level][:maxhp]*100}% 格檔增幅#{@table[@level][:block]}%'}
$skill[:fighter_magic_immunity]={
  name:'魔法免疫',type: :active,cd: 30,
  icon:'./rc/icon/icon/tklre04/skill_053.png',
  base: :magic_immunity,consum: 50,table:[0,{base:{atk: 30,def: 10},add:{atk:[:str,0.1],def:[:con,0.1]},last: 4}],#}#}#}#}
  comment:'魔法免疫且增加#{@table[@level][:base][:atk]}+#{@table[@level][:add][:atk][1]}str近攻及#{@table[@level][:base][:def]}+#{@table[@level][:add][:def][1]}con物防'}
$skill[:break_armor]={
  name:'破甲斬擊',type: :append,
  icon:'./rc/icon/icon/tklre05/skill_074.png',
  base: :break_armor,table:[0,-5],
  comment:'命中目標降低#{-@table[@level]}xLog(matk}的雙防2秒'}
$skill[:fire_boost]={
  name:'猛攻之火',type: :active,consum: 40,cd: 20,
  icon: './rc/icon/skill/2011-12-23_3-050.gif',
  base: :boost,
  table:[0,{base:{atkspd: 40,wlkspd: 0.12},add:{atkspd:[:int,0.1],wlkspd:[:int,0.001]}}],
  data:{name:'猛攻',sym: :boost_fire,icon:'./rc/icon/skill/2011-12-23_3-050.gif',last: 16},
  comment:'在#{@data[:last]}秒內增加#{@table[@level][:base][:atkspd]}+#{@table[@level][:add][:atkspd][1]}int%攻速及#{@table[@level][:base][:wlkspd]*100}+#{@table[@level][:add][:wlkspd][1]*100}int%跑速'}
$skill[:attack_increase]={
  name:'烈火戳刺',type: :before,
  icon:'./rc/icon/icon/mat_tkl001/skill_001a.png:[0,0]',
  base: :attack_increase,table:[0,6],
  data:{name:'烈火戳刺',sym: :attack_increase,atk: 15},
  comment:'每次攻擊同一目標提高#{@data[:atk]}傷害最多疊加#{@table[@level]}層'}
$skill[:fire_burn]={
  name:'流動之火',type: :append,
  icon:'./rc/icon/skill/2011-12-23_3-051.gif',
  base: :burn,table:[0,[25,0.55]],
  data:{name:'燃燒',sym: :burn,icon:'./rc/icon/skill/2011-12-23_3-051.gif'},
  comment:'普攻造成目標燃燒2秒造成#{@table[@level][0]}+#{@table[@level][1]}matk絕對傷害}'}
$skill[:fire_circle]={
  name:'熾焰焚身',type: :switch_auto,cd: 1,
  icon:'./rc/icon/skill/2011-12-23_3-072.gif',
  base: :fire_circle,consum: 5,table:[0,[20,-0.1]],
  comment:'每秒造成#{@table[@level][0]}+matk範圍魔法傷害並降低#{-@table[@level][1]*100}%跑速'}
$skill[:fire_burst]={
  name:'火圈迸裂',type: :append,
  icon:'./rc/icon/icon/mat_tkl001/skill_005a.png:[0,0]',
  base: :fire_burst,table:[0,[40,0.3,0.3]],
  comment:'第三下普攻造成範圍#{@table[@level][0]}+#{@table[@level][1]}matk魔傷並暈眩#{@table[@level][2]}秒'}
$skill[:dual_weapon_atkspd]={
  name:'輕巧雙刀',type: :auto,
  icon:'./rc/icon/icon/mat_tkl002/we_sword007b.png:[5,0]',
  base: :dual_weapon_atkspd_acc,
  comment:'雙手裝備雙刀時額外增加雙刀攻速xLog(str)的攻速'}
$skill[:rl_weapon_heal]={
  name:'平衡再生',type: :auto,
  icon:'./rc/icon/icon/mat_tkl003/shield_001r.png:[0,0]',
  base: :rl_weapon_heal,
  comment:'增加盾0.2物防的回復生命以及0.2魔防的回復法力'}
  
$skill[:counter_beam]={
  name:'聖光反射',type: :attack_defense,
  icon:'./rc/icon/icon/mat_tklre002/skill_022.png:[0,0]',
  base: :counter_beam,table:[0,[20,0.1]],
  data:{possibility: 14,cd: 0.8},
  comment:'受攻擊#{@data[:possibility]}%造成範圍#{@table[@level][0]}+def魔法傷害及暈眩#{@table[@level][1]}秒'}
$skill[:holy_protect]={
  name:'神聖庇護',type: :auto,
  icon:'./rc/icon/skill/2011-12-23_3-073.gif',
  base: :amplify,table:[0,{ignore: 9}],
  data:{name:'神聖庇護',sym: :amplify_ignore},
  comment:'有#{@table[@level][:ignore]}%機率忽略受到的攻擊'}
$skill[:paladin_magic_immunity]={
  name:'魔法免疫',type: :active,cd: 30,
  icon:'./rc/icon/icon/tklre04/skill_053.png',
  base: :magic_immunity,consum: 50,
  table:[0,{base:{matk: 10,def: 30},add:{matk:[:int,0.1],def:[:con,0.1]},last: 3}],#}#}#}
  comment:'魔法免疫且增加#{@table[@level][:base][:matk]}+#{@table[@level][:add][:matk][1]}int魔攻及#{@table[@level][:base][:def]}+#{@table[@level][:add][:def][1]}con物防'}
$skill[:paladin_boost]={
  name:'輝煌聖光',type: :active,cd: 6,
  icon:'./rc/icon/icon/mat_tkl001/skill_011.png:[0,0]',
  base: :boost_circle,consum: 10,
  table:[0,[30,30]],
  data:{name:'輝煌聖光',sym: :paladin_boost,icon:'./rc/icon/icon/mat_tkl001/skill_011.png',last: 5},
  comment:'範圍回復#{@table[@level][0]}+0.3matk生命並增加#{@table[@level][1]}+0.1int攻速'}
$skill[:paladin_smash_wave]={
  name:'神聖波動',type: :append,
  icon:'./rc/icon/skill/2011-12-23_3-037.gif',
  base: :smash_wave,table:[0,[50,50]],
  data:{sym: :atk,coef: 0.6,type: :umag},
  comment:'攻擊時#{@table[@level][1]}%產生#{@table[@level][0]}+#{@data[:coef]}atk範圍魔法傷害'}
$skill[:paladin_recover]={
  name:'神聖祝福',type: :active,cd: 15,
  icon:'./rc/icon/icon/mat_tkl001/skill_012.png:[0,0]',
  base: :recover,consum: 15,
  table:[0,{coef: 0,add: 0.2,attrib:{atk: 0.35}}],
  data:{add: :matk,name:'神聖祝福',sym: :paladin_recover,icon:'./rc/icon/icon/mat_tkl001/skill_012.png',last: 10},
  comment:'每秒回復#{@table[@level][:add]}matk生命並增加#{@table[@level][:attrib][:atk]}%攻擊持續#{@data[:last]}秒'}
  
  
Output('skill')