#coding: utf-8
class Skill::Base
  def self.call(info)
    raise "SkillBaseNotImplementError"
  end
  ['Boost','Amplify','NormalAttack',
   'Omamori','Flash','Recover','Aura','MagicImmunity',
   'Wolfear','Dogear',
   'Arrow','Missile','Explode',
   'BoostCircle','CounterBeam','Contribute','SmashWave',
   'CounterAttack','AttackIncrease','FireBurst','Burn','FireCircle','BreakArmor',
   'DualWeaponAtkspdAcc','RightLeftWeapon','SingleWeapon'
   ].each{|postfix|
    require_relative "Skill/Base#{postfix}.rb"
  }
  def self.init
    @proc={}

    @proc[:fire_arrow]=->(info){
      attack=info[:args]
      Attack.new(info[:caster],type: :mag,attack: attack).affect(info[:target],info[:target].position)
    }
    @proc[:enegy_arrow]=->(info){
      const,percent= *info[:args]
      attack=const+info[:caster].attrib[:sp]*percent/100
      Attack.new(info[:caster],type: :umag,attack: attack).affect(info[:target],info[:target].position)
    }

    @proc[:snow_shield]=->(info){
      reduce_percent=info[:args][0]
      convert_coeff=info[:args][1]
      caster=info[:caster]

      damage=info[:attack]-info[:attack]*reduce_percent/100
      consum=damage/convert_coeff.to_i

      if consum>caster.attrib[:sp]
        consum=caster.attrib[:sp]
        damage=info[:attack]-consum*convert_coeff
      end
      info[:caster].lose_sp(consum)
      return damage
    }
    @proc[:freezing_rain]=->(info){
      percent=info[:args][0]+info[:caster].attrib[:int]*info[:data][:coef]
      percent/=-100.0
      info[:target].add_state(info[:caster],
        name:'凍雨凝結',sym: :freezing_rain,
        icon: info[:data][:icon],
        attrib: {atk: percent,matk: percent},
        magicimu_keep: true,
        last: info[:args][1].to_sec
      )
      return info[:attack]
    }
    @proc[:ice_body]=->(info){
      info[:caster].add_state(info[:caster],
        name:'寒冰之軀',sym: :ice_body,
        icon: info[:data][:icon],
        attrib:{def: info[:args][0],mdef: info[:args][0],matk: info[:args][1]/100.0},#}
        magicimu_keep: true,
        last: info[:args][2].to_sec)
    }
    @proc[:water_smash]=->(info){
      attack=info[:args][0]+info[:args][1]*info[:caster].attrib[:int]
      Attack.new(info[:caster],type: :umag,attack: attack.to_i).affect(info[:target],info[:target].position)
    }
    @proc[:itegumo_erupt]=->(info){
      rand(100)<info[:args][0] or return
      slow=info[:args][1]/-100.0
      caster=info[:caster]
      Map.add_friend_bullet(
        caster.ally,
        Bullet.new([
           Attack.new(caster,type: :acid,attack: 0,append: :ice_wave),
           Effect.new(caster,
             name:'凍雲緩速',sym: :itegumo_slow,effect_type: :slow,
             icon:'./rc/icon/skill/2011-12-23_3-057.gif',
             attrib: {wlkspd: slow,atkspd: slow},
             magicimu_keep: true,
             last: info[:args][2].to_sec)],
          nil,
          :col,
          caster: caster,
          x: info[:x],y: 0,z: info[:z],
          r: 60,h: 1000,
          live_cycle: :frame)
      )
    }
    @proc[:ice_wave]=->(info){
      caster=info[:caster]
      attack=info[:args]
      info[:data][:coef].each{|sym,val|
        attack+=(caster.attrib[sym]*val).to_i
      }
      Map.add_friend_circle(
        caster.ally,
        Bullet.new(
          Attack.new(caster,type: :acid,attack: attack),
          Animation.new(:follow,
            {img:['./rc/pic/battle/ice_wave.png'],
              w: 120,h: 60,horizon: true,
              limit: 1
            },
            [[[:blit,0,24]]]),
          :col,
          caster: caster,
          x: info[:x],y: 0,z: info[:z],
          r: 60,h: 1000,
          live_cycle: :frame,
          surface: :horizon
        )
      )
    }

    @proc[:heal]=->(info){
      hp,sp=info[:args][:hp],info[:args][:sp]
      data=info[:data]||{}
      target=info[:target]
      Heal.new(info[:caster],
        type: data[:type],hp: hp,sp: sp,
        hpsym: data[:hpsym],hpcoef: data[:hpcoef],
        spsym: data[:spsym],spcoef: data[:spcoef]).affect(target,target.position)
    }
        
    @proc[:Mototada_R]=->(info){
      caster=info[:caster]
      data=info[:data]

      Map.add_friend_circle(
        caster.ally,
        Bullet.new(
          Attack.new(caster,
            type: :acid,
            cast_type: :skill,
            attack: info[:attack]*info[:args][0]/100),
          nil,
          :col,
          caster: caster,
          live_cycle: :frame,
          r: info[:args][1],
          h: info[:args][2],
          x: caster.position.x,
          y: caster.position.y,
          z: caster.position.z,
          surface: :horizon
        )
      )
      return info[:attack]
    }
  end
  def self.[](skill)
    skill or return
    @proc[skill] or Skill::Base.const_get(skill)
  end
end
