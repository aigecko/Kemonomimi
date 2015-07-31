#coding: utf-8
class Actor
  class AI
    class Move
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
          actor.target and return
          actor.var[:w]=400
          actor.var[:h]=50
          unless actor.moving?
            dst_x=actor.position.x+rand(actor.var[:w])-actor.var[:w]/2
            dst_x=dst_x.confine(0,Map.w)
            dst_z=actor.position.z+rand(actor.var[:h])-actor.var[:h]/2
            dst_z=dst_z.confine(0,Map.h)
            actor.set_move_dst(dst_x,nil,dst_z)
          end
        }
        @proc[:none]=->(actor){}
      end
      def self.[](type)
        return @proc[type]
      end
    end
    class Action
      def self.init
        @proc=Hash.new
        @proc[:agreesive]=->(actor){
          actor.set_target(Game.player,:chase)
        }
        @proc[:peaceful]=->(actor){
          if actor.attrib[:maxhp]>actor.attrib[:hp]
            actor.set_target(Game.player,:chase)
          end
        }
        @proc[:shoot]=->(actor){
          actor.var[:shoot_skill_list] or return
          offset_z=actor.var[:shoot_z_range]
          offset_x=actor.var[:shoot_x_range]
          actor_x=actor.position.x
          actor_y=actor.position.y
          actor_z=actor.position.z
          player_x=Game.player.position.x
          player_z=Game.player.position.z
          if (player_x-actor_x).abs<=offset_x&&
             (player_z-actor_z).abs<=offset_z
            direct=(player_x>actor_x)? 1: -1
            actor.rotate(direct)
            actor.var[:shoot_skill_list].each{|name|
              actor.cast(name,nil,actor_x,actor_y,actor_z)
            }
          end
        }
      end
      def self.[](type)
        return @proc[type]
      end
    end
  end
end
class Actor::AI
  def self.init
    Move.init
    Action.init
  end
  def self.fail_message(type)
    Message.show(:ai_fetch_failure)
    Message.show_format("AI選擇了不存在的 %s "%type,"錯誤",:ERROR)
    exit
  end
  def initialize(info)
    @move=Move[info[:move]] or  Actor::AI.fail_message(info[:move])
    @action=Action[info[:action]]||->(info){}
  end
  def call(actor)
    @move.call(actor)
    @action.call(actor)
  end
end