#coding: utf-8
class Friend < Actor
  attr_accessor :var
  def initialize(race,klass,pos,attrib,pics)
    super("friend #{race} #{klass}",
          pos,attrib,pics)
    @var={}
    #@ai=AI.render(:sidemove)
    @ai=AI.render(:cycle)
    
  end  
  def update
    super
    @ai.call(self)
  end
end