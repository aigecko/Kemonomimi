#coding: utf-8
%w{Actor_Attrib Actor_Position
   Actor_ActorAni Actor_Equip 
   Actor_State Actor_AI
   ActorSingleton}.each{|actor_lib|
  require_relative actor_lib
}
class Actor
  attr_reader :position,:attrib,:ally,:race,:class
  attr_reader :equip_list,:item_list,:equip,:skill
  #dbg
  attr_accessor :act,:shape
  def initialize(comment,pos,attrib,pics)
    str=comment.split
    
    @ally=str[0].to_sym
    @race=str[1].to_sym
    @class=str[2].to_sym
	
    @face=:right
	@position=Position.new(pos[0],pos[1],pos[2])
    
	@attrib=Attrib.new(attrib,@race,@class)
	
	@animation=ActorAni.new(pics)
	
	@state=State.new
	@equip=Equip.new
	@equip_list=Array.new
	@item_list=Array.new
    #dbg
    gain_equip([:head,0])
    gain_equip([:hand,0])
    gain_equip([:back,0])
    gain_equip([:neck,0])
    gain_equip([:body,0])    
    gain_equip([:range,0])
    gain_equip([:finger,0])
    gain_equip([:feet,0])
    gain_equip([:deco,0])
    #dbg
    (0...@equip_list.size).each{|n|
       wear_equip(0)
    }
    #dbg
	@skill={}
    @skill[:flash]=Skill.new(self,name:'閃現',
						     icon:'./rc/icon/skill/2011-12-23_3-033.gif',
						     base: :flash,consum:10,level:1,table:[0,100],
                             comment:'瞬間移動到指定地點')
	@skill[:arrow]=Skill.new(self,name:'投射',
							 icon:'./rc/icon/skill/2011-12-23_3-040.gif',
							 base: :arrow,consum:1,level:1,table:[0,200],
							 comment:'投射出快速移動的蝸牛')
    #dbg
    @act=[]
    #dbg
	@shape=Shape.new(:box,					 
					 w: @animation.w,
					 h: @animation.w/2,
					 t: @animation.h)
  end
  def get_equip_list
    @equip_list
  end
  def set_move_dst(x,y,z)
    x||=@position.x
    y||=@position.y
    z||=@position.z
    
    z>400 and z=400
    z<0 and z=0
    distance=Math.distance(@position.x,@position.z,x,z)
    if distance>0
      @dst_x=x
      @dst_z=z
      step=@attrib[:wlkstep]
      delta_x=x-@position.x
      delta_z=z-@position.z
      @vector_x=step*(delta_x)/distance
      @vector_z=step*(delta_z)/distance
      
      @face= (@vector_x>0)? :right : :left
      @animation.rotate(@face)
      
      @act_affect=true
    end
  end
  def move2dst
    @act_affect or return
    next_x=@position.x+@vector_x
    next_z=@position.z+@vector_z
    if (next_x>@dst_x&&@vector_x>0)||
       (next_x<@dst_x&&@vector_x<0)||
       (next_z<@dst_z&&@vector_z<0)||
       (next_z>@dst_z&&@vector_z>0)
      @position.x=@dst_x
      @position.z=@dst_z
      @act_affect=false
    else
      @position.x=next_x
      @position.z=next_z
    end
  end
  def get_dst
    [@dst_x,@dst_y,@dst_z]
  end
  def add_act(act,judge)
    @act<<act
  end
  def moving?
    @act_affect ? true : false
  end
  def update
    @state.update
    recover
    move2dst
  end
  def wear_equip(index)
    part=@equip_list[index].part
    equip=@equip_list[index]
    @equip_list.delete_at(index)
    unless @equip[part]
      @equip[part]=equip
    else
      old_equip=@equip[part]
      @equip[part]=equip
	  @equip_list<<old_equip	
	  @attrib.lose_equip_attrib(old_equip.attrib)
    end
	@attrib.gain_equip_attrib(equip.attrib)
  end
  def takeoff_equip(part)
    @equip_list<<@equip[part]
    @attrib.lose_equip_attrib(@equip[part].attrib)
    @equip[part]=nil
  end
  def add_state(caster,info)
    @state.add(self,Statement.new(caster,info))
    #@attrib.gain_state_attrib(state.attrib)
  end
  def gain_equip(*equips)
    equips.each{|equip|
	  part=equip[0]
	  index=equip[1]
      @equip_list<<Database.get_equip(part,index)
	}
  end
  def gain_consum(index)
    @item_list<<Database.get_consum(index)
  end
  def gain_hp(hp)
    @attrib[:hp]+=hp
    @attrib[:hp]=[@attrib[:hp],@attrib[:maxhp]].min
  end
  def gain_sp(sp)
    @attrib[:sp]+=sp
    @attrib[:sp]=[@attrib[:sp],@attrib[:maxsp]].min
  end
  def recover
    @accum_hp||=0
    @accum_sp||=0
    @last_recover_time||=SDL.get_ticks
    
    if SDL.get_ticks>@last_recover_time+1000
      if @attrib[:hp]<@attrib[:maxhp]        
        @accum_hp+=@attrib[:healhp]
        hp=@accum_hp.to_i
        gain_hp(hp)
        @accum_hp-=hp
      end
      if @attrib[:sp]<@attrib[:maxsp]
        @accum_sp+=@attrib[:healsp]      
        sp=@accum_sp.to_i
        gain_sp(sp)      
        @accum_sp-=sp
      end
      @last_recover_time=SDL.get_ticks
    end
  end
  def lose_hp(hp)
    if @attrib[:hp]-hp>0
	  @attrib[:hp]-=hp
	else
	  @attrib[:hp]=0
	end
  end
  def lose_sp(sp)
    if @attrib[:sp]-sp>0
	  @attrib[:sp]-=sp
	else
	  @attrib[:sp]=0
	end
  end
  def can_cast?(consum)
    @attrib[:sp]>=consum ? true : false
  end
  def cast(name,target,x,y,z)
    @skill[name].cast(target,x,y,z)
  end
  def gain_attrib(hash)
    @attrib.gain_attrib(hash)
  end
  def lose_attrib(hash)
    @attrib.lose_attrib(hash)
  end
  def update_attrib
    @attrib.compute_base
    @attrib.compute_total
  end
  def draw_hpbar(dst)
    percent=@attrib[:hp]/@attrib[:maxhp].to_f
    @animation.draw_hpbar(@position,percent,dst)
  end
  def draw_state(x,y)
    @state.draw(x,y)
  end
  def draw(dst)
	@animation.draw(@position,dst)
  end
end