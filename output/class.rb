#coding: utf-8
require_relative 'output'

#職業
$class=Hash.new
$attrib=[:str,:con,:int,:wis,:agi,:atk,:matk,:ratk,:attack_cd,:arrow_cd]
#[種類]=             [str,con,int,wis,agi,atk,matk,ratk,atc, arc]
$class[:crossbowman]=[ 10, 16,  5,  9, 30, 23,  0, 33, 1.72,1.68]
$class[:archer]=     [ 10, 15,  5, 10, 30, 22,  0, 35, 1.68, 1.6]
 
$class[:mage]=       [  5, 13, 30, 19,  3, 10, 20,  0,  1.8, 1.8]
$class[:cleric]=     [  7, 14, 25, 20,  4, 12, 18,  0, 1.76, 1.8]

$class[:fighter]=    [ 30, 19,  5,  8,  8, 43,  0,  0,  1.6, 1.8]
$class[:paladin]=    [ 25, 19,  7, 10,  9, 37, 15,  0, 1.64, 1.8]
$class[:darkknight]= [ 27, 20,  5,  9,  9, 40, 13,  0, 1.64, 1.8]

$class[:none]=       [  0,  0,  0,  0,  0,  0,  0,  0,  1.8, 1.8]
$class.each_key{|key|
  ary=$class[key]
  hash=Hash.new()
  for i in 0...$attrib.size
    hash[$attrib[i]]=ary[i]
  end
  $class[key]=hash
}
Output('class')