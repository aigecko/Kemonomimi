#coding: utf-8
class Player < Actor
  def initialize
    #@player=Player.new('friend catear crossbowman',[125,125,125],
     #                  {str:100,con:100,int:100,wis:100,agi:100},
     #                  "mon_001.bmp")
    comment="player 
             #{Game.window(:RaceWindow).get_race}
             #{Game.window(:ClassWindow).get_class}"
    pos=[50,0,200]
    attrib={}
    pics="mon_083"
    
    super(comment,pos,attrib,pics)
  end
  def inspect
    return "#<Player: 0x%X>"%self.object_id
  end
  def gain_exp(exp)
    @attrib.gain_exp(exp)
  end
end