#coding: utf-8
require 'openssl'
require 'digest'
require 'zlib'
require 'pp'

#加密設定
$Encrypt=true

def Output(name)
  #輸出設定
  eval("Output=$#{name}")
  #檔案輸出
  Zlib::GzipWriter.open("../rc/data/#{name}.data"){|file|
    pp Output
    data=Marshal.dump(Output)
    if $Encrypt
      cipher=OpenSSL::Cipher::Cipher.new('bf-cbc')
      cipher.encrypt
      cipher.key=Digest::SHA1.hexdigest('')
      str=cipher.update(data)<<cipher.final
    else
      str=data
    end
    file.write str
  }
  puts "#{name} OK"
  gets
end