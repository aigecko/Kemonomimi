#coding: utf-8
class Consumable < Item
  def initialize(name,pic,attrib,price,comment,args={})
    super(name,pic,price,comment,args)
    
    pic="./rc/icon/"+pic
    attrib[:icon]=pic
    
    @skill=Skill.new(attrib)
  end
  def use(caster,target,x,y,z)
    @skill.cast(caster,target,x,y,z)
  end
end