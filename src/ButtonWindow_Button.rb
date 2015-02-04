#coding: utf-8
class ButtonWindow::Button
  @@icon_w=@@icon_h=24
  @@rect_w=@@rect_h=26
  def initialize(icon,x,y)
    @icon,@x,@y=icon,x,y
    
    draw_up=@y-1
    draw_left=@x-1
    draw_down=draw_up+@@rect_h
    draw_right=draw_left+@@rect_w
    
    @lines=[
      Line.new(draw_left,draw_up,draw_right,draw_up),
      Line.new(draw_left,draw_up,draw_left,draw_down),
      Line.new(draw_left,draw_down,draw_right,draw_down),
      Line.new(draw_right,draw_down,draw_right,draw_up) 
    ]
  end
  def select?(x,y)
    return x.between?(@x,@x+@@icon_w)&&
      y.between?(@y,@y+@@icon_h)
  end
  def draw
    @icon.draw(@x,@y)
  end
  def draw_select(click)
    if click
      color_up_left=Color[:icon_dark]
      color_down_right=Color[:icon_light]
    else
      color_up_left=Color[:icon_light]
      color_down_right=Color[:icon_dark]
    end
    @lines[0].color=@lines[1].color=color_up_left
    @lines[2].color=@lines[3].color=color_down_right
    @lines.each{|line| line.draw}
  end
end
 