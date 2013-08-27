#coding: utf-8
class Item  
  def initialize(name,pic,price,comment)
    @name=name
	@price=price
    begin
	@pic=SDL::Surface.load("./rc/icon/#{pic}")
    rescue
      Message.show(:equip_pic_load_failure)
      puts "pic=#{pic}"
      exit
    end
  end
  def draw(x,y)
    @pic.draw(x,y)
  end
end