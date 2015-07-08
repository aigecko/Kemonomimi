#coding: utf-8
class Enemy < Actor
  def initialize(name,race,klass,pos,attrib,pics)
    super("enemy %s %s"%[race,klass],pos,attrib,pics)
    @ai=AI.new({move: :none,action: :agreesive})
    @name=name
  end
  def update
    super
    @ai.call(self)
  end
  def die
    super
    Game.player.gain_exp(@attrib[:exp])
    Game.window(:GameWindow).add_hint("%s遭到擊敗，獲得#FF0000|%d#FFFFFF|經驗值"% [@name,@attrib[:exp]])
  end
end