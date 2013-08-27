#coding: utf-8
class ClassWindow < SelectWindow
  def initialize
    win_w,win_h=400,300
    win_x=(Game.Width-win_w)/2
    win_y=(Game.Height-win_h)/2
    super(win_x,win_y,win_w,win_h)
    
    @alone=true
    
    @table=[:crossbowman,:archer,
            :mage,:cleric,
            :fighter,:paladin,:darkknight]
    
    title_initialize('請選擇職業')
    word_initialize
    pic_initialize
    comment_initialize(:default)
  end
  def pic_initialize
    @back=Input.load_title
    @class_pic=select_pic_initialize(@name)
    @detail_pic=detail_pic_initialize(@detail)
  end
  def word_initialize
    @name=Actor.class_table
    
    @detail=Hash.new("")
    @detail[:crossbowman]=<<-EOF
使用弩作為武器
單次攻擊輸出非常高
不過攻擊速度並不快
具有雷電的屬性
普通攻擊有機率使目標麻痺
攻擊高且攻擊範圍也很遠
    EOF
    @detail[:archer]=<<-EOF
使用弓作為武器
攻擊速度非常地快
但是傷害沒有#{@name[:crossbowman]}那麼高
帶有風的屬性
普通攻擊有機率使目標暈眩
攻速快閃避高為特色
    EOF
    @detail[:mage]=<<-EOF
使用法杖作為武器
利用技能輸出大量魔法傷害
不論單體或範圍技能都有
由於帶有水的屬性
還可以使敵人凍結或降低跑速
此外還能使用法力抵銷部份傷害
    EOF
    @detail[:cleric]=<<-EOF
和#{@name[:mage]}一樣使用法杖作為武器
技能的傷害較#{@name[:mage]}為低
不過普攻消去法力並帶魔法傷害
本身帶有地的屬性
防禦並不薄弱
反而能夠抵擋敵方的大量傷害
    EOF
    @detail[:fighter]=<<-EOF
將劍和盾搭配或是採用二刀流
輸出以普通攻擊為主
血量很高可以承受大量傷害
具有火的屬性
可以降低附近敵人的速度
還能夠使目標持續受到傷害
    EOF
    @detail[:paladin]=<<-EOF
使用長槍或是以劍盾作為搭配
本身可以恢復血量很有續戰力
物理輸出和魔法輸出兼具
對異常狀態抗性也很高
帶有神聖的屬性
能夠對黑暗屬性敵人造成高傷害
    EOF
    @detail[:darkknight]=<<-EOF
和#{@name[:paladin]}使用相同的武器
不只使用普通攻擊造成物理傷害
還可以輸出大量的絕對傷害
帶有黑暗的屬性
能夠對神聖屬性敵人造成高傷害
也能對敵人施放異常狀態
    EOF
  end
  def interact
    Event.each{|event|
      case event
      when Event::KeyDown
        case event.sym
        when Key::DOWN
          @select=(@select==@table.size-1)? 0 : @select+1
          @need2draw_word=true
        when Key::UP
          @select=(@select==0)? @table.size-1 : @select-1
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
          result=check_select_index(@class_pic,@table)
          result and select_check
        when SDL::Mouse::BUTTON_RIGHT
          select_back
        end
      when Event::MouseMotion
        check_select_index(@class_pic,@table)
        @need2draw_word=true
      when Event::Quit
        Game.quit
      end
    }
  end
  def select_check
    close
    Game.set_window(:GameWindow,:open)
    Game.window(:GameWindow).start_init
  end
  def select_back
    close
    Game.set_window(:RaceWindow,:open)
  end
  def get_class
    return @table[@select]
  end
  def open
    super
    @need2draw_back=true
    @need2draw_word=true
  end
  def draw
    if @need2draw_back
      @back.draw(0,0)
      @need2draw_back=false
    end
    if @need2draw_word
      super
      draw_title
      draw_select_detail(@class_pic,@detail_pic,@table)
      draw_comment
      @need2draw_word=false
    end
  end
end