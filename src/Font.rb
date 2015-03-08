#coding: utf-8
require_relative 'FontTextureSet'
class Font;end
class<<Font
  def init
    @font=Hash.new
    @cache=Hash.new
    @texture=Hash.new
    [12,15,20,30].each{|size|
      @font[size]=Input.load_font('wt064.ttf',size)
      @cache[size]=Hash.new
      @texture[size]=Hash.new
    }
  end
  def release
    @cache=Hash.new
  end
  def demo_render(text,r,g,b)
    @demo.render_blended_utf8(text,r,g,b)
  end
  def [](size)
    unless @font[size]
      begin
        raise "FontNotExisted"
      rescue => e
        Message.show_format("字體大小 #{size} 不存在","錯誤",:ASTERISK)
        Message.show_backtrace(e)
      end
      exit
    end
    return @font[size]
  end
  def render_solid(text,size,r,g,b)
    color=(r<<20)+(g<<10)+b

    @cache[size]||=Hash.new
    @cache[size][color]||=Hash.new
    
    return @cache[size][color][text]||=self[size].render_blended_utf8(text,r,g,b)
  end
  def draw_solid(text,size,x,y,r,g,b)
    pic=render_solid(text,size,r,g,b)
    pic.draw(x,y)
    return pic.w,pic.h
  end
  def render_texture(text,size,r,g,b)
    color=(r<<20)+(g<<10)+b
    @texture[size]||=Hash.new
    @texture[size][color]||=Hash.new
    
    return @texture[size][color][text]||=FontTextureSet.new(text,size,r,g,b)
  end
  def draw_texture(text,size,x,y,r,g,b)
    texture=render_texture(text,size,r,g,b)
    texture.draw(x,y)
    return texture.w,texture.h
  end
  def render_character(char,size,r,g,b)
    color=(r<<20)+(g<<10)+b
    @texture[size]||=Hash.new
    @texture[size][color]||=Hash.new
    
    @texture[size][color][char]||=FontTexture.new(render_solid(char,size,r,g,b))
  end
end