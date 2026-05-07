
#ifndef StarJumpIncluded
#define StarJumpIncluded

#include "Star\\StarBase.j"
#include "Star\\X.j"

//! zinc

library StarJump requires X,StarCommon
{
    //跳跃系统
    struct SJumper{
        static timer Timer;//系统中心计时器
        static boolean IsRun = false;//运行指示符
        static integer count = 0;//栈顶计数
        static integer now = 0;//临时参数
        static boolean skip = false;//临时参数
        static SJumper sjlist[];//子成员列表
        unit u;//跳跃者
        real disd;//已经跳跃距离
        real dis;//需要跳跃距离
        real speed;//速度
        real maxheight;//最大跳跃高度
        real d;//跳跃方向
        real lz;//
        trigger callback;//回调
        //命令单位u朝d开始跳跃,最大高度,跳跃距离,所需时间,结束回调
        static method create(unit u,real d,real mz,real dis,real time,trigger cb)->thistype
        {
            thistype this = thistype.allocate();
            this.u = u;//unit
            this.d = d;//fac
            this.maxheight = mz;//MaxHeight
            this.speed = dis/(time/0.02);//s=v/t
            this.callback = cb;//callback
            this.dis = dis;//disd
            this.disd = 0;//清除路程记录
            this.lz = 0;
            //使单位可以设置高度
            UnitAddAbility(u,'Amrf');
            UnitRemoveAbility(u,'Amrf');
            //压栈
            SJumper.sjlist[thistype.count] = this;
            thistype.count +=1;
            //运行计时器;
            thistype.Start();
            //Print("Created");
            return this;
        }
        
        //移动方法
        method move(integer i){
            real t = disd/dis;//
            real x,y,z;
            //Print("Moved");
            thistype.now = i;

            x = Star_CoordinateX(GetUnitX(this.u) + CosBJ(this.d)*this.speed );
            y = Star_CoordinateY(GetUnitY(this.u) + SinBJ(this.d)*this.speed );
            z = Math.Parabola(t,this.maxheight,0);
            
            //非深渊即可跳跃
            if(GetTerrainType(x,y) != 'cOc1')
            {
                SetUnitX(u,x);
                SetUnitY(u,y);
                SetUnitFlyHeight(u,GetUnitFlyHeight(u) - lz,0);
                SetUnitFlyHeight(u,GetUnitFlyHeight(u) + z,0);
                lz = z;
            }
            //到距离移除
            this.disd+=this.speed;
            if(this.disd>=this.dis)
            {
                //Print("disd = "+R2S(this.disd) + "dis = " + R2S(dis));
                //调用回调
                Star_TriggerUnit = this.u;
                if(TriggerEvaluate(this.callback))
                {
                    TriggerExecute(this.callback);
                }
                //退栈
                this.destroy();
            }
            
        }
        //
        method onDestroy(){
            //Print("Destroyed");
            SetUnitFlyHeight(this.u,GetUnitFlyHeight(this.u) - this.lz,0);
            //出栈
            if(thistype.now != thistype.count-1)
            {
                thistype.skip = true;
                thistype.sjlist[thistype.now] = thistype.sjlist[thistype.count-1];
            }
            thistype.count -=1;     
        }
        //开启中心计时器
        static method Start()
        {
            if(!thistype.IsRun)
            {
                TimerStart(Timer,0.02,true,function(){//遍历子成员
                    integer i = 0;
                    SJumper sj;
                    while(i<SJumper.count)
                    {
                        thistype.now = i;
                        sj = SJumper.sjlist[i];
                        sj.move(i);
                        if(thistype.skip)
                        {
                            thistype.skip = false;
                            i-=1;
                        }
                        i+=1;
                    }
                    if(SJumper.count ==0)//没有子成员,停止计时器
                    {
                        SJumper.Stop();
                    }
                });
                thistype.IsRun = true;
            }
        }
        //停止中心计时器
        static method Stop(){
            if(thistype.IsRun)
            {
                //Print("Stoped");
                PauseTimer(thistype.Timer);
                thistype.IsRun = false;
            }
        }
        static method onInit(){
            //Print("Inited");
            thistype.Timer = CreateTimer();
            
        }
    }
    public function SJ_JumpBase(unit u,real d,real mz,real dis,real time,trigger cb)
    {
        if(GetUnitDefaultMoveSpeed(u)>0.1)
        {
            SJumper.create(u,d,mz,dis,time,cb);
        }
    }
}

//! endzinc


#endif



