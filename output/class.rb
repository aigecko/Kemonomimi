#coding: utf-8
require_relative 'output'

#職業
$class=Hash.new
$attrib=[:str,:con,:int,:wis,:agi]
#[種類]=[str,con,int,wis,agi]
$class[:crossbowman]=[10,16, 5, 9,30]
$class[:archer]=     [10,15, 5,10,30]

$class[:mage]=       [ 5,13,30,19, 3]
$class[:cleric]=     [ 7,14,25,20, 4]

$class[:fighter]=    [30,19, 5, 8, 8]
$class[:paladin]=    [25,19, 7,10, 9]
$class[:darkknight]= [27,20, 5, 9, 9]


$class.each_key{|key|
  ary=$class[key]
  hash=Hash.new()
  for i in 0..4
    hash[$attrib[i]]=ary[i]
  end
  $class[key]=hash
}
Output('class')