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
    race_initialize
    
    gain_equip_from_database [[:head,1],[:head,2],[:head,3],[:head,4],[:head,5],[:head,6],[:head,7]]
    gain_equip_from_database [[:head,11],[:head,12],[:head,13],[:head,14],[:head,15],[:head,16],[:head,17]]
    gain_equip_from_database [[:head,21],[:head,22],[:head,23],[:head,24],[:head,25],[:head,26],[:head,27]]
    # gain_equip_from_database([[:dual,1],[:right,1],[:left,1]])
    # gain_equip_from_database([[:dual,1],[:range,1],[:single,1]])
    
    @attrib[:hp]=@attrib[:maxhp]
    @attrib[:sp]=@attrib[:maxsp]
    
  end
  def race_initialize
    case @race
    when :catear
      add_state(@player,
	    name:'貓耳之血',sym: :catear,
        attrib:{wlkspd: 20},
        magicimu_keep: true,
        last: nil)
    when :foxear
      add_state(@player,
        name:'狐耳之血',sym: :foxear,
        attrib:{maxsp: 0.1,mag_outamp: 20,consum_amp: 10},
        magicimu_keep: true,
        last: nil)
    end
    add_base_skill(@race,Database.get_skill(@race))
  end
  def inspect
    return "#<Player: 0x%X>"%self.object_id
  end
  def gain_exp(exp)
    @attrib.gain_exp(exp)
  end
end