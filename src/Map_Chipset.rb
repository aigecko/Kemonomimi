#coding: utf-8
class Map::Chipset
  @@chipsets=Input.load_chipset_pic
  def self.[](idx)
    @@chipsets[idx]
  end
end