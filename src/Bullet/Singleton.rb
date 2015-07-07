#coding: utf-8
class Bullet
  @@DrawProc={
    box: ->(ani,position,shape){
      draw_x=position.x-ani.w/2
      draw_y=431-position.y-position.z/2-ani.h
      ani.draw(draw_x,draw_y,position.z)
    },
    col: ->(ani,position,shape){
      draw_x=position.x-ani.w/2
      draw_y=431-position.y-(position.z+ani.h)/2
      ani.draw(draw_x,draw_y,position.z)
    },
    hoz: ->(ani,position,shape){
      draw_x=position.x-ani.w/2
      draw_y=431-position.y+(ani.h-position.z)/2
      ani.draw(draw_x,draw_y,position.z)
    }
  }
end