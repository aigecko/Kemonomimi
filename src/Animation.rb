#coding: utf-8
class Animation
  attr_reader :w,:h,:length
  def initialize(target,data,tracks)
    @target=target
    @data={}
    @data[:img]=[]
    data[:img].each_with_index{|filename,idx|
      if data[:cut]
        img=Surface.load_with_colorkey(filename)
        cut_w=data[:cut][idx][0]
        cut_h=data[:cut][idx][1]
        for x in 0..img.w/cut_w
          for y in 0..img.h/cut_h
            @data[:img]<<img.copy_rect(x*cut_w,y*cut_h,cut_w,cut_h).to_texture
          end
        end
      else
        @data[:img]<<Input.load_texture(filename)
      end
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
    
    @w,@h=data[:w],data[:h]
    @limit=data[:limit]
    @limit_count=0
    @length=@tracks.max_by{|track| track.size}.size
    @round=0
  end
  def reverse
    @reverse=true
  end
  def end?
    return @end
  end
  def draw(x,y,z)
    @tracks.each{|track|
      frame=track[@frame]
      act,img,*arg=frame
      case act
      when :blit
        case @target
        when :follow
          @data[:img][img].draw_direct(x,y,z,@reverse)
        end
      end
    }
    @frame+=1
    if @frame>=@length
      if @limit
        @limit_count>@limit and @end=true
        @limit_count+=1
      end
      @frame=0
    end
  end
end