#!/usr/bin/ruby
#coding: utf-8
line=0
Dir.foreach('src'){|name|
  if name=~/\.rb$/
  open("./src/#{name}",'r:utf-8'){|file|
    begin
      line+=file.read.split(/\n/).size
    rescue
      p name
      exit
    end
  }
  elsif name=='.'||name=='..'||name=~/\.c$/
  else
    path='src/'+name
    Dir.foreach(path){|name|
      name=~/\.rb$/ and
      open("./#{path}/#{name}",'r:utf-8'){|file|
        begin
          line+=file.read.split(/\n/).size
        rescue
          p name
          exit
        end
      }
    }
  end
}
open('./main.rbw','r:utf-8'){|file|
  line+=file.read.split(/\n/).size
}
print line
gets