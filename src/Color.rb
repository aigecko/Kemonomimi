class Color
  def self.init
    @color=Hash.new([0,0,0])
    @color={
      clear:[89,214,255],
    
      loading_font:[128,128,128],
      
      focused_select:[0,0,255],
      normal_select:[255,255,255],
      title:[0,0,125],
      comment:[0,0,25],
      text:[0,50,125],
      
      font_demo:[0,64,128],
      
      level_win_font:[23,41,83],
      
      bar_hp_back:[255,220,215],
      bar_hp_leave:[236,159,159],
      bar_hp:[255,73,47],
      font_hp:[105,16,16],
      
      bar_sp_back:[179,228,255],
      bar_sp_leave:[140,192,255],
      bar_sp:[0,115,255],
      font_sp:[11,4,72],
      
      bar_exp_back:[255,249,170],
      bar_exp_leave:[255,228,121],
      bar_exp:[236,189,0],
      font_exp:[66,64,0],
      
      icon_light:[128,191,255],
      icon_dark:[9,132,255],
      
      attrib_str:[106,170,240],
      attrib_val:[182,204,244],
      attrib_font:[0,0,128],
      attrib_plus:[180,2,255],
      
      drag_bar:[0,0,255],
      drag_title:[147,190,255,],
      
      item_tag_font:[22,66,148],
      item_tag_focus:[122,162,235],
      item_tag_normal:[182,204,244],
      item_page:[200,200,255],
      item_box:[0,159,236],
      item_money_font:[0,128,41],
      
      equip_pic_back:[153,206,238],
      equip_str_back:[128,194,234],
      equip_str_font:[19,49,119],
      part_str_font:[116,38,149],
      
      click_box_back:[255,0,0],
      
      item_drag_bar_back:[20,20,255],
      item_drag_bar:[186,205,242],
      
      item_comment_font:[34,65,102],
      item_rect_back:[240,240,255],
      item_name_font:[32,32,94],
      item_count_font:[210,249,255],
      equip_attrib_sym_font:[21,120,230],
      equip_attrib_val_font:[89,43,213],
      
      attack_phy:[255,0,0],
      attack_mag:[128,0,255],
      attack_umag:[128,0,128],
      attack_acid:[255,255,255],
      
      heal_hp_font:[20,232,9],
      heal_sp_font:[0,255,255],
      
      statement_back:[0,217,255],
      statement_border:[47,57,128],
      
      actor_hpbar_back:[0,0,0],
      actor_hpbar:[255,0,0],
      player_hpbar:[255,128,0],
      
      skill_comment_font:[0,94,0],
      
      shadow:[0,0,0]
    }
  end
  def self.[](sym)
    @color[sym]
  end
end