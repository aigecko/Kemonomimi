#coding: utf-8
class Actor::Action
  @@ActionList=[:standby,:attack,:cast]
  def initialize(actor)
    @actor=actor
    @action=:standby
    @counter=0
  end
  def current_action
    return @action
  end
  def current_target
    return @target
  end
  def set_action(action)
    @counter=0
    @action=action
  end
  def set_target(target)
    @target=target
  end
  def yield_frame
    case @action
    when :standby
      return :standby
    when :chase
      return :standby
    when :attack
      if @counter==0
        @counter+=1
        return :raise_hand
      elsif @counter<2
        @counter+=1
        return :attack
      elsif @counter<5
        @counter+=1
        return :complete_attack
      else
        @counter=0
        @action=:standby
        return :standby
      end
    when :pickup
      return :standby
    when :cast
      return :standby
    end
  end
end