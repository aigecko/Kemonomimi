#coding: utf-8
class ParaString
  def initialize(*ary)
    case ary.size
    when 4
      @string,target,@color,@font_size= *ary
      
      @draw_x=target.position.x-(@string.size*@font_size>>2)
      @draw_y=430-target.position.y-target.position.z/2-target.pic_h
      @direct=rand(5)-2
    when 5
      @string,target,@direct,@color,@font_size= *ary
      
      @draw_x=target.position.x-(@string.size*@font_size>>2)
      @draw_y=430-target.position.y-target.position.z/2-target.pic_h
    when 6
      @string,@draw_x,@draw_y,@direct,@color,@font_size= *ary
    end
    @count=0
  end
  def draw
    @draw_x+=@direct
    if @count<5
      @draw_y-=4
    elsif @count<10
      @draw_y-=3
    elsif @count<15
      @draw_y-=2
    elsif @count<20
      @draw_y-=1
    elsif @count<25
      return true
    end
    Font.draw_texture(@string,@font_size,
                    @draw_x,@draw_y,
                    *@color)
    @count+=1
    return false
  end
end