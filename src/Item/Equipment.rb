#coding: utf-8
class Equipment < Item
  attr_reader :sym,:skill
  @@NameSize=15
  Abbrev=@@Abbrev={
    name: :n,icon: :i,price: :pc,comment: :c,
    attrib: :a,part: :pt,material: :m,type: :t
  }
  require_relative 'Item/Equipment_Attrib'
  def initialize(data)
    super(
      data[@@Abbrev[:name]],
      data[@@Abbrev[:icon]],
      data[@@Abbrev[:price]],
      data[@@Abbrev[:comment]])
    
    attrib=data[@@Abbrev[:attrib]]
    if attrib[:skill]
      @skill=attrib[:skill]
      if !@skill.respond_to?(:each_value)
        @sym=@skill.collect{|skill| skill[:sym]}
      else
        @sym=@skill[:sym]
      end
    end
    
    @attrib=Attrib.new(data[@@Abbrev[:part]],attrib)
    
    @rect_h+=@attrib.size*@@FontSize
    @rect_back.h=@rect_h
    @superposed=false
    
    @material=data[@@Abbrev[:material]]
    @type=data[@@Abbrev[:type]]
  end
  def attrib
    @attrib.attrib
  end
  def part
    @attrib.part
  end
  def draw_detail(x,y,direct)
    @attrib.draw_detail(x,super,direct)
  end
  def draw_name(x,y)
    Font.draw_texture(@name,@@NameSize,x,y,*Color[:equip_str_font])
  end
  def self.init
    Attrib.init
  end
end