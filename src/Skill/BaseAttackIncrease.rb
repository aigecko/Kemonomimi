#coding: utf-8
class Skill::Base::AttackIncrease
  def self.call(info)
    caster=info[:caster]
    target=info[:target]

    data=info[:data]

    if target==caster.var[:attack_increase_target]
      if caster.var[:attack_increase_count]<info[:args]
        caster.var[:attack_increase_count]+=1
      end
    else
      caster.del_state(data[:sym])
      caster.var[:attack_increase_target]=target
      caster.var[:attack_increase_count]=0
    end

    caster.add_state(caster,
      name: data[:name],sym: data[:sym],
      icon: nil,
      magicimu_keep: true,
      attrib: {atk: data[:atk]*caster.var[:attack_increase_count]},
      last: nil)
  end
end