#coding: utf-8
require 'prime'
class Material < Item
  @@MaterialTable={
    def: 2,mdef: 3,atk: 5,matk: 7,ratk: 11, #}
    str: 13,con: 17,int: 19,wis: 23,agi: 29,
    maxhp: 31,maxsp: 37,healhp: 41,healsp: 43,
    wlkspd: 47,atkspd: 53,
    atk_vamp: 59,skl_vamp: 61,
    phy_outamp: 67,mag_outamp: 71,
    block: 73,dodge: 79,
    tough: 83,consum_amp: 89,
    phy_decatk: 101,mag_decatk: 103,
    omamori: 107
  }
  @@CodeTable={}
  for sym,val in @@MaterialTable
    @@CodeTable[val]=sym
  end
  def initialize(name,pic,price,comment,arg={})
    super(name,pic,price,comment,arg)
    @content=arg[:id]
    @list=@content.prime_division
    for pair in @list
      pair[0]=@@CodeTable[pair[0]]
    end
  end
  def self.compose(list)
    for pair in list
      pair[0]=@@MaterialTable[pair[0]]
    end
    return self.new(Prime.int_from_prime_division(list))
  end
  def seperate
    return @list
  end
  def inspect
    puts "Material: #{@content}"
    return self
  end
end