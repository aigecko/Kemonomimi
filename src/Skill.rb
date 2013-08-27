class Skill
  class Base
    def self.init
      @proc={}
      @proc[:flash]=->(info){
        limit=info[:args]
        caster=info[:caster]
        x,z=caster.position.x,caster.position.z
        dis=Math.distance(x,z,info[:x],info[:z])
        if dis>limit          
          delta_x=(info[:x]-x)*limit/dis
          delta_z=(info[:z]-z)*limit/dis
          
          dst_x=x+delta_x
          dst_z=z+delta_z
          caster.set_move_dst(info[:x],0,info[:z])
          caster.position.x=dst_x
          caster.position.z=dst_z
        else
          caster.set_move_dst(info[:x],0,info[:z])
          caster.position.x=info[:x]
          caster.position.z=info[:z]
        end
      }
	  @proc[:arrow]=->(info){
	    Map.current_map.add_friend_bullet(
     	  Bullet.new(nil,
		             (pic=Database.get_actor_pic('mon_056')[:right]),
					 :box,
					 x: info[:caster].position.x,
					 y: info[:caster].position.y,
					 z: info[:caster].position.z,
					 w: pic.w,
					 h: pic.w/4,
					 t: pic.h,
					 vx: 20)
	    )
		
	  
	  }
    end
    def self.[](skill)
      @proc[skill]
    end    
    def formula(attack,defense)
      attack*attack/(attack+defense)
    end
  end
  class Ani
    def self.init      
    end
    def draw
    end
  end
  def self.init
    Ani.init
    Base.init
  end
end
class Skill
  @@types=[:active,:auto,:attrib,:state,:switch]
  def initialize(caster,info)
    @name=info[:name]
    begin
      if info[:icon]
        @icon=SDL::Surface.load(info[:icon])
      else
        @icon=SDL::Surface.new(Screen.flag,24,24,Screen.format)
      end
    rescue
      Message.show(:skill_pic_load_failure)
      exit
    end
    
    @proc=Base[info[:base]]  
    @type=info[:type]
    
    @consum=info[:consum]
    @caster=caster
    
    @level=info[:level]
    @table=info[:table]
    
    @comment=info[:comment]
  end
  def cast(target,x,y,z)
    @caster.can_cast?(@consum) or return
    @caster.lose_sp(@consum)
  
    @proc.call(caster:@caster,target:target,x:x,y:y,z:z,args:@table[@level])
  end  
  def draw_icon(x,y)
    @icon.draw(x,y)
  end
  def draw_name(x,y)
    Font.draw_solid(@name,15,x,y,255,255,0)
  end
  def draw_comment(x,y)
    Font.draw_solid(@comment,15,x,y,0,255,0)
  end
end