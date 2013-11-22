#coding: utf-8
class Effect
  @@FontSize=20
  @@buffer=[]
  def initialize(caster,info)
    @info=info
    @caster=caster
  end
  def affect(target)
    #魔免 有視   結果
    # t    t   f  f
    # t    f   t  t
    # t    nil f  f
    # f    t   f  t
    # f    f   t  t
    # f    nil f  t
    if target.has_state?(:magic_immunity)&&!(@info[:magimu_enable]==false)
      #@@buffer<<ParaString.new("魔免",target,[170,170,170],@@FontSize)      
      return true
    end
    
    target.add_state(@caster,@info)
    add_extra_effect(target)
    return true
  end
  def add_extra_effect(target)
    case @info[:effect_type]
    when :slow
      @@buffer<<ParaString.new("緩速",target,[70,70,70],@@FontSize)
    when :stun
      @@buffer<<ParaString.new("暈眩",target,[70,70,70],@@FontSize)
    end
  end
  def self.draw(dst)
    @@buffer.each{|pic|
      pic.draw(dst)
    }    
  end
end