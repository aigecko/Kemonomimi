#coding: utf-8
require_relative './StatementSet'
class Actor::State
  def initialize(actor)
    @state={}
    bind_actor(actor)
  end
  def bind_actor(actor)
    @actor=actor
  end
  def add(state)
    
    @state[state.sym]||=StatementSet.new
    case state.multi
    when :refresh
      state_list=@state[state.sym]
      state_list.size<state.num_limit and state_list<<state
      state_list.each{|state| state.refresh}
    when :add
      @state[state.sym]<<state
    when nil
      @state[state.sym].empty? or
      @actor.attrib.lose_state_attrib(@state[state.sym].attrib)
    
      @state[state.sym].replace(state)
    end
    @actor.attrib.gain_state_attrib(state.attrib)
  end
  def include?(name)
    @state[name]
  end
  def has_flag(name)
    @state.each_value{|state|
      state.flag.include?(name) and return true
    }
    return false
  end
  def keep_if
    @state.keep_if{|sym,state| yield state}
  end
  def delete(sym)
    state_list=@state[sym] or return
    state_list.each{|state|
      @actor.attrib.lose_state_attrib(state.attrib)
    }
    @state.delete(sym)
  end
  def update
    @state.reject!{|_,state|
      state.reject!{|s|
        if s.end?
          @actor.attrib.lose_state_attrib(s.attrib)
          true
        end
      }
      state.empty?
    }
    @state.each_value{|state|
      state.each{|st| st.update(@actor)}
    }
  end
  def draw(x,y,mx,my)
    n=0
    @state.each_value{|state|
      state.empty? and next
      state=state[-1]
      state.draw_icon(x+n*30,y,mx,my)
      n+=1
    }
  end
  def marshal_dump
    return [@state]
  end
  def marshal_load(array)
    @state=array[0]
  end
end
