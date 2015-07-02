#coding: utf-8
class StatusWindow::Bar
  @@attrib_table=Actor.attrib_table
  attr_reader :name
  require_relative 'StatusWindow/PlusBar'
  require_relative 'StatusWindow/ShortBar'
  require_relative 'StatusWindow/MidBar'
  require_relative 'StatusWindow/LongBar'
  require_relative 'StatusWindow/ExtraBar'
  def initialize(name,win_x,win_y,x,y,skeleton)
    @name=name
    @str=@@attrib_table[name]
    @value=Game.player.attrib[@name]
    
    @x,@y=x,y
    
    @font_size=12
    
    @str_back_x,@str_back_y=@x-win_x,@y-win_y
    @str_back_w||=@font_size*2+8
    @str_back_h=18
    
    @val_back_x=@str_back_x+@str_back_w
    @val_back_y=@str_back_y
    
    value_init(win_x,win_y)
    pic_init(skeleton)
  end
  def value_init(win_x,win_y)
    @val_back_w-=@str_back_w
    @val_back_h=18

    @str_font_x=@x+2-win_x
    @str_font_y=@y+3-win_y
    
    @val_font_y=@y+3
  end
  def pic_init(skeleton=nil)
    skeleton.fill_rect(@str_back_x,@str_back_y,@str_back_w,@str_back_h,Color[:attrib_str])
    skeleton.fill_rect(@val_back_x,@val_back_y,@val_back_w,@val_back_h,Color[:attrib_val])
    
    @str_pic=Font.render_solid("#{@str}:",@font_size,*Color[:attrib_font])
    @str_pic.draw(@str_font_x,@str_font_y,skeleton)
    @val_pic=Font.render_texture(@val.call,@font_size,*Color[:attrib_font])
  end
  def update
    attrib=Game.player.attrib
    unless @click_plus
      @value==attrib[@name] and return
      @value=attrib[@name]
      @val_pic=Font.render_texture(@val.call,@font_size,*Color[:attrib_font])
    else
      @value==attrib[@name]+@plus_val and return
      @value=attrib[@name]+@plus_val
      @val_pic=Font.render_texture(@val.call,@font_size,*Color[:attrib_plus])
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
  def update_coord(win_x,win_y,x,y)
    @x=x
    @y=y
    value_init(win_x,win_y)
  end
  def any_value_plus?
    return @plus_val>0
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
  def draw
    @val_pic.draw(@val_font_x,@val_font_y)
  end
end