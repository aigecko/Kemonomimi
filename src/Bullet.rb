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
  attr_reader :shape,:position
  @@draw_proc={
    box: ->(ani,position,shape,dst){
      ani.draw(position.x-shape[:w]/2,431-position.y-position.z/2-ani.h,dst)
    },
    col: ->(ani,position,shape,dst){
      ani.draw(position.x-shape[:r],431-position.y-position.z/2-ani.h,dst)
    }
  }
  def initialize(effect,ani,shape,info)
    @type=shape
    @shape=Shape.new(shape,info)
    @effect=effect
    @ani=ani
    
    @position=Position.new(info[:x],info[:y],info[:z])
	@vector=[info[:vx]||0,info[:vy]||0,info[:vz]||0]	
  end
  def update
    @position.x+=@vector[0]
	@position.y+=@vector[1]
	@position.z+=@vector[2]
  end
  def draw(dst)
    @@draw_proc[@type].call(@ani,@position,@shape,dst)
  end
end