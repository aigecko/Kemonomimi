#coding: utf-8
class Bullet
  require_relative 'HorizonBullet'
  require_relative 'BulletSingleton'
  attr_reader :shape,:position,:caster
  def initialize(effect,ani,shape,info)
    @type=shape
    @shape=Shape.new(shape,info)
    
    @effect=effect
        
    @caster=info[:caster]
    @position=Position.new(info[:x],info[:y],info[:z])
    
    @ani=ani
    @vector=[info[:vx]||0,info[:vy]||0,info[:vz]||0]
    if @vector[0]<0
      @ani=@ani.reverse
    end
    ani_initialize
    
    @live_cycle=info[:live_cycle]
    @live_count=info[:live_count]
    
    @hit_target=[info[:exclude]]
  end
  def ani_initialize
    @ani and @ani=@ani.to_texture
  end
  def mark_live_frame
    @trigger=true
  end
  def to_delete?
    case @live_cycle
    when :frame
      @trigger and return true
      @trigger=true
      return false
    when :time,:time_only
      @live_count-=1
      return @live_count<0
    else
      return false
    end 
  end  
  def update
    @position.x+=@vector[0]
    @position.y+=@vector[1]
    @position.z+=@vector[2]
  end
  def affect(target)
    @effect or return true
    
    @hit_target.include?(target) and return false
    
    if @effect.respond_to?(:each)
      @effect.each{|effect| effect.affect(target,@position)}
    else
      @effect.affect(target,@position)
    end

    case @live_cycle
    when :once,:time
      return true
    when :count
      @hit_target<<target
      @live_count-=1
      return @live_count<0
    when :frame,:time_only
      @hit_target<<target
      return false
    else
      return true
    end
  end
  def draw
    @ani and
    @@draw_proc[@type].call(@ani,@position,@shape)
  end
end