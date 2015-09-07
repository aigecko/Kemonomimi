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
    before(target,position)
    damage=attack(target)
    if damage==:miss
      show_damage("MISS",target)
      return true
    end
    
    if damage!=0
      damage=(damage*scale).to_i
      damage==0 and damage=1
      real_damage=damage
      vamp_damage=0
      if @info[:type]!=:acid
        if target.attrib[:atk_shield]>=damage
          target.attrib[:atk_shield]-=damage
          real_damage=0
          vamp_damage+=damage
        else
          real_damage-=target.attrib[:atk_shield]
          vamp_damage+=target.attrib[:atk_shield]
          target.attrib[:atk_shield]=0
        end
      end
      if @info[:type]==:mag||@info[:type]==:umag
        if target.attrib[:mag_shield]>=real_damage
          target.attrib[:mag_shield]-=real_damage
          real_damage=0
          vamp_damage+=damage
        else
          real_damage-=target.attrib[:mag_shield]
          vamp_damage+=target.attrib[:mag_shield]
          target.attrib[:mag_shield]=0
        end
      end
      vamp_damage+=target.lose_hp(real_damage)
      vamp(vamp_damage)
      
      show_damage(damage,target)
    end
    if @info[:cast_type]==:attack
      append(target,position)
    else
      skill_append(target,position)
    end
    return true
  end
private
  def before(target,position)
    if @caster.has_skill?(:dogear)
      @caster.skill[:dogear].cast(
        @caster,target,position.x,position.y,position.z)
    end
    
    before=@info[:before]
    before and
    if before.respond_to? :each
      before.each{|name|
        skill=@caster.skill[name] and
        skill.cast(@caster,target,position.x,position.y,position.z)
      }
    else
      skill=@caster.skill[before] and
      skill.cast(@caster,target,position.x,position.y,position.z)
    end
  end
  def pre_attack_defense(target,attack)
    target.skill.each_pre_attack_defense{|skill|
      attack=skill.cast_defense(target,@caster,attack)||attack
    }
    return attack
  end
  def pre_skill_defense(target,attack)
    target.skill.each_pre_skill_defense{|skill|
      attack=skill.cast_defense(target,@caster,attack)||attack
      attack==:miss and return :miss
    }
    return attack
  end
  def attack_defense(target,damage)
    target.skill.each_attack_defense{|skill|
      damage=skill.cast_defense(target,@caster,damage)||damage
    }
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
        attack-=target.attrib[:phy_decatk]
        attack<=0 and attack=1
        
        attack+=calculate_phy_output(attack)
        
        damage=Attack.formula(attack,target.attrib[:def])
        
        block=target.attrib[:block]*100
        if rand(10000)<block
          skill=target.skill[:block] and
          skill.cast_defense(target,@caster,damage)
        end
        damage=attack_defense(target,damage)
        
        damage=critical(damage)
        damage=bash(target,damage)
        
        damage-=calculate_phy_resist(target,damage)
      else
        attack=assign_skill_defense(target,attack)
        attack==:miss and return :miss
        
        attack-=target.attrib[:phy_decatk]
        attack<=0 and attack=1
        attack+=calculate_phy_output(attack)
        
        damage=Attack.formula(attack,target.attrib[:def])
        damage=attack_defense(target,damage)
        
        damage-=calculate_phy_resist(target,damage)
      end
    when :mag
      target.has_state?(:magic_immunity) and return :miss
      attack=assign_skill_defense(target,attack)
      attack==:miss and return :miss
      
      damage=calculate_mag_damage(target,attack)
    when :umag
      attack=assign_skill_defense(target,attack)
      attack==:miss and return :miss
      
      damage=calculate_mag_damage(target,attack)
    when :acid
      attack=assign_skill_defense(target,attack)
      attack==:miss and return :miss
      
      damage=attack
    end
    damage-=damage*target.attrib[:atk_resist]/100
    return damage.confine(1,damage)
  end
  def assign_skill_defense(target,attack)
    @info[:assign] and return pre_skill_defense(target,attack)
    return attack
  end
  def calculate_phy_output(attack)
    return attack*@caster.attrib[:phy_outamp]/100
  end
  def calculate_phy_resist(target,damage)
    return damage*target.attrib[:phy_resist]/100
  end
  def calculate_mag_damage(target,attack)
    attack-=target.attrib[:mag_decatk]
    attack<=0 and attack=1
    
    attack+=attack*@caster.attrib[:mag_outamp]/100
    
    damage=Attack.formula(attack,target.attrib[:mdef])
    damage=attack_defense(target,damage)
    
    damage-=damage*target.attrib[:mag_resist]/100
    return damage
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
    if append=@info[:append]
      if append.respond_to? :each
        append.each{|skill|
          skill.respond_to?(:cast) or 
          skill=@caster.skill[skill] and
          skill.cast(@caster,target,position.x,position.y,position.z)
        }
      else
        append.respond_to?(:cast) or 
        skill=@caster.skill[append] and
        skill.cast(@caster,target,position.x,position.y,position.z)
      end
    else
      @caster.skill.each_append{|skill|
        skill.cast(@caster,target,position.x,position.y,position.z)
      }
    end
  end
  def skill_append(target,position)
    append=@info[:append] and
    if append.respond_to? :each
      append.each{|skill|
        skill.respond_to?(:cast) or 
        skill=@caster.skill[skill] and
        skill.cast(@caster,target,position.x,position.y,position.z)
      }
    else
      append.respond_to?(:cast) or 
      skill=@caster.skill[append] and
      skill.cast(@caster,target,position.x,position.y,position.z)
    end
  end
public
  def self.draw
    @@buffer.reject!{|dmg| dmg.draw}
  end
  def marshal_dump
    return [{
      :i=>@info,
      :a=>@attrib,
      :c=>Map.find_actor(@caster)
    }]
  end
  def marshal_load(array)
    data=array[0]
    @info=data[:i]
    @attrib=data[:a]
    @caster=Map.load_actor(data[:c])
  end
  require_relative 'Attack/Singleton' #must at last line
  require_relative 'Attack/FixAttack'
end