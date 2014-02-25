#coding: utf-8
class Database
  @Class=Input.load_database(:class,true)
  @Equip=Input.load_database(:equip,true)
  @Actor_pic=Input.load_actor_pic  
  @Actor_pic_cache={}
  @Race= Input.load_database(:race,true)
  @Consum=Input.load_database(:consum,true)
  @Skill=Input.load_database(:skill,true)
  #@buffer=Surface.new(Surface.flag,Game.Width,Game.Height,Screen.format)
  def self.get_class(key)
    return @Class[key]
  end
  def self.get_base(key)
    return @Race[key]
  end
  def self.get_equip(part,index)
    begin
      data=@Equip[part][index]      
    rescue NoMethodError
      print "part: #{part} index: #{index}"
      Message.show(:unvalid_equip)
      return nil
    else
      name,pic,attrib,price,comment=data
      return Equipment.new(name,pic,part,attrib,price,comment)
    end
  end
  def self.get_consum(index)   
    name,pic,attrib,price,comment=@Consum[index]
    return Consumable.new(name,pic,attrib,price,comment,{id: index})
  end
  def self.get_actor_pic(name)    
    str=StringIO.new(Zlib::Inflate.inflate(@Actor_pic[name]))
    begin
      pic=SDL::Surface.load_bmp_from_io(str)
      pics={}
      pics[:right]=pic.transform_surface(pic[0,0],0,2,2,SDL::TRANSFORM_SAFE)      
      pic=pic.reverse
      pics[:left]=pic.transform_surface(pic[0,0],0,2,2,SDL::TRANSFORM_SAFE)
    rescue NoMethodError,ArgumentError=>e
      Message.show_backtrace(e)
      exit
    rescue SDL::Error=>e
      Message.show_backtrace(e)
      Message.show(:actor_pic_format_wrong)
      Message.show(:please_check_files)
      exit
    end
    pics.each_value do |pic|
      pic.set_color_key(SDL::SRCCOLORKEY,pic[0,0])
      pic.display_format_alpha
    end
    return pics
  end
  def self.get_skill(sym)
    return @Skill[sym]
  end
end