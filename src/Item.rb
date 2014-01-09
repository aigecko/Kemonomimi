#coding: utf-8
class Item
  attr_reader :position,:superposed,:name    
  @@rect_alpha=220    
  @@low_bound=350
  def initialize(name,pic,price,comment,args={})
    @name=name
    @price=price
    begin
      @pic=Icon.load("./rc/icon/#{pic}")
    rescue
      Message.show(:equip_pic_load_failure)
      puts "pic=#{pic}"
      exit
    end    
    @onground=args[:onground]
    @position=Position.new(args[:x]||0,0,args[:z]||0)
    
    @superposed=true
        
    @font_size=12
    @name_size=15
    
    @comment=ColorString.new(comment,@font_size,Color[:item_comment_font],7)
    
    @rect_w=85
    @rect_h=28+@comment.h
  end
  def pickup
    @onground=false
  end
  def under_cursor?(offset_x)
    draw_x,draw_y,* =Mouse.state
    x=draw_x-@draw_x+offset_x
    y=draw_y-@draw_y    
    if x.between?(0,@pic.w)&&
       y.between?(0,@pic.h)&&
       @pic[x,y]!=@pic.colorkey
      return true
    else
      return false
    end
  end
  def draw(*args)
    if @onground
      @draw_x=@position.x-@pic.w/2
      @draw_y=Map.h-@position.y-@position.z/2
      args[0].draw_ellipse(@position.x,@draw_y+@pic.h,10,5,Color[:shadow],true,false,150)
      @pic.draw(@draw_x,@draw_y,args[0])
    else
      @pic.draw(*args)
    end
  end
  def draw_detail(x,y)
    y>@@low_bound and y=@@low_bound
    Screen.draw_rect(x,y,@rect_w,@rect_h,Color[:item_rect_back],true,@@rect_alpha)
    Font.draw_solid(@name,@font_size,x,y,*Color[:item_name_font])
    return y+14
  end
  def draw_comment(x,y)
    @comment.draw(x,y)
  end
end