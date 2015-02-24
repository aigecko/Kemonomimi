#coding: utf-8
class Enemy < Actor
  def initialize(race,klass,pos,attrib,pics)
    super("enemy #{race} #{klass}",pos,attrib,pics)
    @ai=AI.new({move: :cycle,action: :peaceful})
  end
  def update
    super
    @ai.call(self)
  end
  def die
    super
    Game.player.gain_exp(@attrib[:exp])
  end
end