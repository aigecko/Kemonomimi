#coding: utf-8
class WIN32API
  include Singleton
  def initalize
  end
  def FindWindow(window_name)
    system()
  end
  def ShowMessage(title,message,mb,icon,top_most)
    system("echo \"#{title}: #{message}\"")
  end
  def DebuggerDetect
    return false
  end
  def self.FindWindow(window_name)
  end
  def self.ShowMessage(title,message,mb,icon,top_most)
  end
  def self.DebuggerDetect
  end
end