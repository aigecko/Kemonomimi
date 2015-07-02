#coding: utf-8
class Actor::Attrib
  require_relative 'Actor_AttribSingleton'
  attr_accessor :equip
  def initialize(attrib,race,klass)
    base=Database.get_base(race)
    growth_base=Database.get_class(klass)
    base.default=0
    attrib.default=0

    @base=Hash.new(0)
    [:str,:con,:int,:wis,:agi,
     :atk,:def,:matk,:mdef,:ratk,
     :maxhp,:maxsp,
     :wlkspd,:jump,:atkspd,
     :level,:money
     ].each{|sym|
      @base[sym]=base[sym]+attrib[sym]
    }
    @base[:atkcd]=growth_base[:attack_cd]
    @base[:shtcd]=growth_base[:arrow_cd]

    [:atk,:matk,:ratk].each{|sym| @base[sym]+=growth_base[sym]}

    @state=Hash.new(0)
    @equip=Hash.new(0)
    @state[:critical]=[]
    @equip[:critical]=[]
    @equip[:bash]=[]
    @state[:bash]=[]
    @amped=Hash.new(0)
    @total=Hash.new(0)

    @growth=growth_base 

    @base[:level]=[@base[:level],1].max
    @base[:atkspd]==0 and @base[:atkspd]=100

    compute_total
    
    @total[:hp]=@total[:maxhp]
    @total[:sp]=@total[:maxsp]
    @total[:exp]=attrib[:exp]
    @total[:maxexp]=Actor.get_need_exp(@base[:level])
    @total[:extra]=@@Coef[:extra]
  end
  [:base,:equip,:state].each{|name|
  [:gain,:lose].each{|act|
  eval %Q{
  def #{act}_#{name}_attrib(attrib)
    attrib.each{|sym,value|
      if [:dodge,:block,
          :healhp,:healsp,
          :atk_vamp,:skl_vamp,
          :critical,:bash].include?(sym)||value.integer?
        #{(name==:state&&act==:lose)? "(sym==:hp||sym==:sp||sym==:mag_shield||sym==:atk_shield) or ":''}
        @#{name}[sym]#{act==:gain ? '+':'-'}=value
      else
        @amped[sym]#{act==:gain ? '+':'-'}=(value*100).to_i
      end
    }
    compute_total
  end
  }}}
  def [](sym)
    return @total[sym]
  end
  def []=(sym,value)
    @total[sym]=value
  end
  def gain_exp(exp)
    @total[:exp]+=exp
    while @total[:exp]>=@total[:maxexp]
      if @base[:level]<@@Max[:level]
        @total[:exp]-=@total[:maxexp]
        @base[:level]+=1
        
        @total[:maxexp]=Actor.get_need_exp(@base[:level])
        @total[:extra]+=@@Coef[:extra]
      else
        @total[:exp]=@total[:maxexp]
        return
      end
    end
    compute_total
  end
  def consume(consumption)
    consumption.each{|sym,val|
      val=val*(100+@total[:consum_amp])/100
      @total[sym]= (@total[sym]>val) ? (@total[sym]-val) : 0
    }
  end
  def >=(consumption)
    consumption.each{|sym,val|
      @total[sym]<val and return false
    }
    return true
  end
private
  def compute_base_attrib
    @@Base.each{|base|
      @total[base]=@base[base]+@equip[base]+@state[base]+
                   @growth[base]*@base[:level]/@@Coef[:growth]
      @@Conv[base].each{|key,val|
        @total[key]=@base[key]+@total[base]*val
      }
    }
  end
  def compute_state_equip
    [:wlkspd,:atkspd,:jump,:level,:atkcd,:shtcd].each{|sym|
      @total[sym]=@base[sym]
    }

    [:mag_outamp,:phy_outamp,
     :mag_resist,:phy_resist,:atk_resist,
     :mag_decatk,:phy_decatk,
     :consum_amp,:heal_amp,:tough,
     :max_mag_shield,:max_atk_shield,
     :atk_vamp,:skl_vamp].each{|sym|
      @total[sym]=0
    }

    @total[:critical]=[]
    @total[:bash]=[]
    @total[:healhp]=@total[:str]*@@Coef[:healhp]
    @total[:healsp]=@total[:int]*@@Coef[:healsp]
    @total[:tough]=@base[:level]

    [:atk,:def,:matk,:mdef,:ratk,
     :wlkspd,:atkspd,
     :maxhp,:maxsp,:healhp,:healsp,:hp,:sp,
     :mag_outamp,:phy_outamp,
     :mag_resist,:phy_resist,:atk_resist,
     :mag_decatk,:phy_decatk,
     :consum_amp,:heal_amp,:tough,
     :mag_shield,:max_mag_shield,
     :atk_shield,:max_atk_shield,
     :atk_vamp,:skl_vamp,
     :critical,:bash].each{|sym|
      @total[sym]+=@state[sym]
      @total[sym]+=@equip[sym]
    }
    @state[:hp]=@state[:sp]=0
    @state[:mag_shield]=@state[:atk_shield]=0
  end
  def compute_block_dodge
    agi=@total[:agi]
    str=@total[:str]
    value=(agi/@@Coef[:agi_div])**@@Coef[:agi_exp]*@@Coef[:agi_mul]

    @total[:dodge]=value*(agi**@@Coef[:dodge_exp])/((str+agi)**@@Coef[:dodge_exp])
    @total[:block]=value-@total[:dodge]
    @total[:ignore]=0

    [:dodge,:block,:ignore].each{|sym|
      @total[sym]+=@state[sym]
      @total[sym]+=@equip[sym]
    }
  end
  def compute_amp_attrib
    @@Base.each{|base|
      delta_base=@total[base]
      @total[base]+=@amped[base]*@total[base]/@@Coef[:amped]
      delta_base=@total[base]-delta_base
      @@Conv[base].each{|key,val|
        @total[key]+=delta_base*val
        @total[key]+=@amped[key]*@total[key]/@@Coef[:amped]
      }
    }

    @total[:hp]>@total[:maxhp] and @total[:hp]=@total[:maxhp]
    @total[:sp]>@total[:maxsp] and @total[:sp]=@total[:maxsp]
    @total[:mag_shield]=@total[:mag_shield].confine(0,@total[:max_mag_shield])
    @total[:atk_shield]=@total[:atk_shield].confine(0,@total[:max_atk_shield])

    @total[:wlkspd]+=@total[:wlkspd]*@amped[:wlkspd]/@@Coef[:amped]
    @total[:wlkstep]=@total[:wlkspd].confine(0,@total[:wlkspd])

    @total[:atkspd]>@@Coef[:atkspd_max] and @total[:atkspd]=@@Coef[:atkspd_max]
  end
  def compute_step
    @total[:wlkstep]=@total[:wlkspd]/Game.FPS
    @total[:hlhpstep]=@total[:healhp]/Game.FPS
    @total[:hlspstep]=@total[:healsp]/Game.FPS
  end
public
  def compute_total
    compute_base_attrib
    compute_state_equip
    compute_block_dodge
    compute_amp_attrib
    compute_step
  end
  def set_attack_cd(cd)
    @base[:atkcd]=cd
  end
  def set_shoot_cd(cd)
    @base[:shtcd]=cd
  end
  def marshal_dump
    data={}
    @@MarshalTable.each{|abbrev,name|
      variable=instance_variable_get(name)
      hash=data[abbrev]={}
      attrib_list=variable.keys&Attribute.attrib_table.keys
      attrib_list.each{|sym|
        (value=variable[sym])!=0 and
        hash[Attribute.attrib_table[sym]]=value
      }
    }
    p data
    return [data]
  end
  def marshal_load(array)
    data=array[0]
    @@MarshalTable.each{|abbrev,name|
      hash=Hash.new(0)
      variable=data[abbrev]
      variable.each{|abbsym,value|
        hash[Attribute.abbrev_table[abbsym]]=value
      }
      instance_variable_set(name,hash)
    }
    @growth=Database.get_class(Game.player.class)
    @total[:maxexp]=Actor.get_need_exp(@base[:level])
  end
end