#coding: utf-8
class Skill::Base::Wolfear 
  def self.call(info)
    caster=info[:caster]
    attrib=caster.attrib

    healhp=(attrib[:maxhp]-attrib[:hp])*0.02
    healsp=healhp*attrib[:maxsp]/attrib[:maxhp]

    caster.add_state(caster,
      name:'狼耳之血',sym: :wolfear,
      icon:'./rc/icon/skill/2011-12-23_3-079.gif:[0,0]B[255,0,0]',
      attrib: {healhp: healhp,healsp: healsp},
      magicimu_keep: true,
      last: nil)
  end
end