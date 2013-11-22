#coding : utf-8
class Attack
  @@FontSize=30
  @@buffer=[]
  def initialize(caster,info)  
    @info=info
    @caster=caster
  end
  def affect(target)
    before(target) 
   
    damage=attack(target)
	
    color=Color[:"attack_#{@info[:type]}"]
	if damage==:miss
	  @@buffer<<ParaString.new("MISS",target,0,color,@@FontSize)
	  return true
	end
    target.lose_hp(damage)
    vamp(damage)
	
    show_damage(damage,target)
    
    append(target)
    
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
  def show_damage(damage,target)
    damage=damage.to_s
	case @info[:type]
	when :phy
	  direct=-2
	when :mag	  
	  direct=-1
	when :umag	
	  direct=1  
	when :acid	  
	  direct=2
	end
	color=Color[:"attack_#{@info[:type]}"]
    @@buffer<<ParaString.new(damage,target,direct,color,@@FontSize)
  end
  def attack(target)
    attack=@info[:attack]
	attack+=attack*@caster.attrib[:attack_amp]/100
    case @info[:type]
    when :phy
	  dodge=target.attrib[:dodge]*100
	  if rand(10000)<dodge
	    return :miss
	  end	   
      damage=Attack.formula(attack,target.attrib[:def])
	  
	  block=target.attrib[:block]*100	
	  if rand(10000)<dodge
	    if @caster.skill[:catear]
		  damage=damage*40/100
		else
	      damage=1
		end
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
  def vamp(damage)
    if @info[:cast_type]
      vamp_hp=0
      
      case @info[:cast_type]
      when :attack
        vamp_hp=damage*@caster.attrib[:atk_vamp]/100
      when :skill
        vamp_hp=damage*@caster.attrib[:skl_vamp]/100
      end      
      if vamp_hp>0
        @caster.gain_hp(vamp_hp)      
        vamp_hp="%+d"%vamp_hp
        color=Color[:"vamp_#{@info[cast_type]}"]
        @@buffer<<ParaString.new(vamp_hp,@caster,color,@@FontSize)
      end
    end 
  end
  def append(target)
    append=@info[:append]
    append and
    if append.respond_to? :each
      append.each{|name|
        skill=@caster.skill[name] and
        skill.cast(@caster,target,nil,nil,nil)
      }
    else
      skill=@caster.skill[append] and
      skill.cast(@caster,target,nil,nil,nil)
    end
  end
  class<<self  
    def draw(dst)
      @@buffer.reject!{|dmg|
        dmg.draw(dst)
      }
    end
    def formula(attack,defense)
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