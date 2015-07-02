#coding: utf-8
class Actor::Equip
  @@Part=[:head,:neck,:body,:back,:right,:left,
          :range,:finger,:feet,:deco]
  def initialize(list={})
    @wear=Hash.new(nil)
    @@Part.each{|part|
      @wear[part]=list[part]
    }
  end
  def []=(part,equip)
    @wear[part]=equip
  end
  def [](part)
    if part==:hand
      @wear[:right]
    else
      @wear[part]
    end
  end
  def wear(actor,part,equip)
    case part
    when :single
      @wear[:right] and actor.takeoff_equip(:right)
      @wear[:left] and actor.takeoff_equip(:left)
      
      @wear[:right]=equip
      return
    when :dual
      if @wear[:right]
        if @wear[:right].part==:single
          actor.takeoff_equip(:right)
          @wear[:left]=equip
        elsif @wear[:left]
          actor.takeoff_equip(:right)
          @wear[:right]=equip
        else
          @wear[:left]=equip
        end
      else
        @wear[:right]=equip
      end
      return
    when :left
      if @wear[:right]&&@wear[:right].part==:single
        actor.takeoff_equip(:right)
      end
    when :right
      if @wear[:left]&&@wear[:left].part==:dual
        actor.takeoff_equip(:left)
      end
    end
    
    @wear[part] and actor.takeoff_equip(part)
    @wear[part]=equip
  end
  def parts
    return @@Part
  end
  def each
    @wear.each{|part,equip| yield part,equip}
  end
  def each_equip
    @wear.each_value{|equip| yield equip}
  end
  def marshal_dump
    [@wear]
  end
  def marshal_load(array)
    @wear=array[0]
  end
end