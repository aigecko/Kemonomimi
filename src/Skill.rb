#coding: utf-8
require_relative 'Skill_Base'
class Skill
  @@SwitchTypeList=[:switch,:switch_auto,:switch_append]
  attr_reader :switch,:invisible,:type
  attr_writer :cd
  def initialize(info)
    @name=info[:name]
    unless @name
      Message.show_format('技能名稱設定錯誤','錯誤',:ERROR)
      exit
    end
    
    begin
      if info[:icon]
        @icon=Icon.load(info[:icon])
      else
        @invisible=true
      end
    rescue
      p info[:icon]
      Message.show(:skill_pic_load_failure)
      exit
    end
    @common_cd=info[:common_cd]
    
    @proc=Base[info[:base]]
    @type=info[:type]
    @equip_need=info[:equip_need]
    
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
    
    @comment=DynamicString.new(info[:comment]||'nil',:skill_comment_font,binding)    
    @cd_pic=DynamicString.new('CD: #{@cd}',:skill_comment_font,binding)
  end
  def toggle(x,y,z)
    if @@SwitchTypeList.include?(@type)&&!x&&!y&&!z
      @switch=!@switch
      return true
    end
    return false
  end
  def cast(caster,target,x,y,z)
    if toggle(x,y,z)
      return
    end
    @switch or return
    
    consum=@consum*(100+caster.attrib[:consum_amp])/100
    caster.can_cast?(@end_time,consum) or return
    caster.lose_sp(consum)
    cd_start
    common_cd(caster)
    call_skill_base(caster,target,x,y,z)
  end
  def cast_auto(caster)
    consum=@consum*(100+caster.attrib[:consum_amp])/100
    caster.can_cast_auto?(@end_time,consum) or return    
    caster.lose_sp(consum)
    
    cd_start
    common_cd(caster)
    
    call_skill_base(caster,nil,nil,nil,nil)
  end
  def common_cd(caster)
    @common_cd and
    if @common_cd.respond_to? :each
      @common_cd.each{|name|
        caster.skill[name] and caster.skill[name].cd_start
      }
    else
      caster.skill[@common_cd] and caster.skill[@common_cd].cd_start
    end
  end
  def call_skill_base(caster,target,x,y,z)
    @proc.call(caster:caster,target:target,x:x,y:y,z:z,args:@table[@level],data:@data)
  end
  def cast_attack(caster,target,atkspd)
    @equip_need and (caster.equip[@equip_need] or return)
    consum=@consum*(100+caster.attrib[:consum_amp])/100
    caster.can_cast?(@end_time,@consum) or return
    caster.lose_sp(consum)
    
    reset_cd    
    @cd=@cd*100/(atkspd)
    
    cd_start
    common_cd(caster)
    
    call_skill_base(caster,target,nil,nil,nil)
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
  def draw_cd(x,y)
    @cd>0 and @cd_pic.draw(x,y)
  end
  def draw_comment(x,y)
    @comment.draw(x,y)
  end
  def self.all_type_list
    [:none,:auto,:switch,:active,:append,:before,
     :attack,:shoot,:defense,:pf_defense,
     :switch_auto,:switch_append]
  end
end