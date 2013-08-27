#coding: utf-8
class WIN32API
  include Singleton
  def initialize
    @FindWindow=Win32API.new('user32', 'FindWindow', %w(L P), 'L')
    @MessageBox=Win32API.new('user32', 'MessageBox', %w(P P P I), 'I')
	@IsDebuggerPresent=Win32API.new('kernel32', 'IsDebuggerPresent', 'V','I')
	
	@mb=Hash.new
	@mb[:OK]=0
    @mb[:OK_CANCEL]=1
    @mb[:ABORT_RETRY_IGNORE]=2
    @mb[:ES_NO_CANCEL]=3
    @mb[:YES_NO]=4
    @mb[:RETRY_CANCEL]=5
	
	@icon=Hash.new
	@icon[:NONE]=0
	@icon[:WARNING]=16
	@icon[:QUESTION]=32
	@icon[:ERROR]=48
	@icon[:ASTERISK]=64
	
	@top_most=Hash.new
	@top_most[true]=0x4000
	@top_most[false]=0
  end
  def FindWindow(window_name)
    return @FindWindow.call(0, window_name.encode!('big5'))
  end
  def ShowMessage(title, message, mb, icon, top_most= false)
    @MessageBox.call(0, title.encode!('big5'), message.encode!('big5'),
                                  	@mb[mb]+@icon[icon]+@top_most[top_most])
  end
  def DebuggerDetect
    @IsDebuggerPresent.call()
  end
  def self.FindWindow(window_name)
    self.instance.FindWindow(window_name)
  end
  def self.ShowMessage(title, message, mb, icon, top_most= false)
    self.instance.ShowMessage(title, message, mb, icon, top_most= false)
  end
  def self.DebuggerDetect
    self.instance.DebuggerDetect()
  end
end