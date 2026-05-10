#ifndef StarFastEffectIncluded
#define StarFastEffectIncluded

#include "Star\\StarBase.j"

#include "YDWETimerSystem.j"
#include "Star\\insert.j"

//! zinc
//快速预警提示圈
library StarFastEffect requires StarBase,YDWETimerSystem
{
    //快速创建一个矩形提示框在x,y 它的宽为w,它的长为l,朝向fac 存在时间 time
    public function SFE_Square2(real x,real y,real width,real long ,real fac,real time)
    {
        effect e;
        real sw,sl,s;
        real d,dis;
        if(width>1500)width=1500;
        sw = width /1000;
        if(long>7500)long =7500;
        d = fac -0;
        dis = long / 2;
        x = x+CosBJ(d) * dis;
        y = y+SinBJ(d) * dis;
        if(long /width<=4.00)
        {
            e = AddSpecialEffect("Tip\\Abiltip_Square4x.mdx", x,y);
            sl = long /4000;
        }
        else if(long /width<=5.00)
        {
            e = AddSpecialEffect("Tip\\Abiltip_Square2x.mdx", x,y);
            sl = long /4000;
        }
        else
        {
            sl = long /4000;
            e = AddSpecialEffect("Tip\\Abiltip_Square3x.mdx", x,y);
        }
        if(time<=0){
            s = 1;
            YDWETimerDestroyEffect(1,e);
        }
        else
        {
            s = 1/time;
            YDWETimerDestroyEffect(time+0.5,e);
        }
        EXEffectMatRotateZ(e,fac+270);
        EXSetEffectSpeed(e,s);
        EXEffectMatScale( e, sl, sw, 1.00 );
        e = null;
    }
    public function SFE_Square(real x,real y,real width,real long ,real fac,real time)
    {
        effect e;
        real sw,sl,s;
        real d,dis;
        if(width>1500)width=1500;
        sw = width /1000;
        if(long>7500)long =7500;
        //d = fac - 180;
        dis = long / 2;
        x = x+CosBJ(fac) * dis;
        y = y+SinBJ(fac) * dis;
        if(long /width<=1.00)
        {
            e = AddSpecialEffect("Tip\\Abiltip_Square1x.mdx", x,y);
            sl = long /1000;
        }
         else if(long /width<=2.00)
        {
            e = AddSpecialEffect("Tip\\Abiltip_Square2x.mdx", x,y);
            sl = long /2000;
        }
         else if(long /width<=3.00)
        {
            e = AddSpecialEffect("Tip\\Abiltip_Square3x.mdx", x,y);
            sl = long /3000;
        }
        else if(long /width<=4.00)
        {
            e = AddSpecialEffect("Tip\\Abiltip_Square4x.mdx", x,y);
            sl = long /4000;
        }
        else if(long /width<=5.00)
        {
            e = AddSpecialEffect("Tip\\Abiltip_Square5x.mdx", x,y);
            sl = long /5000;
        }
        else if(long /width<=6.00)
        {
            sl = long /6000;
            e = AddSpecialEffect("Tip\\Abiltip_Square6x.mdx", x,y);
        }
        if(time<=0){
            s = 1;
            YDWETimerDestroyEffect(1,e);
        }
        else
        {
            s = 1/time;
            YDWETimerDestroyEffect(time+0.5,e);
        }
        EXEffectMatRotateZ(e,fac+270);
        EXEffectMatScale( e, sl, sw, 1.00 );
        EXSetEffectSpeed(e,s);
        
        e = null;
    }
    //快速创建黄色扇形提示圈 在(x,y) 方向fac, 大小size, 持续时间 time
    public function SFE_Square3(real x,real y,real fac,real size,real time)
    {
        effect e;
        x = x+CosBJ(fac) * 10;
        y = y+SinBJ(fac) * 10;
        e = AddSpecialEffect("Tip\\AbilTipSX.mdx", x,y);
        DzSetEffectVertexColor( e, DzGetColor2( 255, 255, 255, 0));
        if(time<=0){
            YDWETimerDestroyEffect(0.5,e);
        }
        else
        {
            YDWETimerDestroyEffect(time+0.1,e);
        }
        EXEffectMatRotateZ(e,fac);
        EXSetEffectSize(e,size);
        e = null;
    }
     //快速创建红色扇形提示圈 在(x,y) 方向fac, 大小size, 持续时间 time
    public function SFE_Square4(real x,real y,real fac,real size,real time)
    {
        effect e;
        x = x+CosBJ(fac) * 10;
        y = y+SinBJ(fac) * 10;
        e = AddSpecialEffect("Tip\\AbilTipSX.mdx", x,y);
        DzSetEffectVertexColor( e, DzGetColor2( 255, 255, 0, 0));
        if(time<=0){
            YDWETimerDestroyEffect(0.5,e);
        }
        else
        {
            YDWETimerDestroyEffect(time+0.1,e);
        }
        EXEffectMatRotateZ(e,fac);
        EXSetEffectSize(e,size);
        e = null;
    }
    //快速创建红色圆形提示圈 在(x,y) 半径r，持续时间 time
    public function SFE_Circle(real x,real y,real r,real time)
    {
        effect e;
        real size = r /200;
        real s;
        e = AddSpecialEffect("Tip\\Abiltip_ring.mdx", x,y);
        if(time<=0){
            s = 1;
            YDWETimerDestroyEffect(1,e);
        }
        else
        {
            s = 1/time;
            YDWETimerDestroyEffect(time+0.5,e);
        }
        EXSetEffectSpeed(e,s);
        EXSetEffectSize(e,size);

        e = null;
    }
    //快速创建白色圆形提示圈 在(x,y) 半径r，持续时间 time
    public function SFE_Circle2(real x,real y,real r,real time)
    {
        effect e;
        real size = r /200;
        real s;
        e = AddSpecialEffect("Tip\\Tip_ring_A.mdx", x,y);
        DzSetEffectAnimation( e,0,0);
        if(time<=0){
            s = 1;
            YDWETimerDestroyEffect(1,e);
        }
        else
        {
            s = 1/time;
            YDWETimerDestroyEffect(time+0.5,e);
        }
        EXSetEffectSpeed(e,s);
        EXSetEffectSize(e,size);
        EXSetEffectSpeed( e, 1.00);
        e = null;
   
    }
   //快速创建由绿到黄到红的渐变圆形提示圈 在(x,y) 半径r，持续时间 time
    public function SFE_Circle3(real x,real y,real r,real time)
    {
        effect e;
        real size = r /200;
        real s;
        e = AddSpecialEffect("Tip\\Tip_ring_B.mdx", x,y);
        DzSetEffectAnimation( e,1,0);
        if(time<=0){
            s = 1;
            YDWETimerDestroyEffect(0.1,e);
        }
        else
        {
            s = 1/time;
            YDWETimerDestroyEffect(time-0.5,e);
        }
        EXSetEffectSpeed(e,s);
        EXSetEffectSize(e,size);
        EXSetEffectSpeed( e, 1.00);
        e = null;
   
    }
}
//! endzinc


#endif
