#coding: utf-8
require 'zlib'
inp=nil
Zlib::GzipReader.open('mon.pic'){|file|
  inp=Marshal.load(file)
}