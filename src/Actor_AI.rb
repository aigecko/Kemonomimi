#coding: utf-8
class Actor
  class AI
    def self.init
      @proc=Hash.new
      @proc[:cycle]=->(actor){
        actor.var[:degree]||=0        
        actor.var[:degree]+=1
        dst_x=Game.player.position.x+Math.cos(actor.var[:degree])*200
        dst_x=dst_x.confine(0,Map.w)
        dst_z=Game.player.position.z+Math.sin(actor.var[:degree])*200
        dst_z=dst_z.confine(0,Map.h)
        actor.set_move_dst(dst_x,nil,dst_z)
                           
      }
      @proc[:sidemove]=->(actor){
        actor.var[:w]=400
        actor.var[:h]=50
        unless actor.moving?
          dst_x=actor.position.x+rand(actor.var[:w])-actor.var[:w]/2
          dst_x=dst_x.confine(0,Map.w)
          dst_z=actor.position.z+rand(actor.var[:h])-actor.var[:h]/2
          dst_z=dst_z.confine(0,Map.h)
          actor.set_move_dst(dst_x,nil,dst_z)                             
        else          
          dst_x=dst_z=nil
          if actor.position.x.to_i==0
            dst_x=rand(actor.var[:w])
          elsif actor.position.x.to_i==Map.w
            dst_x=rand(Map.w-actor.var[:w])
          end
          if actor.position.z.to_i==0
            dst_z=rand(actor.var[:h])
          elsif actor.position.z.to_i==Map.h
            dst_z=rand(Map.h-actor.var[:h])
          end
          actor.set_move_dst(dst_x,nil,dst_z)
        end
      }
      @proc[:none]=->(actor){}
    end
    def self.render(type)
      unless @proc[type]
        Message.show(:ai_fetch_failure)
        Message.show_format("AI選擇了不存在的 %s "%type,"錯誤",:ERROR)
        exit
      end
      @proc[type]
    end
  end
end