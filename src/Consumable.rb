#coding: utf-8
class Consumable < Item
  class Attrib
    def initialize(attrib)
	  @attrib=Hash.new(0)
	  [:skill,:type,:hp,:sp].each{|sym|
	    @attrib[sym]=attrib[sym]
	  }
	end
  end
  def initialize(name,pic,attrib,price,comment)
    super(name,pic,price,comment)
	@attrib=Attrib.new(attrib)
  end
end