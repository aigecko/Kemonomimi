#coding: utf-8
class Skill::Base::Boost 
  def self.call(info)
    caster=info[:caster]
    data=info[:data]
    args=info[:args]
    add=args[:add]
    attrib={}
    args[:base].each{|key,value|
      attrib[key]=value
    }
    attrib.each_key{|sym|
      add[sym] or next
      add_value=caster.attrib[add[sym][0]]*add[sym][1]
      attrib[sym]+=(add_value<1)? add_value : add_value.to_i
    }
    last=data[:last].to_sec

    caster.add_state(caster,
      name: data[:name],sym: data[:sym],
      icon: data[:icon],
      magicimu_keep: true,
      attrib: attrib,
      last: last)
  end
end