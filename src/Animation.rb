#coding: utf-8
class Animation
  attr_reader :w,:h
  def initialize(target,data,tracks)
    @target=target
    @data=data
    @data[:img_rev]=data[:img].collect{|filename|
      surface=Surface.load(filename).reverse
      surface.set_color_key(SDL::SRCCOLORKEY,surface[0,0])
      surface.to_texture
    }
    @data[:img].collect!{|filename|
      Surface.load_with_colorkey(filename).to_texture
    }
    @tracks=tracks
    @frame=0
    
    @w,@h=@data[:w],@data[:h]
  end
  def reverse
    @data[:img]=@data[:img_rev]
  end
  def draw(x,y,z)
    @tracks.each{|track|
      frame=track[@frame]
      act,*arg=frame
      case act
      when :blit
        case @target
        when :follow
          @data[:img][arg[0]].draw(x,y,z)
        end
      end
    }
    @frame+=1
    @frame=@frame% @tracks[0].size
  end
end