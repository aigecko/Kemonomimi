class Map
  class Chipset
    @@chipsets=Input.load_chipset_pic
    def self.[](idx)
      @@chipsets[idx]
    end
  end
end
class Map
  attr_reader :w,:h
  @@current_map=nil
  def initialize
    @w=1000
    @h=400
    Actor.set_map_size(@w,@h)
    
    @chip_w=40
    @chip_h=20
    @chips=Array.new(@h/@chip_h/2){Array.new(@w/@chip_w){rand(2)}}
    @map_pic=Surface.new(Surface.flag,@w,400,Screen.format)
    
    for column in 0..@chips.size-1
      for row in 0..@w/@chip_w-1
        Chipset[@chips[column][row]].draw(row*@chip_w,column*@chip_h,@map_pic)
      end
    end
    
    @friend=[]
    @enemy=[]
    
    @friend_bullet=[]
	@enemy_bullet=[]
	
	@@current_map=self
  end
  def which_side(player_x)
    if player_x<Game.Width/2
      return :left
    elsif player_x>@w-Game.Width/2
      return :right
    else
      return :mid
    end
  end
  def render_friend
    return @friend
  end  
  def render_enemy
    return @enemy
  end
  def render_friend_bullet
    return @friend_bullet
  end
  def render_enemy_bullet
    return @enemy_bullet
  end
  def add_friend_bullet(bullet)
    @friend_bullet<<bullet
  end
  def add_enemy_bullet(bullet)
    @enemy_bullet<<bullet
  end
  def update
    @enemy.each{|actor|
      @friend_bullet.reject!{|bullet|	  
	    Shape.collision?(actor,bullet)
	  }
	}
    update_actor
    update_bullet
  end
  def update_actor
    rand(1000)>950 and 
    @enemy<<Enemy.new("slime","fighter",
                       [rand(1000),0,rand(400)],
                       {},
                       'mon_001r')
    @friend.each{|friend|
      friend.update
    }    
    @enemy.each{|enemy|
      enemy.update
    }
  end
  def update_bullet
    @friend_bullet.each{|bullet|
	  bullet.update
	}
	@enemy_bullet.each{|bullet|
	  bullet.update
	}
  end
  def draw(dst)
    player_x=Game.player.position.x
    side=which_side(player_x)
    case side
    when :left
      x=0
    when :mid
      x=player_x-Game.Width/2
    when :right
      x=@w-Game.Width
    end
    y=230
    
    Surface.blit(@map_pic,x,0,Game.Width,@h/2,dst,x,y)
  end
  def self.current_map
    @@current_map
  end
end