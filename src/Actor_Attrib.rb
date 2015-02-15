#coding: utf-8
class Actor::Attrib
  @@Conv={
    str:{atk: 1},
    con:{def: 1,maxhp: 10},#}
    int:{matk: 1},
    wis:{mdef: 1,maxsp: 10},
    agi:{ratk: 1}
  }
  @@Max={
    level: 200,
    str: 1024,
    con: 1024,
    int: 1024,
    wis: 1024,
    agi: 1024
  }
  @@Base=[:str,:con,:int,:wis,:agi]
  @@Coef={
    extra: 7,      
    healhp: 0.01,
    healsp: 0.02,
    
    growth: 10,
    amped: 100,
    step: 40,
    
    agi_div: 50.0,
    agi_exp: 1.06,
    agi_mul: 2,
    dodge_exp: 1.3,
    dodge_max: 30,
    dtob: 0.8,
    atkspd_max: 500
  }
  attr_accessor :equip
  attr_reader :total
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
     :level,:money].each{|sym|
      @base[sym]=base[sym]+attrib[sym]
    }

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
    [:wlkspd,:atkspd,:jump,:level].each{|sym|
      @total[sym]=@base[sym]
    }      
  
    [:mag_outamp,:phy_outamp,
     :mag_resist,:phy_resist,:atk_resist,
     :mag_decatk,:phy_decatk,
     :consum_amp,:heal_amp,:tough,
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
     :maxhp,:maxsp,:healhp,:healsp,
     :mag_outamp,:phy_outamp,
     :mag_resist,:phy_resist,:atk_resist,
     :mag_decatk,:phy_decatk,
     :consum_amp,:heal_amp,:tough,
     :atk_vamp,:skl_vamp,
     :critical,:bash].each{|sym|
      @total[sym]+=@state[sym]
      @total[sym]+=@equip[sym]
    }
    @total[:wlkstep]=@total[:wlkspd]/@@Coef[:step].to_f
    @total[:hlhpstep]=@total[:healhp]/25.to_f
    @total[:hlspstep]=@total[:healsp]/25.to_f
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
    
    # if @total[:dodge]>@@Coef[:dodge_max]
      # @total[:block]+=(@total[:dodge]-@@Coef[:dodge_max])*@@Coef[:dtob]
      # @total[:dodge]=@@Coef[:dodge_max]
    # end
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
          
    @total[:wlkspd]+=@total[:wlkspd]*@amped[:wlkspd]/@@Coef[:amped]
    @total[:wlkstep]=@total[:wlkspd].confine(0,@total[:wlkspd])
    @total[:wlkstep]=@total[:wlkspd]/@@Coef[:step].to_f
    
    @total[:atkspd]>@@Coef[:atkspd_max] and @total[:atkspd]=@@Coef[:atkspd_max]
  end
  def compute_total
    compute_base_attrib
    compute_state_equip
    compute_block_dodge
    compute_amp_attrib
  end
  def marshal_dump
    data={}
    instance_variables.each{|var|
      data[var]=instance_variable_get(var)
    }
    return [data]
  end
  def marshal_load(array)
    array[0].each{|sym,val|
      instance_variable_set(sym,val)
    }
  end
end