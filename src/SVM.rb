#coding: utf-8
class SVM
  def initialize(env)
    @OPCODE={
      new: ->(dst,klass,*arg){
        @reg[dst]=get_object(klass).new(
          *arg.collect{|str| get_object(str)}
        )
      },
      mov: ->(dst,obj){
        @reg[dst]=get_object(obj)
      },
      ary: ->(dst,*arg){
        @reg[dst]=arg.collect{|str| get_object(str)}
      },
      sub: ->(dst,num){
        @reg[dst]-=get_object(num)
      },
      siv: ->(sym,obj){
        @env.instance_variable_set(sym,get_object(obj))
      },
      giv: ->(dst,sym){
        @reg[dst]=@env.instance_variable_get(sym)
      }
    }
    @inst=[]
    @reg={}
    @env=env
  end
  def load(string)
    string.each_line{|line|
      info=line.match(/\s*(?<Label>#\w+)?\s*(?<Operator>[a-zA-Z]+)\s+(?<Dst>[a-zA-Z0-9%]+)?\s*((?<Operand>(\S+(\s*,\s*\S+)?)))?/)
      inst=[info[:Operator].to_sym]
      info[:Dst] and inst<<info[:Dst]
      inst+=info[:Operand].split(/,/)
      @inst<<inst
    }
  end
  def load_file(filename)
    File.open(filename,'r'){|file|
      load(file.read)
    }
  end
  def get_object(str)
    result=case str
    when /%\d/
      @reg[str]
    when /^:\w+/
      str.to_sym
    when /^["|'].*["|']$/
      str
    when /&(\w+)/
      name=str[1..-1]
      if Object.const_defined?(name)
        Object.const_get(name)
      else
        @env.class.const_get(name)
      end
    when /\d+/
      str.to_i
    when /\d+\.\d+/
      str.to_f
    when /true/
      true
    when /false/
      false
    when /nil/
      nil
    else
      raise "unknown type"
    end
    return result
  end
  def run
    @inst.each{|inst|
      @OPCODE[inst[0]].call(*inst[1..-1])
    }
  end
end