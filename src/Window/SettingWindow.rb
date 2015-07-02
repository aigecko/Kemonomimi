#coding: utf-8
class SettingWindow < SelectWindow
  def initialize
    win_w,win_h=400,300
    win_x=(Game.Width-win_w)/2
    win_y=(Game.Height-win_h)/2
    super(win_x,win_y,win_w,win_h)

    skeleton_initialize
    title_initialize('變更遊戲設定')
    comment_initialize(:save,:change)
    word_initialize
    pic_initialize
    gen_skeleton_texture
    @alone=true
  end
  def word_initialize
    @table=[]
    Conf.each_key{|key| @table<<key}
    
    @name={
      'FULL_SCREEN'=>'全螢幕-  ：',
      'SDL_VIDEO_CENTERED'=>'視窗置中-：',
      'MUSIC'=>'音樂開啟 ：',
      'SOUND'=>'音效開啟 ：'
    }
    
    @value=Hash.new('')
    Conf.each{|key,val|
      @value[key]=val.to_s
    }
    
    @extra_comment="有-號之選項須重新啟動遊戲才會變更"
    
    @font_demo_str='字體範例DEMO'
  end
  def pic_initialize
    @back=Input.load_title
    @name_pic=select_pic_initialize(@name)
    @value_pic=select_pic_initialize(@value)
    
    w_long=0
    @name_pic.each_value{|pic|
      pic[0].w>w_long and w_long=pic[0].w
    }
    @value_draw_x=@win_x+@border*2+w_long
    @value_draw_y=@win_y+@border+@title_pic.h
        
    extra_comment_pic=Font.render_solid(@extra_comment,@comment_size,*Color[:comment])
    
    ex_cmt_draw_x=@cmt_draw_x-2
    ex_cmt_draw_y=@cmt_draw_y-extra_comment_pic.h-@border/2
    
    extra_comment_pic.draw(ex_cmt_draw_x,ex_cmt_draw_y,@skeleton)
  end
  def interact
    Event.each{|event|
      case event
      when Event::KeyDown
        case event.sym
        when Key::UP
          @select=(@select==0) ? @table.size-1: @select-1
        when Key::DOWN
          @select=(@select==@table.size-1) ? 0: @select+1
        when *Key::BACK
          select_back
        when *Key::CHECK
          select_check
        end
      when Event::MouseButtonDown
        case event.button
        when SDL::Mouse::BUTTON_LEFT
          result=check_select_index
          result and select_check
        when SDL::Mouse::BUTTON_RIGHT
          select_back
        end
      when Event::MouseMotion
        check_select_index
      when Event::Quit
        Game.quit
      end
    }
  end
  def select_check
    key=@table[@select]
    other_change
    refresh_pic
  end
  def select_back
    close
    Conf.save
    Game.set_window(:MenuWindow,:open)
  end
  def check_select_index
    result=super(@name_pic,@table)
    value_pic_start
    result||=super(@value_pic,@table)
    value_pic_end
    return result
  end
  def value_pic_start
    @select_draw_x,@value_draw_x=@value_draw_x,@select_draw_x
  end
  def value_pic_end
    @select_draw_x,@value_draw_x=@value_draw_x,@select_draw_x
  end
  def other_change
    Conf[@table[@select]]=!Conf[@table[@select]]
  end
  def refresh_pic
    key=@table[@select]
    @value[key]=Conf[@table[@select]]
    
    str=@value[key].to_s
    if @select_cache[str]
      @value_pic[key]=@select_cache[str]
    else
      @select_cache[str]=@value_pic[key]=[
        Font.render_texture(str,@font_size,*Color[:normal_select]),
        Font.render_texture(str,@font_size,*Color[:focused_select])]
    end
  end
  def draw
    @back.draw(0,0)
    super
    draw_select(@name_pic,@table)
    value_pic_start
    draw_select(@value_pic,@table)
    value_pic_end
  end
end