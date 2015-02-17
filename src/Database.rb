#coding: utf-8
class Database
  @Class=Input.load_database(:class,true)
  @Equip=Input.load_database(:equip,true)
  @Actor_pic=Input.load_actor_pic  
  @Actor_pic_cache={}
  @Race= Input.load_database(:race,true)
  @Consum=Input.load_database(:consum,true)
  @Skill=Input.load_database(:skill,true)
  def self.get_class(key)
    return @Class[key]
  end
  def self.get_base(key)
    return @Race[key]
  end
  def self.get_equip(part,index)
    begin
      data=@Equip[part][index] or raise "EquipDatabaseOutOfIndex"
      name,pic,attrib,price,comment=data
      return Equipment.new(name,pic,part,attrib,price,comment)
    rescue NoMethodError
      print "part: #{part} index: #{index}"
      Message.show(:unvalid_equip)
      exit
    rescue => e
      Message.show_format("裝備:#{part}編號:#{index}不存在","錯誤",:ASTERISK)
      exit
    end
  end
  def self.get_consum(index)
    consumable=@Consum[index]
    unless consumable.respond_to? :use
      name,pic,attrib,price,comment=consumable
      @Consum[index]=Consumable.new(name,pic,attrib,price,comment,{id: index})
    end
    return @Consum[index]
  end
  def self.get_actor_pic(name)
    str=StringIO.new(Zlib::Inflate.inflate(@Actor_pic[name]))
    begin
      img=SDL::Surface.load_bmp_from_io(str)
      img=img.transform_surface(img[0,0],0,2,2,SDL::TRANSFORM_SAFE)
      base=SDL::Surface.new_32bpp(img.w,img.h)
      img.draw(0,0,base)
      
      pics={}
      pics[:right]=base
      pics[:left]=base.reverse
      
      pics.each_value do |pic|
        pic.set_color_key(SDL::SRCCOLORKEY,pic[0,0])
      end
      pics[:right]=pics[:right].to_texture
      pics[:left]=pics[:left].to_texture
    rescue NoMethodError,ArgumentError=>e
      Message.show_backtrace(e)
      exit
    rescue SDL::Error=>e
      Message.show_backtrace(e)
      Message.show(:actor_pic_format_wrong)
      Message.show(:please_check_files)
      exit
    end
    
    return pics
  end
  def self.get_skill(sym)
    return @Skill[sym]
  end
end