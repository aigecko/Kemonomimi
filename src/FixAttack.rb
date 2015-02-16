#coding: utf-8
class FixAttack < Attack
  class<<self
    undef :new
    alias new create
  end
end
require_relative 'ConstAttack'
require_relative 'ConstMixAttack'
require_relative 'PercentAttack'
