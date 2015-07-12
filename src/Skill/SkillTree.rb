#coding: utf-8
class SkillTree
  def initialize(caster)
    @caster=caster
    @skill={}
    @skill_list={}
    Skill.all_type_list.each{|type|
      @skill_list[type]=[]
    }
    @base={}
    @class={}
    @other={}
  end
  def has?(skill)
    @skill[skill]
  end
  def add_base(skill,info)
    add_single_skill(skill,info)
    @base[skill]=@skill[skill]
  end
  def add_class(type,skill,info)
    @class[type]||=[]
    if skill.respond_to? :zip
      skill.zip(info){|skl,inf|
        add_single_skill(skl,inf)
        @class[type]<<@skill[skl]
      }
    else
      add_single_skill(skill,info)
      @class[type]<<@skill[skill]
    end
  end
  def add_single_skill(skill,info)
    @skill[skill]=Skill.new(info,skill)
    @skill_list[info[:type]]<<@skill[skill]
  end
  def add_other(skill,info)
    if skill.respond_to? :zip
      skill.zip(info){|skl,inf|
        add_single_skill(skl,inf)
        @other[skl]=@skill[skl]
      }
    else
      add_single_skill(skill,info)
      @other[skill]=@skill[skill]
    end
  end
  def delete(skill,info)
    if skill.respond_to? :zip
      skill.zip(info){|skl,inf|
        @skill_list[inf[:type]].delete(@skill[skl])
        @skill.delete(skl)
      }
    else
      @skill_list[info[:type]].delete(@skill[skill])
      @skill.delete(skill)
    end
  end
  def [](sym)
    return @skill[sym]
  end
  def each
    @skill.each{|sym,skill|
      yield sym,skill
    }
  end
  def each_attack_defense
    @skill_list[:attack_defense].each{|skill| yield skill}
    @skill_list[:switch_attack_defense].each{|skill| yield skill}
  end
  def each_pre_attack_defense
    @skill_list[:pre_attack_defense].each{|skill| yield skill}
  end
  def each_pre_skill_defense
    @skill_list[:pre_skill_defense].each{|skill| yield skill}
  end
  def each_append
    @skill_list[:append].each{|skill| yield skill}
    @skill_list[:switch_append].each{|skill| yield skill}
  end
  def size
    return @skill.size+1
  end
  def update
    @skill_list[:auto].each{|skill|
      skill.cast_auto(@caster)
    }
    @skill_list[:switch_auto].each{|skill|
      skill.switch and skill.cast_auto(@caster)
    }
  end
  def check_click(x,y)
    row=y/43
    col=x/26
    y%43<20 and return nil
    case @click_y=row
    when 0
      @click_x=0
      @base.each_value{|skill|
        skill.invisible and next
        col==@click_x and 
          @click_skill=skill and 
          return @skill.key(skill)
        @click_x+=1
      }
    when 1
      @click_x=0
      @class.each_value{|skill_ary|
        skill_ary.each{|skill|
          col==@click_x and 
            @click_skill=skill and 
            return @skill.key(skill)
          @click_x+=1
        }
      }
    when 2
      @click_x=0
      @other.each_value{|skill|
        skill.invisible and next
          col==@click_x and 
            @click_skill=skill and 
            return @skill.key(skill)
          @click_x+=1
      }
    end
    return nil
  end
  def draw(x,y)
    y=draw_base(x,y)
    y=draw_class(x,y)
    draw_other(x,y)
  end
  def draw_base(draw_x,draw_y)
    Font.draw_texture("基本技能:",15,draw_x,draw_y,0,0,0)
    draw_y+=17
    @base.each_value{|skill|
      skill.invisible and next
      if skill==@click_skill
        skill.draw_click_back(draw_x,draw_y)
      else
        skill.draw_back(draw_x,draw_y)
      end
      skill.draw_icon(draw_x,draw_y)
      draw_x+=26
    }
    return draw_y+26
  end
  def draw_class(draw_x,draw_y)
    Font.draw_texture("職業技能:",15,draw_x,draw_y,0,0,0)
    draw_y+=17
    @class.each_value{|skill_ary|
      skill_ary.each{|skill|
        if skill==@click_skill
          skill.draw_click_back(draw_x,draw_y)
        else
          skill.draw_back(draw_x,draw_y)
        end
        skill.draw_icon(draw_x,draw_y)
        draw_x+=26
      }
    }
    return draw_y+26
  end
  def draw_other(draw_x,draw_y)
    Font.draw_texture("其他技能:",15,draw_x,draw_y,0,0,0)
    draw_y+=17
    @other.each_value{|skill|
      skill.invisible and next
      if skill==@click_skill
        skill.draw_click_back(draw_x,draw_y)
      else
        skill.draw_back(draw_x,draw_y)
      end
      skill.draw_icon(draw_x,draw_y)
      draw_x+=26
    }
  end
  def marshal_dump
    [:@caster, :@skill, :@skill_list, :@base, :@class, :@other]
    data={
      :c=>Map.find_actor(@caster)
    }
    return [data]
  end
  def marshal_load(array)
  end
end