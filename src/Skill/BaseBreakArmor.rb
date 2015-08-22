#coding: utf-8
class Skill::Base::BreakArmor
  def self.call(info)
    caster=info[:caster]
    dec_armor=(info[:args]*Math.log10(caster.attrib[:matk])).to_i
    info[:target].add_state(caster,
      name:'破防',sym: :break_armor,
      icon: './rc/icon/skill/2011-12-23_3-146.gif',
      attrib: {def: dec_armor,mdef: dec_armor},#}
      last: 2.to_sec)
  end
end