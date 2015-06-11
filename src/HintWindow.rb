#coding: utf-8
class HintWindow < BaseWindow
  def initialize
    win_w,win_h=100,300
    win_x,win_y=10,150
    super(win_x,win_y,win_w,win_h)
    @buff=[]
  end
  def start_init
  end
  def add(string)
    @timer=Game.get_ticks+5.to_sec
    @buff<<ColorString.new(string,15,[255,255,255])
    open
  end
  def interact
    @timer and
    @timer<Game.get_ticks and close
  end
  def draw
    @buff.last(10).each_with_index{|color_string,i|
      color_string.draw(@win_x,@win_y+15*i)
    }
  end
  def get_test_message
    @_idx||=-1
    @_str||=[
      "#ff0000|小島貞興#ffffff|擊敗#0000ff|前田慶次#ffffff|,敗陣者損失了#ff8000|75#ffffff|的金錢",
      "#ff0000|小島貞興#ffffff|拿下了精彩的雙殺！他將獲得額外#ff8000|100#ffffff|的賞金！",
      "#ff0000|小島貞興#ffffff|擊敗#0000ff|北條早雲#ffffff|,敗陣者損失了#ff8000|75#ffffff|的金錢",
      "#ff0000|小島貞興#ffffff|拿下了高超的三連殺！使敵軍聞風喪膽！他將獲得額外#ff8000|200#ffffff|的賞金！",
      "#ff0000|小島貞興#ffffff|擊敗#0000ff|瀧川一益#ffffff|,敗陣者損失了#ff8000|75#ffffff|的金錢",
      "#ff0000|小島貞興#ffffff|拿下了神一般四連殺！無任何敵將可與之匹敵！他將獲得額外#ff8000|300#ffffff|的賞金！",
      "#ff0000|小島貞興#ffffff|擊敗#0000ff|直江兼續#ffffff|,敗陣者損失了#ff8000|75#ffffff|的金錢",
      "#ff0000|小島貞興#ffffff|所屬的織田軍控制了整個戰場！隻身一人便打得敵方潰不成軍！",
      "#ff0000|小島貞興#ffffff|擊敗#0000ff|蜂須賀政勝#ffffff|,敗陣者損失了#ff8000|75#ffffff|的金錢"
    ]
    return @_str[@_idx+=1]
  end
end