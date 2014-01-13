#coding: utf-8
require 'pp'
class Font
  def self.init
    @font=Hash.new
    @cache=Hash.new
	  [12,15,20,30].each{|size|
      @font[size]=Input.load_font(Conf['FONT_TYPE'],size)
      @cache[size]=Hash.new()
	  }
  end
  def self.release
    @cache=Hash.new
  end
  def self.demo_init(size)
    @demo=Input.load_font(Conf['FONT_TYPE'],size)
  end
  def self.demo_render(text,r,g,b)
    @demo.render_solid_utf8(text,r,g,b)
  end
  def self.[](index)
    @font[index]
  end  
  def self.render_solid(text,size,r,g,b)
    unless @font[size]
      print text      
      
      begin
        raise "FontNotExisted"
      rescue => e
        Message.show_format("字體大小#{size}不存在","錯誤",:ASTERISK)
        Message.show_backtrace(e)
      end
      exit
    end
  
    color=(r<<20)+(g<<10)+b
    
    @cache[size]||=Hash.new
    @cache[size][color]||=Hash.new
    
    unless @cache[size][color][text]
      @cache[size][color][text]=@font[size].render_solid_utf8(text,r,g,b)
    end
    @cache[size][color][text]

    
  end
  def self.draw_solid(text,size,x,y,r,g,b,dst=Screen.render)
    pic=self.render_solid(text,size,r,g,b)
    pic.draw(x,y,dst)
    return pic.w,pic.h
  end
end