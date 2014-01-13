#coding: utf-8
class Bullet
  class Position
    attr_accessor :x,:y,:z
    def initialize(x,y,z)
      @x,@y,@z=x,y,z
    end
  end
end
class Bullet
  attr_reader :shape,:position,:caster
  @@draw_proc={
    box: ->(ani,position,shape,dst){
      ani.draw(position.x-ani.w/2,431-position.y-position.z/2-ani.h,dst)
    },
    col: ->(ani,position,shape,dst){
      ani.draw(position.x-ani.w/2,431-position.y-position.z/2-ani.h/2,dst)
    }
  }
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
      @ani.set_color_key(SDL::SRCCOLORKEY,@ani[0,0])
    end
    
    @live_cycle=info[:live_cycle]
    @live_count=info[:live_count]
    
    @hit_target=[info[:exclude]]
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
    when :time    
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
      @effect.each{|effect| effect.affect(target)}
    else
      @effect.affect(target)    
    end
	
    case @live_cycle
    when :once,:time
      return true
    when :count
      @hit_target<<target
      @live_count-=1
      return @live_count<0 ? true : false 
    when :frame
      return false    
    else
      return true
    end
  end
  def draw(dst)
    @ani and
    @@draw_proc[@type].call(@ani,@position,@shape,dst)
  end
end