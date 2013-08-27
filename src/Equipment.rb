#coding: utf-8
class Equipment < Item
  class Attrib
    attr_reader :part,:attrib
    def initialize(part,attrib)
	  @part=part
	  @attrib=Hash.new(0)
	  attrib.each{|sym,value|
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
    @font_size=12
    @name_size=15
    
	@comment=ColorString.new(comment,@font_size,Color[:equip_comment_font],7)
	@attrib=Attrib.new(part,attrib)
	@attrib_str={}
    @attrib.each{|sym,val|     
      @attrib_str[sym]="+%d"%val
    }
    
    @rect_w=85
    @rect_h=28+@attrib.size*@font_size+@comment.h
    @rect_alpha=220
    
    @low_bound=350
  end  
  def attrib
    @attrib.attrib
  end
  def part
    @attrib.part
  end
  def draw_detail(x,y)
    y>@low_bound and y=@low_bound
    Screen.draw_rect(x,y,@rect_w,@rect_h,Color[:equip_rect_back],true,@rect_alpha)
    Font.draw_solid(@name,@font_size,x,y,*Color[:equip_name_font])
    str_y=y+14
    @attrib.each{|sym,value|
      Font.draw_solid(@@Attrib_table[sym],@font_size,x,str_y,*Color[:equip_attrib_sym_font])
      Font.draw_solid(@attrib_str[sym],@font_size,
                      x+@@Attrib_table[sym].size*@font_size,
                      str_y,*Color[:equip_attrib_val_font])      
      str_y+=@font_size
    }
    str_y+=2
    @comment.draw(x,str_y)
  end  
  def draw_name(x,y)
    Font.draw_solid(@name,@name_size,x,y,*Color[:equip_str_font])
  end
  def self.init
    @@Part_table=Actor.part_table
    @@Attrib_table=Actor.attrib_table
  end
end