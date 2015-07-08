#coding: utf-8
class Equipment < Item  
  attr_reader :sym,:skill
  @@NameSize=15
  require_relative 'Item/Equipment_Attrib'
  def initialize(name,pic,part,attrib,price,comment,arg)
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
        case val.first.size
        when 2
          "+%d%%%d倍"%val.first
        when 3
          "+%d%%暈%.1f秒"%val.first
        end        
      end
    }
    @rect_h+=@attrib.size*@@FontSize
    @rect_back.h=@rect_h
    @superposed=false
  end  
  alias create initialize
  def initialize(data,*arg)
    if arg.size>0
      create(data,*arg)
    else
      create(data[:name],data[:pic],data[:part],data[:attrib],data[:price],data[:comment])
      @material=data[:material]
    end
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
      Font.draw_texture(@@Attrib_table[sym],@@FontSize,x,str_y,*Color[:equip_attrib_sym_font])
      Font.draw_texture(@attrib_str[sym],@@FontSize,
                      x+@@Attrib_table[sym].size*@@FontSize,
                      str_y,*Color[:equip_attrib_val_font])
      str_y+=@@FontSize
    }
    str_y+=2
  end
  def draw_name(x,y)
    Font.draw_texture(@name,@@NameSize,x,y,*Color[:equip_str_font])
  end
  def self.init
    @@Part_table=Actor.part_table
    @@Attrib_table=Actor.attrib_table
  end
end