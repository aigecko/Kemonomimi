#coding: utf-8
class Skill::Base
  ['Boost','Amplify','NormalAttack',
   'Omamori','Flash','Recover','Aura','MagicImmunity','EnergyArrow','Heal',
   'Wolfear','Dogear',
   'Arrow','Missile','Explode',
   'BoostCircle','CounterBeam','Contribute','SmashWave',
   'CounterAttack','AttackIncrease','FireBurst','Burn','FireCircle','BreakArmor',
   'SnowShield','FreezingRain','IceWave',
   'DualWeaponAtkspdAcc','RightLeftWeapon','SingleWeapon',
   'MototadaR'
   ].each{|postfix|
    require_relative "Skill/Base#{postfix}.rb"
  }
  def self.[](skill)
    skill or return
    Skill::Base.const_get(skill)
  end
end
