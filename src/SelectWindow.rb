 #coding: utf-8
class SelectWindow < BaseWindow
  def initialize(x,y,w,h)
    super(x,y,w,h)
    @select=0
    word_init
  end
private
  def word_init
    @comment_size=15
  
    @Comment=Hash.new("")
    @Comment={
      back:"shift:返回主選單",
      escape:"esc:離開",
      check:"enter/space:確定",
      
      save:"shift:返回主選單並儲存設定",
      change:"enter/space:變更"
      
    }
    @Comment[:default]=get_comment(:back,:escape,:check)
  end
public
  def title_initialize(text)
    @title=text
    @title_pic=Font.render_texture(@title,@font_size,*Color[:title])
  end
  def select_pic_initialize(list)
    pic=Hash.new([])
    @select_cache={}
    list.each{|key,val|
      @select_cache[val]=[
        Font.render_texture(val,@font_size,*Color[:normal_select]),
        Font.render_texture(val,@font_size,*Color[:focused_select])]
      pic[key]=@select_cache[val]
    }    
    @w_long=0
    pic.each_value{|p| p[0].w>@w_long and @w_long=p[0].w}
    @select_draw_x=@win_x+(@border<<1)
    @select_draw_y=@win_y+(@border<<2)
    return pic
  end
  def detail_pic_initialize(detail)
    pic=Hash.new
    detail.each{|klass,words|
      pic[klass]=ColorString.new(words,@font_size,Color[:text])
    }
    @detail_draw_x=@win_x+@w_long+(@border<<2)
    @detail_draw_y=@win_y+(@border<<2)
    return pic
  end
  def comment_initialize(*ary)
    @comment=get_comment(*ary)
    @comment_pic=Font.render_texture(@comment,@comment_size,*Color[:comment])
    
    @cmt_draw_x=@win_x+@border
    @cmt_draw_y=@win_y+@win_h-@comment_pic.h-@border
  end
 
  def get_comment(*ary)
    str=""
    for sym in ary
      str<<@Comment[sym]<<", "
    end
    str.chop!
    str.chop!
    return str
  end
  def check_select_index(list_pic,table)
    mouse_x,mouse_y,* =SDL::Mouse.state
    pic_check_x=@select_draw_x
    pic_check_y=@select_draw_y
    pic_limit=table.size-1
    pic=list_pic[table[0]][0]
    if mouse_x.between?(pic_check_x,pic_check_x+pic.w)&&
       mouse_y.between?(pic_check_y,pic_check_y+pic.h*table.size)
      index=(mouse_y-pic_check_y)/pic.h
      @select=index
      return index
    end
    return nil
  end
  def draw_comment
    @comment_pic.draw(@cmt_draw_x,@cmt_draw_y)
  end
  def draw_title
    @title_pic.draw(@win_x+@border,@win_y+@border)
  end
  def draw_select_detail(list_pic,text_pic,table)
    pic_draw_x=@select_draw_x
    pic_draw_y=@select_draw_y
    pic_limit=table.size-1
    for i in 0..pic_limit
      if i==@select
        pic=list_pic[table[i]][1]
      else
        pic=list_pic[table[i]][0]
      end
      pic.draw(pic_draw_x,pic_draw_y)
      pic_draw_y+=pic.h
    end
    text=text_pic[table[@select]]
    text and text.draw(@detail_draw_x,@detail_draw_y)
  end
  def draw_select(list_pic,table)
    pic_draw_x=@select_draw_x
    pic_draw_y=@select_draw_y
    pic_limit=table.size-1
    for i in 0..pic_limit
      if i==@select
        pic=list_pic[table[i]][1]
      else
        pic=list_pic[table[i]][0]
      end
      pic.draw(pic_draw_x,pic_draw_y)
      pic_draw_y+=pic.h
    end
  end
end