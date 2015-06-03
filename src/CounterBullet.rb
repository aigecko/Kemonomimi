#coding: utf-8
class CounterBullet < Bullet
  class<<self
    undef :new
    alias new create
  end
  def affect(target)
    result=super
    @go_forward or return result
    @hit_target<<target
    @live_count-=1
    return @live_count<0
  end
end
