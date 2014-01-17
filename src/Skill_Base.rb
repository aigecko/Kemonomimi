#coding: utf-8
class Skill
  class Base
    def self.init
      @proc={}
      @proc[:flash]=->(info){
        limit=info[:args]
        caster=info[:caster]
        x,z=caster.position.x,caster.position.z
        dis=Math.distance(x,z,info[:x],info[:z])
        if dis>limit          
          delta_x=(info[:x]-x)*limit/dis
          delta_z=(info[:z]-z)*limit/dis
          
          dst_x=x+delta_x
          dst_z=z+delta_z
          caster.set_move_dst(info[:x],0,info[:z])
          caster.position.x=dst_x
          caster.position.z=dst_z
        else
          caster.set_move_dst(info[:x],0,info[:z])
          caster.position.x=info[:x]
          caster.position.z=info[:z]
        end
      }
      
      @proc[:counter_attack]=->(info){
        attack=info[:args][0]+(info[:caster].attrib[:def]*info[:args][1]).to_i
        Attack.new(info[:caster],
          type: :acid,
          attack: attack).affect(info[:target],info[:target].position)
        return info[:damage]
      }
      
      @proc[:amplify]=->(info){
        caster=info[:caster]
        attrib=info[:args]
        caster.add_state(caster,
          name: info[:data][:name],
          sym: info[:data][:sym],
          attrib: attrib,
          last: nil
        )
      }
      @proc[:boost]=->(info){
        caster=info[:caster]
        args=info[:args]
        data=info[:data]
        
        if healhp=args[:healhp]
          healhp+=(caster.attrib[data[:healhp_sym]]*args[:healhp_coef]||0).to_i
          healhp*=Math.log10(caster.attrib[data[:healhp_amp]||1])
          caster.gain_hp(healhp)
        end
        
        #todo atkspd,wlkspd
      }
      
      @proc[:arrow]=->(info){
        caster=info[:caster]
        attack=info[:args][0]+caster.attrib[:ratk]
        Map.add_friend_bullet(
          caster.ally,
          Bullet.new(
            Attack.new(caster,
              type: :phy,
              cast_type: :attack,
              attack: attack,
              append: [:fire_arrow,:enegy_arrow]),
            (pic=Surface.load_with_colorkey('./rc/pic/battle/arrow.png')),
            :box,
            caster: caster,
            live_cycle: :time,
            live_count: 25,
            x: caster.position.x,
            y: caster.position.y+caster.pic_h/4,
            z: caster.position.z,
            w: pic.w,
            h: pic.w/4,
            t: pic.h,
            vx: caster.face_side==:right ? 20 : -20)
        )
      }
      @proc[:missile]=->(info){
        caster=info[:caster]
        attack=info[:args][0]
        info[:data][:coef].each{|sym,val|
          attack+=(caster.attrib[sym]*val).to_i
        }
        
        pic=Surface.load_with_colorkey(info[:data][:pic])
        distance=Math.distance(info[:x],info[:z],caster.position.x,caster.position.z).to_i
        delta_x=info[:x]-caster.position.x
        delta_z=info[:z]-caster.position.z
        Map.add_friend_bullet(
          caster.ally,
          Bullet.new(
            Attack.new(caster,
              type: info[:data][:type],
              cast_type: :skill,
              attack: attack,
              append: info[:data][:append]),
            pic,
            :col,
            caster: caster,
            live_cycle: info[:data][:live_cycle],
            live_count: info[:data][:live_count],
            x: caster.position.x,
            y: caster.position.y+caster.pic_h/2-pic.h/2,
            z: caster.position.z,
            r: pic.w/2,
            h: pic.h,
            vx: info[:data][:velocity]*delta_x/distance,
            vz: info[:data][:velocity]*delta_z/distance
          )
        )
      }
      @proc[:fire_arrow]=->(info){
        attack=info[:args]
        Attack.new(info[:caster],type: :mag,attack: attack).affect(info[:target],info[:target].position)
      }
      @proc[:enegy_arrow]=->(info){
        const,percent= *info[:args]
        attack=const+info[:caster].attrib[:sp]*percent/100
        Attack.new(info[:caster],type: :umag,attack: attack).affect(info[:target],info[:target].position)
      }
      
      @proc[:magic_immunity]=->(info){
        caster=info[:caster]
        attrib=info[:args][:base]
        add=info[:args][:add]
        attrib.each_key{|sym|
          attrib[sym]+=(caster.attrib[add[sym][0]]*add[sym][1]).to_i
        }
        last=info[:args][:last]
        caster.add_state(caster,
          name:'魔法免疫',sym: :magic_immunity,
          icon:'./rc/icon/icon/tklre04/skill_053.png',
          attrib: attrib,
          last: last)
      }
      
      @proc[:burn]=->(info){
        info[:target].add_state(info[:caster],
          name:'燒毀',sym: :burn,
          icon:'./rc/icon/icon/tklre03/skill_041.png',
          attrib: {},
          effect: Attack.new(info[:caster],type: :acid,attack: 50+info[:caster].attrib[:matk]),
          effect_amp: 0.04,
          last: 2.to_sec)
      }
      @proc[:break_armor]=->(info){
        caster=info[:caster]
        dec_armor=(info[:args]*Math.log10(caster.attrib[:matk])).to_i
        info[:target].add_state(caster,
          name:'破防',sym: :break_armor,
          icon: './rc/icon/skill/2011-12-23_3-146.gif',
          attrib: {def: dec_armor},#}
          last: 2.to_sec)
      }
      @proc[:smash_wave]=->(info){
        caster=info[:caster]

        attack=info[:args][0]        
        probability=info[:args][1]
        
        rand(100)<probability and
        Map.add_friend_bullet(
          caster.ally,
          Bullet.new(
            Attack.new(
              caster,type: :mag,cast_type: :skill,attack: attack),
              nil,
              :col,
              caster: info[:caster],
              x: caster.position.x,
              y: caster.position.y,
              z: caster.position.z,
              r: 75,h: 50,
              live_cycle: :frame)
        )
      }
      #BUG!!
      #假如沒有delay或是print會錯誤
      @proc[:dst_dec_dmg]=->(info){
        caster=info[:caster]
        target=info[:target]
        distance=Math.distance(caster.position.x,caster.position.z,
                               target.position.x,target.position.z)
                               #SDL.delay(2)
        rad=info[:args]
        if distance>=rad
          return true
        else
        #dbg
          #attack=caster.attrib[:atk]*(rad-distance)/rad
          attack=10*(rad-distance)/rad
          attack==0 and attack=1
          Attack.new(caster,type: :mag,attack: attack).affect(target,target.position)
        end
      }
      #BUG!!
      @proc[:shatter]=->(info){
        caster=info[:caster]
        shatter=Skill.new(
          name:'噴濺',tpye: :append,
          icon: './rc/icon/skill/2011-12-23_3-045.gif',
          base: :dst_dec_dmg,consum: 0,level: 1,table:[0,info[:args]],
          commit:'技能用')
        
        Map.add_friend_bullet(
          caster.ally,
          Bullet.new(
            Attack.new(caster,type: :phy,cast_type: :skill,attack: 0,append: shatter),
            nil,
            :col,
            caster: caster,
            x: caster.position.x,
            y: caster.position.y,
            z: caster.position.z,
            r: 100,h: 50,
            live_cycle: :frame,
            exclude: info[:target])
        )
      }
      
      @proc[:normal_attack]=->(info){
        caster=info[:caster]
        attack=caster.attrib[:atk]
        Attack.new(caster,
          type: :phy,
          cast_type: :attack,
          attack: attack,
          append: [:smash_wave,:enegy_arrow,:shatter,:break_armor,:burn]).affect(info[:target],info[:target].position)
      }
      
      @proc[:fire_circle]=->(info){        
        const=info[:args][0]
        percent=info[:args][1]
        if SDL.get_ticks>info[:caster].var[:fire_circle_triger]
          info[:caster].var[:fire_circle_triger]=SDL.get_ticks+1.to_sec
        else
          return
        end
        
        Map.add_friend_circle(
          info[:caster].ally,
          Bullet.new(
            [Attack.new(info[:caster],type: :mag,dmg_type: :const_cur,attack: [const,percent]),
             Effect.new(info[:caster],
               name:'燃燒',sym: :burn,effect_type: :slow,
               icon:'./rc/icon/skill/2011-12-23_3-049.gif',
               attrib:{wlkspd: -0.8},
               last: 5.to_sec)],
            (pic=Surface.load_with_colorkey('./rc/pic/battle/fire_circle.png')),
            :col,
            caster: info[:caster],
            x: info[:caster].position.x,
            y: 0,
            z: info[:caster].position.z,
            r: 75,
            h: 50,
            live_cycle: :frame)
        )
      }
      
      @proc[:wolfear]=->(info){
        caster=info[:caster]
        attrib=caster.attrib
    
        healhp=(attrib[:maxhp]-attrib[:hp])*0.04
        healsp=healhp*attrib[:maxsp]/attrib[:maxhp]
      
        caster.add_state(caster,
          name:'狼耳之血',sym: :wolfear,
          icon:'./rc/icon/skill/2011-12-23_3-079.gif',
          attrib: {healhp: healhp,healsp: healsp},          
          magicimu_keep: true,
          last: nil)
      }
      @proc[:dogear]=->(info){
        maxhp,hp=info[:target].attrib[:maxhp],info[:target].attrib[:hp]
        percent=hp*100/maxhp
        
        if percent<10
          attack_amp=50
          elsif percent<20
          attack_amp=40
        elsif percent<40
          attack_amp=20
        elsif percent<60
          attack_amp=10
        else
          attack_amp=0
        end
        #0.1*0.5+0.1*0.4+0.2*0.2+0.2*0.1
        # 0.10*0.6+0.05*0.5+0.1*0.4+0.15*0.3+0.2*0.15
        #10%:1.6 15%:1.5 25%:1.4 40%:1.3 60%:1.15
          info[:caster].attrib[:attack_amp]=attack_amp
      }
      
      @proc[:ice_wave]=->(info){
        caster=info[:caster]
        attack=info[:args]        
        info[:data][:coef].each{|sym,val|        
          attack+=(caster.attrib[sym]*val).to_i
        }
        Map.add_friend_bullet(
          caster.ally,
          Bullet.new(
            Attack.new(caster,type: :acid,attack: attack),
            Surface.load_with_colorkey('./rc/pic/battle/ice_wave.png'),
            :col,
            caster: caster,
            x: info[:x],y: 0,z: info[:z],
            r: 60,h: 1000,
            live_cycle: :frame
          )
        )
      }
      
      @proc[:heal]=->(info){
        hp,sp=info[:args][:hp],info[:args][:sp]
        target=info[:target]
        case info[:type]
        when :percent
          hp&&=(target.attrib[:maxhp]*hp).to_i
          sp&&=(target.attrib[:maxsp]*hp).to_i
        when :lost
          hp_lost=target.attrib[:maxhp]-target.attrib[:hp]
          sp_lost=target.attrib[:maxsp]-target.attrib[:sp]
          
          hp&&=(hp_lost*hp).to_i
          sp&&=(sp_lost*sp).to_i
        end
        Heal.new(info[:caster],hp: hp,sp: sp).affect(target,target.position)
      }
      @proc[:recover]=->(info){
        caster=info[:caster]
        target=caster
        
        case info[:data][:type]
        when :max
          hp=target.attrib[:maxhp]*info[:args][:coef]/100
        when :cur
          hp=target.attrib[:hp]*info[:args][:coef]/100
        when :lose
          hp=target.attrib[:maxhp]-target.attrib[:hp]*info[:args][:coef]/100
        else
          hp=info[:args][:coef]
        end
        attrib=info[:args][:attrib]
        attrib[:healhp]=hp
        
        target.add_state(caster,
          name: info[:data][:name],sym: info[:data][:sym],
          icon: info[:data][:icon],
          attrib: attrib,
          last: 1.to_sec)
      }
    end
    def self.[](skill)
      @proc[skill]
    end
    def formula(attack,defense)
      attack*attack/(attack+defense)
    end
  end
  def self.init
    Base.init   
    
    @@types=[:active,:auto,:attrib,:state,:switch,:attach]
  end
end
