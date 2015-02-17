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
" if (#{type}=@info[:#{type}])
    case @info[:type]
    when :percent
      #{type}&&=(target.attrib[:max#{type}]*#{type}).to_i
    when :lost
      #{type}_lost=target.attrib[:max#{type}]-target.attrib[:#{type}]
      #{type}&&=(#{type}_lost*#{type}).to_i
    when :coef
      @info[:#{type}sym] and #{type}+=(target.attrib[@info[:#{type}sym]]*@info[:#{type}coef]).to_i
    end
    target.gain_#{type}(#{type})
    color=Color[:heal_#{type}_font]
    @@buffer<<ParaString.new(\"%+d\"%#{type},target,color,@@FontSize)
  end\n"    
  }
  str+="end"
  eval str
  
  def self.draw
    @@buffer.reject!{|heal| heal.draw}
  end
end