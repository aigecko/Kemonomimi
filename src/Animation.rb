#coding: utf-8
class Animation
  attr_reader :w,:h
  def initialize(target,data,tracks)
    @target=target
    @data=data.dup
    @data[:img]=data[:img].collect{|filename|
      Texture.load_with_colorkey(filename)
    }
    @tracks=tracks
    @tracks.collect!{|track|
      new_track=[]
      track.each{|frame|
        act,img,last,*arg=frame
        if last
          last.times{
            new_track<<[act,img,*arg]
          }
        else
          new_track<<frame
        end
      }
      new_track
    }
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