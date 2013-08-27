#coding: utf-8
class Actor  
  class ActorAni
    def initialize(pics)
      @pic=[]
	  pics.to_sym and pics=[pics]
	  pics.each{|name|
	    @pic<<Database.get_actor_pic(name)
	  }
 	  @idx=0
      @face=:right
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
    def draw(pos,dst)
      draw_x=pos.x-@pic[@idx][@face].w/2
      draw_y=@@map_h-pos.y-pos.z/2-@pic[@idx][@face].h+30+1
      @pic[@idx][@face].draw(draw_x,draw_y,dst)
	end
    def draw_hpbar(pos,percent,dst)
      bar_w=40
      bar_h=6
      draw_x=pos.x-bar_w/2
      draw_y=@@map_h-pos.y-pos.z/2+30+1
      dst.fill_rect(draw_x-1,draw_y,bar_w+1,bar_h+1,[0,0,0])
      dst.fill_rect(draw_x,draw_y+1,bar_w*percent,bar_h-1,[255,0,0])
    end
    
    def self.set_map_size(w,h)
      @@map_w=w
      @@map_h=h
    end
  end  
end