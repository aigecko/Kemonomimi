#coding: utf-8
class Database
  @Class=Input.load_database(:class,true)
  @Equip=Input.load_database(:equip,true)
  @Actor_pic=Input.load_actor_pic
  @Race= Input.load_database(:race,true)
  @Consum=Input.load_database(:consum,true)
  @Item=Input.load_database(:material,true)
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
      case data
      when Array
        name,icon,attrib,price,comment,arg=data
        return Equipment.new(
          Equipment::Abbrev[:name] => name,
          Equipment::Abbrev[:icon] => icon,
          Equipment::Abbrev[:part] => part,
          Equipment::Abbrev[:attrib] => attrib,
          Equipment::Abbrev[:price] => price,
          Equipment::Abbrev[:comment] => comment)
      when Hash
        return Equipment.new(data)
      end
    rescue NoMethodError
      Message.show_format("裝備:#{part}編號:#{index}不存在","錯誤",:ASTERISK)
      Message.show(:unvalid_equip)
      exit
    rescue => e
      p e
      Message.show_backtrace(e)
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
  def self.get_item(index)
    begin
      item=@Item[index]
      unless item.respond_to? :draw
        name,pic,price,comment,arg=item
        @Item[index]=Item.new(name,pic,price,comment,{id: arg[:id]})
      end
      return @Item[index]
    rescue NoMethodError
      Message.show_format("編號:#{index}的物品不存在","錯誤",:ASTERISK)
      exit
    end
  end
  def self.get_actor_pic(name)
    if data=@Actor_pic[name]
      str=StringIO.new(Zlib::Inflate.inflate(data))
      img=SDL::Surface.load_bmp_from_io(str)
      img=img.transform_surface(img[0,0],0,2,2,SDL::TRANSFORM_SAFE)
    else
      img=Surface.load_bmp('./rc/pic/battle/%s'%name)
    end
    begin
      base=SDL::Surface.new_32bpp(img.w,img.h)
      img.draw(0,0,base)
      
      pics=Array.new(3)
      pics[1]=base
      pics[-1]=base.reverse
      
      pics.each do |pic|
        pic and
        pic.set_color_key(SDL::SRCCOLORKEY,pic[0,0])
      end
      pics[1]=pics[1].to_texture
      pics[-1]=pics[-1].to_texture
    rescue NoMethodError,ArgumentError=>e
      p e
      Message.show_backtrace(e)
      exit
    rescue SDL::Error=>e
      Message.show_backtrace(e)
      Message.show(:actor_pic_format_wrong)
      Message.show(:please_check_files)
      exit
    rescue
      p e
      Message.show_backtrace(e)
      exit
    end
    return pics
  end
  def self.get_skill(sym)
    return @Skill[sym]
  end
end