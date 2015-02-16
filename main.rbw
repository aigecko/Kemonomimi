#!/usr/bin/ruby
#coding: utf-8
$t=Time.now
std_lib=%w(sdl gl glu yaml singleton pathname pp)
std_lib.each{|lib|
  require "#{lib}"
}
begin
  require "win32api"
rescue LoadError
  require_relative "src/linux/Win32api"
  require_relative "src/linux/Surface_Blend"
else  
  require_relative "src/win32/Win32api"
  require_relative "src/win32/Surface_Blend"
end
my_lib=%w(Color Screen Config Message Icon
          Font Input Extension Skill Mouse
          Texture Drawable Game)
my_lib.each{|lib|
  require_relative "src/#{lib}"
}
Game.init
Game.show
