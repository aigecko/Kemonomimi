#coding: utf-8
class Item
  attr_reader :position,:superposed,:name,:id
  @@rect_alpha=220    
  @@low_bound=350
  @@font_size=12
  @@rect_w=135
  def initialize(name,pic,price,comment,args={})
    @name=name
    @id=args[:id]
    
    @price=price
    begin
      @pic=Icon.load("./rc/icon/#{pic}")
    rescue => e
      Message.show(:equip_pic_load_failure)
      puts "pic=#{pic}"
      exit
    end    
    @onground=args[:onground]
    @position=Position.new(args[:x]||0,0,args[:z]||0)
    
    @superposed=true 
    @comment=ColorString.new(comment,@@font_size,Color[:item_comment_font],11)
    
    @rect_h=28+@comment.h
  end
  def pickup
    @onground=false
    return self
  end
  def drop
    @onground=true
    return self
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
      @pic.draw(@draw_x,@draw_y,args[0])
    else
      @pic.draw(*args)
    end
  end
  def draw_shadow(dst)    
    @draw_x=@position.x-@pic.w/2
    @draw_y=Map.h-@position.y-@position.z/2
    dst.draw_ellipse(@position.x,@draw_y+@pic.h,10,5,Color[:shadow],true,false,150)
  end
  def draw_detail(x,y,direct)
    y>@@low_bound and y=@@low_bound
    case direct
    when :above
      y-=@rect_h+1
    when :below
      y+=27
    end
    Screen.draw_rect(x,y,@@rect_w,@rect_h,Color[:item_rect_back],true,@@rect_alpha)
    y+=Font.draw_solid(@name,@@font_size,x,y,*Color[:item_name_font])[1]
    x+=Font.draw_solid("價格：",@@font_size,x,y,*[198,192,0])[0]
    y+=Font.draw_solid(@price.to_s,@@font_size,x,y,*[189,133,0])[1]
    return y
  end
  def draw_comment(x,y)
    @comment.draw(x,y)
  end
end