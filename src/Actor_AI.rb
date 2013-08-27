#coding: utf-8
class Actor
  class AI
    def self.init
      @proc=Hash.new
      @proc[:cycle]=->(actor){
        actor.var[:degree]||=0        
        actor.var[:degree]+=1
        actor.set_move_dst(Game.player.position.x+Math.cos(actor.var[:degree])*200,
                           nil,
                           Game.player.position.z+Math.sin(actor.var[:degree])*200)
      }
      @proc[:sidemove]=->(actor){
        actor.var[:w]||=400
        actor.var[:h]||=50
        unless actor.moving?
          actor.set_move_dst(actor.position.x+rand(actor.var[:w])-actor.var[:w]/2,
                             nil,
                             actor.position.z+rand(actor.var[:h])-actor.var[:h]/2)
        end
      }
    end
    def self.render(type)
      unless @proc[type]
        Message.show(:ai_fetch_failure)
        Message.show_format("AI選擇了不存在的 %s ","錯誤",:ERROR,binding,:type)
        exit
      end
      @proc[type]
    end
  end
end