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
    x=x/26
    y=y/26
  end
  def draw(x,y)
    draw_x=x+10
    draw_y=y+24
    @base.each_value{|skill|
      skill.invisible and next
      skill.draw_icon(draw_x,draw_y)
      draw_x+=26
    }
    draw_x=x+10
    draw_y+=26
    @class.each_value{|skill_ary|
      draw_x=x
      skill_ary.each{|skill|
        skill.draw_icon(draw_x,draw_y)
        draw_x+=26
      }
      draw_y+=26
    }
    draw_x=x+10
    @other.each_value{|skill|
      skill.invisible and next
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