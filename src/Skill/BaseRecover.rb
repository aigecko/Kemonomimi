#coding: utf-8
class Skill::Base::Recover
  def self.call(info)
      caster=info[:caster]
      target=caster

      case info[:data][:type]
      when :max
        hp=target.attrib[:maxhp]*info[:args][:coef]/100
      when :cur
        hp=target.attrib[:hp]*info[:args][:coef]/100
      when :lose
        hp=target.attrib[:maxhp]-target.attrib[:hp]*info[:args][:coef]/100
      else
        hp=info[:args][:coef]
        info[:args][:add] and hp+=(target.attrib[info[:data][:add]]*info[:args][:add]).to_i
      end
      attrib=info[:args][:attrib]
      attrib[:healhp]=hp

      target.add_state(caster,
        name: info[:data][:name],sym: info[:data][:sym],
        icon: info[:data][:icon],
        attrib: attrib,
        magicimu_keep: true,
        last: info[:data][:last].to_sec)
  end
end