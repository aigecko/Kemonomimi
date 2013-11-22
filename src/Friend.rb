#coding: utf-8
class Friend < Actor
  def initialize(race,klass,pos,attrib,pics)
    super("friend #{race} #{klass}",
          pos,attrib,pics)
    #@ai=AI.render(:sidemove)
    @ai=AI.render(:cycle)
    
  end  
  def update
    super
    @ai.call(self)
  end
end