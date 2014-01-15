#coding: utf-8
%w{Actor_Attrib Actor_ActorAni Actor_Equip 
   Actor_State Actor_AI
   ActorSingleton}.each{|actor_lib|
  require_relative actor_lib
}
class Actor
  attr_reader :position,:attrib,:ally,:race,:class
  attr_reader :equip_list,:item_list,:equip,:skill,:target
  #dbg
  attr_accessor :shape  
  attr_accessor :var
  def initialize(comment,pos,attrib,pics)
    str=comment.split
    
    @ally=str[0].to_sym
    @race=str[1].to_sym
    @class=str[2].to_sym
	
    @face=:right
    @position=Position.new(pos[0],pos[1],pos[2])
      
    @attrib=Attrib.new(attrib,@race,@class)
    
    @animation=ActorAni.new(pics,(@ally==:player)? :player : :actor)
    
    @state=State.new(self)
    @equip=Equip.new
    @equip_list=FixedArray.new(100)
    @item_list=FixedArray.new(100){[nil,0]}
    
    @attrib[:hp]=@attrib[:maxhp]
    @attrib[:sp]=@attrib[:maxsp]

    @skill={}

    @skill_list={}
    Skill.all_type_list.each{|type|
      @skill_list[type]=[]
    }
    
    #dbg
    gain_equip ([[:head,1],[:head,10],[:head,20],
      [:left,1],[:dual,1],[:dual,1],[:right,1],[:single,1],
      [:body,1],[:body,10],[:body,20],[:range,1],[:range,10],
      [:finger,1],[:finger,2],[:feet,1],[:feet,10],[:deco,5]])
    
    @shape=Shape.new(:col,					 
      r: @animation.w/2,
      h: @animation.h)
    race_initialize
    class_initialize
    skill_initialize
    
    @var=Hash.new(0)
  end
  def race_initialize
    case @race
    when :catear
      add_state(@player,
	    name:'貓耳之血',sym: :catear,
        attrib:{wlkspd: 20},
        magicimu_keep: true,
        last: nil)	
      add_skill(:catear,
        name:'貓耳基里的祝福',type: :none,
        icon:'./rc/icon/icon/mat_tklre002/skill_029.png:[0,0]',
        comment:'敵人格檔時可以產生4成傷害')
    when :dogear
      add_skill(:dogear,
        name:'尾刀狗',type: :before,cd: 0,
        icon:'./rc/icon/icon/mat_tklre002/skill_028.png:[0,0]',
        base: :dogear,consum: 0,level: 1,table:[0,0],
        comment:'敵人的生命比例越低對其傷害越高')
    when :foxear
      add_skill(:foxear,
        name:'狐耳基里的祝福',type: :none,		
        icon:'./rc/icon/skill/2011-12-23_3-078.gif',
        comment:'最大SP及消耗多1成 魔法輸出多2成')
      add_state(@player,
        name:'狐耳之血',sym: :foxear,
        attrib:{maxsp: 0.1,magic_amp: 20,consum_amp: 10},
        magicimu_keep: true,
        last: nil)      
    when :wolfear
      add_skill(:wolfear,
        name:'狼耳基里的祝福',type: :auto,cd: 0.5,
        icon:'./rc/icon/skill/2011-12-23_3-079.gif',
        base: :wolfear,consum: 0,level: 1,table:[0,0],
        comment:'生命越少回復的生命和法力會越多')
    end
  end
  def class_initialize
    class_data=Database.get_class(@class)
    attack_cd=class_data[:attack_cd]
    arrow_cd=class_data[:arrow_cd]
	
    add_skill(:normal_attack,
      name:'普通攻擊',type: :attack,cd: attack_cd,
      icon:'./rc/icon/skill/2011-12-23_3-034.gif',
      base: :normal_attack,consum: 0,level: 1,table:[0,0],
      common_cd: :arrow,
      comment:'對點擊的敵人攻擊 追著目標窮追猛打')
	  
    #(@class==:archer||@class==:crossbowman)and
    add_skill(:arrow,
      name:'弓箭射擊',type: :shoot,cd: arrow_cd,
      icon:'./rc/icon/skill/2011-12-23_3-047.gif',
      base: :arrow,level: 1,table:[0,[0,:ratk,1]],
      common_cd: :normal_attack,
      comment:'快速射出一隻箭 威力和ratk成正相關')
  end  
  def skill_initialize
	(@class==:paladin||@class==:darkknight)and
    add_skill(:smash_wave,
      name:'粉碎波',type: :append,
      icon:'./rc/icon/skill/2011-12-23_3-037.gif',
      base: :smash_wave,consum: 0,level: 1,table:[0,[100,20]],
      comment:'攻擊時產生範圍魔法傷害')
    @class==:fighter and
    add_skill(:fire_circle,
      name:'熾焰焚身',type: :switch_auto,cd: 1,
      icon:'./rc/icon/skill/2011-12-23_3-072.gif',
      base: :fire_circle,consum: 1,level: 1,table:[0,[50,0]],
      comment:'焚燒周圍的敵人 造成傷害')
    @class==:cleric and
    add_skill(:enegy_arrow,
      name:'碎石杖擊',type: :switch_append,
      icon:'./rc/icon/skill/2011-12-23_3-125.gif',
      base: :enegy_arrow,consum: 0,level: 1,table:[0,[40,10]],
      comment:'普攻附加無視魔免魔法傷害')
    (@class==:fighter||@class==:paladin||@class==:darkknight) and
    add_skill(:magic_immunity,
      name:'魔法免疫',type: :active,cd: 15,
      icon:'./rc/icon/icon/tklre04/skill_053.png',
      base: :magic_immunity,consum: 30,level: 1,table:[0,[{atk: 20,con: 10},3.to_sec]],
      comment:'數秒內不受大部分魔法及狀態影響')
  end
  def rotate(side)
    @animation.rotate(side)
  end
  def face_side
    @animation.side
  end
  def pic_w
    @animation.w
  end
  def pic_h
    @animation.h
  end
  def under_cursor?(offset_x)
    @animation.under_cursor?(offset_x)
  end
  def get_equip_list
    @equip_list
  end
  def set_target(target,action=nil)
    @target=target
    @action=action
  end
  def set_move_dst(x,y,z)
    x||=@position.x
    y||=@position.y
    z||=@position.z
    
    z=z.confine(0,400)
    distance=Math.distance(@position.x,@position.z,x,z)
    if distance>0
      @dst_x=x
      @dst_z=z
      delta_x=x-@position.x
      delta_z=z-@position.z
      @wlkstep=@attrib[:wlkstep]
      @vx_scalar=(delta_x)/distance
      @vz_scalar=(delta_z)/distance
      @vector_x=@wlkstep*@vx_scalar
      @vector_z=@wlkstep*@vz_scalar
      
      @face= (@vector_x>0)? :right : :left
      @animation.rotate(@face)
      
      @act_affect=true
    end
  end
  def move2dst
    @act_affect or return
    if @wlkstep!=@attrib[:wlkstep]
      @wlkstep=@attrib[:wlkstep]
      @vector_x=@attrib[:wlkstep]*@vx_scalar
      @vector_z=@attrib[:wlkstep]*@vz_scalar
    end
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
  def reach_target?
    case @action
    when :attack
      return (@position.x-@target.position.x).abs<=(pic_w+@target.pic_w)/2&&
             (@position.z-@target.position.z).abs<=20
    when :pickup
      return Math.distance(@position.x,@position.z,
                           @target.position.x,@target.position.z)<=50                           
    end
  end
  def interact_target    
    @target and reach_target? and
    case @action
    when :attack
      if !@target.died?
        @position.x>@target.position.x ? rotate(:left) : rotate(:right)
        @skill[:normal_attack].cast_attack(self,@target,@attrib[:atkspd])
      end
    when :pickup      
      @target.pickup
      gain_item(@target)
      Map.render_onground_item.delete(@target)
      set_target(nil)
    end
  end
  def chase_target
    @target and not reach_target? and
    case @action
    when :attack
      if @target.position.x>@position.x
        rotate(:right)		
        dst_x=@target.position.x-(@target.pic_w+pic_w)/2+1
      else
        rotate(:left)
        dst_x=@target.position.x+(@target.pic_w+pic_w)/2-1
      end      
      dst_x=dst_x.confine(0,Map.w)
      dst_z=@target.position.z
      set_move_dst(dst_x,0,dst_z)
    when :pickup      
      item_x=@target.position.x
      item_z=@target.position.z
      dis=Math.distance(item_x,item_z,
                        @position.x,@position.z)
      delta_x=item_x-@position.x
      delta_z=item_z-@position.z
      dst_x=@position.x+delta_x*(dis-50)/dis
      dst_z=@position.z+delta_z*(dis-50)/dis
      set_move_dst(dst_x,nil,dst_z)
    end
  end
  def moving?
    @act_affect ? true : false
  end
  def update
    @state.update
    recover
    
    @skill_list[:auto].each{|skill|
      skill.cast_auto(self)
    }
    @skill_list[:switch_auto].each{|skill|
      skill.switch and skill.cast_auto(self)
    }
    
    unless has_state?(:stun)
      chase_target
      move2dst
      interact_target
    end
  end
  def wear_equip(index)
    part=@equip_list[index].part
    equip=@equip_list[index]
    @equip_list.delete_at(index)
        
    #unless @equip[part]
    #  @equip.wear(self,part,equip)
    #else
    takeon_equip(part,equip)
  end
  def takeon_equip(part,equip)
    #old_equip=@equip[part]      
    
    #if old_equip
    #  if old_equip.skill
    #    del_skill(old_equip.sym,old_equip.skill)
    #  end
    #  @attrib.lose_equip_attrib(old_equip.attrib)
    #end
    @equip.wear(self,part,equip)
	  @attrib.gain_equip_attrib(equip.attrib)
    if equip.skill
      add_skill(equip.sym,equip.skill)
    end
  end
  def takeoff_equip(part)
    @equip_list<<@equip[part]
    @attrib.lose_equip_attrib(@equip[part].attrib)
    if @equip[part].skill
      del_skill(@equip[part].sym,@equip[part].skill)
    end
    @equip[part]=nil
  end
  def has_state?(name)
    @state.include?(name)
  end
  def add_state(caster,info)
    if info[:sym]==:magic_immunity
      @state.keep_if{|state| state.keep_when_magicimmunity?}
    end
    @state.add(Statement.new(caster,info))
  end
  def has_skill?(name)
    @skill[name]
  end
  def add_skill(skill,info)
    if skill.respond_to? :zip
      skill.zip(info){|skl,inf|
        @skill[skl]=Skill.new(inf)
        @skill_list[inf[:type]]<<@skill[skl]
      }
    else
      @skill[skill]=Skill.new(info)
      @skill_list[info[:type]]<<@skill[skill]
    end
  end
  def del_skill(skill,info)
    if skill.respond_to? :zip
      skill.zip(info){|skl,inf|
        @skill_list[inf[:type]].delete(@skill[skl])
        @skill.delete(skl)
      }
    else
      @skill_list[info[:type]].delete(@skill[skill])
      @skill.delete(skill)
    end
  end
  def gain_equip(equips)
    equips.each{|equip|
	    part,index=equip
      @equip_list<<Database.get_equip(part,index)
	  }
  end
  def gain_consum(index)
    @item_list<<Database.get_consum(index)
  end
  def gain_item(item)
    @item_list<<item
  end
  def gain_hp(hp)
    @attrib[:hp]+=hp
    @attrib[:hp]=[@attrib[:hp],@attrib[:maxhp]].min
  end
  def gain_sp(sp)
    @attrib[:sp]+=sp
    @attrib[:sp]=[@attrib[:sp],@attrib[:maxsp]].min
  end
  def gain_exp(exp)
    @attrib.gain_exp(exp)
  end
  def recover
    @accum_hp||=0
    @accum_sp||=0
    
    if @attrib[:hp]<@attrib[:maxhp]        
      @accum_hp+=@attrib[:hlhpstep]
      hp=@accum_hp.to_i
      gain_hp(hp)
      @accum_hp-=hp
    end
    if @attrib[:sp]<@attrib[:maxsp]
      @accum_sp+=@attrib[:hlspstep]      
      sp=@accum_sp.to_i
      gain_sp(sp)      
      @accum_sp-=sp
    end
  end
  def lose_hp(hp)
    if @attrib[:hp]-hp>0
      @attrib[:hp]-=hp
    else
      hp=@attrib[:hp]
      @attrib[:hp]=0
      die
    end    
    return hp
  end
  def die
    @die=true
  end
  def died?;return @die;end
  def lose_sp(sp)
    if @attrib[:sp]-sp>0
      @attrib[:sp]-=sp
    else
      @attrib[:sp]=0
    end
  end
  def can_cast?(end_time,consum)
    has_state?(:stun) and return false
    SDL.get_ticks>end_time or return false
    @attrib[:sp]>=consum ? true : false
  end
  def can_cast_auto?(end_time,consum)
    SDL.get_ticks>end_time or return false
    @attrib[:sp]>=consum ? true : false
  end
  def cast(name,target,x,y,z)
    unless @skill[name]
      #Message.show_format("使用不存在的技能#{name}",'錯誤',:ASTERISK)
      return
    end
    if (skill=@skill[name]).type==:attack||
       skill.type==:shoot
      skill.cast_attack(self,target,@attrib[:atkspd])
    else      
      skill.cast(self,target,x,y,z)
    end
  end
  def gain_attrib(attrib)
    @attrib.gain_base_attrib(attrib)
  end
  def lose_attrib(attrib)
    @attrib.lose_base_attrib(attrib)
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
    draw_hpbar(dst)
  end
end