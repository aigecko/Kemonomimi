#coding: utf-8
class ItemWindow < DragWindow
  class DragBar
    def initialize(x,y)
	  update_coord(x,y)
	  @w=11
	  @h=268
	  @rect_w=9
	  @rect_h=132#266 #or 132
      
      @offset_y=0
      @last_y=0      
	end
	def reinit
      @offset_y=0
	end
	def check_click(x,y)
      @click and return
      if x.between?(@x,@x+@rect_w)&&
         y.between?(@y+@offset_y,@y+@offset_y+@rect_h+@offset_y)
        @click=true
        
        @last_y=y
      end
	end
	def drag(x,y)
      @click or return            
      update_offset(x,y)
	end
	def end_drag(x,y)
      @click or return
      @click=false      
      update_offset(x,y)
	end
    def update_offset(x,y)
      @offset_y+=y-@last_y
      @last_y=y    
      @offset_y<0 and @offset_y=0
      @rect_h==132 and @offset_y>132 and @offset_y=132
      @rect_h==266 and @offset_y=0
    end
	def update_coord(x,y)
      @x=x
      @y=y
      
      @rect_x=@x+1
      @rect_y=@y+1      
	end
	def draw
	  Screen.fill_rect(@x,@y,@w,@h,Color[:item_drag_bar_back])
	  Screen.fill_rect(@rect_x,@rect_y+@offset_y,@rect_w,@rect_h,Color[:item_drag_bar])
	end
  end
  class Page
    attr_accessor :boxes
    def initialize(name,x,y,idx)
      @title=name
      @title_pic=Font.render_solid(@title,15,*Color[:item_tag_font])
      @idx=idx
      
      @w=148
      @h=271
      update_coord(x,y)
      
      @box_limit=100
      @box_draw_n=50
      @boxes
      
      @title_w=@w/4
      @title_h=15
    end
    def tag
      @select=true
    end
    def untag
      @select=false
    end
    def update_coord(x,y)
      @x=x
      @y=y+@title_pic.h
      
      @title_back_x=@x+@w*@idx/4
      @title_back_y=y
      
      @title_font_x=@title_back_x+(@w/4-@title_pic.w)/2
      @title_font_y=y
    end
    def check_click(x,y)
	  if x.between?(@title_back_x,@title_back_x+@title_w)&&
	     y.between?(@title_back_y,@title_back_y+@title_h)
		return true
      elsif x.between?(@x+1,@x+135)&&
            y.between?(@y+1,@y+270)&&
            @boxes&&@select
        box_x=(x-@x-1)/27
        box_y=(y-@y-1)/27
        if box_x+box_y*5<@boxes.size
          if @first_click_time&&
             @first_click_time+0.22.to_sec>SDL.get_ticks&&
             @click_box[0]==box_x&&
             @click_box[1]==box_y
            wear_equip
            @click_box=nil
            @first_click_time=nil
          else
            @first_click_time=SDL.get_ticks
            @click_box=[box_x,box_y]
          end
        else
          @click_box=nil
        end
        return false #don't change page
	  else
	    return false
	  end
	end
    def wear_equip
      if @click_box
        Game.player.wear_equip(@click_box[0]+@click_box[1]*5)
        @click_box=nil
      end
    end
	def draw_title
      if @select
        Screen.fill_rect(@title_back_x,@title_back_y,@title_w,@title_h,Color[:item_tag_focus])
      else
        Screen.fill_rect(@title_back_x,@title_back_y,@title_w,@title_h,Color[:item_tag_normal])
      end
      @title_pic.draw(@title_font_x,@title_font_y)
    end
    def draw_back(dst=Screen.render)
      dst.fill_rect(@x,@y,@w,@h,Color[:item_page])
    end
    def draw_boxes(dst=Screen.render)
      @box_draw_n.times{|n|
        col=n%5
        row=n/5
        dst.fill_rect(@x+col*27+1,@y+row*27+1,26,26,Color[:item_box])
      }
    end
    def draw_page      
      @click_box and 
      Screen.fill_rect(@x+@click_box[0]*27+1,@y+@click_box[1]*27+1,26,26,Color[:click_box_back])
      @boxes and
      @boxes.each_with_index{|equip,n|
        col=n%5
        row=n/5
        equip.draw(@x+col*27+2,@y+row*27+2)
      }
    end
  end
  def initialize
    win_w,win_h=167,320
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
	@dragbar_init_y=->{@win_y+38}
	@drag_bar=DragBar.new(@dragbar_init_x.call,@dragbar_init_y.call)
	
    title_initialize('道具物品')
    pic_initialize
  end
  def interact
    Event.each{|event|
      case event
      when Event::MouseButtonDown
	    @pages.each{|name,page| 
		  if page.check_click(event.x,event.y)
		    @current=name
            @drag_bar.reinit
            page.tag
		    break
		  end
		}
        @pages.each{|name,page|
          unless @current==name
            page.untag
          end
        }
		@drag_bar.check_click(event.x,event.y)
      when Event::MouseMotion
        keep_drag(event.x,event.y)
		bar_drag(event.x,event.y)
      when Event::MouseButtonUp
        case event.button
        when SDL::Mouse::BUTTON_LEFT
          end_drag
		  @drag_bar.end_drag(event.x,event.y)
        end
      when Event::KeyDown
        case event.sym
        when Key::W
          @current==:equip and
          @pages[@current].wear_equip
        end
      end
    }
  end
  def start_init
    player=Game.player
    @pages[:equip].boxes=player.equip_list
    @pages[:consum].boxes=player.item_list
  end
  def update_coord
    super
    @pages.each_value{|page| page.update_coord(@page_init_x.call,@page_init_y.call)}
	@drag_bar.update_coord(@dragbar_init_x.call,@dragbar_init_y.call)
  end
  def bar_drag(x,y)
    @drag_bar.drag(x,y)
  end
  def draw(dst)
    super(dst)
    @pages[@current].draw_back(dst)
    @pages[@current].draw_boxes(dst)
    draw_title(dst)    
    def draw      
      @skeleton.draw(@win_x,@win_y)
      @pages[@current].draw_page
      #@pages[@current].tag
      @pages.each_value{|page| page.draw_title}
	  @drag_bar.draw
    #@pages.each{|page| page.draw}
    end
  end
end