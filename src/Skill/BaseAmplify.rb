#coding: utf-8
class Skill::Base::Amplify < Skill::Base
  def self.call(info)
    caster=info[:caster]
    if caster.has_state?(info[:data][:sym])
      if caster.var[:amplify_attrib]!=info[:args]
        caster.var[:amplify_attrib]=info[:args]
      else
        return
      end
    end
    attrib=info[:args]
    caster.add_state(caster,
      name: info[:data][:name],
      sym: info[:data][:sym],
      magicimu_keep: true,
      attrib: attrib,
      last: nil
    )
  end
end