#coding: utf-8
class Database
  @Class=Input.load_database(:class,true)
  @Equip=Input.load_database(:equip,true)
  @Actor_pic=Input.load_actor_pic  
  @Actor_pic_cache={}
  @Race= Input.load_database(:race,true)
  @Skill=Input.load_skill
  #@@consum=Input.load_consum
  #@buffer=Surface.new(Surface.flag,Game.Width,Game.Height,Screen.format)
  def self.get_growth(key)
    @Class[key]
  end
  def self.get_base(key)
    @Race[key]
  end
  def self.get_equip(part,index)
	begin
	  data=@Equip[part][index]      
	rescue NoMethodError
	  Message.show(:unvalid_equip)
	  return nil
	else
	  name=data[0]
	  pic=data[1]
	  attrib=data[2]
	  price=data[3]
	  comment=data[4]
      return Equipment.new(name,pic,part,attrib,price,comment)
	end
  end
  def self.get_consum(index)
    data=@Consum[index]
	name=data[0]
	pic=data[1]
	attrib=data[2]
	price=data[3]
	comment=data[4]
	return Consumable.new(name,pic,attrib,price,comment)
  end
  def self.get_actor_pic(name)
    @Actor_pic_cache[name] and return @Actor_pic_cache[name]
    
    str=StringIO.new(Zlib::Inflate.inflate(@Actor_pic[name]))
    begin
      pic=SDL::Surface.load_bmp_from_io(str)
      
      @Actor_pic_cache[name]={}
      @Actor_pic_cache[name][:right]=pic.transform_surface(pic[0,0],0,2,2,SDL::TRANSFORM_SAFE)
            
      pic=pic.reverse
      
      @Actor_pic_cache[name][:left]=pic.transform_surface(pic[0,0],0,2,2,SDL::TRANSFORM_SAFE)
    rescue =>e
      Message.show_backtrace(e)
      Message.show(:actor_pic_format_wrong)
      Message.show(:please_check_files)
      exit
    end
    
    @Actor_pic_cache[name].each_value do |pic|
      pic.set_color_key(SDL::SRCCOLORKEY|SDL::RLEACCEL,pic[0,0])
      pic.display_format_alpha
    end
    @Actor_pic.delete(name)
    return @Actor_pic_cache[name]
  end
end