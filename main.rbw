#coding: utf-8
$t=Time.now
std_lib=%w(sdl gl glu yaml singleton pathname)
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
          Font Input Extension Skill Mouse
          Texture Drawable)
my_lib.each{|lib|
  require_relative "src/#{lib}"
}
class Game;end
class<<Game
  include Gl
  def init
    @Width=640
    @Height=480
    Conf.init
    Conf.load
    sdl_initialize
    gl_initialize
    sdl_putenv
    
    Color.init
    Skill.init 
    Icon.init
    
    check_multi_window
    
    Mouse.init 
    Screen.init
    
    font_initialize
    gl_parameters
    
    load_lib
    Event.init
    Screen.flip
    win_initialize
    
    puts "start #{Time.now-$t}"
  end
  private
  def sdl_putenv
    SDL.putenv("SDL_VIDEODRIVER=directx")
    SDL.putenv("SDL_VIDEO_CENTERED=#{Conf['SDL_VIDEO_CENTERED']}")
  end
  def sdl_initialize
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
  def gl_initialize
    SDL::GL.set_attr SDL::GL_RED_SIZE,8
    SDL::GL.set_attr SDL::GL_GREEN_SIZE,8
    SDL::GL.set_attr SDL::GL_BLUE_SIZE,8
    SDL::GL.set_attr SDL::GL_DEPTH_SIZE,24
    SDL::GL.set_attr SDL::GL_DOUBLEBUFFER,1
  end
  def font_initialize
    SDL::TTF.init
    Font.init
  end
  def win_initialize
    windows=%w(RaceWindow ClassWindow LoadWindow
               MenuWindow GameWindow SettingWindow
               LevelWindow BarsWindow ButtonWindow)
    @window=Hash.new
    windows.each{|window|
      symbol=window.to_sym
      @window[symbol]=Object.const_get(symbol).new
    }
    @window[:MenuWindow].open
  end
  def check_multi_window
    if WIN32API.FindWindow('遊戲視窗')>0||WIN32API.FindWindow('初始化中...')>0
      Message.show(:game_already_run)
      exit
    end
  end  
  def gl_parameters
    glViewport( 0, 0, Game.Width, Game.Height );
    glEnable GL_TEXTURE_2D
    glTexParameteri(GL_TEXTURE_2D,
      GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,
      GL_TEXTURE_MIN_FILTER,
      GL_LINEAR_MIPMAP_LINEAR);
    
    glEnable GL_BLEND
    glEnable GL_ALPHA_TEST
    glBlendFunc GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA
    #dbg
    #glEnable(GL_DEPTH_TEST);

    glDepthFunc(GL_LESS);
    glShadeModel(GL_SMOOTH);
  end
  def load_lib
    done=false
    t=Thread.new{
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
      done=true
    }
    
    text=Font.render_texture('Loading',30,*Color[:loading_font])
    dot=Font.render_texture('.',30,*Color[:loading_font])
    num=0
    until done
      glClearColor(0,0,0,1.0);
      glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
      text.direct_draw(230,240)
      num=(num<3) ? num+1 : 0
      num.times{|i|
        dot.direct_draw(370+i*30,240)
      }
      SDL::GL.swap_buffers
      SDL.delay(40)
    end
    Screen.set_caption("遊戲視窗")
    Mouse.set_cursor(:select)
  end

  def update
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
  def draw
    @window.each{|name,window| window.visible and window.draw}
    Screen.flip
  end
  def draw_back
    Screen.fill_rect(0,0,@Width,@Height,0)
  end
  public
  def set_window(name,state)
    if state==:open
      @window[name].open
    else
      @window[name].close
    end
  end
  def window(idx)
    return @window[idx]
  end
  def Width
    return @Width
  end
  def Height
    return @Height
  end
  def player
    return @window[:GameWindow].get_player
  end
  def release
    Font.release
  end
  def quit
    Screen.destroy
    SDL.quit
    exit
  end
  def show
    $queue=[]
    loop{
      time=SDL.get_ticks

      update
      glClearColor(1.0,0,0,1.0);
      glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
      
      draw
      $queue.each{|text|
        text.display
      }
      $queue.clear
      SDL::GL.swap_buffers
      delta_time=SDL.get_ticks-time
      #p delta_time
      delta_time<40 and SDL.delay(40-delta_time)
    }
  end
  def get_real_path
    realpath=Pathname.new(__FILE__).realpath.to_s
    until realpath[-1]=="/"
      realpath.chop!
    end
    realpath
  end
end
Game.init
Game.show
