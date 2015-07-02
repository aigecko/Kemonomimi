#coding: utf-8
class Actor::Action
  @@ActionList=[:standby,:attack,:cast]
  def initialize(actor)
    @actor=actor
    @action=:standby
    @frame=:standby
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
  def set_target(target,action=nil)
    action and set_action(action)
    @target=target
  end
  def chase_target
    @target and not reach_target? and
    case @action
    when :chase
      if @target.position.x>@position.x
        @actor.rotate(:right)
        dst_x=@target.position.x-(@target.pic_w+@actor.pic_w)/2+1
      else
        @actor.rotate(:left)
        dst_x=@target.position.x+(@target.pic_w+@actor.pic_w)/2-1
      end      
      dst_x=dst_x.confine(0,Map.w)
      dst_z=@target.position.z
      @actor.set_move_dst(dst_x,0,dst_z)
    when :pickup
      item_x=@target.position.x
      item_z=@target.position.z
      dis=Math.distance(item_x,item_z,
                        @position.x,@position.z)
      delta_x=item_x-@position.x
      delta_z=item_z-@position.z
      dst_x=@position.x+delta_x*(dis-50)/dis
      dst_z=@position.z+delta_z*(dis-50)/dis
      @actor.set_move_dst(dst_x,nil,dst_z)
    end
  end
  def reach_target?
    case @action
    when :chase
      return (@position.x-@target.position.x).abs<=(@actor.pic_w+@target.pic_w)/2&&
             (@position.z-@target.position.z).abs<=20
    when :pickup
      return Math.distance(@position.x,@position.z,
                           @target.position.x,@target.position.z)<=51
    end
  end
  def interact_target
    @target and reach_target? and
    case @action
    when :chase
      set_action(:attack)
      if !@target.died?
        @position.x>@target.position.x ? @actor.rotate(:left) : @actor.rotate(:right)
        @actor.cast(:normal_attack,@target,nil,nil,nil)
      end
    when :pickup
      case @target
      when Equipment
        func=:gain_equip
      when Consumable
        func=:gain_consumable
      when OnGroundItem
        func=:gain_consumable
      when Item
        func=:gain_item
      else
        begin
          raise "UnknownItemOnGround"
        rescue => e
          p e
          Message.show_format("拾起的物件型別未知","錯誤",:ERROR)
          exit
        end
      end
      Map.render_onground_item.delete(@target)
      @target=@target.pickup
      send(func,@target)
      set_target(nil)
    end
  end
  def action_progress
    case @action
    when :standby
      @frame=:standby
    when :chase
      @frame=:standby
    when :attack
      if @counter==0
        @counter+=1
        @frame=:raise_hand
      elsif @counter<2
        @counter+=1
        @frame=:attack
      elsif @counter<5
        @counter+=1
        @frame=:complete_attack
      else
        @counter=0
        @action=:chase
        @frame=:standby
      end
    when :pickup
      @frame=:standby
    when :cast
      @frame=:standby
    end
  end
  def update
    @position=@actor.position
    unless @actor.has_state?(:stun)
      chase_target
      @actor.move2dst
      interact_target
    end
    action_progress
  end
  def yield_frame
    return @frame
  end
end