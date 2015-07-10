#coding: utf-8
class Bullet
  require_relative 'Bullet/Singleton'
  attr_reader :shape,:position,:caster
  def initialize(effect,ani,shape,info)
    @type=shape
    @shape=Shape.new(shape,info)
    
    @effect=effect
        
    @caster=info[:caster]
    @position=Position.new(info[:x],info[:y],info[:z])
    
    @vector=[info[:vx]||0,info[:vy]||0,info[:vz]||0]
    @surface=info[:surface]
    if @surface==:horizon
      @ani=HorizonSurfaceTexture.new(ani)
    else
      @ani=ani
    end
    if @vector[0]<0
      @ani.reverse
    end
    
    @live_cycle=info[:live_cycle]
    @live_count=info[:live_count]
    
    @hit_target=[info[:exclude]]
    
    @collidable=info[:collidable]
    @collide_count=info[:collide_count]
  end
  def mark_live_frame
    @trigger=true
  end
  def to_delete?
    return false
  end
  def collision
    @collide_count-=1
  end
  def crashed?
    return @collide_count<=0
  end
  def update
    @position.x+=@vector[0]
    @position.y+=@vector[1]
    @position.z+=@vector[2]
  end
  def affect(target)
    @go_forward=false
    @effect or return true
    
    @hit_target.include?(target) and return false
    
    if @effect.respond_to?(:each)
      @effect.each{|effect| effect.affect(target,@position)}
    else
      @effect.affect(target,@position)
    end
    @go_forward=true
  end
  def draw
    @ani and
    if @surface==:horizon
      @@DrawProc[:hoz].call(@ani,@position,@shape)
    else
      @@DrawProc[@type].call(@ani,@position,@shape)
    end
  end
end
class<<Bullet
  alias create new
  def new(effect,ani,shape,info)
    case info[:live_cycle]
    when :once
      return NormalBullet.new(effect,ani,shape,info)
    when :time
      return TimerBullet.new(effect,ani,shape,info)
    when :count
      return CounterBullet.new(effect,ani,shape,info)
    when :frame
      return FlashBullet.new(effect,ani,shape,info)
    when :time_only
      return TimerOnlyBullet.new(effect,ani,shape,info)
    else
      return NormalBullet.new(effect,ani,shape,info)
    end
  end
end
require_relative 'Bullet/NormalBullet'
require_relative 'Bullet/TimerBullet'
require_relative 'Bullet/CounterBullet'
require_relative 'Bullet/FlashBullet'
require_relative 'Bullet/TimerOnlyBullet'