#coding: utf-8
class Icon
  def self.init
    @pattern=Regexp.new(
      '(?<rc>(\.\/rc\/icon\/))?'+
      '(?<path>([0-9a-zA-Z_\/\.\-\/]*[a-zA-Z]))'+
      '('+
      '(:\[(?<colorKeyAtX>(\d+)),(?<colorKeyAtY>(\d+))\])|'+
      '(@\[(?<imgAtX>(\d+)),(?<imgAtY>(\d+))\])|'+
      '(((?<firstMode>(\-|\+))\[(?<R1st>(\d+)),(?<G1st>(\d+)),(?<B1st>(\d+))\])'+
      '((?<secondMode>(\+|\-))\[(?<R2nd>(\d+)),(?<G2nd>(\d+)),(?<B2nd>(\d+))\])?)|'+
      '((?<base>(B|b))\[(?<baseR>(\d+)),(?<baseG>(\d+)),(?<baseB>(\d+))\])'+
      ')*')
    @icon_set={}
    @cache={}
    currentDir=Dir.pwd
    Dir.chdir './rc/icon/merge'
    Dir.foreach('.'){|name|
      name=~/.png/ or next
      @icon_set[name]=Surface.load(name)
    }
    Dir.chdir(currentDir)
    @base_w=@base_h=24
  end
  def self.load(str,gen=true)
    info=str.match(@pattern)
    img=nil
    if info[:imgAtX]&&info[:imgAtY]
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
      img=@icon_set[info[:path]].copy_rect(x*@base_w,y*@base_h,@base_w,@base_h)
    else
      path=info[:rc]+info[:path]
      if img=@cache[str]
        gen and img=img.to_texture
        return img
      end
      unless img=@cache[path]
        @cache[path]=(img=Surface.load(path))
      end
    end
    base=SDL::Surface.new_32bpp(@base_w,@base_h)
    if info[:base]
      base.fill_rect(0,0,@base_w,@base_h,[
        info[:baseR].to_i,
        info[:baseG].to_i,
        info[:baseB].to_i])
    else
      base.fill_rect(0,0,@base_w,@base_h,img[0,0])
    end

    img.draw(0,0,base)
    img=base

    if info[:firstMode]
      img.send(info[:firstMode]=='+'?:add_blend: :sub_blend,
        [info[:R1st].to_i,info[:G1st].to_i,info[:B1st].to_i])
    end
    if info[:secondMode]
      img.send(info[:secondMode]=='+'?:add_blend: :sub_blend,
        [info[:R2nd].to_i,info[:G2nd].to_i,info[:B2nd].to_i])
    end
    
    colorkey_x=colorkey_y=0
    if info[:colorKeyAtX]&&info[:colorKeyAtY]
      colorkey_x=info[:colorKeyAtX].to_i
      colorkey_y=info[:colorKeyAtY].to_i
    end
    
    img.set_color_key(SDL::SRCCOLORKEY,img[colorkey_x,colorkey_y])
    @cache[str]=img
    gen and img=img.to_texture
    return img
  end
end