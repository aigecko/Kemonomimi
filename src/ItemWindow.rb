#coding: utf-8
class ItemWindow < DragWindow
  require_relative 'ItemWindow_MoneyBar'
  require_relative 'ItemWindow_DragBar'
  require_relative 'ItemWindow_Page'
  def initialize
    win_w,win_h=167,340
    win_x,win_y=200,50
    super(win_x,win_y,win_w,win_h)
    
    @page_list=[:consum,:equip,:other,:mission]
    @page_name={
      consum:'消耗',
      equip:'裝備',
      other:'物品',
      mission:'任務'
    }
    @page_init_x=->{@win_x+@border}
    @page_init_y=->{@win_y+21}
    @pages={}
    @page_list.each_with_index{|sym,i|
      @pages[sym]=Page.new(@page_name[sym],@page_init_x.call,@page_init_y.call,i)
    }
    
    @current=:consum
    @pages[@current].tag
    
    @dragbar_init_x=->{@win_x+146}
    @dragbar_init_y=->{@win_y+37}
    @drag_bar=DragBar.new(@dragbar_init_x.call,@dragbar_init_y.call)
    
    @moneybar_init_x=->{@win_x+@border}
    @moneybar_init_y=->{@win_y+308}
    @money_bar=MoneyBar.new(@moneybar_init_x.call,@moneybar_init_y.call)
    
    skeleton_initialize
    title_initialize('道具物品')
    gen_skeleton_texture
  end
  def interact
    Event.each{|event|
      case event
      when Event::MouseButtonDown
        case event.button
        when Mouse::BUTTON_LEFT
          @drag_bar.check_click(event.x,event.y)
          @pages.each{|name,page| 
            page.check_click(event.x,event.y,@drag_bar.offset) or next
            @current=name
            @drag_bar.reinit
            page.tag
            break
          }
          @pages.each{|name,page|
            unless @current==name
              page.untag
            end
          }
        when Mouse::BUTTON_RIGHT
        end
      when Event::MouseMotion
        keep_drag(event.x,event.y)
        bar_drag(event.x,event.y)
      when Event::MouseButtonUp
        case event.button
        when SDL::Mouse::BUTTON_LEFT
          end_drag
          @drag_bar.end_drag(event.x,event.y)
          @pages[@current].end_drag(event.x,event.y,@drag_bar.offset)
        end
      end
    }
  end
  def start_init
    player=Game.player
    @pages[:equip].boxes=player.equip_list
    @pages[:consum].boxes=player.comsumable_list
    @pages[:other].boxes=player.item_list
    @pages[:mission].boxes=player.pledge_list
  end
  def update_coord
    super
    @pages.each_value{|page| page.update_coord(@page_init_x.call,@page_init_y.call)}
    @drag_bar.update_coord(@dragbar_init_x.call,@dragbar_init_y.call)
    @money_bar.update_coord(@moneybar_init_x.call,@moneybar_init_y.call)
  end
  def close
    super
    @drag_bar.stop_drag
    @pages[@current].stop_drag
  end
  def bar_drag(x,y)
    @drag_bar.drag(x,y) and @pages[@current].cancel_item_tag
  end
  def draw
    super
    @pages[@current].draw_back
    @pages[@current].draw_boxes
    @drag_bar.draw
    @pages[@current].draw_page(@drag_bar.offset)
    @pages.each_value{|page| page.draw_title}
    @money_bar.draw
  end
end