#coding: utf-8
class Equipment::Attrib
  attr_reader :part,:attrib
  @@FontSize=12
  @@NameSize=15
  @@FormatPosInteger="+%d"
  @@FormatNegInteger="-%d"
  @@FormatPosFloat="+%d%%"
  @@FormatNegFloat="-%d%%"
  @@FormatCritical="+%d%%%d倍"
  @@FormatBash="+%d%%暈%.1f秒"
  def initialize(part,attrib)
    @part=part
    @attrib=Hash.new(0)
    @attrib_str={}
    attrib.each{|sym,val|
      sym==:skill and next
      @attrib[sym]=val
      @attrib_str[sym]=
        case val
        when Integer
          ((val>0)? @@FormatPosInteger : @@FormatNegInteger)%val
        when Float
          ((val>0)? @@FormatPosFloat: @@FormatNegFloat)% (val*100)
        when Array
          case val.first.size
          when 2
            @@FormatCritical%val.first
          when 3
            @@FormatBash%val.first
          end
        end
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
  def draw_detail(x,y,direct)
    @attrib.each{|sym,value|
      Font.draw_texture(@@Attrib_table[sym],@@FontSize,x,y,*Color[:equip_attrib_sym_font])
      Font.draw_texture(@attrib_str[sym],@@FontSize,
                      x+@@Attrib_table[sym].size*@@FontSize,
                      y,*Color[:equip_attrib_val_font])
      y+=@@FontSize
    }
    y+=2
  end
  def self.init
    @@Part_table=Actor.part_table
    @@Attrib_table=Actor.attrib_table
  end
end