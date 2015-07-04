#!/usr/bin/ruby
#coding: utf-8
line=0
list={}
Dir.foreach('src'){|name|
  if name=~/\.rb$/
  open("./src/#{name}",'r:utf-8'){|file|
    line+=(list[name]=file.read.split(/\n/).size)
  }
  elsif name=='.'||name=='..'||name=~/\.c$/
  else
    path='src/'+name
    Dir.foreach(path){|name|
      name=~/\.rb$/ and
      open("./#{path}/#{name}",'r:utf-8'){|file|
        line+=(list[name]=file.read.split(/\n/).size)
      }
    }
  end
}
open('./main.rbw','r:utf-8'){|file|
  line+=file.read.split(/\n/).size
}
puts line
if ARGV[0]=='list'
  list.sort_by{|_,v| -v}.each{|name,count|
    print "%s:%d\n"%[name,count]
  }
end
STDIN.gets