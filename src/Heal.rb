#coding: utf-8
class Heal
  def initialize(caster,info)
    @info=info
    @caster=caster
  end
  def affect(target)
    target.gain_hp(@info[:hp]||0)
    target.gain_sp(@info[:sp]||0)
  end
end