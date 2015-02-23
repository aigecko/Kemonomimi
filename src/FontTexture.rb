#coding: utf-8
class FontTexture < Texture
  def initialize(surface)
    super
    rm=surface.format.Rmask
    gm=surface.format.Gmask
    bm=surface.format.Bmask
    am=surface.format.Amask
    if bm>rm
      bm,rm=rm,bm
    end
    for x in 0...@origin_w
      for y in 0...@origin_h
        color=surface[x,y]
        @surface[x,y]=((color&rm)>>16)|(color&gm)|((color&bm)<<16)|(color&am)
      end
    end
    gen_texture
  end
end