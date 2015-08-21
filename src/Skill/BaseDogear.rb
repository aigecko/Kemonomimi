#coding: utf-8
class Skill::Base::Dogear < Skill::Base
  def self.call(info)
    maxhp,hp=info[:target].attrib[:maxhp],info[:target].attrib[:hp]
    percent=hp*100/maxhp

    if percent<10
      attack_amp=50
      elsif percent<20
      attack_amp=40
    elsif percent<40
      attack_amp=20
    elsif percent<60
      attack_amp=10
    else
      attack_amp=0
    end
    #0.1*0.5+0.1*0.4+0.2*0.2+0.2*0.1
    # 0.10*0.6+0.05*0.5+0.1*0.4+0.15*0.3+0.2*0.15
    #10%:1.6 15%:1.5 25%:1.4 40%:1.3 60%:1.15
      info[:caster].attrib[:attack_amp]=attack_amp
  end
end