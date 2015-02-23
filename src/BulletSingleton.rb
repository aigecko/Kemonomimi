#coding: utf-8
class Bullet
  @@depth=(Game.Depth+1).to_f
  @@draw_proc={
    box: ->(ani,position,shape){
      ani.draw(position.x-ani.w/2,431-position.y-position.z/2-ani.h,position.z/401.0)
    },
    col: ->(ani,position,shape){
      ani.draw(position.x-ani.w/2,431-position.y-position.z/2-ani.h/2,position.z/401.0)
    }
  }
end