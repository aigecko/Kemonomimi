#coding: utf-8
class TimerOnlyBullet < Bullet
  class<<self
    undef :new
    alias new create
  end
  def affect(target)
    result=super
    @go_forward or return result
    @hit_target<<target
    return false
  end
  def to_delete?
    @live_count-=1
    return @live_count<0
  end
end