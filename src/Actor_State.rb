#coding: utf-8
require 'pp'
class Actor
  class State
    def initialize(actor)
      @state={}
      @actor=actor
    end
    def add(state)
      if multi_type=state.multi        
        @state[state.sym]||=[]
        case multi_type
        when :refresh
          state_list=@state[state.sym]
          state_list.size<state.num_limit and state_list<<state
          state_list.each{|state| state.refresh}
        when :add
          @state[state.sym]<<state
        end
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
    def delete(sym)
      state_list=@state[sym] or return
      if state_list.respond_to? :each
        state_list.each{|state|
          @actor.attrib.lose_state_attrib(state.attrib)
        }
      else
        @actor.attrib.lose_state_attrib(state_list.attrib)
      end
      @state.delete(sym)
    end
    def update
      @state.reject!{|_,state|
        if state.respond_to? :reject!
          state.reject!{|s|
            if s.end?              
              @actor.attrib.lose_state_attrib(s.attrib)
              true
            end
          }
          state.empty?
        else
          if state.end?
            @actor.attrib.lose_state_attrib(state.attrib)
            true
          end
        end
      }
      @state.each_value{|state|
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
