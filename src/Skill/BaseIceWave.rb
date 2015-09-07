#coding: utf-8
class Skill::Base::IceWave
  def self.call(info)
    caster=info[:caster]
    attack=info[:args]
    info[:data][:coef].each{|sym,val|
      attack+=(caster.attrib[sym]*val).to_i
    }
    Attack.new(caster,type: :acid,attack: attack).affect(info[:target],info[:target].position)
  end
end