#coding: utf-8
class Animation
  attr_reader :w,:h
  def initialize(target,data,tracks)
    @target=target
    @data=data.dup
    @data[:img]=data[:img].collect{|filename|
      Surface.load_with_colorkey(filename).to_texture
    }
    @tracks=tracks
    @frame=0
    
    @w,@h=@data[:w],@data[:h]
  end
  def reverse
    @reverse=true
  end
  def draw(x,y,z)
    @tracks.each{|track|
      frame=track[@frame]
      act,*arg=frame
      case act
      when :blit
        case @target
        when :follow
          @data[:img][arg[0]].draw_direct(x,y,z,@reverse)
        end
      end
    }
    @frame+=1
    @frame=@frame% @tracks[0].size
  end
end