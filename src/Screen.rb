#coding: utf-8
class Screen
  def self.init
    screen_surface=SDL::OPENGL
    full_screen=Conf['FULL_SCREEN']? SDL::FULLSCREEN : 0
    begin
      @screen=SDL::Screen.open(Game.Width,Game.Height,24,screen_surface|full_screen)
    rescue SDL::Error => e
      p e
      Message.show(:initialize_failure)
      Message.show(:plaese_restart_game)
      exit
    end
    Mouse.set_cursor(:loading)
    self.set_caption("初始化中...")
    SDL::WM.icon=SDL::Surface.load('./rc/icon/window_icon/icon.bmp')
  end
  def self.set_caption(str)
    SDL::WM.set_caption(str,'')
  end
  def self.format
    @screen.format
  end
end
