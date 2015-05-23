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
    healhp: 0.01,
    healsp: 0.02,
    
    growth: 10,
    amped: 100,
    step: 40.0,
    
    agi_div: 50.0,
    agi_exp: 1.06,
    agi_mul: 2,
    dodge_exp: 1.3,
    dodge_max: 30,
    dtob: 0.8,
    atkspd_max: 500
  }
  @@MarshalTable={:b=>:@base,:s=>:@state,:e=>:@equip,:a=>:@amped,:t=>:@total}
end