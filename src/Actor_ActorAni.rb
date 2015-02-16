#coding: utf-8
class Actor::ActorAni
  require_relative 'Actor_ActorAniSingleton'
  @@hpbar_color_back=Color[:actor_hpbar_back]
  def initialize(pics,actor)
    @pics=pics
    pic_initialize
    
    @idx=0
    @face=:right
    
    @hpbar_color=Color[:"#{actor}_hpbar"]
  end
  def pic_initialize
    @pic=[]
    @pics.to_sym and @pics=[@pics]
    @pics.each{|name|
      @pic<<Database.get_actor_pic(name)
    }
  end
  def side
    return @face
  end
  def rotate(side)
    @face=side
  end
  def w
    return @pic[@idx][@face].w
  end
  def h
    return @pic[@idx][@face].h
  end
  def under_cursor?(offset_x)
    draw_x,draw_y,* =Mouse.state
    x=draw_x-@draw_x+offset_x
    y=draw_y-@draw_y
    pic=@pic[@idx][@face]
    if x.between?(0,pic.w)&&
       y.between?(0,pic.h)&&
       pic[x,y]!=pic.colorkey
      return true
    else
      return false
    end
  end
  def draw(pos,dst)
    @draw_x=pos.x-@pic[@idx][@face].w/2
    @draw_y=@@map_h-pos.y-pos.z/2-@pic[@idx][@face].h+30+1
    @pic[@idx][@face].draw(@draw_x,@draw_y,dst)
  end
  def draw_hpbar(pos,percent,dst)
    bar_w=40
    bar_h=4
    draw_x=pos.x-bar_w/2
    draw_y=@@map_h-pos.y-pos.z/2-@pic[@idx][@face].h+15
    dst.draw_rect(draw_x-1,draw_y,bar_w+2,bar_h+2,@@hpbar_color_back,true,255)
    dst.draw_rect(draw_x,draw_y+1,bar_w*percent,bar_h,@hpbar_color,true,255)
  end
  def marshal_dump
    return [{
      :p=>@pics,:i=>@idx,:f=>@face,
      :c=>Color.find(@hpbar_color)
    }]
  end
  def marshal_load(array)
    data=array[0]
    @pics=data[:p]
    @idx=data[:i]
    @face=data[:f]
    @hpbar_color=Color[data[:c]]
  end
end