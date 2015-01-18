module Mouse
  BUTTON_RIGHT=SDL::Mouse::BUTTON_RIGHT
  BUTTON_LEFT=SDL::Mouse::BUTTON_LEFT
  DOUBLECLICK_DELAY=0.3
  def init
    @cursors={}
    %w{loading select attack move drag}.each{|name|
      @cursors[name.to_sym]=SDL::Surface.load("./rc/icon/cursor/#{name}.bmp")
    }
  end
  def state
    SDL::Mouse.state
  end
  def set_cursor(type)
    cursor=@cursors[type]
    SDL::Mouse.set_cursor(cursor,cursor[1,1],cursor[0,0],cursor[5,0],0)
  end  
  module_function :init,:state,:set_cursor
end
