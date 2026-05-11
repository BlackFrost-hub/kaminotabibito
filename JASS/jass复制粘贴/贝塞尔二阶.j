#ifndef StarESIncluded
#define StarESIncluded
/*

*/
#include "japi\\YDWEJapiEffect.j"

#include "Star\\StarBase.j"

/*
	native EXGetEffectX takes effect e returns real
	native EXGetEffectY takes effect e returns real
	native EXGetEffectZ takes effect e returns real
	native EXSetEffectXY takes effect e, real x, real y returns nothing
	native EXSetEffectZ takes effect e, real z returns nothing
	native EXGetEffectSize takes effect e returns real
	native EXSetEffectSize takes effect e, real size returns nothing
	native EXEffectMatRotateX takes effect e, real angle returns nothing
	native EXEffectMatRotateY takes effect e, real angle returns nothing
	native EXEffectMatRotateZ takes effect e, real angle returns nothing
	native EXEffectMatScale takes effect e, real x, real y, real z returns nothing
	native EXEffectMatReset takes effect e returns nothing
	native EXSetEffectSpeed takes effect e, real speed returns nothing
	function YDWESetEffectLoc takes effect e, location loc returns nothing
		call EXSetEffectXY(e, GetLocationX(loc), GetLocationY(loc))
	endfunction
*/

//! zinc

//贝塞尔二阶+抛物线 弹幕冲锋库
library StarES requires StarCommon,EC
{
    public struct Soul{
        static integer count = 0;
        public real x0;
        public real y0;
        public real x1;
        public real y1;
        public real angle;
        public real speed;
        public real upspeed;
        public effect efc;
        public unit u;
        public unit target;
        public real x2;
        public real y2;
        public real timed;
        public real height;
        public real baseh;
        public trigger callback;
        public real maxtime;
        public real targethieght;
        public boolean UsedZ;
        public method GetZ(real steeps,real t, real heightMax ,real fly) ->real
        {
            return (-(2*(steeps)*t-1)*(2*(steeps)-1)*t+1)*heightMax+fly;
        }
        public method GetZ3(real steeps, real Max ,real base) ->real
        {
            return (-(2*(steeps)-1)*(2*(steeps)-1)+1)*Max+base;
        }
        static method GetZ2(real steeps,real t, real heightMax ,real fly) ->real
        {
            return (-(2*(steeps)*t-1)*(2*(steeps)-1)*t+1)*heightMax+fly;
        }
        //获取顶部计数
        static method GetIndex()->integer{
            return Soul.count - 1;
        }
        //贝塞尔 二阶 通用 t ,中点 起点 终点
        method Bessel(real t, real mid ,real st,real tt) -> real
        {
            return (t * t * tt + 2 * t * (1 - t) * mid + (1 - t) * (1 - t) * st);
        }
        
        //移动
        method Move(real dealtatime)
        {
            real fac,x5,y5,ry,time,z,r;real x6,y6,z6;
            if(this.target!=null){this.x1 = GetUnitX(this.target);this.y1 = GetUnitY(this.target);}
            this.speed +=  this.upspeed * dealtatime;//速度
            time = Math.GDBC(this.x1,this.y1,this.x2,this.y2) / this.speed;//时间
            r = Math.Min(this.timed+(dealtatime * (1/time)),this.maxtime);//t = s / v
            this.timed = r;time = r+0.01;//取 贝塞尔曲线当前所在位置 t
            x5 = Bessel(r,x2,x0,x1);y5 = Bessel(r,y2,y0,y1);//当前帧的X.Y
            x6 = Bessel(time,x2,x0,x1);y6 = Bessel(time,y2,y0,y1);//下一帧的X.Y
            z6 = Star_GetLocZ(x6,y6) + Math.Parabola(time,this.height,this.baseh)+(time)*(GetUnitFlyHeight(this.target)+this.targethieght);//计算Z轴
            fac = Math.GAFC(x5,y5,x6,y6);//计算偏航轴
            z = Star_GetLocZ(x5,y5) + Math.Parabola(r,this.height,this.baseh)+r*(GetUnitFlyHeight(this.target)+this.targethieght);//计算Z轴
            ry = Atan2BJ(z6-z,Math.GDBC(x5,y5,x6,y6));//计算俯仰轴
            if( (fac<0&&fac>=-90) || (fac>0)&&(fac<=90) ){ry = ry * -1;}
            EXSetEffectXY(this.efc,x5,y5);//设置xyz
            EXSetEffectZ(this.efc,z);//设置xyz
            EXEffectMatReset( this.efc );//归零姿态角
            EXEffectMatRotateZ( this.efc, fac);//设置姿态角
            EXEffectMatRotateY( this.efc, ry);//设置姿态角
        }
        static method create(real x, real y,real a,real dis,real h,unit u,unit tu,effect e,real x6,real y6)->Soul
        {
            Soul this = Soul.allocate();
            this.x0 = x;
            this.y0 = y;
            this.speed = 300;
            this.upspeed = 1200;
            
            this.timed = 0;
            this.u = u;
            this.target = tu;
            this.efc = e;
            this.x2 = this.x0 + CosBJ(this.angle )* dis;//初始化偏移点(二阶中点)
            this.y2 = this.y0 + SinBJ(this.angle )* dis;

            this.angle = a;//Math.GAFC(x,y,this.x2,this.y2);

            this.height = h;
            this.baseh = EXGetEffectZ(e);
            this.maxtime = 1;
            this.x1 = x6;
            this.y1 = y6;
            this.targethieght = 0;
            this.UsedZ = false;
            Soul.count +=1;
            return this;
        }
        public method ResetSpeed(real a,real b)//重新设置速度/加速度
        {
            this.speed = a;
            this.upspeed = b;
        }
        static method DisplayCount(){//Debug function
            Print(I2S(Soul.count));
        }
        method onDestroy(){//
            this.callback = null;
            Soul.count -=1;
            DestroyEffect(this.efc);
        }
    }
    private 
    {
        real dealtatime = 0.04;
        Soul table[4000];
    }
    public timer SES_TIMER = CreateTimer();
    private function TimerEvent()
    {
        integer i = 0;
        Soul soul;
        while(i<Soul.count)
        {
            soul = table[i];
            if(soul.timed<1)
            {
                soul.Move(dealtatime);
            }
            else
            {
                Star_TriggerUnit = soul.target;//触发单位 = 弹幕目标单位;
                Star_TargetUnit = soul.u;//目标单位 = 弹幕起始单位;
                Star_TriggerEffect = soul.efc;//触发的特效
                //printi(GetHandleId(Star_TriggerEffect));
                if(soul.callback!=null)//触发回调
                {
                    if(TriggerEvaluate(soul.callback))
                    {
                        TriggerExecute(soul.callback);
                    }
                }
                //printi(GetHandleId(Star_TriggerEffect));
                table[i] = table[Soul.GetIndex()];
                soul.destroy();
                i-=1;
            }
            i+=1;
        }
    }
    //创建一个弹幕在x,y,中点->(从x,y开始,偏移角度为a,距离为dis),最大高度h,到达时间,速度,加速度,来源单位 目标单位 弹幕特效 回调触发器
    public function StarES_Add(real x, real y,real a,real dis,real h,real time,real spd,real upspd,unit u,unit tu,effect e,trigger t)
    {
        Soul soul = Soul.create(x,y,a,dis,h,u,tu,e,0,0);
        soul.maxtime = time;
        soul.ResetSpeed(spd,upspd);
        table[Soul.GetIndex()] = soul;
        soul.callback = t;
    }
    //创建一个弹幕在x,y,中点->(从x,y开始,偏移角度为a,距离为dis),最大高度h,到达时间,速度,加速度,来源单位 目标单位 弹幕特效 回调触发器
    public function StarES_AddZ(real x, real y,real a,real dis,real h,real time,real spd,real upspd,real hm,unit u,unit tu,effect e,trigger t)
    {
        Soul soul = Soul.create(x,y,a,dis,h,u,tu,e,0,0);
        soul.maxtime = time;
        soul.UsedZ = true;
        soul.targethieght = hm;
        soul.ResetSpeed(spd,upspd);
        table[Soul.GetIndex()] = soul;
        soul.callback = t;
    }
    //创建一个弹幕在x,y,终点{x2,y2} 中点->(从x,y开始,偏移角度为a,距离为dis),最大高度h,到达时间,速度,加速度,来源单位 弹幕特效 回调触发器
    public function StarES_AddForLoc(real x, real y,real x2,real y2,real a,real dis,real h,real time,real spd,real upspd,unit u,unit tu,effect e,trigger t)
    {
        Soul soul = Soul.create(x,y,a,dis,h,u,null,e,x2,y2);
        soul.maxtime = time;
        soul.ResetSpeed(spd,upspd);
        table[Soul.GetIndex()] = soul;
        soul.callback = t;
    }
    //带高度
    //创建一个弹幕在x,y,终点{x2,y2} 中点->(从x,y开始,偏移角度为a,距离为dis),最大高度h,到达时间,速度,加速度,来源单位 弹幕特效 回调触发器
    public function StarES_AddForLocZ(real x, real y,real x2,real y2,real a,real dis,real h,real time,real spd,real upspd,real hm,unit u,unit tu,effect e,trigger t)
    {
        Soul soul = Soul.create(x,y,a,dis,h,u,null,e,x2,y2);
        soul.maxtime = time;
        soul.ResetSpeed(spd,upspd);
        soul.UsedZ = true;
        soul.targethieght = hm;
        table[Soul.GetIndex()] = soul;
        soul.callback = t;
    }
    //自适应
    public function StarES_EX(real x, real y,real x2,real y2,real a,real dis,real h,real time,real spd,real upspd,real hm,unit u,unit tu,effect e,trigger t)
    {
        Soul soul = Soul.create(x,y,a,dis,h,u,tu,e,x2,y2);
        soul.maxtime = time;
        soul.ResetSpeed(spd,upspd);
        soul.UsedZ = true;
        soul.targethieght = hm;
        table[Soul.GetIndex()] = soul;
        soul.callback = t;
    }
    trigger StarES_FastGoldTrig;
    trigger StarES_FastExpTrig;
    
    //快速创建金币特效
    public function StarES_FastGold(unit u,unit tu,integer count,real value){
        integer v = R2I(value/count);
        integer i = 0 ;
        real x,y,a,b,d,dis,h;
        effect e;
        x=GetUnitX(u);
        y=GetUnitY(u);
        a=GetUnitX(tu);
        b=GetUnitY(tu);
        for(0<i<count)
        {
            d=Math.GAFC(x,y,a,b)-GetRandomReal(90,270);
            dis=GetRandomReal(150,650);
            h=GetRandomReal(100,450);
            e = AddSpecialEffect("Objects\\InventoryItems\\PotofGold\\PotofGold.mdl",x,y);
            EXSetEffectZ( e, 20.00 );
            EXSetEffectSize( e, 0.20 );
            SaveInteger(StarBaseHT,GetHandleId(e),<?= StringHash("gold") ?>,v);
            StarES_EX(x,y,a,b,d,dis,h,2,GetRandomReal(100,150),GetRandomReal(75,225),h,u,tu,e,StarES_FastGoldTrig);
        }
        e = null;
    }
    //快速创建经验特效
    public function StarES_FastExp(unit u,unit tu,integer count,integer value){
        integer v = R2I(value/count);
        integer i = 0 ;
        real x,y,a,b,d,dis,h;
        effect e;
        x=GetUnitX(u);
        y=GetUnitY(u);
        a=GetUnitX(tu);
        b=GetUnitY(tu);
        for(0<i<count)
        {
            d=Math.GAFC(x,y,a,b)-GetRandomReal(90,270);
            dis=GetRandomReal(150,650);
            h=GetRandomReal(100,450);
            e = AddSpecialEffect("Objects\\InventoryItems\\PotofGold\\PotofGold.mdl",x,y);
            EXSetEffectZ( e, 20.00 );
            EXSetEffectSize( e, 0.20 );
            SaveInteger(StarBaseHT,GetHandleId(e),<?= StringHash("exp")?>,v);
            StarES_EX(x,y,a,b,d,dis,h,2,GetRandomReal(100,150),GetRandomReal(75,225),h,u,tu,e,StarES_FastExpTrig);
        }
        e = null;
    }
    //Init
    function onInit()
    {
        TimerStart(SES_TIMER,dealtatime,true,function TimerEvent);

        StarES_FastGoldTrig=CreateTrigger();
        TriggerAddAction(StarES_FastGoldTrig,function(){
            integer v = LoadInteger(StarBaseHT,GetHandleId(Star_TriggerEffect),<?= StringHash("gold") ?>);
            unit u = Star_TriggerUnit;
            real beilv = LoadReal(YDHT,GetHandleId(u),<?= StringHash("金币获取率")?>);
            v = R2I(v*beilv);
            AdjustPlayerStateBJ(v, GetOwningPlayer(u), PLAYER_STATE_RESOURCE_GOLD );
            //显示增加的数字
            udg_SS_X = GetUnitX(u);
            udg_SS_Y = GetUnitY(u);
            udg_SS_String = ( "+" + I2S(v) );
            udg_SS_Colour = "黄";
            udg_SS_SH = 75.00;
            TriggerExecute( gg_trg_Tag_System );
            FlushChildHashtable(StarBaseHT,GetHandleId(Star_TriggerEffect));
            DestroyEffect( Star_TriggerEffect );
            u = null;
        });

        StarES_FastExpTrig=CreateTrigger();
        TriggerAddAction(StarES_FastExpTrig,function(){
            integer v = LoadInteger(StarBaseHT,GetHandleId(Star_TriggerEffect),<?= StringHash("exp")?>);
            unit u = Star_TriggerUnit;
            real beilv = LoadReal(YDHT,GetHandleId(u),<?= StringHash("经验获取率")?>);
            v = R2I(v*beilv);
            AddHeroXP( u, v, true );
            //显示增加的数字
            udg_SS_X = GetUnitX(u);
            udg_SS_Y = GetUnitY(u);
            udg_SS_String = ( "+" + I2S(v) );
            udg_SS_Colour = "白";
            udg_SS_SH = 50.00;
            TriggerExecute( gg_trg_Tag_System );
            FlushChildHashtable(StarBaseHT,GetHandleId(Star_TriggerEffect));
            DestroyEffect( Star_TriggerEffect );
            u = null;
        });
    }

}





//! endzinc



#endif


