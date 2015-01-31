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
          Font Input Extension Skill Mouse Texture)
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
    self.gl_initialize
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
  def self.gl_initialize
    SDL::GL.set_attr SDL::GL_RED_SIZE,8
    SDL::GL.set_attr SDL::GL_GREEN_SIZE,8
    SDL::GL.set_attr SDL::GL_BLUE_SIZE,8
    SDL::GL.set_attr SDL::GL_DEPTH_SIZE,24
    SDL::GL.set_attr SDL::GL_DOUBLEBUFFER,1
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
      symbol=window.to_sym
      @window[symbol]=Object.const_get(symbol).new
    }
    @window[:MenuWindow].open
  end
  def self.check_multi_window
    if WIN32API.FindWindow('遊戲視窗')>0||WIN32API.FindWindow('初始化中...')>0
      Message.show(:game_already_run)
      exit
    end
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
    Gl::glViewport( 0, 0, 640, 480 );
    Gl::glEnable Gl::GL_TEXTURE_2D
    Gl::glTexParameteri(Gl::GL_TEXTURE_2D,
      Gl::GL_TEXTURE_MAG_FILTER, Gl::GL_LINEAR);
    Gl::glTexParameteri(Gl::GL_TEXTURE_2D,
      Gl::GL_TEXTURE_MIN_FILTER,
      Gl::GL_LINEAR_MIPMAP_LINEAR);
    
    Gl::glEnable Gl::GL_BLEND
    Gl::glEnable Gl::GL_ALPHA_TEST
    Gl::glBlendFunc Gl::GL_SRC_ALPHA,Gl::GL_ONE_MINUS_SRC_ALPHA
    Gl::glEnable(Gl::GL_DEPTH_TEST);

    Gl::glDepthFunc(Gl::GL_LESS);
    Gl::glShadeModel(Gl::GL_SMOOTH);
  
    $queue=[]
    loop{
      time=SDL.get_ticks

      update
      Gl::glClearColor(1.0,0,0,1.0);
      Gl::glClear(Gl::GL_COLOR_BUFFER_BIT|Gl::GL_DEPTH_BUFFER_BIT);
      
      draw
      #Gl::glDisable Gl::GL_BLEND
      $queue.each{|pack|
        id,x,y,w,h,vx,vy=*pack
        Gl::glBindTexture(Gl::GL_TEXTURE_2D,id)
        Gl::glBegin(Gl::GL_QUADS)
        # Gl::glTexCoord2d(0,0)
        Gl::glTexCoord2d(0,0)
        Gl::glVertex3f -1+(x/320.0),1-y/240.0+0,0
        # Gl::glTexCoord2d(1,0)  
        Gl::glTexCoord2d(0.75,0)
        Gl::glVertex3f -1+(x/320.0)+(w)/320.0,1-y/240.0+0,0
        # Gl::glTexCoord2d(1,1)
        Gl::glTexCoord2d(0.75,0.75)
        Gl::glVertex3f -1+(x/320.0)+(w)/320.0,1-y/240.0-(h)/240.0,0
        # Gl::glTexCoord2d(0,1)
        Gl::glTexCoord2d(0,0.75)
        Gl::glVertex3f -1+(x/320.0),1-y/240.0-(h)/240.0,0
        Gl::glEnd
      }
      $queue.clear
      # Screen.flip
      SDL::GL.swap_buffers
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
