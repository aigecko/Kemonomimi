#coding: utf-8
class Bullet
  @@draw_proc={
    box: ->(ani,position,shape){
      ani.draw(position.x-ani.w/2,
      431-position.y-position.z/2-ani.h,
      position.z)
    },
    col: ->(ani,position,shape){
      ani.draw(position.x-ani.w/2,431-position.y-(position.z+ani.h)/2,position.z)
    },
    hoz: ->(ani,position,shape){
      ani.draw(position.x-ani.w/2,431-position.y+(ani.h-position.z)/2,position.z)
    }
  }
end