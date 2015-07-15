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
        return info[:attack]
      }
      @proc[:omamori]=->(info){
        return :miss
      }

      @proc[:amplify]=->(info){
        caster=info[:caster]
        if caster.has_state?(info[:data][:sym])
          if caster.var[:amplify_attrib]!=info[:args]
            caster.var[:amplify_attrib]=info[:args]
          else
            return
          end
        end
        attrib=info[:args]
        caster.add_state(caster,
          name: info[:data][:name],
          sym: info[:data][:sym],
          magicimu_keep: true,
          attrib: attrib,
          last: nil
        )
      }
      @proc[:boost]=->(info){
        caster=info[:caster]
        data=info[:data]
        args=info[:args]
        add=args[:add]
        attrib={}
        args[:base].each{|key,value|
          attrib[key]=value
        }
        attrib.each_key{|sym|
          add[sym] or next
          add_value=caster.attrib[add[sym][0]]*add[sym][1]
          attrib[sym]+=(add_value<1)? add_value : add_value.to_i
        }
        last=data[:last].to_sec

        caster.add_state(caster,
          name: data[:name],sym: data[:sym],
          icon: data[:icon],
          magicimu_keep: true,
          attrib: attrib,
          last: last)
      }
      @proc[:boost_circle]=->(info){
        caster=info[:caster]
        args=info[:args]
        data=info[:data]

        healhp=args[0]+(caster.attrib[:matk]*0.3).to_i

        atkspd=args[1]+(caster.attrib[:int]*0.1).to_i
        Map.add_enemy_circle(
          caster.ally,
          Bullet.new(
            [Heal.new(caster,hp: healhp),
             Effect.new(caster,
               name: data[:name],sym: data[:sym],
               icon: data[:icon],
               magicimu_keep: true,
               attrib:{atkspd: atkspd},
               last: data[:last].to_sec)],
            nil,
            :col,
            caster: caster,
            x: caster.position.x,
            y: caster.position.y,
            z: caster.position.z,
            r: 100,h: 50,
            live_cycle: :frame)
        )
      }

      @proc[:attack_increase]=->(info){
        caster=info[:caster]
        target=info[:target]

        data=info[:data]

        if target==caster.var[:attack_increase_target]
          if caster.var[:attack_increase_count]<info[:args]
            caster.var[:attack_increase_count]+=1
          end
        else
          caster.del_state(data[:sym])
          caster.var[:attack_increase_target]=target
          caster.var[:attack_increase_count]=0
        end

        caster.add_state(caster,
          name: data[:name],sym: data[:sym],
          icon: nil,
          magicimu_keep: true,
          attrib: {atk: data[:atk]*caster.var[:attack_increase_count]},
          last: nil)
      }
      @proc[:fire_burst]=->(info){
        caster=info[:caster]
        target=info[:target]
        if caster.var[:fire_burst_count]< 2
          caster.var[:fire_burst_count]+=1
          return
        else
          caster.var[:fire_burst_count]=0
        end
        attack=info[:args][0]+(info[:args][1]*caster.attrib[:matk]).to_i
        Map.add_friend_bullet(
          caster.ally,
          Bullet.new(
            [Attack.new(caster,type: :mag,cast_type: :skill,attack: attack),
             Effect.new(caster,
               name:'暈眩',sym: :circle_burst_stun,effect_type: :stun,
               icon: nil,
               attrib:{},
               last: info[:args][2].to_sec)],
            nil,
            :col,
            caster: caster,
            x: caster.position.x,
            y: caster.position.y,
            z: caster.position.z,
            r: 80,h:50,
            live_cycle: :frame))
      }
      @proc[:dual_weapon_atkspd_acc]=->(info){
        caster=info[:caster]
        right_hand=caster.equip[:right]
        left_hand=caster.equip[:left]
        if right_hand&&left_hand&&
           right_hand.part==:dual&&
           left_hand.part==:dual
          if caster.var[:dual_weapon_right]!=right_hand||
             caster.var[:dual_weapon_left]!=left_hand
            atkspd=right_hand.attrib[:atkspd]*Math.log10(caster.attrib[:str])
            atkspd+=left_hand.attrib[:atkspd]*Math.log10(caster.attrib[:str])
            caster.add_state(caster,
              name:'',sym: :dual_weapon_atkpsd,
              icon: nil,
              attrib: {atkspd: atkspd.to_i},
              magicimu_keep: true,
              last: nil)
            caster.var[:dual_weapon_right]=right_hand
            caster.var[:dual_weapon_left]=left_hand
          end
        else
          caster.var[:dual_weapon_right]=nil
          caster.var[:dual_weapon_left]=nil
          caster.del_state(:dual_weapon_atkpsd)
        end
      }
      @proc[:rl_weapon]=->(info){
        caster=info[:caster]
        right_hand=caster.equip[:right]
        left_hand=caster.equip[:left]
        if right_hand&&left_hand&&
           right_hand.part==:right&&
           left_hand.part==:left
          if caster.var[:rl_weapon_right]!=right_hand||
             caster.var[:rl_weapon_left]!=left_hand
            def_conv=left_hand.attrib[:def]*info[:data][:def_coef]
            mdef_conv=left_hand.attrib[:mdef]*info[:data][:mdef_coef]
            caster.add_state(caster,
              name:'',sym: :rl_weapon,
              icon: nil,
              attrib: {info[:data][:def_conv]=>def_conv,info[:data][:mdef_conv]=>mdef_conv},
              magicimu_keep: true,
              last: nil)
            caster.var[:rl_weapon_right]=right_hand
            caster.var[:rl_weapon_left]=left_hand
          end
        else
          caster.var[:rl_weapon_right]=nil
          caster.var[:rl_weapon_left]=nil
          caster.del_state(:rl_weapon)
        end
      }
      @proc[:single_weapon]=->(info){
        caster=info[:caster]
        right_hand=caster.equip[:right]
        left_hand=caster.equip[:left]
        if right_hand&&!left_hand&&
           right_hand.part==:single
          if caster.var[:single_weapon]!=right_hand
            value=(right_hand.attrib[info[:data][:sym]]*info[:data][:coef]).to_i
            caster.add_state(caster,
              name:'',sym: :single_weapon,
              icon: nil,
              attrib:{info[:data][:conv]=>value},
              magicimu_keep: true,
              last: nil)
            caster.var[:single_weapon]=right_hand
          end
        else
          caster.var[:single_weapon]=nil
          caster.del_state(:single_weapon)
        end
      }

      @proc[:counter_beam]=->(info){
        caster=info[:caster]
        possibility=info[:data][:possibility]
        unless rand(100)<possibility
          return info[:attack]
        end
        if Game.get_ticks>caster.var[:counter_beam_endtime]
          caster.var[:counter_beam_endtime]=Game.get_ticks+info[:data][:cd].to_sec
        else
          return info[:attack]
        end
        attack=info[:args][0]+caster.attrib[:def]
        last=info[:args][1].to_sec

        Map.add_friend_circle(
          caster.ally,
          Bullet.new(
            [Attack.new(caster,type: :mag,attack: attack),
             Effect.new(caster,
               name:'暈眩',sym: :counter_beam_stun,effect_type: :stun,
               icon: nil,attrib:{},last: last)],
            nil,
            :col,
            caster: caster,
            x: caster.position.x,
            y: caster.position.y,
            z: caster.position.z,
            r: 90,h: 50,
            live_cycle: :frame
          )
        )
        return info[:attack]
      }

      @proc[:arrow]=->(info){
        caster=info[:caster]
        data=info[:data]
        attack=info[:args][0]+(caster.attrib[data[:sym]]*data[:coef]).to_i
        Map.add_friend_bullet(
          caster.ally,
          Bullet.new(
            Attack.new(caster,
              type: data[:type],
              cast_type: data[:cast_type],
              attack: attack,
              attack_defense: data[:attack_defense],
              append: data[:append],
              assign: true),
            (pic=Animation.new(*data[:pic])),
            :box,
            caster: caster,
            live_cycle: data[:live_cycle],
            live_count: info[:args][1],
            x: caster.position.x,
            y: caster.position.y+
            case data[:launch_y]
            when :center
              caster.pic_h/4
            when :ground
              0
            end,
            z: caster.position.z,
            w: data[:shape_w],
            h: data[:shape_h],
            t: data[:shape_t],
            vx: caster.face_side==:right ? data[:velocity] : -data[:velocity],
            collidable: data[:collidable],
            collide_count: info[:args][2]||caster.var[data[:collide_count_var]]
            )
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
              append: info[:data][:append],
              assign: true),
            Animation.new(:follow,
              {img:[info[:data][:pic]],w: pic.w,h: pic.h},
              [[[:blit,0]]]),
            :col,
            caster: caster,
            live_cycle: info[:data][:live_cycle],
            live_count: info[:data][:live_count],
            x: caster.position.x,
            y: caster.position.y+caster.pic_h/4-pic.h/2,
            z: caster.position.z,
            r: pic.w/2,
            h: pic.h,
            vx: info[:data][:velocity]*delta_x/distance,
            vz: info[:data][:velocity]*delta_z/distance
          )
        )
      }
      @proc[:explode]=->(info){
        caster=info[:caster]
        data=info[:data]
        attack=info[:args]+(caster.attrib[data[:sym]]*data[:coef]).to_i

        Map.add_friend_circle(
          caster.ally,
          Bullet.new(
            Attack.new(caster,
              type: data[:type],
              cast_type: :skill,
              attack: attack),
            (pic=Surface.load_with_colorkey(data[:pic])),
            :col,
            caster: caster,
            live_cycle: :frame,
            r: pic.w/2,
            h: pic.h,
            x: info[:x],
            y: info[:y],
            z: info[:z],
            surface: :horizon
          )
        )
      }
      @proc[:aura]=->(info){
        caster=info[:caster]
        args=info[:args]
        data=info[:data]
        aura=Bullet.new(
          Effect.new(caster,args[:effect]),
          data[:ani],
          :col,
          caster: caster,
          live_cycle: :frame,
          r: args[:r],
          h: args[:h],
          x: caster.position.x,
          y: caster.position.y,
          z: caster.position.z
        )
        case data[:target]
        when :enemy
          Map.add_friend_circle(caster.ally,aura)
        when :friend
          Map.add_enemy_circle(caster.ally,aura)
        else
          raise "UnkownAuraTarget"
        end
      }
      
      @proc[:contribute]=->(info){
        caster=info[:caster]
        Map.add_enemy_circle(
          caster.ally,
          Bullet.new(
            Heal.new(caster,type: :percent, hp: info[:args],sp: info[:args]),
            nil,
            :col,
            caster: caster,
            x: caster.position.x,
            y: caster.position.y,
            z: caster.position.z,
            r: 100,h: 50,
            live_cycle: :frame
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
        add=info[:args][:add]
        attrib={}
        info[:args][:base].each{|key,value|
          attrib[key]=value
        }
        attrib.each_key{|sym|
          add[sym] and
          attrib[sym]+=(caster.attrib[add[sym][0]]*add[sym][1]).to_i
        }
        last=info[:args][:last].to_sec

        caster.add_state(caster,
          name:'魔法免疫',sym: :magic_immunity,
          icon:'./rc/icon/icon/tklre04/skill_053.png',
          attrib: attrib,
          last: last)
      }

      @proc[:burn]=->(info){
        args=info[:args]
        data=info[:data]
        caster=info[:caster]
        attack=args[0]+(args[1]*info[:caster].attrib[:matk]).to_i
        info[:target].add_state(caster,
          name: data[:name],sym: data[:sym],
          icon: data[:icon],
          attrib: {},
          effect: Attack.new(info[:caster],type: :acid,attack: attack),
          effect_amp: 0.5,
          last: 2.to_sec)
      }
      @proc[:break_armor]=->(info){
        caster=info[:caster]
        dec_armor=(info[:args]*Math.log10(caster.attrib[:matk])).to_i
        info[:target].add_state(caster,
          name:'破防',sym: :break_armor,
          icon: './rc/icon/skill/2011-12-23_3-146.gif',
          attrib: {def: dec_armor,mdef: dec_armor},#}
          last: 2.to_sec)
      }
      @proc[:smash_wave]=->(info){
        caster=info[:caster]

        attack=info[:args][0]+(caster.attrib[info[:data][:sym]]*info[:data][:coef]).to_i
        probability=info[:args][1]

        rand(100)<probability and
        Map.add_friend_bullet(
          caster.ally,
          Bullet.new(
            Attack.new(
              caster,type: info[:data][:type],cast_type: :skill,attack: attack),
              nil,
              :col,
              caster: caster,
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
        attack=info[:caster].attrib[:atk]
        Attack.new(info[:caster],
          type: :phy,
          cast_type: :attack,
          attack: attack,
          before: :attack_increase,
        ).affect(info[:target],info[:target].position)
      }

      @proc[:fire_circle]=->(info){
        attack=info[:args][0]+info[:caster].attrib[:matk]
        if Game.get_ticks>info[:caster].var[:fire_circle_triger]
          info[:caster].var[:fire_circle_triger]=Game.get_ticks+1.to_sec
        else
          return
        end

        Map.add_friend_circle(
          info[:caster].ally,
          Bullet.new(
            [Attack.new(info[:caster],type: :mag,cast_type: :skill,attack: attack),
             Effect.new(info[:caster],
               name:'燃燒',sym: :circle_burn,effect_type: :slow,
               icon:'./rc/icon/skill/2011-12-23_3-049.gif',
               attrib:{wlkspd: info[:args][1]},
               last: 5.to_sec)],
            Animation.new(:follow,
              {img:['./rc/pic/battle/fire_circle.png'],
                w: 120,h: 60,horizon: true,
                limit: 1,
              },
              [[[:blit,0,24]]]),
            :col,
            caster: info[:caster],
            x: info[:caster].position.x,
            y: 0,
            z: info[:caster].position.z,
            r: 75,
            h: 50,
            live_cycle: :frame,
            surface: :horizon,
            broken_draw: true)
        )
      }

      @proc[:wolfear]=->(info){
        caster=info[:caster]
        attrib=caster.attrib

        healhp=(attrib[:maxhp]-attrib[:hp])*0.02
        healsp=healhp*attrib[:maxsp]/attrib[:maxhp]

        caster.add_state(caster,
          name:'狼耳之血',sym: :wolfear,
          icon:'./rc/icon/skill/2011-12-23_3-079.gif:[0,0]B[255,0,0]',
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

      @proc[:snow_shield]=->(info){
        reduce_percent=info[:args][0]
        convert_coeff=info[:args][1]
        caster=info[:caster]

        damage=info[:attack]-info[:attack]*reduce_percent/100
        consum=damage/convert_coeff.to_i

        if consum>caster.attrib[:sp]
          consum=caster.attrib[:sp]
          damage=info[:attack]-consum*convert_coeff
        end
        info[:caster].lose_sp(consum)
        return damage
      }
      @proc[:freezing_rain]=->(info){
        percent=info[:args][0]+info[:caster].attrib[:int]*info[:data][:coef]
        percent/=-100.0
        info[:target].add_state(info[:caster],
          name:'凍雨凝結',sym: :freezing_rain,
          icon: info[:data][:icon],
          attrib: {atk: percent,matk: percent},
          magicimu_keep: true,
          last: info[:args][1].to_sec
        )
        return info[:attack]
      }
      @proc[:ice_body]=->(info){
        info[:caster].add_state(info[:caster],
          name:'寒冰之軀',sym: :ice_body,
          icon: info[:data][:icon],
          attrib:{def: info[:args][0],mdef: info[:args][0],matk: info[:args][1]/100.0},#}
          magicimu_keep: true,
          last: info[:args][2].to_sec)
      }
      @proc[:water_smash]=->(info){
        attack=info[:args][0]+info[:args][1]*info[:caster].attrib[:int]
        Attack.new(info[:caster],type: :umag,attack: attack.to_i).affect(info[:target],info[:target].position)
      }
      @proc[:itegumo_erupt]=->(info){
        rand(100)<info[:args][0] or return
        slow=info[:args][1]/-100.0
        caster=info[:caster]
        Map.add_friend_bullet(
          caster.ally,
          Bullet.new([
             Attack.new(caster,type: :acid,attack: 0,append: :ice_wave),
             Effect.new(caster,
               name:'凍雲緩速',sym: :itegumo_slow,effect_type: :slow,
               icon:'./rc/icon/skill/2011-12-23_3-057.gif',
               attrib: {wlkspd: slow,atkspd: slow},
               magicimu_keep: true,
               last: info[:args][2].to_sec)],
            nil,
            :col,
            caster: caster,
            x: info[:x],y: 0,z: info[:z],
            r: 60,h: 1000,
            live_cycle: :frame)
        )
      }
      @proc[:ice_wave]=->(info){
        caster=info[:caster]
        attack=info[:args]
        info[:data][:coef].each{|sym,val|
          attack+=(caster.attrib[sym]*val).to_i
        }
        Map.add_friend_circle(
          caster.ally,
          Bullet.new(
            Attack.new(caster,type: :acid,attack: attack),
            Surface.load_with_colorkey('./rc/pic/battle/ice_wave.png'),
            :col,
            caster: caster,
            x: info[:x],y: 0,z: info[:z],
            r: 60,h: 1000,
            live_cycle: :frame,
            surface: :horizon
          )
        )
      }

      @proc[:heal]=->(info){
        hp,sp=info[:args][:hp],info[:args][:sp]
        data=info[:data]||{}
        target=info[:target]
        Heal.new(info[:caster],
          type: data[:type],hp: hp,sp: sp,
          hpsym: data[:hpsym],hpcoef: data[:hpcoef],
          spsym: data[:spsym],spcoef: data[:spcoef]).affect(target,target.position)
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
          info[:args][:add] and hp+=(target.attrib[info[:data][:add]]*info[:args][:add]).to_i
        end
        attrib=info[:args][:attrib]
        attrib[:healhp]=hp

        target.add_state(caster,
          name: info[:data][:name],sym: info[:data][:sym],
          icon: info[:data][:icon],
          attrib: attrib,
          magicimu_keep: true,
          last: info[:data][:last].to_sec)
      }
      
      
    end
    def self.[](skill)
      @proc[skill]
    end
    def formula(attack,defense)
      attack*attack/(attack+defense)
    end
  end
end
