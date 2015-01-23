#coding: utf-8
$t=Time.now
std_lib=%w(sdl yaml singleton pathname)
std_lib.each{|lib|
  require "#{lib}"
}
begin
  require "win32api"
rescue LoadError
  require_relative "src/linux/Win32api"
  require_relative "src/linux/Surface_Blend"
else  
  require_relative "src/win32/Win32api"
  require_relative "src/win32/Surface_Blend"
end
my_lib=%w(Color Screen Config Message Icon
          Font Input Extension Skill Mouse)
my_lib.each{|lib|
  require_relative "src/#{lib}"
}
class Game
  def self.init
    @Width=640
    @Height=480
    Conf.init
    Conf.load
    self.sdl_initialize
    self.sdl_putenv
    
    Color.init
    Skill.init 
    Icon.init
    
    self.check_multi_window
    
    Mouse.init 
    Screen.init
    
    self.font_initialize
    self.load_lib
    Event.init
    Screen.flip
    self.win_initialize
    puts "start #{Time.now-$t}"
  end
  private
  def self.sdl_putenv
    SDL.putenv("SDL_VIDEODRIVER=directx")
    SDL.putenv("SDL_VIDEO_CENTERED=#{Conf['SDL_VIDEO_CENTERED']}")
  end
  def self.sdl_initialize
    retried=false
    begin
      SDL.init(SDL::INIT_VIDEO | SDL::INIT_AUDIO)
    rescue SDL::Error => message
      unless retried
        Message.show(:initialize_failure)
        Conf.fix
        Message.show(:config_data_rewrite)
        _sdl_putenv
        retried=true
        retry
      else
        Message.show(:several_failure)
        Message.show(:please_restart_game)
        exit
      end
    end
  end
  def self.font_initialize
    SDL::TTF.init
    Font.init
  end
  def self.win_initialize
    windows=%w(RaceWindow ClassWindow LoadWindow
               MenuWindow GameWindow SettingWindow
               LevelWindow BarsWindow ButtonWindow)
    @window=Hash.new
    windows.each{|window|
      eval("@window[:#{window}]=#{window}.new")
    }
    @window[:MenuWindow].open
  end
  def self.check_multi_window
    if WIN32API.FindWindow('遊戲視窗')>0||WIN32API.FindWindow('初始化中...')>0
      Message.show(:game_already_run)
      exit
    end
  end
  def self.screen_initialize
    Screen.init
  end
  def self.load_lib
    t=Thread.new{
      text=Font.render_solid('Loading',30,*Color[:loading_font])
      dot=Font.render_solid('.',30,*Color[:loading_font])
      num=0
      loop{
        Screen.fill_rect(0,0,@Width,@Height,0)
        text.draw(230,240)
        num=(num<3) ? num+1 : 0
        for i in 0..num
          dot.draw(370+i*30,240)
        end
        Screen.flip
        SDL.delay(80)
      }
    }
    
    require 'openssl'
    require 'digest'
    require 'zlib'
    require 'stringio'
    
    library_list=%w(
      Database Position 
      Item Equipment Consumable ItemArray
      Event Key HotKey
      Actor Player Enemy Friend
      Statement SkillTree
      ColorString ParaString DynamicString
      Shape Bullet
      Attack FixAttack Effect Heal)
    library_list.each{|lib|
      require_relative "src/#{lib}"
    }
    Actor.init
    Equipment.init
    HotKey.init
    window_list=%w(BaseWindow SelectWindow DragWindow
                   MenuWindow 
                   RaceWindow ClassWindow LoadWindow GameWindow
                   SettingWindow LevelWindow BarsWindow
                   ButtonWindow StatusWindow ItemWindow
                   EquipWindow SkillWindow)
    window_list.each{|window|
      require_relative "src/#{window}"
    }
    
    require_relative 'src/Map'
    Thread.kill(t)
    Screen.set_caption("遊戲視窗")
    Mouse.set_cursor(:select)
  end

  def self.update
    Event.poll
    @window.each_value{|window|
      if window.enable
	    window.interact
        if window.alone
          break
        end
      end
    }
    if Event[:Quit]
      Game.quit
    end
  end
  def self.draw
    @window.each_value{|window| window.visible and window.draw}
    Screen.flip
  end
  def self.draw_back
    Screen.fill_rect(0,0,@Width,@Height,0)
  end
  public
  def self.set_window(name,state)
    if state==:open
      @window[name].open
    else
      @window[name].close
    end
  end
  def self.window(idx)
    return @window[idx]
  end
  def self.Width
    return @Width
  end
  def self.Height
    return @Height
  end
  def self.player
    return @window[:GameWindow].get_player
  end
  def self.release
    Font.release
  end
  def self.quit
    Screen.destroy
    SDL.quit
    exit
  end
  def self.show
    loop{
      time=SDL.get_ticks

      update
      draw

      delta_time=SDL.get_ticks-time
      #p delta_time
      delta_time<40 and SDL.delay(40-delta_time)
    }
  end
  def self.get_real_path
    realpath=Pathname.new(__FILE__).realpath.to_s
    until realpath[-1]=="/"
      realpath.chop!
    end
    realpath
  end
end
Game.init
Game.show
