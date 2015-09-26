#coding: utf-8
class Skill::Base::SuikaMusou
  def self.call(info)
    caster=info[:caster]
    target=info[:target]
    data=info[:data]
    
    base,amp=info[:args]
    base+=data[:coef]*caster.attrib[data[:sym]]
    base=base.to_i
    
    if (sp=target.attrib[:sp])<base
      target.attrib[:sp]=0
      attack=sp
    else
      target.attrib[:sp]-=base
      attack=base
    end
    
    Attack.new(caster,
      type: :mag,attack: (attack*amp).to_i
    ).affect(target,target.position)
  end
end