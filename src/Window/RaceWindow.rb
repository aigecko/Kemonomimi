#coding: utf-8
class RaceWindow < SelectWindow
  def initialize 
    win_w,win_h=400,300
    win_x,win_y=(Game.Width-win_w)/2,(Game.Height-win_h)/2
    super(win_x,win_y,win_w,win_h)
    
    if(rand()<0.3)
      @table=[:catear,:foxear,:wolfear,:dogear,:leopardcatear]
    else
      @table=[:catear,:foxear,:wolfear,:dogear]
    end
    skeleton_initialize
    title_initialize('請選擇種族')
    comment_initialize(:default)
    word_initialize
    pic_initialize
    gen_skeleton_texture
    @alone=true
  end
  def word_initialize
    @race=Actor.race_table
 
    @detail=Hash.new
    @detail[:catear]=<<-EOF
帶有貓咪耳朵的半獸人種族
動作非常靈活
和其他的半獸人種族相比
行走相對快速許多
還有更快的基礎攻速
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
天生的回復能力很強
在受傷的狀況下可以很快復原
血量越低回復生命和法力的量越高
持久戰十分有利
    EOF
    @detail[:dogear]=<<-EOF
帶有狗耳朵的半獸人種族
平常看起來雖然和狼耳很像
可是具有特殊的潛能
在敵人低血量時可以造成更大傷害
是名為尾刀狗的能力
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
          @select= (@select==@table.size-1)? 0 : @select+1
        when Key::UP
          @select= (@select==0)? @table.size-1 : @select-1
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
  def draw
    @back.draw(0,0)
    super
    draw_select_detail(@race_pic,@text_pic,@table)
  end
 
end