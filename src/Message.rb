#coding: utf-8
class Message
  @@table={
    #設定檔相關訊息
    config_data_lost: ['設定檔遺失', '錯誤', :OK, :ERROR],
    config_data_error:['設定檔錯誤', '錯誤', :OK, :ERROR],
    config_data_rewrite:['設定檔覆寫', '提示', :OK, :ASTERISK],
    config_data_create:['產生設定檔', '提示', :OK, :ASTERISK],
    config_load_default:['使用原先設定','提示',:OK, :ASTERISK],

    #錯誤相關訊息
    initialize_failure:['初始化錯誤', '錯誤', :OK, :ERROR],
    several_failure:['多次錯誤!!', '錯誤', :OK, :ERROR],
    game_already_run:['遊戲已運行!結束!','提示',:OK,:ERROR],

    #請求訊息
    please_restart_game:['請重新啟動遊戲','提示',:OK,:ASTERISK],
    please_check_files:['請檢查檔案', '提示', :OK, :ASTERISK],

    #載入相關訊息
    font_lost:['字型不存在', '錯誤', :OK, :ERROR],	  

    ui_pic_lost:['介面圖片遺失','錯誤',:OK,:ERROR],
    ui_pic_load_failure:['介面圖片載入失敗','錯誤',:OK,:ERROR],
    title_lost:['選單圖片遺失','錯誤',:OK,:ERROR],
    title_load_failure:['選單圖片載入失敗','錯誤',:OK,:ERROR],

    item_load_failure:['物品載入錯誤','錯誤', :OK, :ERROR],
    class_load_failure:['職業載入錯誤','錯誤', :OK, :ERROR],
    rece_load_failure:['種族載入錯誤','錯誤', :OK, :ERROR],
    equip_load_failure:['裝備載入錯誤','錯誤', :OK, :ERROR],
    consum_load_failure:['消耗品載入錯誤','錯誤', :OK, :ERROR],
    skill_load_failure:['技能載入錯誤','錯誤', :OK, :ERROR],
    
    actor_pic_lost:['人物圖片遺失','錯誤', :OK, :ERROR],
    actor_pic_rescue:['使用備用圖片','提示', :OK, :ASTERISK],
    actor_pic_load_failure:['人物圖片載入失敗','錯誤', :OK, :ERROR],
    actor_pic_format_wrong:['人物圖片格式錯誤','錯誤', :OK, :ERROR],
    equip_pic_load_failure:['裝備圖片載入失敗','錯誤', :OK, :ERROR],
    skill_pic_load_failure:['技能圖片載入失敗','錯誤', :OK, :ERROR],
      
    ai_fetch_failure:['AI選取失敗','錯誤', :OK, :ERROR],
    #提示訊息
    unvalid_equip:['裝備不存在','錯誤', :OK, :ASTERISK],

    #謎樣訊息
    debugger_present: ['偵測到核心崩潰前兆','警告', :OK, :WARNING]

  }
  def self.show(function)
    message=@@table[function]
    WIN32API.ShowMessage(message[0],message[1],message[2],message[3])
  end
  def self.show_format(format,title,type)
    WIN32API.ShowMessage(format, title, :OK, type)
  end
  def self.show_backtrace(e)
    p e
    e.backtrace.each{|line|
      print "\t"
      puts line
    }
  end
end