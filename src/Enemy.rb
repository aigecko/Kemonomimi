#coding: utf-8
class Enemy < Actor
  def initialize(race,klass,pos,attrib,pics)
    super("enemy #{race} #{klass}",
          pos,attrib,pics)

  end
end