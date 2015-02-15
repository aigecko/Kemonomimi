#!/usr/bin/ruby
#coding: utf-8
line=0
Dir.foreach('src'){|name|
  name=~/rb/ and
  open("./src/#{name}",'r:utf-8'){|file|
    begin
      line+=file.read.split(/\n/).size
    rescue
      p name
      exit
    end
  }
}
open('./main.rbw','r:utf-8'){|file|
  line+=file.read.split(/\n/).size
}
print line
gets