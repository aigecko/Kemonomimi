#coding: utf-8
class Game;end
class<<Game
  include Gl,Glu
  def init
    @Width=640
    @Height=480
    @Depth=400
    @NumOfRequire=103
    @FPS=25
    @TFP=40
    
    Conf.init
    Conf.load
    sdl_initialize
    gl_initialize
    sdl_putenv
    
    Color.init
    Icon.init
    
    check_multi_window
    
    Mouse.init 
    Screen.init
    
    font_initialize
    gl_parameters
    
    load_lib
    Skill.init 
    Event.init
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
    
    @Camera=[0,0,1]
    @Center=[0,0,0]
    @Vertical=[0,1,0]
    @OrthoRect=[0,@Width,@Height,0]
    @OrthoWall=[802,-2]
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
    glViewport(0, 0, Game.Width, Game.Height)
    gluLookAt(*@Camera,*@Center,*@Vertical)
    glOrtho(*@OrthoRect,*@OrthoWall)
    glEnable(GL_TEXTURE_2D)
    glTexParameteri(GL_TEXTURE_2D,
      GL_TEXTURE_MAG_FILTER, GL_NEAREST)
    glTexParameteri(GL_TEXTURE_2D,
      GL_TEXTURE_MIN_FILTER,
      GL_NEAREST)
    
    glEnable(GL_BLEND)
    glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA)
    glEnable(GL_ALPHA_TEST)
    glAlphaFunc(GL_GREATER,0)
    
    glShadeModel(GL_SMOOTH)
  end
  $require_count=0
  module ::Kernel
    alias origin_require require
    def require(lib)
      origin_require(lib)
      $require_count+=1
      Game.draw_loading
    end
    alias origin_require_relative require_relative
    def require_relative(lib)
      origin_require_relative(lib)
      $require_count+=1
      Game.draw_loading
    end
  end
  def load_lib
    @time=SDL.get_ticks
    %w(openssl digest zlib stringio).each{|lib|
      require(lib)
    }
    
    library_list=%w(
      Database Position Skill 
      Item Equipment Consumable ItemArray OnGroundItem
      Event Key HotKey Animation
      Actor Player Enemy Friend Attribute
      Statement SkillTree
      ColorString ParaString DynamicString
      Shape Shadow Bullet
      Attack FixAttack Effect Heal)
    library_list.each{|lib|
      require_relative(lib)
    }
    Actor.init
    Equipment.init
    HotKey.init
    window_list=%w(BaseWindow SelectWindow DragWindow
                   MenuWindow 
                   RaceWindow ClassWindow LoadWindow GameWindow
                   SettingWindow LevelWindow BarsWindow
                   ButtonWindow StatusWindow ItemWindow
                   EquipWindow SkillWindow
                   DialogWindow)
    window_list.each{|window|
      require_relative (window)
    }
    
    require_relative('Map')
    Screen.set_caption("遊戲視窗")
    Mouse.set_cursor(:select)
  end
  def update
    @cur_frame_ticks=SDL.get_ticks
    Event.poll
    @window.each{|name,window|
      window.enable or next
      window.interact
      window.alone and break
    }
    if Event[:Quit]
      Game.quit
    end
  end
  def draw
    @window[:GameWindow].visible and @window[:GameWindow].draw
    @window.each{|name,window|
      name==:GameWindow and next
      window.visible and window.draw
    }
    SDL::GL.swap_buffers
  end
  def draw_back
    glClearColor(0,0,0,1.0)
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT)
  end
  public
  def draw_loading
    @time>SDL.get_ticks and return
    @time=SDL.get_ticks+10
    draw_back
    Font.draw_texture('Loading',30,270,240,*Color[:loading_font])
    x,y,z=160,288,0
    w,h=@Width/@NumOfRequire*$require_count/2,48
    glDisable GL_TEXTURE_2D
    glBegin(GL_QUADS)
    glColor4d 1-$require_count*0.011,$require_count*0.011,0,1
    glVertex3f x,y,z
    glVertex3f x+w,y,z
    glVertex3f x+w,y+h,z
    glVertex3f x,y+h,z
    glEnd
    glEnable GL_TEXTURE_2D
    SDL::GL.swap_buffers
  end
  def save
    @window[:GameWindow].close_all_subwindows
    @time=SDL.get_ticks
    def saving_time;return @time;end
    File.open('test.sav','w'){|file|
      Marshal.dump({
        Player: @window[:GameWindow].get_player
      },file)
    }
  end
  def load
    File.open('test.sav','r'){|file|
      data=Marshal.load(file)
    }
  end
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
  # def Depth
    # return 401.0
  # end
  def FPS
    return @FPS
  end
  def player
    return @window[:GameWindow].get_player
  end
  def release
    Font.release
  end
  def quit
    SDL.quit
    exit
  end
  def show
    loop{
      time=SDL.get_ticks

      update
      draw_back
      draw
      delta_time=SDL.get_ticks-time
      #p delta_time
      delta_time<@TFP and SDL.delay(@TFP-delta_time)
    }
  end
  def get_real_path
    realpath=Pathname.new(__FILE__).realpath.to_s
    until realpath[-1]=="/"
      realpath.chop!
    end
    realpath
  end
  def get_ticks
    return @cur_frame_ticks
  end
end