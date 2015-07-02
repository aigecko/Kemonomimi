#coding: utf-8
class Attribute
  @@NameTable={
    str:'力量',con:'體質',
    int:'智力',wis:'智慧',
    agi:'敏捷',

    hp:'生命',sp:'法力',
    maxhp:'最大生命',maxsp:'最大法力',
    healhp:'生命回復',healsp:'法力回復',

    atk:'近攻',def:'物防',#}
    matk:'魔攻',mdef:'魔防',
    ratk:'遠攻',

    block:'格檔',dodge:'閃避',ignore:'忽略傷害',
    wlkspd:'跑速',atkspd:'攻速',
    atkcd:'基礎攻速',shtcd:'基礎射速',
    jump:'跳躍',tough:'韌性',
    extra:'剩餘點數',

    atk_vamp:'普攻吸血',
    skl_vamp:'技能吸血',

    mag_outamp:'魔法輸出強化',phy_outamp:'物理輸出強化',
    mag_resist:'魔法抗性',phy_resist:'物理抗性',atk_resist:'傷害抗性',
    mag_decatk:'減少魔傷',phy_decatk:'減少物傷',
    mag_shield:'魔法護盾',atk_shield:'傷害護盾',

    consum_amp:'消耗係數',heal_amp:'治癒係數',

    attack_amp:'輸出強化',

    critical:'爆擊',
    bash:'暈眩'
  }
  @@AbbrevTable={
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
    :msh=>:mag_shield,:ash=>:atk_shield,
    :mms=>:max_mag_shield,:mas=>:max_atk_shield,

    :ca=>:consum_amp,:ha=>:heal_amp,:aa=>:attack_amp,

    :cr=>:critical,:ba=>:bash,
  
    #below attribute will be re-initialize after load
    #:tc=>:attack_cd,:rc=>:arrow_cd
    #:me=>:maxexp
  }
  @@AttribTable=@@AbbrevTable.invert
  def self.attrib_table
    return @@AttribTable
  end
  def self.abbrev_table
    return @@AbbrevTable
  end
  def self.name_table
    return @@NameTable
  end
end