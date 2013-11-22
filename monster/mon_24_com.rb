#coding: utf-8
require 'zlib'
out=Hash.new
dir='mon_24'
Dir.foreach(dir){|name|
  if name=~/bmp/
    File.open("./#{dir}/#{name}",'rb'){|file|
	  out[name]=file.read
	}
  end
}
Zlib::GzipWriter.open('mon.pic'){|file|
  file.write Marshal.dump(out)

}