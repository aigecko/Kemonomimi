class Mouse
  def self.init
    @cursors={}
    %w{loading select attack move}.each{|name|
      @cursors[name.to_sym]=SDL::Surface.load("./rc/icon/cursor/#{name}.bmp")
    }
  end
  def self.state
    SDL::Mouse.state
  end
  def self.set_cursor(type)
    cursor=@cursors[type]
    SDL::Mouse.set_cursor(cursor,cursor[1,1],cursor[0,0],cursor[5,0],0)
  end
end