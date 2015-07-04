#coding: utf-8
class Input
  def self.load_pic(path)
    Surface.load(path)
  end
  def self.load_ui_pic
    path='./rc/pic/system/ui.bmp'
    unless FileTest.exist?(path)
      Message.show(:ui_pic_lost)
      Message.show(:please_check_files)
      exit
    end
    begin
      pic=Input.load_pic(path)
    rescue SDL::Error
      Message.show(:ui_pic_load_failure)
      Message.show(:please_check_files)
      exit
    else
      return pic
    end
  end
  def self.load_title
    @pic and return @pic
    path='./rc/pic/title/title.jpg'
    unless FileTest.exist?(path)
      Message.show(:title_lost)
      Message.show(:please_check_files)
      exit
    end
    begin
      @pic=BigTexture.new(Input.load_pic(path))
    rescue SDL::Error
      Message.show(:title_load_failure)
      Message.show(:please_check_files)
      exit
    else
      return @pic
    end
  end
  def self.load_font(name,size)
    unless FileTest.exist?("./rc/font/#{name}")
      Message.show(:font_lost)
      Message.show(:config_load_default)
      Conf.fix
      Message.show(:config_data_rewrite)
    end
    retried=false
    begin
      font=SDL::TTF.open("./rc/font/#{name}", size)
    rescue
      unless retried
        Message.show(:font_lost)
        Conf.fix
        Message.show(:config_data_rewrite)
        retried=true
        retry
      else
        Message.show(:several_failure)
        Message.show(:please_restart_game)
        exit
      end
    end
  end
  def self.load_database(type,encrypt=true)
    name=type.to_s
    unless FileTest.exist?("./rc/data/#{name}.data")
      load_failure_message(type)
      exit
    end
    decrypt_data=''
    Zlib::GzipReader.open("./rc/data/#{name}.data",){|file|
      encrypt_data=file.read
      encrypt_data.chomp!
      if encrypt
        cipher=OpenSSL::Cipher::Cipher.new('bf-cbc')
        cipher.decrypt
        cipher.key=Digest::SHA1.hexdigest('')
        decrypt_data=cipher.update(encrypt_data)<<cipher.final
      else
        decrypt_data=encrypt_data
      end
    }
    begin
      data=Marshal.load(decrypt_data)
    rescue
      load_failure_message(type)
      exit
    end
    return data
  end
  def self.load_failure_message(type)
    case type
    when :class
      Message.show(:class_load_failure)
    when :race
      Message.show(:race_load_failure)
    when :equip
      Message.show(:equip_load_failure)
    when :consum
      Message.show(:consum_load_failure)
    when :skill
      Message.show(:skill_load_failure)
    end
    Message.show(:please_check_files)
  end
  def self.load_actor_pic
    self.load_actor_pack('./rc/pic/mon_com.pic')
  end
  def self.load_actor_pack(path)
    unless FileTest.exist?(path)
      Message.show(:actor_pic_lost)
      Message.show(:please_check_files)
      exit
    end
    data=nil
    File.open(path){|file|
      begin
        data=Marshal.load(file)
      rescue
        Message.show(:actor_pic_load_failure)
        Message.show(:please_check_files)
        exit
      end
    }
    return data
  end
  def self.load_chipset_pic
    path='./rc/pic/chipset/chipset.bmp'
    base=Input.load_pic(path)
    chip_w=40
    chip_h=20
    idx_w=base.w/chip_w
    idx_h=base.h/chip_h
    pics=[]
    h=0
    for i in 0..idx_w-1
      w=0
      for j in 0..idx_h-1
        pics<<base.copy_rect(w,h,chip_w,chip_h)
        w+=chip_w
      end
      h+=chip_h
    end
    return pics
  end
  def self.load_window_icon_pic
    path='./rc/icon/window_icon'
    w=h=24
    icons={}
    [:status,:item,:equip,:save,:tool,:skill].each{|name|
      icons[name]=self.load_icon("#{path}/MI_#{name}.png:[0,0]B[255,255,0]")
    }
    return icons
  end
  def self.load_icon(str)
    Icon.load(str)
  end
end
