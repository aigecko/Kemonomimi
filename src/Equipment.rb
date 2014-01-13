#coding: utf-8
class Equipment < Item  
  attr_reader :sym,:skill
  @@name_size=15
  class Attrib
    attr_reader :part,:attrib
    def initialize(part,attrib)
      @part=part
      @attrib=Hash.new(0)
      attrib.each{|sym,value|
        sym!=:skill and
        @attrib[sym]=value
      }
    end
    def [](key)
      @attrib[key]
    end
    def size
      @attrib.size
    end
    def each
      @attrib.each{|key,val| yield key,val}
    end
  end
  def initialize(name,pic,part,attrib,price,comment)
    super(name,pic,price,comment)
    
    if attrib[:skill]
      @skill=attrib[:skill]
      if @skill.respond_to? :each
        @sym=@skill.collect{|skill| skill[:sym]}
      else
        @sym=@skill[:sym]
      end
    end
    
    @attrib=Attrib.new(part,attrib)
    @attrib_str={}
    @attrib.each{|sym,val|
      @attrib_str[sym]=
      case val
      when Integer
        ((val>0)? "+%d" : "-%d")%val
      when Float
        ((val>0)? "+%d%%": "-%d%%")%(val*100)
      when Array
        #str=
        case val.first.size
        when 2
          "+%d%%%d倍"%val.first
        when 3
          "+%d%%暈%.1f秒"%val.first
        end        
      end
    }
    @rect_h+=@attrib.size*@@font_size
    @superposed=false
  end  
  def attrib
    @attrib.attrib
  end
  def part
    @attrib.part
  end
  def draw_detail(x,y,direct)
    str_y=super
    @attrib.each{|sym,value|
      Font.draw_solid(@@Attrib_table[sym],@@font_size,x,str_y,*Color[:equip_attrib_sym_font])
      Font.draw_solid(@attrib_str[sym],@@font_size,
                      x+@@Attrib_table[sym].size*@@font_size,
                      str_y,*Color[:equip_attrib_val_font])
      str_y+=@@font_size
    }
    str_y+=2
  end
  def draw_name(x,y)
    Font.draw_solid(@name,@@name_size,x,y,*Color[:equip_str_font])
  end
  def self.init
    @@Part_table=Actor.part_table
    @@Attrib_table=Actor.attrib_table
  end
end