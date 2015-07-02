#coding: utf-8
class TimerBullet < Bullet
  class<<self
    undef :new
    alias new create
  end
  def affect(target)
    result=super
    @go_forward or return result
    return true
  end
  def to_delete?
    @live_count-=1
    return @live_count<0
  end
end