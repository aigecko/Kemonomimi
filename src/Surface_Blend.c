#include "ruby.h"
typedef char byte;

void pixel_blend_add_rgb(char *pixels,int r,int g,int b){
  r+=(byte)pixels[0];
  g+=(byte)pixels[1];
  b+=(byte)pixels[2];

  r=(r<255) ? r : 255;
  g=(g<255) ? g : 255;
  b=(b<255) ? b : 255;

  pixels[0]=r;
  pixels[1]=g;
  pixels[2]=b;
}
void pixel_blend_add_bgr(char *pixels,int r,int g,int b){
  r+=(byte)pixels[2];
  g+=(byte)pixels[1];
  b+=(byte)pixels[0];

  r=(r<255) ? r : 255;
  g=(g<255) ? g : 255;
  b=(b<255) ? b : 255;

  pixels[2]=r;
  pixels[1]=g;
  pixels[0]=b;
}
void pixel_blend_sub_rgb(char *pixels,int r,int g,int b){
  r=(byte)pixels[0]-r;
  g=(byte)pixels[1]-g;
  b=(byte)pixels[2]-b;

  r=(r>0) ? r: 0;
  g=(g>0) ? g: 0;
  b=(b>0) ? b: 0;

  pixels[0]=r;
  pixels[1]=g;
  pixels[2]=b;
}
void pixel_blend_sub_bgr(char *pixels,int r,int g,int b){
  r=(byte)pixels[2]-r;
  g=(byte)pixels[1]-g;
  b=(byte)pixels[0]-b;

  r=(r>0) ? r : 0;
  g=(g>0) ? g : 0;
  b=(b>0) ? b : 0;

  pixels[2]=r;
  pixels[1]=g;
  pixels[0]=b;
}
static VALUE Surface_i_blend(VALUE self,VALUE mode,VALUE color){
  VALUE w=rb_funcall(self,rb_intern("w"),0);
  VALUE h=rb_funcall(self,rb_intern("h"),0);
  VALUE colorkey=rb_funcall(self,rb_intern("colorkey"),0);

  int color_r=FIX2INT(rb_ary_entry(color,0));
  int color_g=FIX2INT(rb_ary_entry(color,1));
  int color_b=FIX2INT(rb_ary_entry(color,2));
  int pitch=FIX2INT(rb_funcall(self,rb_intern("pitch"),0));
  int bpp=FIX2INT(rb_funcall(self,rb_intern("bpp"),0));

  VALUE format=rb_funcall(self,rb_intern("format"),0);
  VALUE Rmask=rb_funcall(format,rb_intern("Rmask"),0);
  VALUE Gmask=rb_funcall(format,rb_intern("Gmask"),0);
  VALUE Bmask=rb_funcall(format,rb_intern("Bmask"),0);
  VALUE Amask=rb_funcall(format,rb_intern("Amask"),0);

  VALUE SDL=rb_const_get(rb_cObject,rb_intern("SDL"));
  
  int i;int j;	
  switch(bpp){
    case 24:{
      VALUE pixel_str=rb_funcall(self,rb_intern("pixels"),0);
      char *pixels=RSTRING_PTR(pixel_str);
      int length=FIX2INT(rb_funcall(pixel_str,rb_intern("size"),0));
      void (*conv_func)(char*,int,int,int)=NULL;
      if(Rmask<Bmask){
        if(mode==ID2SYM(rb_intern("add")))
          conv_func=pixel_blend_add_rgb;
        else if(mode==ID2SYM(rb_intern("sub")))
          conv_func=pixel_blend_sub_rgb;
        else
          rb_raise(rb_const_get(SDL,rb_intern("Error")),"Unexpect blend type");
      }
      else{
        if(mode==ID2SYM(rb_intern("add")))
          conv_func=pixel_blend_add_bgr;
        else if(mode==ID2SYM(rb_intern("sub")))
          conv_func=pixel_blend_sub_bgr;
        else
          rb_raise(rb_const_get(SDL,rb_intern("Error")),"Unexpect blend type");
      }
      for(i=0;i<FIX2INT(h);i++){
        for(j=0;j<FIX2INT(w);j++){
          conv_func(pixels+i*pitch+j*3,color_r,color_g,color_b);
        }
      }

      return rb_funcall(rb_const_get(SDL,rb_intern("Surface")),rb_intern("new_from"),9,
        rb_str_new(pixels,length),
        w,h,
        INT2FIX(bpp),INT2FIX(pitch),
        Rmask,Gmask,Bmask,Amask);
      break;}
    default:
      rb_raise(rb_const_get(SDL,rb_intern("Error")),"Unsupported image type");
      return self;
  }
}

//  __declspec(dllexport)
  void Init_Surface_Blend(){
    VALUE sdl=rb_const_get(rb_cObject,rb_intern("SDL"));
    VALUE c=rb_const_get(sdl,rb_intern("Surface"));
    rb_define_method(c,"blend",(VALUE(*)(ANYARGS))Surface_i_blend,2);


  }
