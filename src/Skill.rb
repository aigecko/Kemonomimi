#coding: utf-8
require_relative 'Skill_Base'
class Skill
  @@SwitchTypeList=[:switch,:switch_auto,:switch_append,:switch_attack_defense]
  attr_reader :switch,:invisible,:type
  attr_writer :cd
  def initialize(info,sym=nil)
    @name=info[:name]
    @sym=sym
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
    rescue => e
      p e
      p info[:icon]
      Message.show(:skill_pic_load_failure)
      exit
    end
    @common_cd=info[:common_cd]
    
    @proc=Base[info[:base]]
    @type=info[:type]
    @equip_need=info[:equip_need]
    
    @consum=info[:consum]||0
    
    @switch=!@@SwitchTypeList.include?(@type)
    
    @org_cd=@cd=info[:cd]||0
    @end_time=0
    
    @level=info[:level]||1
    @table=info[:table]||[0,0]
    @data=info[:data]
    
    @attach=info[:attach]
    
    @comment=DynamicString.new(info[:comment]||'nil',:skill_comment_font,binding)    
    @cd_pic=DynamicString.new('CD: #{"%.2f"%@cd}',:skill_comment_font,binding)
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
    
    @attach and caster.skill[@attach].cast(caster,target,x,y,z)
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
  def cast_defense(caster,target,attack)
    @switch and
    @proc.call(caster:caster,target:target,attack:attack,args:@table[@level],data:@data)
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
  def cding?
    return @end_time&&@end_time>SDL.get_ticks
  end
  def draw_icon(x,y)
    @icon.draw(x,y)
    
    @sym and 
    if key=HotKey.get_key(@sym)
      key!=@hotkey_str and
      @hotkey_str=Font.render_texture(Key.get_key_name(key).upcase,15,*Color[:hotkey_font])
      
      @hotkey_str and @hotkey_str.draw(x+22-@hotkey_str.w,y+24-@hotkey_str.h)
    end    
  end
  def draw_name(x,y)
    Font.draw_texture(@name,15,x,y,*Color[:skill_name])
  end
  def draw_cd(x,y)
    @cd>0 or return
    @cd_pic.draw(x,y)
  end
  def draw_comment(x,y)
    @comment.draw(x,y)
  end
  def self.all_type_list
    [:none,:auto,:switch,:active,:append,:before,:attach,
     :attack,:shoot,
     :pre_attack_defense,:attack_defense,:skill_defense,
     :switch_auto,:switch_append,:switch_attack_defense]
  end
end