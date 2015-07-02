#coding: utf-8
class NormalBullet < Bullet
  class<<self
    undef :new
    alias new create
  end
  def affect(target)
    result=super
    @go_forward or return result
    return true
  end
end