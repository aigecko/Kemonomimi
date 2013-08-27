#coding: utf-8
class Actor  
  class Equip
    @@Part=[:head,:neck,:body,:back,:right,:left,
	         :range,:finger,:feet,:deco]
    def initialize(list={})      
	  @wear=Hash.new(nil)
	  @@Part.each{|part|
	    @wear[part]=list[part]
	  }
	end
	def []=(part,equip)
      if part==:hand
        @wear[:right]=equip
      else
	    @wear[part]=equip
      end
	end
	def [](part)
	  @wear[part]
	end
    def parts
      @@Part
    end
    def each
      @wear.each{|part,equip| yield part,equip}
    end
    def each_equip
      @wear.each_value{|equip| yield equip}
    end
  end
end