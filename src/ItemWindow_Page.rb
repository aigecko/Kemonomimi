#coding: utf-8
class ItemWindow::Page
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
    
    case @title
    when '裝備'
      @click_proc=->{
        if @click_box
          Game.player.wear_equip(*convert_position)
          @click_box=nil
        end
      }
    when '消耗'
      @click_proc=->{
        player=Game.player
        pack=@boxes[convert_position]
        pack.item or return
        pack.item.use(player,player,*Game.window(:GameWindow).convert_position)
        pack.num-=1
        if pack.num==0
          pack.item=nil
        end
      }
    else
      @click_proc=->{}
    end
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
  def check_click(x,y,offset)
    if check_click_title(x,y)
      return true
    elsif check_cilck_window(x,y)
      box_x=(x-@x-1)/27
      box_y=(y-@y-1)/27
      if box_x+box_y*5<@boxes.size
        if check_double_click(box_x,box_y)
          @click_proc.call
         
          @click_box=nil
          @first_click_time=nil
        else            
          @click_box=Position.new(box_x,box_y+offset/5,nil)
          if (box=@boxes[convert_position])&&
             (!box.respond_to?(:empty? )||!box.empty?)
            @first_click_time=SDL.get_ticks
            @drag=true
          else
            @first_click_time=nil
            @click_box=nil              
            @drag=false
          end
        end
      else
        @click_box=nil
      end
      return false #don't change page
    else
      return false
    end
  end
  def end_drag(x,y,offset)
    @drag or return
    box_x=((x-@x-1)/27).confine(0,4)
    box_y=((y-@y-1)/27).confine(0,9)
    box_idx=box_x+box_y*5+offset
    if @boxes[box_idx].respond_to?(:item)&&
       !@boxes[box_idx].empty?
       #@boxes[convert_position].respond_to?(:num)
      @boxes.add(box_idx,convert_position)
    elsif @boxes[box_idx]&&!@boxes[box_idx].respond_to?(:empty? )&&
          @boxes[convert_position]
      @boxes.exchange(box_idx,convert_position)
    else
      @boxes.swap(box_idx,convert_position)
    end
    @click_box.x=box_x
    @click_box.y=box_y+offset/5
    @drag=false
  end
  def stop_drag
    @drag=false
    @click_box=nil
  end
  def check_double_click(box_x,box_y)
    @first_click_time&&
    @first_click_time+0.22.to_sec>SDL.get_ticks&&
    @click_box.x==box_x&&
    @click_box.y==box_y&&
    @boxes[convert_position]
  end
  def check_click_title(x,y)
    x.between?(@title_back_x,@title_back_x+@title_w)&&
    y.between?(@title_back_y,@title_back_y+@title_h)
  end
  def check_cilck_window(x,y)
    x.between?(@x+1,@x+135)&&
    y.between?(@y+1,@y+@h-1)&&
    @boxes&&@select
  end
  def cancel_item_tag
    @click_box=nil
  end
  def convert_position
    @click_box and
    @click_box.x+@click_box.y*5
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
  def draw_page(offset)
    if @click_box
      box_draw_x=@x+@click_box.x*27+1
      box_draw_y=@y+(@click_box.y-offset/5)*27+1
      Screen.fill_rect(box_draw_x,box_draw_y,26,26,Color[:click_box_back])
    end
    @boxes and
    @boxes[offset,50].each_with_index{|item,n|
      item or next
      col=n%5
      row=n/5
      item_draw_x=@x+col*27+2
      item_draw_y=@y+row*27+2
      if item.respond_to? :num
        item.item or next
        item.draw(item_draw_x,item_draw_y)
        case item.num
        when 0...10
          offset_x=16
        when 10...100
          offset_x=8
        when 100...1000
          offset_x=0
        end
        Font.draw_solid(item.num.to_s,12,item_draw_x+offset_x,item_draw_y+13,*Color[:item_count_font])
      else
        item.draw(item_draw_x,item_draw_y)
      end
    }
    if @click_box&&(item=@boxes[*convert_position])
      if item.respond_to? :num
        item.item or return
        item=item.item
      end
      draw_x=@x
      draw_y=box_draw_y
      if @click_box.y*5-offset>=25
        draw_y=item.draw_detail(draw_x,draw_y,:above)
      else
        draw_y=item.draw_detail(draw_x,draw_y,:below)
      end
      item.draw_comment(draw_x,draw_y)
    end
  end
end