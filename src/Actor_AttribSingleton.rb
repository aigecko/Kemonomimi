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
    step: 40,
    
    agi_div: 50.0,
    agi_exp: 1.06,
    agi_mul: 2,
    dodge_exp: 1.3,
    dodge_max: 30,
    dtob: 0.8,
    atkspd_max: 500
  }
  @@marshal_abbrev_table={
    :l=>:level,:G=>:money,:x=>:exp,
    :s=>:str,:c=>:con,:i=>:int,:w=>:wis,:a=>:agi,

    :hp=>:hp,:sp=>:sp,
    :mh=>:maxhp,:ms=>:maxsp,
    :hh=>:healhp,:hs=>:healsp,

    :at=>:atk,:d=>:def,:ma=>:matk,:md=>:mdef,:ra=>:ratk,

    :b=>:block,:g=>:dodge,:n=>:ignore,
    :ws=>:wlkspd,:as=>:atkspd,
    :j=>:jump,:t=>:tough,
    :e=>:extra,

    :av=>:atk_vamp,:sv=>:skl_vamp,
    :mo=>:mag_outamp,:po=>:phy_outamp,
    :mr=>:mag_resist,:pr=>:phy_resist,:ar=>:atk_resist,
    :mc=>:mag_decatk,:pc=>:phy_decatk,
    :msh=>:mag_shield,:psh=>:atk_shield,

    :ca=>:consum_amp,:ha=>:heal_amp,:aa=>:attack_amp,

    :cr=>:critical,:ba=>:bash,
  
    #below attribute will be re-initialize after load
    #:tc=>:attack_cd,:rc=>:arrow_cd
    #:me=>:maxexp
  }
  @@marshal_attrib_table=@@marshal_abbrev_table.invert
  @@marshal_table={:b=>:@base,:s=>:@state,:e=>:@equip,:a=>:@amped,:t=>:@total}
end