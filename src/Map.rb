#coding: utf-8
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
	
    @friend_circle=[]
    @enemy_circle=[]
    
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
  def find_under_cursor_enemy(offset_x)
    under_cursor=@enemy.select{|enemy|
      enemy.under_cursor?(offset_x)
    }
    result=under_cursor.min_by{|enemy| enemy.position.z}
    return result
  end
  def render_friend(ally=:friend)
    if ally==:enemy
      return @enemy
    else
      return @friend
    end
  end  
  def render_enemy(ally=:friend)
    if ally==:enemy
      return @friend
    else
      return @enemy
    end
  end
  def render_friend_circle(ally=:friend)
    if ally==:enemy
      return @enemy_circle
    else
      return @friend_circle
    end
  end
  def render_friend_bullet(ally=:friend)
    if ally==:enemy
      return @enemy_circle
    else
      return @friend_bullet
    end
  end
  def render_enemy_bullet(ally=:friend)
    if ally==:enemy
      return @friend_bullet
    else    
      return @enemy_bullet
    end
  end
  def add_friend_circle(ally,circle)
    if ally==:enemy
      @enemy_circle<<circle
    else
      @friend_circle<<circle
    end
  end
  def add_friend_bullet(ally,bullet)
    if ally==:enemy
      @enemy_bullet<<bullet
    else
      @friend_bullet<<bullet
    end
  end
  def add_enemy_bullet(ally,bullet)
    if ally==:enemy
      @friend_bullet<<bullet
    else
      @enemy_bullet<<bullet
    end
  end
  def update
    @enemy.reject!{|actor|
      @friend_bullet.reject!{|bullet|	  
	    Shape.collision?(actor,bullet)&&
        bullet.affect(actor)||
        !bullet.position.x.between?(0,@w)
	  }
      actor.died?
	}
    @enemy.reject!{|actor|
      @friend_circle.reject!{|circle|
        Shape.collision?(actor,circle)&&
        circle.affect(actor)||
        !circle.position.x.between?(0,@w)
      }
      actor.died?
    }
    @friend_bullet.reject!{|bullet| bullet.live_frame?}
    @friend_circle.reject!{|circle| circle.live_frame?}
    update_actor
    update_bullet
  end
  def update_actor
    if rand(1000)>990
      enemy=Enemy.new("slime","fighter",
                         [200,0,200],
                         {exp:600,agi:1000,str:1000},
                         "mon_004r")
      #enemy.add_state(@player,name:'魔法免疫',sym: :magic_immunity,
      #                 icon:'./rc/icon/icon/tklre04/skill_053.png',
      #                 attrib:{},last: nil)
      @enemy<<enemy
    end
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
  meta=class<<Map
    def method_missing(method,*arg)
      Map.respond_to?(method) and return
      eval %Q{
        class ::Map
          def Map.#{method}(*arg)
            @@current_map.#{method}(*arg)
          end
        end}        
      Map.send(method,*arg)
    end
  end
end