#coding : utf-8
class Attack
  @@FontSize=30
  @@buffer=[]
  attr_accessor :attrib
  def initialize(caster,info)  
    @info=info
    @caster=caster
    
    @attrib=info[:attrib]||Hash.new(0)
  end
  def affect(target,position,scale=1)    
    before(target)
    damage=attack(target)	
    if damage==:miss      
      show_damage("MISS",target)
      return true
    end
    
    damage=(damage*scale).to_i
    if damage!=0
      vamp_damage=target.lose_hp(damage)
      vamp(vamp_damage)
	
      show_damage(damage,target)
    end
    append(target,position)
    
    return true
  end
  def before(target)
    if @caster.has_skill?(:dogear)
      @caster.skill[:dogear].cast(@caster,target,nil,nil,nil)
    end
    
    before=@info[:before]
    before and
    if before.respond_to? :each
      before.each{|name|
        skill=@caster.skill[name] and
        skill.cast(@caster,target,nil,nil,nil)
      }
    else
      skill=@caster.skill[before] and
      skill.cast(@caster,target,nil,nil,nil)
    end
  end
  def pre_attack_defense(target,attack)
    skill_list=@info[:pre_attack_defense] and
    if skill_list.respond_to? :each
      skill_list.each{|name|
        skill=target.skill[name] and
        attack=skill.cast_defense(target,@caster,attack)
      }
    else
      skill=target.skill[skill_list] and
      attack=skill.cast_defense(target,@caster,attack)
    end
    return attack
  end
  def attack_defense(target,damage)
    skill_list=@info[:attack_defense] and
    if skill_list.respond_to? :each
      skill_list.each{|name|
        skill=target.skill[name] and
        skill.switch and
        damage=skill.cast_defense(target,@caster,damage)
      }
    else
      skill=target.skill[skill_list] and 
      skill.switch and
      damage=skill.cast_defense(target,@caster,damage)
    end
    return damage
  end
  def show_damage(damage,target)
    @info[:visible]!=false or return
    damage=damage.to_s
    direct=rand(5)-2
    color=Color[:"attack_#{@info[:type]}"]
    @@buffer<<ParaString.new(damage,target,direct,color,@@FontSize)
  end
  def attack(target)
    @info[:attack]==0 and return 0
    
    ignore=target.attrib[:ignore]
    if rand(100)<ignore
      skill=target.skill[:ignore] and
      skill.cast(target,target,nil,nil,nil)
      return :miss
    end
    
    attack=@info[:attack]    
    attack+=attack*@attrib[:attack_adj]
    attack+=attack*@attrib[:attack_amp]/100
    attack+=attack*@caster.attrib[:attack_amp]/100
        
    case @info[:type]
    when :phy
      case @info[:cast_type]
      when :attack
        dodge=target.attrib[:dodge]*100
        if rand(10000)<dodge
          skill=target.skill[:dodge] and
          skill.cast_defense(target,@caster,attack)
          return :miss
        end
        
        attack=pre_attack_defense(target,attack)
        damage=Attack.formula(attack,target.attrib[:def])
        damage=attack_defense(target,damage)
        
        block=target.attrib[:block]*100	
        if rand(10000)<block
          skill=target.skill[:block] and
          skill.cast_defense(target,@caster,damage)
          damage=(@caster.skill[:catear])? damage*40/100 : 1
        end
        damage=critical(damage)
        damage=bash(target,damage)
      when :skill        
        damage=Attack.formula(attack,target.attrib[:def])
      else        
        damage=Attack.formula(attack,target.attrib[:def])
      end
    when :mag
      if target.has_state?(:magic_immunity)
        return :miss
      end
      attack+=attack*@caster.attrib[:magic_amp]/100
      damage=Attack.formula(attack,target.attrib[:mdef])
    when :umag
      attack+=attack*@caster.attrib[:magic_amp]/100
      damage=Attack.formula(attack,target.attrib[:mdef])
    when :acid
      damage=attack
    end	
    return damage.confine(1,damage)
  end
  def critical(damage)
    if !@caster.attrib[:critical].empty?
      @caster.attrib[:critical].each{|data|
        possibility,amped=data
        rand(100)<possibility or next
        damage+=(damage*(amped-1)).to_i
      }
    end
    return damage
  end
  def bash(target,damage)    
    if !@caster.attrib[:bash].empty?
      @caster.attrib[:bash].each{|data|
        possibility,time,add_damage=data
        rand(100)<possibility or next
        damage+=add_damage
        Effect.new(@caster,
          name:'暈眩',sym: :stun,effect_type: :stun,
          icon:'./rc/icon/icon/tklre04/skill_064.png',
          attrib:{},
          last: time.to_sec).affect(target,@caster.position)
        break
      }
    end
    return damage
  end
  def vamp(damage)
    if @info[:cast_type]
      vamp_hp=0
      
      case @info[:cast_type]
      when :attack
        vamp_hp=(damage*@caster.attrib[:atk_vamp]).to_i
      when :skill
        vamp_hp=(damage*@caster.attrib[:skl_vamp]).to_i
      end
      if vamp_hp>0
        Heal.new(@caster,hp: vamp_hp).affect(@caster,@caster.position)
      end
    end 
  end
  def append(target,position)
    append=@info[:append]
    append and
    if append.respond_to? :each
      append.each{|skill|
        if skill.respond_to? :cast
          skill.cast(@caster,target,position.x,position.y,position.z)
        else
          skill=@caster.skill[skill] and
          skill.cast(@caster,target,position.x,position.y,position.z)
        end
      }
    elsif append.respond_to? :cast
      append.cast(@caster,target,position.x,position.y,position.z)
    else
      skill=@caster.skill[append] and
      skill.cast(@caster,target,position.x,position.y,position.z)
    end
  end
  class<<self  
    def draw(dst)
      @@buffer.reject!{|dmg|
        dmg.draw(dst)
      }
    end
    def formula(attack,defense)
      defense=defense.confine(0,defense)
      return (attack**2/(attack+defense)).to_i
    end
    alias create new
    def new(caster,info)    
      case info[:dmg_type]      
      when :const
        return ConstAttack.new(caster,info)
      when :max,:cur,:lose
        return PercentAttack.new(caster,info)
      when :const_max,:const_cur,:const_lose
        return ConstMixAttack.new(caster,info)
      else
        return ConstAttack.new(caster,info)
      end
    end
  end
end