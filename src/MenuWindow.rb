#coding: utf-8
class MenuWindow < SelectWindow
  def initialize
    @text={0=>'開始遊戲',1=>'載入遊戲',2=>'遊戲設定',3=>'結束遊戲'}
    @text_w,@text_h=Font[20].text_size(@text[0])
	
    @title=Input.load_title
    @border=10

    win_w=@text_w+@border*2
    win_h=@text_h*@text.size+@border*2
    win_x=Game.Width/2-win_w/2
    win_y=Game.Height/2-win_h/2
    super(win_x,win_y,win_w,win_h)
    @text_pic=select_pic_initialize(@text)
    @select_draw_x=win_x+@border
    @select_draw_y=win_y+@border
    @alone=true
  end
  def interact
    Event.each{|event|
      case event
      when Event::KeyDown
        case event.sym
        when Key::DOWN
          @select+=1
          @select==4 and @select=0
          @need2draw_word=true
        when Key::UP
          @select-=1
          @select==-1 and @select=3
          @need2draw_word=true
        when *Key::CHECK
          select_check
        end
      when Event::MouseButtonDown
        result=check_select_index(@text_pic,Array(0..3))
        result and select_check
      when Event::MouseMotion
        check_select_index(@text_pic,Array(0..3))
        @need2draw_word=true
      when Event::Quit
        Game.quit
      end
    }
  end
  def open
    super
    @need2draw=true
    @need2draw_word=true
  end
  def select_check
    case @select
    when 0
      close
      Game.set_window(:RaceWindow,:open)
    when 1
      close
      Game.set_window(:LoadWindow,:open)
    when 2
      close
      Game.set_window(:SettingWindow,:open)
    when 3
      Game.quit
    end
  end
  def draw
    if @need2draw
      @title.draw(0,0)
      super
      @need2draw=false
    end
    if @need2draw_word
      super
      draw_select(@text_pic,Array(0..3))
      @need2draw_word=false
    end
  end
end