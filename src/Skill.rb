#coding: utf-8
class Skill
  require_relative 'Skill/Base'
  require_relative 'Skill/Singleton'
  require_relative 'Skill/SkillTree'
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
        @icon=Input.load_icon(info[:icon])
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
    
    case consum=info[:consum]
    when Numeric
      @consum=Consumption.new({sp: consum})
    when Consumption
      @consum=consum
    else
      @consum=Consumption.new({})
    end
    
    @switch=!@@SwitchTypeList.include?(@type)
    
    @org_cd=@cd=info[:cd]||0
    @end_time=0
    
    @level=info[:level]||1
    @table=info[:table]||[0,0]
    @data=info[:data]
    
    @attach=info[:attach]
    
    @comment=DynamicString.new(info[:comment]||'nil',Color[:skill_comment_font],binding)
    @cd_pic=DynamicString.new('CD: #{"%.2f"%@cd}',Color[:skill_comment_font],binding)
  end
  def toggle(x,y,z)
    if @@SwitchTypeList.include?(@type)&&!x&&!y&&!z
      @switch=!@switch
      return true
    end
    return false
  end
  def cast(caster,target,x,y,z)
    toggle(x,y,z) and return
    @switch or return
    caster.can_cast?(@end_time,@consum) or return
    @consum.affect(caster)
    
    cd_start
    common_cd(caster)
    
    @attach and caster.skill[@attach].cast(caster,target,x,y,z)
    call_skill_base(caster,target,x,y,z)
  end
  def cast_auto(caster)
    caster.can_cast_auto?(@end_time,@consum) or return
    @consum.affect(caster)
    
    cd_start
    common_cd(caster)
    
    call_skill_base(caster,nil,nil,nil,nil)
  end
  def cast_attack(caster,target,base_cd)
    @equip_need and (caster.equip[@equip_need] or return)
    caster.can_cast?(@end_time,@consum) or return
    @consum.affect(caster)
    
    @cd=base_cd*100/caster.attrib[:atkspd]
    cd_start
    common_cd(caster)
    
    call_skill_base(caster,target,nil,nil,nil)
  end
  def cast_defense(caster,target,attack)
    @switch or return
    caster.can_cast?(@end_time,@consum) or return
    @consum.affect(caster)
    
    cd_start
    common_cd(caster)
    
    @proc.call(caster:caster,target:target,attack:attack,args:@table[@level],data:@data)
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
  def reset_cd
    @cd=@org_cd
  end
  def cd_over
    @end_time=0
  end
  def cd_start
    @end_time=Game.get_ticks+@cd.to_sec.to_i
  end
  def cding?
    return @end_time&&@end_time>=Game.get_ticks
  end
  def can_bind?
    return @@BindableList.include?(@type)
  end
  def draw_click_back(x,y)
    @@SkillBacks[:skill_clicked].draw_at(x,y)
  end
  def draw_back(x,y)
    case @type
    when *@@ActiveTypeList
      color=(cding?)?(:skill_active_cding_back):(:skill_active_back)
    when *@@SwitchTypeList
      color=(@switch)?(:skill_switch_on_back):(:skill_switch_off_back)
    else
      color=:skill_passive_back
    end
    @@SkillBacks[color].draw_at(x,y)
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
end