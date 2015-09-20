#coding: utf-8
class Equipment < Item  
  attr_reader :sym,:skill
  @@NameSize=15
  require_relative 'Item/Equipment_Attrib'
  def initialize(data)
    super(data[:name],data[:icon],data[:price],data[:comment])
    
    attrib=data[:attrib]
    if attrib[:skill]
      @skill=attrib[:skill]
      if !@skill.respond_to?(:each_value)
        @sym=@skill.collect{|skill| skill[:sym]}
      else
        @sym=@skill[:sym]
      end
    end
    
    @attrib=Attrib.new(data[:part],attrib)
    
    @rect_h+=@attrib.size*@@FontSize
    @rect_back.h=@rect_h
    @superposed=false
    
    @material=data[:material]
    @type=data[:type]
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