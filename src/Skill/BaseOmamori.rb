#coding: utf-8
class Skill::Base::Omamori < Skill::Base
  def self.call(info)
    return :miss
  end
end