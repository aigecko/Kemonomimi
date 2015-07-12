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
    @map_pic=MapTexture.new(@map_pic)
    
    @sky_pic=Rectangle.new(0,0,Game.Width,Game.Height-@map_pic.h-50,Color[:clear])
    #dbg
    @items=[]
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
    # Array.new(1000){
      # money=Money.new(100_000_000*(rand(5)+1)).drop
      # money.position.x=rand(2000)
      # money.position.z=rand(400)
      # money
    # }
    # @items+=
    # Array.new(10){
      # equip=Database.get_equip(:deco,17).drop
      # equip.position.x=rand(100)
      # equip.position.z=rand(400)
      # equip
    # }
    
    @friend=[]
    @enemy=[]
    
    @friend_bullet=[]
    @friend_collidable_bullet=[]
    @enemy_bullet=[]
    @enemy_collidable_bullet=[]

    @friend_circle=[]
    @enemy_circle=[]
    
    @cemetery=[]
    
    @@current_map=self
    
    enemy=Enemy.new("始萊姆","slime","none",[500,0,200],{exp: 1000},"mon_001")
    enemy.add_drop_list([[0.5,:Material,20],[0.5,:Material,21]])
    @enemy<<enemy
  end
  def bind_player
    @friend=[Game.player]
  end
  def which_side(player_x)
    if player_x<Game.HalfWidth
      return :left
    elsif player_x>@w-Game.HalfWidth
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
      bullet.collidable and @enemy_collidable_bullet<<bullet
    else
      @friend_bullet<<bullet
      bullet.collidable and @friend_collidable_bullet<<bullet
    end
  end
  def add_enemy_bullet(ally,bullet)
    if ally==:enemy
      @friend_bullet<<bullet
      bullet.collidable and @friend_collidable_bullet<<bullet
    else
      @enemy_bullet<<bullet
      bullet.collidable and @enemy_collidable_bullet<<bullet
    end
  end
  def add_enemy_circle(ally,circle)
    if ally==:enemy
      @friend_circle<<circle
    else
      @enemy_circle<<circle
    end
  end
  def add_onground_item(item)
    @items<<item
  end
  def pickup_onground_items
    player_x=Game.player.position.x
    player_z=Game.player.position.z
    @items.reject!{|item|
      item_x=item.position.x
      item_z=item.position.z
      if Math.distance(item_x,item_z,player_x,player_z)<70
        Game.player.action.pickup_item(item,false)
        true
      else
        false
      end
    }
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
    update_collidable_bullet
    update_friend_bullet_circle
    update_enemy_bullet_circle
    mark_live_frame
    update_actor
    update_bullet
  end
  def update_collidable_bullet
    @friend_collidable_bullet.reject!{|bullet|
      !bullet.position.x.between?(0,@w)&&
      @friend_bullet.delete(bullet)
    }
    @enemy_collidable_bullet.reject!{|bullet|
      !bullet.position.x.between?(0,@w)&&
      @enemy_bullet.delete(bullet)
    }
    @friend_collidable_bullet.reject!{|f_bullet|
      @enemy_collidable_bullet.reject!{|e_bullet|
        f_bullet.crashed? and break
        Shape.collision?(f_bullet,e_bullet)&&
        e_bullet.collision&&
        f_bullet.collision&&
        e_bullet.crashed?&&
        @enemy_bullet.delete(e_bullet)
      }
      f_bullet.crashed?&&
      @friend_bullet.delete(f_bullet)
    }
  end
  def update_friend_bullet_circle
    @friend_bullet.reject!{|bullet|
      !bullet.position.x.between?(0,@w)
    }
    @friend_circle.reject!{|circle|
      !circle.position.x.between?(0,@w)
    }
    [@friend_bullet,@friend_circle].each{|bullet_list|
      @enemy.reject!{|actor|
        bullet_list.reject!{|bullet|
          result=Shape.collision?(actor,bullet)&&
          bullet.affect(actor)&&
          @friend_collidable_bullet.delete(bullet)
          result and @cemetery<<[bullet]
        }
        actor.died?
      }
    }
  end
  def update_enemy_bullet_circle
    @enemy_bullet.reject!{|bullet|
      !bullet.position.x.between?(0,@w)
    }
    @enemy_circle.reject!{|circle|
      !circle.position.x.between?(0,@w)
    }
    [@enemy_bullet,@enemy_circle].each{|bullet_list|
      @friend.reject!{|actor|
        bullet_list.reject!{|bullet|
          result=Shape.collision?(actor,bullet)&&
          bullet.affect(actor)&&
          @enemy_collidable_bullet.delete(bullet)
          result and @cemetery<<[bullet]
        }
        actor.died?
      }
    }
  end
  def update_actor
    true and
    if rand(1000)>990
      enemy=Enemy.new("始萊姆","slime","none",[500,0,200],{exp:1000},"mon_001")
      enemy.add_drop_list([[0.5,:Material,20],[0.5,:Material,21],[1.0,:Money,rand(200)]])
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
    when :mid then x=player_x-Game.HalfWidth
    when :right then x=@w-Game.Width
    end
    y=230
    
    @sky_pic.draw_at(x,0,401)
    @map_pic.draw_part(x,y,x,0,Game.Width,@map_pic.h)
    
    Gl.glDisable(Gl::GL_DEPTH_TEST)
    @items.each{|item| item.draw_shadow}
    @friend_circle.each{|circle| circle.draw}
    Gl.glEnable(Gl::GL_DEPTH_TEST)
    
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