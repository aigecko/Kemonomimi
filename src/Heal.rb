#coding: utf-8
class Heal
  @@buffer=[]
  @@FontSize=20
  def initialize(caster,info)
    @info=info
    @caster=caster
  end
  
  str="def affect(target,position)\n"
  [:hp,:sp].each{|type| 
    str+=
"  if #{type}=@info[:#{type}]    
    target.gain_#{type}(#{type})
    #{type}=\"%+d\"%#{type}
    color=Color[:heal_#{type}_font]
    @@buffer<<ParaString.new(#{type},target,color,@@FontSize)
  end\n"    
  }
  str+="end"
  eval str
  
  def self.draw(dst)
    @@buffer.reject!{|heal|
      heal.draw(dst)
    }
  end
end