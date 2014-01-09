#coding: utf-8
class Actor
  class Attrib
    @@Conv={
	  str:{atk: 1},
	  con:{def: 1,maxhp: 10},
	  int:{matk: 1},
	  wis:{mdef: 1,maxsp: 10},
	  agi:{ratk: 1}
	}#}
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
      atkspd_max: 400
    }
    #attr_reader :base
    attr_accessor :equip
    attr_reader :total
    def initialize(attrib,race,klass)
      base=Database.get_base(race)
	  growth_base=Database.get_class(klass)
	  base.default=0
	  attrib.default=0
      
     
	  @base=Hash.new(0)
      [:str,:con,:int,:wis,:agi,
       :maxhp,:maxsp,
       :wlkspd,:jump,:atkspd,
       :level,:money].each{|sym|
		@base[sym]=base[sym]+attrib[sym]
	  }
      
      @base_attack=Hash.new(0)
      [:atk,:matk,:ratk].each{|sym| @base_attack[sym]=growth_base[sym]}
      
      @state=Hash.new(0)
      @equip=Hash.new(0)
      @amped=Hash.new(0)      
	  @total=Hash.new(0)
      
      @growth=growth_base 
      
      @base[:level]=[@base[:level],1].max
      @base[:atkspd]=100
	  
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
        if value.integer?||
           [:dodge,:block,:healhp,:healsp,:atk_vamp,:skl_vamp].include?(sym)
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
      if @total[:exp]>=@total[:maxexp]
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
        #@total[base]+=@amped[base]*@total[base]/@@Coef[:amped]
             
        @@Conv[base].each{|key,val|
          @base[key]=@base[base]*val
          @total[key]=@total[base]*val+@base_attack[key]
          #@total[key]+=@amped[key]*@total[key]/@@Coef[:amped]
        }
      }
    end
    def compute_state_equip
      [:wlkspd,:atkspd,:jump,:level].each{|sym|
        @total[sym]=@base[sym]
      }      
	  
	  [:magic_amp,:consum_amp,
       :atk_vamp,:skl_vamp].each{|sym|
	    @total[sym]=0
	  }
      #dbg
      @total[:healhp]=@total[:str]*@@Coef[:healhp]
	  @total[:healsp]=@total[:int]*@@Coef[:healsp]
	  
      [:atk,:def,:matk,:mdef,:ratk,
       :wlkspd,:atkspd,
       :maxhp,:maxsp,:healhp,:healsp,
	   :magic_amp,:consum_amp,
       :atk_vamp,:skl_vamp].each{|sym|
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
      
      @total[:dodge]+=@state[:dodge]
      @total[:dodge]+=@equip[:dodge]
      
      @total[:block]+=@state[:block]
      @total[:block]+=@equip[:block]
      
      if @total[:dodge]>@@Coef[:dodge_max]
        @total[:block]+=(@total[:dodge]-@@Coef[:dodge_max])*@@Coef[:dtob]
        @total[:dodge]=@@Coef[:dodge_max]
      end
    end
    def compute_amp_attrib
      @@Base.each{|base|
        delta_base=@total[base]
        @total[base]+=@amped[base]*@total[base]/@@Coef[:amped]
        delta_base=@total[base]-delta_base
        @@Conv[base].each{|key,val|
          @total[key]+=delta_base*val+@base_attack[key]          
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
	  maxhp=@total[:maxhp]
	  maxsp=@total[:maxsp]
	  
      compute_base_attrib
      compute_state_equip
      compute_block_dodge
      compute_amp_attrib
	  
	  maxhp>0 and @total[:maxhp]>maxhp and @total[:hp]=@total[:hp]*@total[:maxhp]/maxhp
	  maxsp>0 and @total[:maxsp]>maxsp and @total[:sp]=@total[:sp]*@total[:maxsp]/maxsp
    end
  end
end