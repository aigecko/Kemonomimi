#coding: utf-8
class Icon
  def self.init
    @pattern=Regexp.new(
      '(?<rc>(\.\/rc\/icon\/))?'+
      '(?<path>([0-9a-zA-Z_\/\.\-\/]*))'+
      '((:\[(?<colorKeyAtX>(\d+)),(?<colorKeyAtY>(\d+))\])|'+
      '(@\[(?<imgAtX>(\d+)),(?<imgAtY>(\d+))\]))*')
    @icon_set={}
    currentDir=Dir.pwd
    Dir.chdir './rc/icon/merge'
    Dir.foreach('.'){|name|
      name=~/.png/ or next
      @icon_set[name]=Surface.load(name)
    }
    Dir.chdir(currentDir)
  end
  def self.load(str)
    info=str.match(@pattern)
    img=nil
    if info[:imgAtX]&&info[:imgAtY]
      x=info[:imgAtX].to_i
      y=info[:imgAtY].to_i
      img=@icon_set[info[:path]].copy_rect(x*24,y*24,24,24)
    else
      img=Surface.load(info[:rc]+info[:path])
    end
    if info[:colorKeyAtX]&&info[:colorKeyAtY]
      unless @base
        @base=Surface.new(Surface.flag,24,24,Screen.format)
      else
        @base.draw_rect(0,0,24,24,[0,0,0])
      end
      img.draw(0,0,@base)
      img.destroy
      img=@base.copy_rect(0,0,@base.w,@base.h)
      img.set_color_key(SDL::SRCCOLORKEY,img[info[:colorKeyAtX].to_i,info[:colorKeyAtY].to_i])
    end
    img.display_format
    return img
  end
end