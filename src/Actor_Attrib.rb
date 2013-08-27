#coding: utf-8
class Actor
  class Attrib
    @@Conv={
	  str:{atk:1},
	  con:{def:1,maxhp:10},
	  int:{matk:1},
	  wis:{mdef:1,maxsp:10},
	  agi:{ratk:1}
	}#}
	@@Max={
      level:20,
	  str:1024,
	  con:1024,
	  int:1024,
	  wis:1024,
	  agi:1024
	}
    #attr_reader :base
    attr_accessor :equip
    attr_reader :total
    def initialize(attrib,race,klass)
      base=Database.get_base(race)
	  growth=Database.get_growth(klass)
	  base.default=0
	  attrib.default=0
	  @base=Hash.new(0)
      [:str,:con,:int,:wis,:agi,
       :maxhp,:maxsp,:wlkspd,:jump,:level].each{|sym|
		@base[sym]=base[sym]+attrib[sym]
	  }
      
      @state=Hash.new(0)
      @equip=Hash.new(0)
	  @total=Hash.new(0)
      @growth=growth
      
      @base[:level]=[@base[:level],1].max
      compute_base
      compute_total
      
      @total[:hp]=@total[:maxhp]
      @total[:sp]=@total[:maxsp]
      @total[:exp]=0
      @total[:maxexp]=Actor.get_need_exp(@base[:level])
      @total[:extra]=7	  
    end
	def gain_attrib(attrib)
	  attrib.each{|sym,value|
	    @base[sym]+=value
	  }
	  compute_base
	  compute_total
	end
	def lose_attrib(attrib)
	  attrib.each{|sym,value|
	    @base[sym]-=value
	  }
      compute_base
	  compute_total
	end
    def gain_equip_attrib(attrib)      
	  attrib.each{|sym,value|
	    @equip[sym]+=value
	  }
	  compute_base
	  compute_total
    end
    def lose_equip_attrib(attrib)
	  attrib.each{|sym,value|
	    @equip[sym]-=value
	  }
      compute_base
	  compute_total
    end
    def gain_state_attrib(attrib)
      attrib.each{|sym,value|
        @state[sym]+=value
      }
      compute_base
      compute_total
    end
    def lose_state_attrib(attrib)
      attrib.each{|sym,value|
        @state[sym]-=value
      }
      compute_base
      compute_total
    end
    def [](sym)
      return @total[sym]
    end
	def []=(sym,value)
	  @total[sym]=value
	end
    def gain_exp(exp)
      @total[:exp]+=exp
      if @total[:exp]>=@total[:maxexp]
        if @base[:level]<@@Max[:level]
          @total[:exp]-=@total[:maxexp]
          @base[:level]+=1
        else
          @total[:exp]=@total[:maxexp]
          return
        end
      end
      @total[:maxexp]=Actor.get_need_exp(@base[:level])
      @total[:extra]+=7
        
      compute_total
    end
    def compute_base
      [:str,:con,:int,:wis,:agi].each{|base|
        @@Conv[base].each{|key,val|
          @base[key]=@base[base]*val
        }
      }
    end
    def compute_total
      [:str,:con,:int,:wis,:agi].each{|base|
        @total[base]=@base[base]+@equip[base]+@state[base]+@growth[base]*@base[:level]/10
        @@Conv[base].each{|key,val|
          @total[key]=@total[base]*val
        }
      }
      
      @total[:wlkspd]=@base[:wlkspd]
      @total[:jump]=@base[:jump]
      @total[:level]=@base[:level]
      
      @total[:healhp]=@total[:str]*0.01
	  @total[:healsp]=@total[:int]*0.02
      
      
      [:atk,:def,:matk,:mdef,:ratk,
       :wlkspd,:maxhp,:maxsp,
       :healhp,:healsp].each{|sym|
        @total[sym]+=@state[sym]
        @total[sym]+=@equip[sym]
      }
      
      value=(@total[:agi]/50.0+0.5)**1.05
      agi=@total[:agi]
      str=@total[:str]
      @total[:dodge]=value*(agi**1.3)/((str+agi)**1.3)
      @total[:block]=value-@total[:dodge]
      if @total[:dodge]>30       
        @total[:block]+=(@total[:dodge]-30)*0.8
        @total[:dodge]=30
      end
      
	  @total[:hp]>@total[:maxhp] and @total[:hp]=@total[:maxhp]
	  @total[:sp]>@total[:maxsp] and @total[:sp]=@total[:maxsp]
      
      @total[:wlkstep]=@total[:wlkspd]/40.to_f
    end
  end
end