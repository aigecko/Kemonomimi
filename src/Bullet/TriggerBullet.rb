#coding: utf-8
class TriggerBullet < Bullet
  class<<self
    undef :new
    alias new create
  end
  def affect(target)
    result=super
    @go_forward or return result
    @hit_target<<target
    @hit=true
    return false
  end
  def to_delete?
    @live_count-=1
    return @live_count<0||@hit
  end
end