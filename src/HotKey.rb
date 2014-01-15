#coding: utf-8
class<<(class HotKey;self;end)
  attr_accessor :bind_mode
  def init
    @hotkey={}
    @object={}
    @active={}
  end
  def bind(key,type,trigger,value)
    @hotkey[key]=[type,trigger,value]
    @object[value]=key
  end
  def turn_on(key)
    @bind_mode and return
    @hotkey[key] and
    @active[key]=@hotkey[key]
  end
  def turn_off(key)
    @active.delete(key)
  end
  def all_off
    @bind_mode=false
    @active={}
  end
  def update
    @bind_mode and return
    @active.each{|key,pack|
      type,trigger,value=pack
      case type
      when :shoot,:active
        position=Game.window(:GameWindow).convert_position and
        Game.player.cast(value,nil,*position)
      when :switch_auto,:switch_append
        position=Game.window(:GameWindow).convert_position and
        Game.player.cast(value,nil,*position)
        @active.delete(key)
      when :proc
        value.call
      end
      
      case trigger
      when :once
        @active.delete(key)
      when :repeat        
      end
    }
  end
  def can_bind?(key)
    return key.between?(Key::A,Key::Z)
  end
end