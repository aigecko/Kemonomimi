#coding: utf-8
class Actor::ActorAni
  require_relative 'Actor_ActorAniSingleton'
  @@hpbar_color_back=Color[:actor_hpbar_back]
  @@hpbar_ske=Rectangle.new(0,0,42,6,@@hpbar_color_back)
  @@hpbar_bar=Rectangle.new(0,0,40,4,@@hpbar_color_back)
  @@mag_shield_bar=Rectangle.new(0,0,40,2,[128,0,128])
  @@atk_shield_bar=Rectangle.new(0,0,40,2,[255,255,255])
  def initialize(pics)
    @pics=pics
    pic_initialize
    
    @idx=0
    @face=:right
  end
  def pic_initialize
    @pic=[]
    @pics.respond_to? :each or @pics=[@pics]
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
    return x.between?(0,pic.w)&&
       y.between?(0,pic.h)&&
       pic[x,y]!=pic.colorkey
  end
  def draw(pos)
    @draw_x=pos.x-@pic[@idx][@face].w/2
    @draw_y=@@map_h-pos.y-pos.z/2-@pic[@idx][@face].h+30+1
    @pic[@idx][@face].draw(@draw_x,@draw_y,pos.z)
  end
  def draw_hpbar(pos,attrib)
    draw_x=pos.x-20
    draw_y=@@map_h-pos.y-pos.z/2-@pic[@idx][@face].h+15
    draw_z=pos.z
    
    ash_percent=attrib[:atk_shield]/attrib[:maxhp].to_f
    msh_percent=attrib[:mag_shield]/attrib[:maxhp].to_f
    hp_percent=attrib[:hp]/attrib[:maxhp].to_f
    
    if ash_percent+msh_percent>1.0
      shield_sum=attrib[:atk_shield]+attrib[:mag_shield]
      ash_percent=attrib[:atk_shield]/shield_sum.to_f
      msh_percent=1-ash_percent
    end
    @@mag_shield_bar.w=40*msh_percent
    @@mag_shield_bar.draw_at(draw_x,draw_y+1,draw_z)
    @@atk_shield_bar.w=40*ash_percent
    atk_draw_x=draw_x+40*msh_percent
    @@atk_shield_bar.draw_at(atk_draw_x,draw_y+1,draw_z)
    
    @@hpbar_bar.w=40*hp_percent
    @@hpbar_bar.color=[255*(1-hp_percent),255*hp_percent,0]
    @@hpbar_bar.draw_at(draw_x,draw_y+1,draw_z)
    @@hpbar_ske.draw_at(draw_x-1,draw_y,draw_z)
  end
  def marshal_dump
    return [{
      :p=>@pics,:i=>@idx,:f=>@face
    }]
  end
  def marshal_load(array)
    data=array[0]
    @pics=data[:p]
    pic_initialize
    @idx=data[:i]
    @face=data[:f]
  end
end