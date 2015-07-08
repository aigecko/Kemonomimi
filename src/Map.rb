#coding: utf-8
class Map
  require_relative 'Map_Chipset'
  attr_reader :w,:h
  @@current_map=nil
  def initialize
    @w=1000
    @h=400
    Actor.set_map_size(@w,@h)
    
    @chip_w=40
    @chip_h=20
    @chips=Array.new(@h/@chip_h/2){Array.new(@w/@chip_w){rand(2)}}
    @map_pic=Surface.new(Surface.flag,@w,@h/2,Screen.format)
    for column in 0..@chips.size-1
      for row in 0..@w/@chip_w-1
        Chipset[@chips[column][row]].draw(row*@chip_w,column*@chip_h,@map_pic)
      end
    end
    @map_pic=BigTexture.new(@map_pic)
    
    @sky_pic=Rectangle.new(0,0,Game.Width,Game.Height-@map_pic.h-50,Color[:clear])
    #dbg
    @items=#[]
    # Array.new(500){
      # Item.new('鑽石','item/2011-12-23_1-228.gif:[0,0]-[50,50,50]+[50,0,80]B[255,255,255]',100,'1|lI',
        # {onground:true,x:rand(1000),z:rand(400)})
    # }+
    
    # Array.new(100){|n|
      # item=Database.get_item(19.1).drop
      # item.position.x=rand(2000)
      # item.position.z=rand(400)
      # item
    # }    # @items+=Array.new(7){|n|
      # item=Database.get_consum(20+n).drop
      # item.position.x=100+rand(100)
      # item.position.z=rand(400)
      # item
    # }
    # @items+=
    Array.new(10){
      equip=Database.get_equip(:deco,17).drop
      equip.position.x=rand(100)
      equip.position.z=rand(400)
      equip
    }
    
    @friend=[]
    @enemy=[]
    
    @friend_bullet=[]
    @enemy_bullet=[]

    @friend_circle=[]
    @enemy_circle=[]
    
    @cemetery=[]
    
    @@current_map=self
    
    enemy=Enemy.new("始萊姆","slime","none",[500,0,200],{exp: 100},"mon_001")
    @enemy<<enemy
  end
  def bind_player
    @friend=[Game.player]
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
  def find_under_cursor_item(offset_x)
    under_cursor=@items.select{|item|
      item.under_cursor?(offset_x)
    }
    result=under_cursor.min_by{|item| item.position.z}
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
  def render_onground_item
    return @items
  end
  def render_shadow
    return @items
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
    ((ally==:enemy)? @friend_bullet : @enemy_bullet)<<bullet
  end
  def add_enemy_circle(ally,circle)
    ((ally==:enemy)? @friend_circle : @enemy_circle)<<circle
  end
  def find_actor(actor)
    if idx=@enemy.find_index(actor)
      return [:e,idx]
    elsif idx=@friend.find_index(actor)
      return [:f,idx]
    elsif Game.player==actor
      return :p
    else
      return nil
    end
  end
  def load_actor(data)
    if data==:p
      return Game.player
    elsif data[0]==:e
      begin
        actor=@enemy[data[1]] and return actor
      rescue
        Message.show(:actor_index_wrong)
        exit
      end
    elsif data[0]==:f
      begin
        actor=@friend[data[1]] and return actor
      rescue
        Message.show(:actor_index_wrong)
        exit
      end
    elsif data==nil
      return nil
    end
    Message.show(:actor_unknown_type)
    exit
  end
  def find_bullet(bullet)
  end
  def delete_live_frame
    @friend_bullet.reject!{|bullet| bullet.to_delete? and @cemetery<<[bullet]}
    @friend_circle.reject!{|circle| circle.to_delete? and @cemetery<<[circle]}
    @enemy_bullet.reject!{|bullet| bullet.to_delete? and @cemetery<<[bullet]}
    @enemy_circle.reject!{|circle| circle.to_delete? and @cemetery<<[circle]}
  end
  def mark_live_frame
    @friend_bullet.each{|bullet| bullet.mark_live_frame}
    @friend_circle.each{|circle| circle.mark_live_frame}
    @enemy_bullet.each{|bullet| bullet.mark_live_frame}
    @enemy_circle.each{|circle| circle.mark_live_frame} 
  end
  def update
    delete_live_frame
    [@friend_bullet,@friend_circle].each{|bullet_list|
      @enemy.reject!{|actor|
        bullet_list.reject!{|bullet|
          result=Shape.collision?(actor,bullet)&&
          bullet.affect(actor)||
          !bullet.position.x.between?(0,@w)
          result and @cemetery<<[bullet]
        }
        actor.died?
      }
    }
    [@enemy_bullet,@enemy_circle].each{|bullet_list|
      @friend.reject!{|actor|
        bullet_list.reject!{|bullet|
          result=Shape.collision?(actor,bullet)&&
          bullet.affect(actor)||
          !bullet.position.x.between?(0,@w)
          result and @cemetery<<[bullet]
        }
        actor.died?
      }
    }
    mark_live_frame
    update_actor
    update_bullet
  end
  def update_actor
    true and
    if rand(1000)>990
      enemy=Enemy.new("始萊姆","slime","none",[500,0,200],{exp:1000},"mon_001")
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
  def draw
    player_x=Game.player.position.x
    side=which_side(player_x)
    case side
    when :left then x=0
    when :mid then x=player_x-Game.Width/2
    when :right then x=@w-Game.Width
    end
    y=230
    
    @sky_pic.draw_at(x,0,401)
    @map_pic.draw_part(x,y,401,x,0,Game.Width,@map_pic.h)
    
    @items.each{|item| item.draw_shadow}
    @friend_circle.each{|circle| circle.draw}
    
    @friend.each{|friend| friend.draw}
    @enemy.each{|enemy| enemy.draw}
    
    @friend_bullet.each{|bullet| bullet.draw}
    @enemy_bullet.each{|bullet| bullet.draw}
    
    @items.each{|item| item.draw}
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