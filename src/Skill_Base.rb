#coding: utf-8
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
        attack=info[:args][0]+info[:caster].attrib[:ratk]
	    Map.add_friend_bullet(
          info[:caster].ally,
     	  Bullet.new(Attack.new(info[:caster],
                                type: :phy,
                                cast_type: :attack,
                                attack: attack,
                                append: [:fire_arrow,:enegy_arrow]),
		             (pic=Surface.load_with_colorkey('./rc/pic/battle/arrow.png')),
					 :box,
                     caster: info[:caster],
					 x: info[:caster].position.x,
					 y: info[:caster].position.y+info[:caster].pic_h/4,
					 z: info[:caster].position.z,
					 w: pic.w,
					 h: pic.w/4,
					 t: pic.h,
					 vx: info[:caster].face_side==:right ? 20 : -20)
	    )
	  }
      @proc[:fire_arrow]=->(info){
        attack=info[:args]
        Attack.new(info[:caster],type: :mag,attack: attack).affect(info[:target])
      }
      @proc[:enegy_arrow]=->(info){
        const,percent= *info[:args]
        attack=const+info[:caster].attrib[:sp]*percent/100
        Attack.new(info[:caster],type: :umag,attack: attack).affect(info[:target])
      }
      @proc[:magic_immunity]=->(info){
        caster=info[:caster]
        attrib=info[:args][0]
        last=info[:args][1]
        caster.add_state(caster,
                         name:'魔法免疫',sym: :magic_immunity,
                         icon:'./rc/icon/icon/tklre04/skill_053.png',
                         attrib: attrib,
                         last: last)
      }
      @proc[:smash_wave]=->(info){
        caster=info[:caster]

        attack=info[:args][0]        
        probability=info[:args][1]
        
        rand(100)<probability and
        Map.add_friend_bullet(
          caster.ally,
          Bullet.new(Attack.new(caster,type: :mag,cast_type: :skill,attack: attack),
                     nil,
                     :col,
                     caster: info[:caster],
                     x: caster.position.x,
                     y: caster.position.y,
                     z: caster.position.z,
                     r: 75,h: 50,
                     live_cycle: :frame)
        
        )
      }
      @proc[:normal_attack]=->(info){
        caster=info[:caster]
        attack=caster.attrib[:atk]
        Attack.new(caster,
                   type: :phy,
                   cast_type: :attack,
                   attack: attack,
                   append: [:smash_wave,:enegy_arrow]).affect(info[:target])
      }      
      @proc[:fire_circle]=->(info){        
        const=info[:args][0]
        percent=info[:args][1]
        if SDL.get_ticks>info[:caster].var[:fire_circle_triger]
          info[:caster].var[:fire_circle_triger]=SDL.get_ticks+1.to_sec
        else
          return
        end
        
        Map.add_friend_circle(
          info[:caster].ally,
          Bullet.new([Attack.new(info[:caster],type: :mag,dmg_type: :const_cur,attack: [const,percent]),
                      Effect.new(info[:caster],
                                name:'燃燒',sym: :burn,effect_type: :slow,
                                icon:'./rc/icon/skill/2011-12-23_3-049.gif',
                                attrib:{wlkspd: -0.8},
                                last: 5.to_sec)],
                     (pic=Surface.load_with_colorkey('./rc/pic/battle/fire_circle.png')),
                     :col,
                     caster: info[:caster],
                     x: info[:caster].position.x,
                     y: 0,
                     z: info[:caster].position.z,
                     r: 60,
                     h: 50,
                     live_cycle: :frame)
        )
      }
      @proc[:wolfear]=->(info){
        caster=info[:caster]
        attrib=caster.attrib
		
        healhp=(attrib[:maxhp]-attrib[:hp])*0.01
        healsp=healhp*attrib[:maxsp]/attrib[:maxhp]
		  
		caster.add_state(@caster,
		  name:'狼耳之血',sym: :wolfear,
		  icon:'./rc/icon/skill/2011-12-23_3-079.gif',
		  attrib: {healhp: healhp,healsp: healsp},
		  last: nil)
      }
      @proc[:dogear]=->(info){
	    maxhp,hp=info[:target].attrib[:maxhp],info[:target].attrib[:hp]
		percent=hp*100/maxhp
		
		if percent<10
		  attack_amp=50
	    elsif percent<20
		  attack_amp=40
		elsif percent<40
		  attack_amp=20
		elsif percent<60
		  attack_amp=10
		else
		  attack_amp=0
		end
		#0.1*0.5+0.1*0.4+0.2*0.2+0.2*0.1
		# 0.10*0.6+0.05*0.5+0.1*0.4+0.15*0.3+0.2*0.15
		#10%:1.6 15%:1.5 25%:1.4 40%:1.3 60%:1.15
	    info[:caster].attrib[:attack_amp]=attack_amp
	  }
	  @proc[:ice_wave]=->(info){      
        caster=info[:caster]
        attack=info[:caster].attrib[:int]*4/5
        Map.add_friend_bullet(
          caster.ally,
          Bullet.new(Attack.new(caster,type: :acid,attack: attack),
                     nil,
                     :col,
                     caster: caster,
                     x: caster.position.x,
                     y: caster.position.y,
                     z: caster.position.z,
                     r: 70,h: 50,
                     live_cycle: :frame)
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
  def self.init
    Base.init   
    
    @@types=[:active,:auto,:attrib,:state,:switch,:attach]
  end
end
