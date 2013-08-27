#coding: utf-8
class StatusWindow < DragWindow
  class Bar
    @@attrib_table=Actor.attrib_table
    attr_reader :name
    def initialize(name,x,y,len)
      @name=name
      @str=@@attrib_table[name]
      @value=Game.player.attrib[@name]
      
      @x,@y=x,y
      
      @font_size=12
      @len=len
      value_init
      pic_init
    end
    def value_init
      @str_back_x,@str_back_y=@x,@y
      @str_back_w=@font_size*2+8
      @str_back_h=18
      
      @str_font_x=@str_back_x+2
      @str_font_y=@str_back_y+3
      
      @val_back_x=@str_back_x+@str_back_w
      @val_back_y=@str_back_y
      
      case @len
      when :plus
        @val_back_w=65
        @val_font_x=@str_font_x+33
        @plus_x=@str_back_x+@val_back_w
        @plus_y=@val_back_y
        @plus_w=@plus_h=18
        @plus_pic=true
        @plus_val||=0
      when :short
        @val_back_w=65
        @val_font_x=@str_font_x+33
      when :mid
        @val_back_w=70
        @val_font_x=@str_font_x+35
      when :long
        @val_back_w=96
        @val_font_x=@str_font_x+56	
        @str_back_w=@font_size*4+8
        @val_back_x=@str_back_x+@str_back_w
      when :extra
        @val_back_w=88
        @val_font_x=@str_font_x+56
        @str_back_w=@font_size*4+8
        @val_back_x=@str_back_x+@str_back_w
      end
      @val_back_w-=@str_back_w
      @val_back_h=18
      @val_font_y=@str_font_y
    end
    def pic_init
      case @len
      when :plus
        @val=->{sprintf("%4d",@value)}
        @plus_pic=true
      when :short
        @val=->{sprintf("%4d",@value)}
      when :mid
        @val=->{sprintf("%5.2f",@value)}
      when :long
        @val=->{sprintf("%5d",@value)}
      when :extra
        @val=->{sprintf("%4d",@value)}
      end
      @str_pic=Font.render_solid("#{@str}:",@font_size,*Color[:attrib_font])
      @val_pic=Font.render_solid(@val.call,@font_size,*Color[:attrib_font])
    end
    def update
	  attrib=Game.player.attrib
      unless @click_plus
        if @value!=attrib[@name] 
          @value=attrib[@name]
          @val_pic=Font.render_solid(@val.call,@font_size,*Color[:attrib_font])
        end
      else
        if @value!=attrib[@name]+@plus_val
          @value=attrib[@name]+@plus_val
          @val_pic=Font.render_solid(@val.call,@font_size,*Color[:attrib_plus])
          @name==:agi and p 'update'
        end
      end
    end
    def detect_click_plus
      x,y,* =SDL::Mouse.state
      if x.between?(@plus_x,@plus_x+@plus_w)&&
         y.between?(@plus_y,@plus_y+@plus_h)
        @click_plus=true
        @plus_val+=1
        return true
      end
      return false
    end
	def detect_undo_plus
	  x,y,* =SDL::Mouse.state
      if x.between?(@plus_x,@plus_x+@plus_w)&&
         y.between?(@plus_y,@plus_y+@plus_h)
		if @plus_val>1
		  @plus_val-=1
          return true
		elsif @plus_val==1
		  @plus_val=0
		  @click_plus=false
		  return true
		else
		  @click_plus=false
		  return false
		end
      end
      return false
	end
    def update_coord(win_x,win_y)
      @x=win_x
      @y=win_y
      value_init
    end
    def any_value_plus?
	  return @plus_val>0 ? true : false
	end
	def sure2plus      
	  attrib=Game.player.gain_attrib @name => @plus_val
      @plus_val=0
      @click_plus=false
      @value=nil
      update
    end
    def not2plus
      val=@plus_val
      @plus_val=0
      @click_plus=false
	  update
      return val
    end
    def draw_back(dst=Screen.render)
      dst.fill_rect(@str_back_x,@str_back_y,@str_back_w,@str_back_h,Color[:attrib_str])
      dst.fill_rect(@val_back_x,@val_back_y,@val_back_w,@val_back_h,Color[:attrib_val])
      @str_pic.draw(@str_font_x,@str_font_y,dst)
    end
    def draw
      if @plus_pic
        Screen.fill_rect(@plus_x,@plus_y,@plus_w,@plus_h,[125,125,125])
      end
      @val_pic.draw(@val_font_x,@val_font_y)
    end
  end
  class Button
    def initialize(str,name,x,y)
	  @str=str
      @name=name
	  @x=x
	  @y=y
	  @str_pic=Font.render_solid(str,20,*Color[:attrib_font])
	  @w,@h=@str_pic.w,@str_pic.h
	end
    def update_coord(x,y)
      @x=x
      @y=y
    end
	def detect_click(x,y)
	  if x.between?(@x,@x+@w)&&
	     y.between?(@y,@y+@h)
		return true
      else
	    return false
	  end
	end
	def draw
	  Screen.fill_rect(@x,@y,@w,@h,Color[:attrib_val])
	  @str_pic.draw(@x,@y)
	end
  end
end
class StatusWindow
  def initialize
    win_w,win_h=180,270
    win_x,win_y=10,50
    super(win_x,win_y,win_w,win_h)
    @bars=[]
	@buttons={}
    title_initialize('人物狀態')
  end
  def pic_initialize
    surface=Surface.new(Surface.flag,Game.Width,Game.Height,Screen.format)
    draw(surface)
    draw_title(surface)
    @bars.each{|bar| bar.draw_back(surface)}
    
    @skeleton=surface.copy_rect(@win_x,@win_y,@win_w,@win_h)
    @skeleton.set_color_key(SDL::SRCCOLORKEY|SDL::RLEACCEL,@skeleton[0,0])
    @skeleton.display_format_alpha
  end
  def coord_init
    @coord={}
    [:str,:con,:int,:wis,:agi].each_with_index{|sym,i|
      @coord[sym]=[@win_x+@border,@win_y+75+i*20]
    }
    [:atk,:def,:matk,:mdef,:ratk].each_with_index{|sym,i|
      @coord[sym]=[@win_x+90+@border,@win_y+75+i*20]
    }
    @coord[:maxhp]=[@win_x+@border,@win_y+25]
	@coord[:maxsp]=[@win_x+@border,@win_y+45]
	
	@coord[:block]=[@win_x+@border,@win_y+185]
    @coord[:dodge]=[@win_x+@border+75,@win_y+185]
    
    @coord[:wlkspd]=[@win_x+@border,@win_y+215]
    @coord[:jump]=[@win_x+@border,@win_y+235]
    
    @coord[:extra]=[@win_x+@border+70,@win_y+215]
	
	@coord[:button_check]=[@win_x+@border+119,@win_y+240]
	@coord[:button_close]=[@win_x+@border+70,@win_y+240]
  end
  def start_init
    coord_init
    [:str,:con,:int,:wis,:agi].each{|sym|
      @bars<<Bar.new(sym,*@coord[sym],:plus)
    }
	[:maxhp,:maxsp].each{|sym|
	  @bars<<Bar.new(sym,*@coord[sym],:long)
	}
	
	
    [:atk,:def,:matk,:mdef,:ratk,:wlkspd,:jump].each{|sym|
      @bars<<Bar.new(sym,*@coord[sym],:short)
    }
    [:block,:dodge].each{|sym|
      @bars<<Bar.new(sym,*@coord[sym],:mid)
    }
    @bars<<Bar.new(:extra,*@coord[:extra],:extra)
    
	button_str={
	  button_check:'確定',
	  button_close:'關閉'
	}
	[:button_check,:button_close].each{|sym|
	  @buttons[sym]=Button.new(button_str[sym],sym,*@coord[sym])
	}
	get_active_button
	pic_initialize    
    def start_init;end
  end
  def interact
    attrib=Game.player.attrib
    @bars.each{|bar| bar.update}
	get_active_button
    Event.each{|event|
      case event
      when Event::MouseButtonDown
        case event.button
        when SDL::Mouse::BUTTON_LEFT		  
		  detect_click_button(event.x,event.y)
          attrib[:extra]>0 or next
          detect_click_plus
		when SDL::Mouse::BUTTON_RIGHT
		  detect_undo_plus(attrib)
        end
      when Event::MouseMotion
        keep_drag(event.x,event.y)
      when Event::MouseButtonUp
        case event.button
        when SDL::Mouse::BUTTON_LEFT          
          end_drag
        end
      end
    }
  end
  def get_active_button
    @active_check=false
	@bars.take(5).each{|bar|
	  if bar.any_value_plus?	    
	    @active_check=true
	    break
	  end
	}
  end
  def detect_click_plus
    @bars.take(5).each{|bar|
      if bar.detect_click_plus
        Game.player.attrib[:extra]-=1
		break
      end
    }
  end
  def detect_undo_plus(attrib)
    @bars.take(5).each{|bar|
	  if bar.detect_undo_plus
	    Game.player.attrib[:extra]+=1
		break
	  end
	}
  end
  def detect_click_button(x,y)
    if @active_check
	  @buttons[:button_check].detect_click(x,y) and
	  @bars.take(5).each{|bar| bar.sure2plus}
	end
	if @buttons[:button_close].detect_click(x,y)
	  close
	end
  end
  def update_coord
    super
    coord_init
    @bars.each{|bar| bar.update_coord(*@coord[bar.name])}
    @buttons.each{|name,button| button.update_coord(*@coord[name])}
  end
  def close
    super
	point=0
    @bars.take(5).each{|bar| point+=bar.not2plus}
    Game.player.attrib[:extra]+=point
	@active_check=false
  end
  def draw_button
    if @active_check
	  @buttons[:button_check].draw
	end
	@buttons[:button_close].draw
  end
  def draw(dst)
    super(dst)
    def draw
      @skeleton.draw(@win_x,@win_y)
      @bars.each{|bar|
        bar.update
        bar.draw
      }
      draw_button
    end
  end
end