#coding: utf-8
class HorizonBullet < Bullet
  def ani_initialize
    @ani=HorizonSurfaceTexture.new(@ani)
  end
end