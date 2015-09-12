#coding: utf-8
class Skill::Base::MagicImmunity
  def self.call(info)
    caster=info[:caster]
    add=info[:args][:add]
    attrib={}
    info[:args][:base].each{|key,value|
      attrib[key]=value
    }
    add and attrib.each_key{|sym|
      add[sym] and
      attrib[sym]+=(caster.attrib[add[sym][0]]*add[sym][1]).to_i
    }
    magic_last=info[:args][:magic_last].to_sec
    attrib_last=info[:args][:attrib_last].to_sec
    
    caster.add_state(caster,
      name: '魔法免疫',sym: :magic_immunity,
      icon: './rc/icon/skill/2011-12-23_3-179.gif:[0,0]B[0,255,0]',
      magicimu_keep: true,
      attrib: {},
      last: magic_last)
    caster.add_state(caster,
      name: '屬性增加',sym: info[:data][:sym],
      magicimu_keep: true,
      attrib: attrib,
      last: attrib_last)
  end
end