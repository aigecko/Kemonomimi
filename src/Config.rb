#coding: utf-8
class Conf
  @@filename=''
  def self.init
    @config=Hash.new
    @config['FULL_SCREEN']=false
    @config['SDL_VIDEO_CENTERED']=true
    @config['MUSIC']=true
    @config['SOUND']=true
    @@filename="./config.yaml"
  end
  def self.load
    if FileTest.exist?(@@filename)
      File.open(@@filename,'rb'){|file|
        begin
          new_config=YAML.load(file)
          @config.merge!(new_config)
        rescue Psych::SyntaxError
          Message.show(:config_data_error)
          save()
          Message.show(:onfig_data_rewrite)
        end
      }
    else
      Message.show(:config_data_lost)
      save()
      Message.show(:config_data_create)
    end
  end
  def self.save
    File.open(@@filename,'wb'){|file|
      file.print YAML.dump(@config)
    }
  end
  def self.fix
    self.init
    self.save
  end
  def self.[](key)
    return @config[key]
  end
  def self.[]=(key,value)
    @config[key]=value
  end
  def self.each
    @config.each{|key,val| yield key,val}
  end
  def self.each_value
    @config.each_value{|val| yield val}
  end
  def self.each_key
    @config.each_key{|key| yield key}
  end
end
