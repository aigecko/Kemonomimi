#coding: utf-8
class WIN32API
  def self.FindWindow(window_name)	
    return 0
  end
  def self.ShowMessage(message,title,mb,icon,top_most=false)
	system("echo \"#{title}: #{message}\"")
  end
  def self.DebuggerDetect	
    return false
  end
end