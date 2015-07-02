#coding: utf-8
class FlashBullet < Bullet
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
    @trigger and return true
    @trigger=true
    return false
  end
end