#coding: utf-8
class Actor::Attrib
  @@Conv={
    str:{atk: 1},
    con:{def: 1,maxhp: 10},#}
    int:{matk: 1},
    wis:{mdef: 1,maxsp: 10},
    agi:{ratk: 1}
  }
  @@Max={
    level: 200,
    str: 1024,
    con: 1024,
    int: 1024,
    wis: 1024,
    agi: 1024
  }
  @@Base=[:str,:con,:int,:wis,:agi]
  @@Coef={
    extra: 7,
    healhp: 0.04,
    healsp: 0.06,
    
    growth: 10,
    amped: 100,
    step: 40.0,
    
    dodge: 0.03,
    block: 0.03,
    
    atkcd_min: 0.7,
    shtcd_min: 0.7,
    atkspd_min: 10,
    atkspd_max: 500,
    wlkspd_min: 10,
    wlkspd_max: 522
  }
  @@MarshalTable={:b=>:@base,:s=>:@state,:e=>:@equip,:a=>:@amped,:t=>:@total}
end