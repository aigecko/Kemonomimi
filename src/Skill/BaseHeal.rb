#coding: utf-8
class Skill::Base::Heal
  def self.call(info)
    hp,sp=info[:args][:hp],info[:args][:sp]
    data=info[:data]||{}
    target=info[:target]
    Heal.new(info[:caster],
      type: data[:type],hp: hp,sp: sp,
      hpsym: data[:hpsym],hpcoef: data[:hpcoef],
      spsym: data[:spsym],spcoef: data[:spcoef]).affect(target,target.position)
  end
end