#coding: utf-8
require_relative 'output'

#職業
$class=Hash.new
$attrib=[:str,:con,:int,:wis,:agi,:atk,:matk,:ratk]
#[種類]=             [str,con,int,wis,agi,atk,matk,ratk]
$class[:crossbowman]=[ 10, 16,  5,  9, 30, 23,  0, 33]
$class[:archer]=     [ 10, 15,  5, 10, 30, 22,  0, 35]
 
$class[:mage]=       [  5, 13, 30, 19,  3, 10, 20,  0]
$class[:cleric]=     [  7, 14, 25, 20,  4, 12, 18,  0]

$class[:fighter]=    [ 30, 19,  5,  8,  8, 43,  0,  0]
$class[:paladin]=    [ 25, 19,  7, 10,  9, 37, 15,  0]
$class[:darkknight]= [ 27, 20,  5,  9,  9, 40, 13,  0]


$class.each_key{|key|
  ary=$class[key]
  hash=Hash.new()
  for i in 0..$attrib.size
    hash[$attrib[i]]=ary[i]
  end
  $class[key]=hash
}
Output('class')