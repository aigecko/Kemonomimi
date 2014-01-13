#coding: utf-8
class<<(class HotKey;self;end)
  def init
    @hotkey={}
  end
  def bind(key,value)
    @hotkey[key]=value
  end
  def can_bind?(key)
    return key.between?(Key::A,Key::Z)
  end
end