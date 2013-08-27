#coding: utf-8
class Actor
  class State
    def initialize
      @state={}
    end
    def add(actor,state)      
      @actor||=actor
      
      if @state[state.sym]
        @actor.attrib.lose_state_attrib(state.attrib)
      end
      @state[state.sym]=state
      @actor.attrib.gain_state_attrib(state.attrib)
    end
    def update
    @state.reject!{|_,state|
      if state.end?
        @actor.attrib.lose_state_attrib(state.attrib)
        true
      else
        false
      end
    }
    end
    def draw(x,y)
      n=0
      @state.each_value{|state|
        state.draw_icon(x+n*30,y)
        n+=1
      }
    end
  end
end
