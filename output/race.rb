#!/usr/bin/ruby
#coding: utf-8
require_relative 'output'

#種族
$race=Hash.new
$attrib=[:str,:con,:int,:wis,:agi,:wlkspd,:jump]
#[種類]=[]
$race[:catear]= [20,20,15,15,30,128,100]
$race[:foxear]= [15,15,30,25,15,120,100]
$race[:wolfear]=[25,20,15,15,25,120,100]
$race[:dogear]= [15,25,20,20,20,120,100]
$race[:leopardcatear]=[30,20,15,15,20,120,100]

$race[:slime]=  [25,15,20,20,20,60,100]
$race.each_key{|key|
  ary=$race[key]
  hash=Hash.new()
  for i in 0..$attrib.size-1
    hash[$attrib[i]]=ary[i]
  end
  $race[key]=hash
}

Output('race')