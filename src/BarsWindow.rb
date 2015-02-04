#coding: utf-8
class BarsWindow < BaseWindow
  require_relative 'BarsWindow_Bar'
  def initialize
    win_w,win_h=350,50
    win_x=94
    win_y=Game.Height-win_h
    super(win_x,win_y,win_w,win_h)
    bar_w=160
    bar_h=12
    
    @hp_bar=Bar.new(:hp,@win_x+@border,@win_y+@border,bar_w,bar_h)
    @sp_bar=Bar.new(:sp,@win_x+@border*2+bar_w,@win_y+@border,bar_w,bar_h)
    @exp_bar=Bar.new(:exp,@win_x+@border,@win_y+@border+bar_h+5,bar_w*2+@border,bar_h)
    
    @hp_font=[]
    @sp_font=[]
    @exp_font=[]
    
    @hp_font_x=@hp_bar.ske_x+2
    @hp_font_y=@hp_bar.ske_y
    @sp_font_x=@sp_bar.ske_x+2
    @sp_font_y=@sp_bar.ske_y
    @exp_font_x=@exp_bar.ske_x+2
    @exp_font_y=@exp_bar.ske_y
    
    skeleton_initialize
    gen_skeleton_texture
    
    @font_size=12
  end
  def start_init
    @attrib=Game.player.attrib
    value_init
  end
  %w{hp sp exp}.each do |p|
  eval %Q{  
  def #{p}_update(attrib)
    if @#{p}!=attrib[:#{p}]
      @#{p}=attrib[:#{p}]
      update=true
    end
    if @max#{p}!=attrib[:max#{p}]
      @max#{p}=attrib[:max#{p}]
      update=true
    end
    if update
      @#{p}_percent=@#{p}/@max#{p}.to_f
      @#{p}_font.clear
      ["#{p.upcase}: ","\#{@#{p}}","/","\#{@max#{p}}",
       " %.#{p!="exp" ? 1 : 3}f"%(@#{p}_percent*100),"%"].each{|str|
        @#{p}_font<<Font.render_texture(str,@font_size,*Color[:font_#{p}])
      }
    end
  end
  def draw_#{p}
    x=0
    @#{p}_font.each{|font|
      font.draw(@#{p}_font_x+x,@#{p}_font_y)
      x+=font.w
    }
  end
  }
  end
  def value_init
    hp_update(@attrib)
    sp_update(@attrib)
    exp_update(@attrib)
  end
  def interact
    value_init
  end
  def draw_bar
    @hp_bar.draw(@hp_percent)
    @sp_bar.draw(@sp_percent)
    @exp_bar.draw(@exp_percent)
  end
  def draw_font
    draw_hp
    draw_sp
    draw_exp
  end
  def draw
    draw_corner(:clear)
    super
    draw_bar
    draw_font
  end
end