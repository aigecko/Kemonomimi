#coding: utf-8
class FixAttack < Attack
  class<<self
    undef :new
    alias new create
  end
end
require_relative 'Attack/ConstAttack'
require_relative 'Attack/ConstMixAttack'
require_relative 'Attack/PercentAttack'
