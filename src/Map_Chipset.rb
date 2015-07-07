#coding: utf-8
class Map::Chipset
  @@Chipsets=Input.load_chipset_pic
  def self.[](idx)
    @@Chipsets[idx]
  end
end