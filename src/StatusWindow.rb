#coding: utf-8
class StatusWindow < DragWindow
  require_relative 'StatusWindow/Bar'
  require_relative 'StatusWindow/Button'
  def initialize
    win_w,win_h=180,270
    win_x,win_y=10,50
    super(win_x,win_y,win_w,win_h)
    @bars=[]
    @buttons={}
    skeleton_initialize
    title_initialize('人物狀態')
  end
  def coord_init
    @coord={}
    [:str,:con,:int,:wis,:agi].each_with_index{|sym,i|
      @coord[sym]=[@win_x,@win_y,@win_x+@border,@win_y+75+i*20]
    }
    [:atk,:def,:matk,:mdef,:ratk].each_with_index{|sym,i|
      @coord[sym]=[@win_x,@win_y,@win_x+90+@border,@win_y+75+i*20]
    }
    @coord[:maxhp]=[@win_x,@win_y,@win_x+@border,@win_y+25]
    @coord[:maxsp]=[@win_x,@win_y,@win_x+@border,@win_y+45]

    @coord[:block]=[@win_x,@win_y,@win_x+@border,@win_y+185]
    @coord[:dodge]=[@win_x,@win_y,@win_x+@border+75,@win_y+185]
    
    @coord[:wlkspd]=[@win_x,@win_y,@win_x+@border,@win_y+215]
    @coord[:atkspd]=[@win_x,@win_y,@win_x+@border,@win_y+235]
    
    @coord[:extra]=[@win_x,@win_y,@win_x+@border+70,@win_y+215]

    @coord[:button_check]=[@win_x+@border+119,@win_y+240]
    @coord[:button_close]=[@win_x+@border+70,@win_y+240]
  end
  def start_init
    coord_init
    [:str,:con,:int,:wis,:agi].each{|sym|
      @bars<<PlusBar.new(sym,*@coord[sym],@skeleton)
    }
    [:maxhp,:maxsp].each{|sym|
      @bars<<LongBar.new(sym,*@coord[sym],@skeleton)
    }
    [:atk,:def,:matk,:mdef,:ratk,:wlkspd,:atkspd].each{|sym|
      @bars<<ShortBar.new(sym,*@coord[sym],@skeleton)
    }
    [:block,:dodge].each{|sym|
      @bars<<MidBar.new(sym,*@coord[sym],@skeleton)
    }
    @bars<<ExtraBar.new(:extra,*@coord[:extra],@skeleton)
    
    button_str={
      button_check:'確定',
      button_close:'關閉'
    }
    [:button_check,:button_close].each{|sym|
      @buttons[sym]=Button.new(button_str[sym],sym,*@coord[sym])
    }
    get_active_button
    gen_skeleton_texture
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
    @active_check and @buttons[:button_check].draw
    @buttons[:button_close].draw
  end
  def draw
    super
    @bars.each{|bar|
      bar.update
      bar.draw
    }
    draw_button
  end
end