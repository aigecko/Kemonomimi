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
      @windows[window]=Object.const_get(window).new
    }
    @contral=true
    
    @actor_buffer=[]
    @shadow_buffer=[]
    #dbg
    HotKey.bind(Key::F1,:proc,:once,->{switch_window(:StatusWindow)})
    HotKey.bind(Key::F2,:proc,:once,->{switch_window(:ItemWindow)})
    HotKey.bind(Key::F3,:proc,:once,->{switch_window(:SkillWindow)})
    HotKey.bind(Key::F4,:proc,:once,->{switch_window(:EquipWindow)})
    HotKey.bind(Key::F5,:proc,:once,->{Game.save})
    HotKey.bind(Key::F6,:proc,:once,->{Game.load})
    HotKey.bind(Key::ESCAPE,:proc,:once,->{Game.quit})
    
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
          HotKey.all_off
          friend_window_close
          Game.set_window(:ClassWindow,:open)
        when Key::S
          #dbg
          @player.add_state(@player,name:'祝福',sym: :recover,
                            icon:'./rc/icon/food/2011-12-23_2-003.gif',
                            attrib:{def:1000,agi:1000,healhp:10,atkspd:200},#}
                            multi: :add,
                            last:4999)
        when Key::D
          #dbg
          @player.add_state(@player,
          name:'燒毀',sym: :burn,
          icon:'./rc/icon/icon/tklre03/skill_041.png',
          attrib: {},
          effect: Attack.new(@player,type: :acid,attack: 25,visible: false),
          effect_amp: 0.04,
          last: 2000)
        when Key::LCTRL
          HotKey.bind_mode=true
        else
          HotKey.turn_on(event.sym)
        end
      when Event::KeyUp
        case event.sym
        when Key::LCTRL
          HotKey.bind_mode=false
        else
          HotKey.turn_off(event.sym)
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
        window_click and next
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
    HotKey.update
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
  def close_all_subwindows
    @drag_list.each{|name| @windows[name].close}
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

    @actor_buffer+=@map.render_friend
    @actor_buffer+=@map.render_enemy
    
    @actor_buffer+=@map.render_friend_bullet
    @actor_buffer+=@map.render_enemy_bullet
    
    @actor_buffer+=@map.render_onground_item
    @shadow_buffer=@map.render_shadow
    
  end
  def draw_circle
    @shadow_buffer.sort_by!{|shadow|
      -shadow.position.z
    }.each{|shadow|
      shadow.draw_shadow(@surface)
    }
    @map.render_friend_circle.sort_by!{|circle|
      -circle.position.z
    }.each{|circle|
      circle.draw(@surface)
    }
  end
  def draw_actor
    @actor_buffer.sort_by!{|actor| -actor.position.z}
    @actor_buffer.each{|actor| actor.draw(@surface)}
    @actor_buffer.clear
  end
  def draw
    @surface.draw_rect(@offset_x,230,Game.Width,200,Color[:clear],true)
    @surface.draw_rect(@offset_x,0,Game.Width,230,Color[:clear],true)
    @map.draw(@surface)
    draw_circle
    draw_actor
    Attack.draw(@surface)
    Heal.draw(@surface)
    Effect.draw(@surface)
    SDL::Surface.blit(
      @surface,@offset_x,@offset_y,Game.Width,Game.Height-50,
      Screen.render,0,0)
    Screen.flip
    draw_sub_window
    @player.draw_state(200,400)
  end
end