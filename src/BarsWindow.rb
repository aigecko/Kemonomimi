#coding: utf-8
class BarsWindow < BaseWindow
  class Bar
    attr_reader :ske_x,:ske_y
    def initialize(type,x,y,w,h)
      @type=type
     
      @ske_x=x
      @ske_y=y
      @bar_x=@ske_x+1
      @bar_y=@ske_y+1
      @max_w=w
      @max_h=h
      @bar_w=@max_w-2
      @bar_h=@max_h-2
      
      @color_back_sym=:"bar_#{@type}_back"
      @color_leave_sym=:"bar_#{@type}_leave"
      @color_sym=:"bar_#{@type}"
    end
    def draw(percent)
      Screen.fill_rect(@ske_x,@ske_y,@max_w,@max_h,Color[@color_back_sym])
      Screen.fill_rect(@bar_x,@bar_y,@bar_w,@bar_h,Color[@color_leave_sym])
      bar_w=@bar_w*percent
      Screen.fill_rect(@bar_x,@bar_y,bar_w,@bar_h,Color[@color_sym])
    end
  end
end
class BarsWindow
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
    
    @font_size=12
    
    @hp_font_x=@hp_bar.ske_x+2
    @hp_font_y=@hp_bar.ske_y
    @sp_font_x=@sp_bar.ske_x+2
    @sp_font_y=@sp_bar.ske_y
    @exp_font_x=@exp_bar.ske_x+2
    @exp_font_y=@exp_bar.ske_y
    
  end
  def start_init
    @attrib=Game.player.attrib
    value_init
  end
  def hp_update(attrib)
    if @hp!=attrib[:hp]
      @hp=attrib[:hp]
      update=true
    end
    if @maxhp!=attrib[:maxhp]
      @maxhp=attrib[:maxhp]
      update=true
    end
    if update
      @hp_percent=@hp/@maxhp.to_f
      str=sprintf("HP: %d/%d %.1f%%",@hp,@maxhp,@hp_percent*100)
      @hp_font=Font.render_solid(str,@font_size,*Color[:font_hp])
    end
  end
  def sp_update(attrib)
    if @sp!=attrib[:sp]
      @sp=attrib[:sp]
      update=true
    end
    if @maxsp!=attrib[:maxsp]
      @maxsp=attrib[:maxsp]
      update=true
    end
    if update
      @sp_percent=@sp/@maxsp.to_f
      str=sprintf("SP: %d/%d %.1f%%",@sp,@maxsp,@sp_percent*100)
      @sp_font=Font.render_solid(str,@font_size,*Color[:font_sp])
    end
  end
  def exp_update(attrib)
    if @exp!=attrib[:exp]
      @exp=attrib[:exp]
      update=true
    end
    if @maxexp!=attrib[:maxexp]
      @maxexp=attrib[:maxexp]
      update=true
    end
    if update
      @exp_percent=@exp/@maxexp.to_f
      str=sprintf("EXP: %d/%d %.3f%%",@exp,@maxexp,@exp_percent*100)
      @exp_font=Font.render_solid(str,@font_size,*Color[:font_exp])
    end
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
    @hp_font.draw(@hp_font_x,@hp_font_y)
    @sp_font.draw(@sp_font_x,@sp_font_y)
    @exp_font.draw(@exp_font_x,@exp_font_y)
  end
  def draw
    draw_corner(:clear)
    super
    draw_bar
    draw_font
  end
end