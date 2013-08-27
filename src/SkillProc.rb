#coding: utf-8
class SkillProc
  def initialize
    @skill=Hash.new
    @skill[:attack]=->(player,enemy){
	  damage=formula(player[:atk],enemy[:def])
	  player.lose_hp(damage)
    }
    @skill[:heal]=->(target,hp,type){
	  case type
	  when :value
	    target.gain_hp(hp)
      when :precent
	    target.gain_hp((tatget[:hp]*hp)/100)
	  end
	}
	@skill[:mana]=->(target,sp,type){
	  case type
	  when :value
	    target.gain_sp(sp)
	  end
	}
    @skill[:bomb]=->(target,hp,type){
      case type
      when :value
	    target.lose_hp(hp)
      end
    }
  end
  def [](key)
    @skill[key]
  end
  def formula(attack,defense)
    constant=1
	damage=constant*(attack**2)/(attack+defense)
	return damage
  end

end