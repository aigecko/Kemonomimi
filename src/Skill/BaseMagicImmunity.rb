#coding: utf-8
class MagicImmunity
  def self.call(info)
    caster=info[:caster]
    add=info[:args][:add]
    attrib={}
    info[:args][:base].each{|key,value|
      attrib[key]=value
    }
    attrib.each_key{|sym|
      add[sym] and
      attrib[sym]+=(caster.attrib[add[sym][0]]*add[sym][1]).to_i
    }
    last=info[:args][:last].to_sec

    caster.add_state(caster,
      name:'魔法免疫',sym: :magic_immunity,
      icon:'./rc/icon/icon/tklre04/skill_053.png',
      attrib: attrib,
      last: last)
  end
end