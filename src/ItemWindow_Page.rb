#coding: utf-8
class ItemWindow::Page
  attr_accessor :boxes
  @@box_row_num=5
  def initialize(name,x,y,idx)
    @title=name
    @title_pic=Font.render_texture(@title,15,*Color[:item_tag_font])
    @idx=idx
    
    @w=148
    @h=271
    
    @title_w=@w/4
    @title_h=15
    update_coord(x,y)

    @box_w=@box_h=26
    @w_with_edge=@h_with_edge=27
    @box_limit=100
    @box_draw_n=50
    @box_draw_half_n=@box_draw_n/2
    @boxes

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
    
    @title_focus||=Rectangle.new(
      @title_back_x,@title_back_y,@title_w,@title_h,Color[:item_tag_focus])
    @title_normal||=Rectangle.new(
      @title_back_x,@title_back_y,@title_w,@title_h,Color[:item_tag_normal])
    
    @title_focus.x=@title_normal.x=@title_back_x
    @title_focus.y=@title_normal.y=@title_back_y
    
    @title_font_x=@title_back_x+(@w/4-@title_pic.w)/2
    @title_font_y=y
  end
  def check_click(x,y,offset)
    if check_click_title(x,y)
      return true
    elsif check_cilck_window(x,y)
      box_x=(x-@x-1)/@w_with_edge
      box_y=(y-@y-1)/@h_with_edge
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
    box_x=((x-@x-1)/@w_with_edge).confine(0,4)
    box_y=((y-@y-1)/@h_with_edge).confine(0,9)
    box_idx=box_x+box_y*@@box_row_num+offset
    if @boxes[box_idx].respond_to?(:item)&&
       !@boxes[box_idx].empty?
      @boxes.add(box_idx,convert_position)
    elsif @boxes[box_idx]&&!@boxes[box_idx].respond_to?(:empty? )&&
          @boxes[convert_position]
      @boxes.exchange(box_idx,convert_position)
    else
      @boxes.swap(box_idx,convert_position)
    end
    @click_box.x=box_x
    @click_box.y=box_y+offset/@@box_row_num
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
    @click_box.x+@click_box.y*@@box_row_num
  end
  def draw_title
    if @select
      @title_focus.draw
    else
      @title_normal.draw
    end
    @title_pic.draw(@title_font_x,@title_font_y)
  end
  def draw_back(dst)
    dst.fill_rect(10,21+@title_h,@w,@h,Color[:item_page])
  end
  def draw_boxes(dst)
    @box_draw_n.times{|n|
      col=n% @@box_row_num
      row=n/ @@box_row_num
      draw_x=col*@w_with_edge+10+1
      draw_y=row*@h_with_edge+21+@title_h+1
      dst.fill_rect(draw_x,draw_y,@box_w,@box_h,Color[:item_box])
    }
  end
  def draw_page(offset)
    if @click_box
      box_draw_x=@x+@click_box.x*@w_with_edge+1
      box_draw_y=@y+(@click_box.y-offset/@@box_row_num)*@h_with_edge+1
      @click_box_back||=Rectangle.new(
        box_draw_x,box_draw_y,@box_w,@box_h,Color[:click_box_back])
      @click_box_back.draw_at(box_draw_x,box_draw_y)
    end
    @boxes and
    @boxes[offset,@box_draw_n].each_with_index{|item,n|
      item or next
      col=n% @@box_row_num
      row=n/ @@box_row_num
      item_draw_x=@x+col*@w_with_edge+2
      item_draw_y=@y+row*@h_with_edge+2
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
        Font.draw_texture(item.num.to_s,12,
          item_draw_x+offset_x,item_draw_y+13,*Color[:item_count_font])
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
      if @click_box.y*@@box_row_num-offset>=@box_draw_half_n
        draw_y=item.draw_detail(draw_x,draw_y,:above)
      else
        draw_y=item.draw_detail(draw_x,draw_y,:below)
      end
      item.draw_comment(draw_x,draw_y)
    end
  end
end