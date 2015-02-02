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
弓箭射擊可以造成範圍傷害
攻擊高且攻擊範圍也很遠
    EOF
    @detail[:archer]=<<-EOF
使用弓作為武器
攻擊速度非常地快
但是傷害沒有弩箭手那麼高
帶有風的屬性
弓箭射擊可以穿透敵人
弓箭能連續發射為其特色
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
和魔法師一樣使用法杖作為武器
雖然技能的傷害較魔法師為低
普通攻擊提供了不少的附加傷害
本身帶有地的屬性
能夠抵擋敵方的大量傷害
甚至強度可以超越坦克的水準
    EOF
    @detail[:fighter]=<<-EOF
可以單手武器與盾搭配或二刀流
輸出以普通攻擊為主
血量很高可以承受大量傷害
具有火的屬性
不只可以強化自身攻擊
還能夠使目標持續受到傷害
    EOF
    @detail[:paladin]=<<-EOF
使用雙手武器或是單手武器和盾
本身可以恢復血量
物理輸出和魔法輸出兼具
帶有神聖的屬性
能夠施展增幅友軍的輔助魔法
可以說是多用途的職業
    EOF
    @detail[:darkknight]=<<-EOF
和聖騎士使用相同類型的武器
除了普通攻擊的物理傷害
還可以輸出大量的絕對傷害
帶有黑暗的屬性
能對敵人施放弱化的輔助魔法
造成比原先更大的傷害
    EOF
  end
  def interact
    Event.each{|event|
      case event
      when Event::KeyDown
        case event.sym
        when Key::DOWN
          @select=(@select==@table.size-1)? 0 : @select+1
        when Key::UP
          @select=(@select==0)? @table.size-1 : @select-1
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
  end
  def draw
    @back.draw(0,0)
    super
    draw_title
    draw_select_detail(@class_pic,@detail_pic,@table)
    draw_comment
  end
end