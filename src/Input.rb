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
    img=@icon_cache[str] and return img

    info=str.match(@icon_load_pattern)
    if info[:imgAtX]&&info[:imgAtY]
      img=extract_from_icon_set(info)
    else
      img=Surface.load(info[:rc]+info[:path])
    end
    
    img=fill_base(info,img)
    
    info[:firstMode] and proc_first_mode(info,img)
    info[:secondMode] and proc_second_mode(info,img)
    
    info[:changeHue] and img.change_hue(info[:changeHue].to_f)
    
    set_color_key(info,img)

    @icon_cache[str]=img.to_texture
    return @icon_cache[str]
  end
  def self.load_texture(str)
    img=@surface_texture_cache[str] and return img
    
    info=str.match(@surface_texture_load_pattern)
    img=Surface.load(info[:path])
    
    info[:cut]&&info[:imgAtX]&&info[:imgAtY] and img=cut_image(info,img)
    
    img=fill_base(info,img)
    
    info[:firstMode] and proc_first_mode(info,img)
    info[:secondMode] and proc_second_mode(info,img)
    
    info[:changeHue] and img.change_hue(info[:changeHue].to_f)
    
    set_color_key(info,img)
   
    img_array=[]
    if info[:cut]&&!(info[:imgAtX]||info[:imgAtY])
      w=info[:cutW].to_i
      h=info[:cutH].to_i
      for x in 0...img.w/w
        for y in 0...img.h/h
          img_array<<img.copy_rect(x*w,y*h,w,h).to_texture
        end
      end
      @surface_texture_cache[str]=img_array
    else
      @surface_texture_cache[str]=img.to_texture
    end
    
    return @surface_texture_cache[str]
  end
  def self.cut_image(info,img)
    w=info[:cutW].to_i
    h=info[:cutH].to_i
    x=info[:imgAtX].to_i*w
    y=info[:imgAtY].to_i*h
    new_img=img.copy_rect(x,y,w,h)
    img.destroy
    return new_img
  end
  def self.extract_from_icon_set(info)
    x=info[:imgAtX].to_i
    y=info[:imgAtY].to_i
    unless @icon_set[info[:path]]
      begin
        raise "IconNotInSet"
      rescue => e
        Message.show_format("圖示:#{info[:path]}不在圖組中","錯誤",:ASTERISK)
        exit
      end
    end
    return @icon_set[info[:path]].copy_rect(x*@icon_base_w,y*@icon_base_h,@icon_base_w,@icon_base_h)
  end
  def self.fill_base(info,img)
    base=SDL::Surface.new_32bpp(img.w,img.h)
    if info[:base]
      base.fill_rect(0,0,img.w,img.h,[
        info[:baseR].to_i,
        info[:baseG].to_i,
        info[:baseB].to_i])
    else
      base.fill_rect(0,0,img.w,img.h,img[0,0])
    end
    img.draw(0,0,base)
    img.destroy
    return base
  end
  def self.proc_first_mode(info,img)
    img.send(info[:firstMode]=='+'? :add_blend : :sub_blend,
      [info[:R1st].to_i,info[:G1st].to_i,info[:B1st].to_i])
  end
  def self.proc_second_mode(info,img)
    img.send(info[:secondMode]=='+'?:add_blend: :sub_blend,
      [info[:R2nd].to_i,info[:G2nd].to_i,info[:B2nd].to_i])
  end
  def self.set_color_key(info,img)
    colorkey_x=colorkey_y=0
    if info[:colorKeyAtX]&&info[:colorKeyAtY]
      colorkey_x=info[:colorKeyAtX].to_i
      colorkey_y=info[:colorKeyAtY].to_i
    end
    img.set_color_key(SDL::SRCCOLORKEY,img[colorkey_x,colorkey_y])
  end
  def self.init
    @surface_texture_load_pattern=Regexp.new(
      '(?<path>([0-9a-zA-Z_\/\.\-\/]*[a-zA-Z]))'+
      '('+
      '(:\[(?<colorKeyAtX>(\d+)),(?<colorKeyAtY>(\d+))\])|'+
      '((?<cut>(C|c))\[(?<cutW>(\d+)),(?<cutH>(\d+))\])|'+
      '(@\[(?<imgAtX>(\d+)),(?<imgAtY>(\d+))\])|'+
      '(((?<firstMode>(\-|\+))\[(?<R1st>(\d+)),(?<G1st>(\d+)),(?<B1st>(\d+))\])'+
      '((?<secondMode>(\+|\-))\[(?<R2nd>(\d+)),(?<G2nd>(\d+)),(?<B2nd>(\d+))\])?)|'+
      '((?<base>(B|b))\[(?<baseR>(\d+)),(?<baseG>(\d+)),(?<baseB>(\d+))\])|'+
      '(#\[(?<changeHue>(\d+\.?\d*))\])'+
      ')*')
    @surface_texture_cache={}
    
    @icon_load_pattern=Regexp.new(
      '(?<rc>(\.\/rc\/icon\/))?'+
      '(?<path>([0-9a-zA-Z_\/\.\-\/]*[a-zA-Z]))'+
      '('+
      '(:\[(?<colorKeyAtX>(\d+)),(?<colorKeyAtY>(\d+))\])|'+
      '(@\[(?<imgAtX>(\d+)),(?<imgAtY>(\d+))\])|'+
      '(((?<firstMode>(\-|\+))\[(?<R1st>(\d+)),(?<G1st>(\d+)),(?<B1st>(\d+))\])'+
      '((?<secondMode>(\+|\-))\[(?<R2nd>(\d+)),(?<G2nd>(\d+)),(?<B2nd>(\d+))\])?)|'+
      '((?<base>(B|b))\[(?<baseR>(\d+)),(?<baseG>(\d+)),(?<baseB>(\d+))\])|'+
      '(#\[(?<changeHue>(\d+\.?\d*))\])'+
      ')*')
    @icon_set={}
    @icon_cache={}
    currentDir=Dir.pwd
    Dir.chdir './rc/icon/merge'
    Dir.foreach('.'){|name|
      name=~/.png/ or next
      @icon_set[name]=Surface.load(name)
    }
    Dir.chdir(currentDir)
    @icon_base_w=@icon_base_h=24
  end
end
