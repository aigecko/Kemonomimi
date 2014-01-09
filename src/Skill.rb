#coding: utf-8
require_relative 'Skill_Base'
class Skill
  @@SwitchTypeList=[:switch,:switch_auto,:switch_append]
  attr_reader :switch
  def initialize(info)
    @name=info[:name]
    unless @name
      Message.show_format('技能名稱設定錯誤','錯誤',:ERROR)
      exit
    end
    
    begin
      if info[:icon]
        @icon=Icon.load(info[:icon])
        #@icon.set_color_key(SDL::SRCCOLORKEY,@icon[0,0])
      else
        @icon=SDL::Surface.new(Screen.flag,24,24,Screen.format)
      end
    rescue
      p info[:icon]
      Message.show(:skill_pic_load_failure)
      exit
    end
    @common_cd=info[:common_cd]
    
    @proc=Base[info[:base]]
    @type=info[:type]
    
    @consum=info[:consum]||0
	
    if @@SwitchTypeList.include?(@type)      
      @switch=false
    else
      @switch=true
    end
    
    @org_cd=@cd=info[:cd]||0    
    @end_time=0
    
    @level=info[:level]||1
    @table=info[:table]
    @data=info[:data]
    
    @comment=info[:comment]||:nil.to_s
  end
  def toggle(x,y,z)
    if @@SwitchTypeList.include?(@type)&&x&&y&&z      
      @switch=!@switch
      return true
    end
    return false
  end
  def cast(caster,target,x,y,z)
    if toggle(x,y,z)
      return
    end
	consum=@consum*(100+caster.attrib[:consum_amp])/100
    caster.can_cast?(@end_time,consum) or return
    
    caster.lose_sp(consum)
    
    cd_start
    @common_cd and
    if @common_cd.respond_to? :each
      @common_cd.each{|name|
        caster.skill[name] and caster.skill[name].cd_start
      }
    else
      caster.skill[@common_cd] and caster.skill[@common_cd].cd_start
    end
    @proc.call(caster:caster,target:target,x:x,y:y,z:z,args:@table[@level],data:@sdata)
  end
  def cast_attack(caster,target,atkspd)    
	consum=@consum*(100+caster.attrib[:consum_amp])/100
    caster.can_cast?(@end_time,@consum) or return
    
    reset_cd
    @cd=@cd*100/(atkspd)
    
    cast(caster,target,nil,nil,nil)
  end
  def cd=(cd)
    @cd=cd
  end
  def reset_cd
    @cd=@org_cd
  end
  def cd_over
    @end_time=0
  end
  def cd_start
    @end_time=SDL.get_ticks+@cd.to_sec.to_i
  end
  def draw_icon(x,y)
    @icon.draw(x,y)
  end
  def draw_name(x,y)
    Font.draw_solid(@name,15,x,y,255,255,0)
  end
  def draw_comment(x,y)
    Font.draw_solid(@comment,15,x,y,135,255,15)
  end
  def self.all_type_list
    [:none,:auto,:switch,:active,:append,:before,
     :switch_auto,:switch_append]
  end
end