#coding: utf-8
class LevelWindow < BaseWindow
  def initialize
    win_w,win_h=95,50
    win_x=0
    win_y=Game.Height-win_h
    super(win_x,win_y,win_w,win_h)
  end
  def start_init
    player=Game.player
    level_initialize(player)
    race_initialize(player)
    class_initialize(player)
  end
private
  def level_initialize(player)
    @level=player.attrib[:level]
    @level_pic=Font.render_solid("Level: #{@level}",15,*Color[:level_win_font])
    
    @level_draw_x=@win_x+@border
    @level_draw_y=@win_y+@border
  end
  def race_initialize(player)
    @race=player.race
    @race_str=Actor.race_table[player.race]
    @race_pic=Font.render_solid(@race_str,15,*Color[:level_win_font])
    
    @race_draw_x=@level_draw_x
    @race_draw_y=@level_draw_y+@level_pic.h
  end
  def class_initialize(player)
    @class=player.class
    @class_str=Actor.class_table[player.class]
    # @class_pic=Font.render_solid(@class_str,15,*Color[:level_win_font])
    @class_pic=Font.render_texture(@class_str,15,*Color[:level_win_font])
    # @class_pic=FontTexture.new @class_pic
    
    @class_draw_x=@race_draw_x+@race_pic.w
    @class_draw_y=@race_draw_y
  end
public
  def interact
    player=Game.player
    if player.attrib[:level]!=@level
      level_initialize(player)
      @need2draw=true
    end
    if player.race!=@race
      race_initialize(player)
      @need2draw=true
    end
    if player.class!=@class
      class_initialize(player)
      @need2draw=true
    end
  end
  def open
    super
    @need2draw=true
  end
  def draw
    #@need2draw or return
    draw_corner(:clear)
    super
    @level_pic.draw(@level_draw_x,@level_draw_y)
    @race_pic.draw(@race_draw_x,@race_draw_y)
    @class_pic.draw(@class_draw_x,@class_draw_y)
    @need2draw=false
  end
end