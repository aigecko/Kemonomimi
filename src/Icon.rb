#coding: utf-8
class Icon
  def self.load(str)
    info=str.match(/([0-9a-z_\/\.\-]*):*\[*(\d*),*(\d*)\]*/)
    img=Surface.load(info[1])
    if !info[2].empty?&&!info[3].empty?
      img.set_color_key(SDL::SRCCOLORKEY,img[info[2].to_i,info[3].to_i])
    end
    img.display_format
    return img
  end
end