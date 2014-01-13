#coding: utf-8
require 'pp'
class Actor
  class State
    def initialize(actor)
      @state={}
      @actor=actor
    end
    def add(state)
      if state.multi
        @state[state.sym]||=[]
        @state[state.sym]<<state
      else
        if @state[state.sym]
          @actor.attrib.lose_state_attrib(@state[state.sym].attrib)
        end      
        @state[state.sym]=state
      end
      @actor.attrib.gain_state_attrib(state.attrib)
    end
    def include?(name)
      return @state[name] ? true : false
    end
    def keep_if
      @state.keep_if{|sym,state| yield state}
    end
    def update
      @state.reject!{|_,state|
        if state.respond_to? :each
          state.reject!{|s|
            if s.end?              
              @actor.attrib.lose_state_attrib(s.attrib)
              true
            else
              false
            end
          }
          state.empty?
        else
          if state.end?
            @actor.attrib.lose_state_attrib(state.attrib)
            true
          else
            false
          end
        end
      }
      @state.each{|_,state|
        if state.respond_to? :each
          state.each{|st| st.update(@actor)}
        else
          state.update(@actor)
        end
      }
    end
    def draw(x,y)
      n=0
      @state.each_value{|state|
        if state.respond_to? :each
          if state.empty? then next end          
          state=state[-1]
        end
        state.draw_icon(x+n*30,y) and n+=1
      }
    end
  end
end
