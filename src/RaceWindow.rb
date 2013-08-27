#coding: utf-8
class RaceWindow < SelectWindow
  def initialize 
    win_w,win_h=400,300
    win_x,win_y=(Game.Width-win_w)/2,(Game.Height-win_h)/2
    super(win_x,win_y,win_w,win_h)
    
    @alone=true
    
    @table=[:catear,:foxear,:wolfear,:dogear]
    title_initialize('請選擇種族')
    comment_initialize(:default)
    word_initialize
    pic_initialize
  end
  def word_initialize
    @race=Actor.race_table
 
    @detail=Hash.new
    @detail[:catear]=<<-EOF
帶有貓咪耳朵的半獸人種族
動作非常靈活
行走相對快速許多
對於敵人格擋有更快的反應
能在敵人格擋時造成一定的傷害
    EOF
    @detail[:foxear]=<<-EOF
帶有狐狸耳朵的半獸人種族
本身就有著強大的魔法力量
本身SP值相對較高
雖然魔法消耗也提升
但是威力跟著強化
    EOF
    @detail[:wolfear]=<<-EOF
帶有狼耳朵的半獸人種族
本身的力量很驚人
暴擊可以造成更高傷害
就算敵人的防禦很高
命中情況下還是能造成一定的傷害
    EOF
    @detail[:dogear]=<<-EOF
帶有狗耳朵的半獸人種族
平常看起來雖然和狼耳很像
可是具有特殊的潛能
在敵人低血量時可以造成更大傷害
是名為撿尾刀的能力
    EOF
  end
  def pic_initialize
    @back=Input.load_title
    @race_pic=select_pic_initialize(@race)
    @text_pic=detail_pic_initialize(@detail)
  end
  def interact
    Event.each{|event|
      case event
      when Event::KeyDown
        case event.sym
        when Key::DOWN
          @select= (@select==3)? 0 : @select+1
          @need2draw_word=true
        when Key::UP
          @select= (@select==0)? 3 : @select-1
          @need2draw_word=true
        when *Key::CHECK
          select_check
        when *Key::BACK
          select_back
        when Key::ESCAPE
          Game.quit
        end
      when Event::MouseButtonDown
        case event.button
        when SDL::Mouse::BUTTON_LEFT
          result=check_select_index(@race_pic,@table)
          result and select_check
        when SDL::Mouse::BUTTON_RIGHT
          select_back
        end
      when Event::MouseMotion
        check_select_index(@race_pic,@table)
        @need2draw_word=true
      when Event::Quit
        Game.quit
      end
    }
  end
  def select_check
    close
    Game.set_window(:ClassWindow,:open)
  end
  def select_back
    close
    Game.set_window(:MenuWindow,:open)
  end
  def get_race
    return @table[@select]
  end
  def open
    super
    @need2draw_word=true
    @need2draw_back=true
  end
  def draw
    if @need2draw_back
      @back.draw(0,0)
      @need2draw_back=false
    end
    if @need2draw_word
      super
      draw_title
      draw_select_detail(@race_pic,@text_pic,@table)
      draw_comment
      @need2draw_word=false
    end
  end
 
end