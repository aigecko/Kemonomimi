#coding: utf-8
class GameWindow < BaseWindow
  def initialize
    @map=Map.new
    @map_up_margin=@map.h+30
    
    @surface=Surface.new(Surface.flag,@map.w,Game.Height,Screen.format)
    @offset_x=0
    @offset_y=0
    
    @friend_windows=[:LevelWindow,:BarsWindow,:ButtonWindow]
       
    @windows={}       
    @drag_list=[:StatusWindow,:ItemWindow,:SkillWindow,:EquipWindow]
    @drag_list.each{|window|
      eval %Q{
        @windows[:#{window}]=#{window}.new
      }
    }
    @contral=true
    
    @actor_buffer=[]
  end
  def start_init
    player_init
    friend_window_init
    sub_window_init
  end
  def player_init
    @player=Player.new
  end
  def friend_window_init
    @friend_windows.each{|window|
      Game.window(window).start_init
      Game.set_window(window,:open)
    }
  end
  def friend_window_close
    @friend_windows.each{|window| Game.set_window(window,:close)}
  end
  def sub_window_init
    @windows.each_value{|window| window.start_init}
  end
  def close_contral
    Game.window(:ButtonWindow).enable=false
  end
  def open_contral
    Game.window(:ButtonWindow).enable=true
  end
  def sub_window_interact
    @drag_list.each{|name| 
      window=@windows[name]
      if window.enable
        window.interact
        return
      end
    }
  end
  def game_window_interact
    window_click=false
    Event.each{|event|
      case event
      when Event::KeyDown
        case event.sym
        when Key::RSHIFT,Key::LSHIFT
          close
          friend_window_close
          Game.set_window(:ClassWindow,:open)
        when Key::F
          #dbg
          convert_position or next
          @player.cast(:flash,nil,*convert_position)
        when Key::S
          #dbg
          @player.add_state(@player,name:'祝福',sym: :recover,
                            icon:'./rc/icon/food/2011-12-23_2-003.gif',
                            attrib:{def:1000,agi:1000,healhp:10,atkspd:200},#}
                            multi: true,
                            last:4999)#}
                         #照秒回 lag會有BUG
        when Key::D
          #dbg
          @player.add_state(@player,
          name:'燒毀',sym: :burn,
          icon:'./rc/icon/icon/tklre03/skill_041.png',
          attrib: {},
          effect: Attack.new(@player,type: :acid,attack: 25,visible: false),
          effect_amp: 0.04,
          last: 2000)
        when Key::A
          convert_position or next
          @player.cast(:arrow,nil,*convert_position,true)
        when Key::Q
          convert_position or next
          @player.cast(:fire_circle,nil,*convert_position)
        when Key::W
          convert_position or next
          @player.cast(:magic_immunity,nil,*convert_position)
        when Key::F1
          switch_window(:StatusWindow)
        when Key::F2
          switch_window(:ItemWindow)
        when Key::F3
          switch_window(:SkillWindow)
        when Key::F4
          switch_window(:EquipWindow)
        when Key::F5
          #svae
        when Key::F6
          #tool
        when Key::F12
          Game.release        
        when Key::ESCAPE
          Game.quit
        end
      when Event::MouseButtonDown
        window=false
	    @drag_list.each_with_index{|window,i|
          case @windows[window].detect_click_window(event)
          when :drag
		    case event.button
			when Mouse::BUTTON_LEFT
              set_first_window(window)
			  window_click=true
              close_contral
			  break
            when Mouse::BUTTON_RIGHT
			  window_click=true
			end
          when :click
			case event.button
			when Mouse::BUTTON_LEFT
              set_first_window(window)
			  window_click=true
			  break
            when Mouse::BUTTON_RIGHT
			  window_click=true
			end
          end
        }
		window_click or
		case event.button
	    when Mouse::BUTTON_RIGHT
          get_attack_target
        when Mouse::BUTTON_LEFT
          get_item_onground
		end
      when Event::Quit
        Game.quit
      end
    }
    
  end
  def interact
    sub_window_interact
    game_window_interact
    @player.update
    @map.update
    offset_change
    set_draw_actor
  end
  def get_player
    return @player
  end
  def get_attack_target
    if convert_position
      target=@map.find_under_cursor_enemy(@offset_x)
      if target        
        @player.set_target(target,:attack)
        @player.chase_target        
      else
        @player.set_move_dst(*convert_position)
        @player.set_target(nil)
      end
    end
  end
  def get_item_onground
    if convert_position
      item=@map.find_under_cursor_item(@offset_x)
      if item
        @player.set_target(item,:pickup)
        @player.chase_target
      else
        @player.set_move_dst(*convert_position)
        @player.set_target(nil)
      end
    end
  end
  def open
    super
    Mouse.set_cursor(:move)
  end
  def convert_position
    x,y,* =SDL::Mouse.state
    y<430 or return false
    dst_x=@offset_x+x
    dst_z=(@map_up_margin-y)*2
    dst_z<0 and dst_z=0
    dst_z>@map.h and dst_z=@map.h
    return [dst_x,0,dst_z]
  end
  def set_first_window(name)
    first=name
    @drag_list.delete_at(@drag_list.rindex(name))
    @drag_list.unshift(first)
  end
  def offset_change
    side=@map.which_side(@player.position.x)
    case side
    when :left
      @offset_x=0
    when :mid
      @offset_x=@player.position.x-Game.Width/2
    when :right
      @offset_x=@map.w-Game.Width
    end
  end
  def render_offset
    return [@offset_x,0]
  end
  def switch_window(name)
    if @windows[name].close?
      set_first_window(name)
      @windows[name].open
    else
      @windows[name].close
    end
  end
  def add_actor_buffer(actor)
    @actor_buffer<<actor
  end
  def draw_sub_window
    @drag_list.reverse.each{|name|
      window=@windows[name]
      window.visible and window.draw
    }
  end
  def set_draw_actor
    add_actor_buffer(@player)
	
    @map.render_friend.each{|actor|
      add_actor_buffer(actor)
    }
    @map.render_enemy.each{|actor|
      add_actor_buffer(actor)
    }
	
    @map.render_friend_bullet.each{|bullet|
      add_actor_buffer(bullet)
    }
	@map.render_enemy_bullet.each{|bullet|
	  add_actor_buffer(bullet)
	}
    
    @map.render_onground_item.each{|item|
      add_actor_buffer(item)
    }
  end
  def draw_circle
    @map.render_friend_circle.sort_by{|circle|
      -circle.position.z
    }.each{|circle|
      circle.draw(@surface)
    }
  end
  def draw_actor    
    @actor_buffer=@actor_buffer.sort_by{|actor| -actor.position.z}
    @actor_buffer.each{|actor| actor.draw(@surface)}
    @actor_buffer.clear
  end
  def draw
    @surface.fill_rect(@offset_x,0,Game.Width,230,Color[:clear])
    @surface.fill_rect(@offset_x,@map_up_margin,Game.Width,50,Color[:clear])
    @map.draw(@surface)
    draw_circle
    draw_actor
    Attack.draw(@surface)
    Heal.draw(@surface)
    Effect.draw(@surface)
    Surface.blit(@surface,@offset_x,@offset_y,Game.Width,Game.Height-50,
                 Screen.render,0,0)
    draw_sub_window
    @player.draw_state(200,400)
  end
end