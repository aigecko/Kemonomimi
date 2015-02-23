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
  def self.init_dirt_rect
    @side=32
    @map_w=Game.Width/@side
    @map_h=Game.Height/@side
    @map=Array.new(@map_w){Array.new(@map_h)}
  end
  def self.set_caption(str)
    SDL::WM.set_caption(str,'')
  end
  def self.render
    return @screen
  end
  def self.fill_rect(x,y,w,h,*arg)
    @screen.fill_rect(x,y,w,h,*arg)
  end
  def self.draw_rect(*arg)
    @screen.draw_rect(*arg)
  end
  def self.draw_line(x1,y1,x2,y2,color)
    @screen.draw_line(x1,y1,x2,y2,color)
  end
  def self.destroy
    @screen.destroy
  end
  def self.format
    @screen.format
  end
  def self.flip
    @screen.flip
  end
end
