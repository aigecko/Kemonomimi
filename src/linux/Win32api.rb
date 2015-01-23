#coding: utf-8
class WIN32API
  @window_name="main.rbw"
  @message_type={ERROR: "error",ASTERISK:"warning"}
  def self.FindWindow(window_name)
    return `ps -C "#{@window_name}" -o pid=|wc`.split(/\s+/)[1].to_i-1
  end
  def self.ShowMessage(message,title,mb,icon,top_most=false)
	system("zenity --#{@message_type[icon]} --text=#{title}:#{message} --no-wrap")
  end
  def self.DebuggerDetect	
    return false
  end
end
