#coding: utf-8
class Item
  attr_reader :superposed,:name,:id,:pic
  @@LowBound=350
  @@FontSize=12
  @@RectW=135
  def initialize(name,pic,price,comment,args={})
    @name=name
    @id=args[:id]
    
    @price=price
    begin
      @pic=Input.load_icon("./rc/icon/#{pic}")
    rescue SDL::Error=> e
      p e
      Message.show(:equip_pic_load_failure)
      puts "pic=#{pic}"
      exit
    rescue =>e
      p e
      Message.show_backtrace(e)
      exit
    end
    
    @superposed=true
    @comment=ColorString.new(comment,@@FontSize,Color[:item_comment_font],11)
    
    @rect_h=28+@comment.h
    @rect_back=Rectangle.new(0,0,@@RectW,@rect_h,Color[:item_rect_back])
  end
  def drop
    return OnGroundItem.new(self)
  end
  def draw(*args)
    @pic.draw(*args)
  end
  def draw_detail(x,y,direct)
    y>@@LowBound and y=@@LowBound
    case direct
    when :above
      y-=@rect_h+1
    when :below
      y+=27
    end
    @rect_back.x=x
    @rect_back.y=y
    @rect_back.draw
    y+=Font.draw_texture(@name,@@FontSize,x,y,*Color[:item_name_font])[1]
    x+=Font.draw_texture("價格：",@@FontSize,x,y,*[198,192,0])[0]
    y+=Font.draw_texture(@price.to_s,@@FontSize,x,y,*[189,133,0])[1]
    return y
  end
  def draw_comment(x,y)
    @comment.draw(x,y)
  end
  def marshal_dump
  end
  def marshal_load(array)
  end
end
require_relative 'Item/Consumable'
require_relative 'Item/Equipment'
require_relative 'Item/OnGroundItem'
require_relative 'Item/ItemArray'
require_relative 'Money'