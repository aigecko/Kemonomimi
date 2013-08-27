#coding: utf-8
require 'sys/proctable'

class Guard
  include Singleton
  def initialize
	@want_list=['olly', 'softice', 'cheat', 'dbg']
	@want_index=0

	@new_proc_list=[]
	@old_proc_list=['alg.exe', 'rmctrl.exe', 'svchost.exe',
	                         'System Idle Process', 'System', 'lsass.exe',
      						     'smss.exe', 'csrss.exe', 'services.exe',
							     'winlogin.exe', 'mDNSResponder.exe']

	@proc_name_list=[]
	@proc_index=0

	@procXwant=0

	@step=0
	@detect=false
	
	@Start_value=-1
  end
  def detect?
    @detect
  end  
  def DebuggerDetect
    if WIN32API.DebuggerDetect() > 0
     @detect=true
	end
  end
  def DebuggerSearch
	case @step
	when 0
	   Sys::ProcTable.ps{ |proc|
	    @new_proc_list<<proc.comm
	  }
	when 1
	  @new_proc_list.each{|name|
	    @proc_name_list<<name.downcase
	  }
	when 2
	  @new_proc_list-=@old_proc_list
	  if @new_proc_list==0
	   @step=@Start_value
		SDL.delay(200)
	  end
   when 3
	  @procXwant=@proc_name_list.size*@want_list.size	  
	else
	  if @step < @procXwant+4
		  @proc_index=(@step-4)>>2
		  @want_index=(@step-4)%4
		  if @proc_name_list[@proc_index].match(@want_list[@want_index])
		   @detect=true
		  end
	  else
		@step=@Start_value
		@old_proc_list|=@new_proc_list
		@proc_name_list=[]
	  end
	end
	@step+=1
  end
  def self.detect?
    return self.instance.detect?
  end
  def self.debugger_detect
    self.instance.DebuggerDetect
  end  
  def self.debugger_search
    self.instance.DebuggerSearch
  end
end