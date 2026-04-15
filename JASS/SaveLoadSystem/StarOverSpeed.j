#ifndef StarOverSpeedIncluded
#define StarOverSpeedIncluded

#include "Star\\StarBase.j"
#include "Star\\X.j"

//! zinc

library StarOverSpeed requires X,StarCommon
{
    struct StarOverSpeedGenerator{
        static timer Timer;//系统中心计时器
        static boolean IsRun = false;//运行指示符
        static integer count = 0;//栈顶计数
        static integer now = 0;//临时参数
        static boolean skip = false;//临时参数
        static thistype list[];//子成员列表
        static integer EventID = 0;//回调事件类型
        static integer hashkey = <?= StringHash("移动速度突破系统ID") ?>;
        real speed;//移动速度 
        unit u;//突破移动速度的单位
        trigger t;//监视触发器
        trigger cb;//回调触发器?
        real tx;//命令发布目标点X
        real ty;//命令发布目标点Y
        real lx;
        real ly;
        real lf;
        boolean movementsync;//TODO  动作同步
        boolean b;//TODO  动作同步
        static method create(unit u , real s,boolean b)->thistype
        {
            thistype this;
            if(!HaveSavedInteger(StarBaseHT,GetHandleId(u),hashkey))
            {
                this = thistype.allocate();
                SaveInteger(StarBaseHT,GetHandleId(u),hashkey,this);//保存当前对象
                //设置变量开始
                this.u = u;
                this.speed = s;
                this.t = CreateTrigger();
                SaveInteger(StarBaseHT,GetHandleId(this.t),hashkey,this);
                TriggerAddAction(this.t,function (){
                    integer i = LoadInteger(StarBaseHT,GetHandleId(GetTriggeringTrigger()),hashkey);
                    StarOverSpeedGenerator this = i;
                    this.tx = GetOrderPointX();
                    this.ty = GetOrderPointY();
                });
                TriggerRegisterUnitEvent(this.t,u,EVENT_UNIT_ISSUED_POINT_ORDER);
                //设置变量结束
                //--------------压栈-------------- 无需改动
                thistype.list[thistype.count] = this;
                thistype.count +=1;
                //检查中心计时器运行状态
                thistype.Start();
                return this;
            }
            else
            {
                return LoadInteger(StarBaseHT,GetHandleId(u),hashkey);
            }
        }
        //
        method doEvent(integer i){
            real x,y,f,d,dis,dis2,s,s2;
            //TODO for 动作同步
            x = GetUnitX(u);y = GetUnitY(u);
            if(GetUnitCurrentOrder(u)==851971 || GetUnitCurrentOrder(u)==851986)
            {
                s= speed - GetUnitMoveSpeed(u);
                s2 = s / 50;
                dis = Math.GDBC(x,y,lx,ly);
                dis2 = Math.GDBC(x,y,tx,ty);
                f = GetUnitFacing(u);
                if(dis>(GetUnitMoveSpeed(u)/60)){
                    if(RAbsBJ(f)-RAbsBJ(lf)<2){
                        if(dis2>s2){
                            d = Math.GAFC(lx,ly,x,y);
                            lx = x + CosBJ(d) * s2;ly = y + SinBJ(d) * s2;
                            if(!X_IsTerrainWalkable(lx,ly)){
                                lx = X_GetAbleX();ly = X_GetAbleY();
                            }
                            SetUnitX(u,lx);SetUnitY(u,ly);
                        }else{
                            lx = tx;ly = ty;
                            if(!X_IsTerrainWalkable(lx,ly)){
                                lx = X_GetAbleX();ly = X_GetAbleY();
                            }
                            SetUnitX(u,lx);SetUnitY(u,ly);
                        }
                    }else{
                        lx = x;ly = y;
                    }
                }
                else{
                    lx = x;ly = y;
                }
                lf = f;
            }else{
                lx = x;ly = y;
            }
        }

        method onDestroy(){
            RemoveSavedInteger(StarBaseHT,GetHandleId(this.t),hashkey);
            RemoveSavedInteger(StarBaseHT,GetHandleId(this.u),hashkey);
            DestroyTrigger(this.t);
            this.u = null;
            //------------------出栈--------------
            if(thistype.now != thistype.count-1)
            {
                thistype.skip = true;
                thistype.list[thistype.now] = thistype.list[thistype.count-1];
            }
            thistype.count -=1;   
              
        }
        //-------------- 无需改动--------------------
        //开启中心计时器
        static method Start()
        {
            if(!thistype.IsRun)
            {
                TimerStart(Timer,0.02,true,function(){//遍历子成员
                    integer i = 0;
                    while(i<thistype.count)
                    {
                        thistype.now = i;
                        thistype.list[i].doEvent(i);
                        if(thistype.skip)
                        {
                            thistype.skip = false;
                            i-=1;
                        }
                        i+=1;
                    }
                    if(thistype.count ==0)//没有子成员,停止计时器
                    {
                        thistype.Stop();
                    }
                });
                thistype.IsRun = true;
            }
        }
        //-------------- 无需改动--------------------
        //停止中心计时器
        static method Stop(){
            if(thistype.IsRun)
            {
                PauseTimer(thistype.Timer);
                thistype.IsRun = false;
            }
        }
        //-------------- 无需改动--------------------
        static method onInit(){
            thistype.Timer = CreateTimer();
        }
    }
    //移动速度突破 单位 u  速度 s (是否动作同步 b 暂无)
    public function SOS_SetUnitSpeed(unit u,real s,boolean b)->integer{
        StarOverSpeedGenerator this;
        if(HaveSavedInteger(StarBaseHT,GetHandleId(u),StarOverSpeedGenerator.hashkey)){
            this = LoadInteger(StarBaseHT,GetHandleId(u),StarOverSpeedGenerator.hashkey);
            this.speed = s;
            this.b = b;
        }else{
            this = StarOverSpeedGenerator.create(u,s,b);
        }
        //debug if(this==0){Print("an error at function SOS_SetUnitSpeed overflow of struct");}
        return this;
    }
    //获取单位当前移动速度 若不在系统中 则返回当前移动速度
    public function SOS_GetUnitSpeed(unit u)->real{
        StarOverSpeedGenerator this;
        real s;
        if(HaveSavedInteger(StarBaseHT,GetHandleId(u),StarOverSpeedGenerator.hashkey)){
            this = LoadInteger(StarBaseHT,GetHandleId(u),StarOverSpeedGenerator.hashkey);
            s = this.speed;
        }else{
            s = GetUnitMoveSpeed(u);
        }
        return s;
    }
    //取消移动速度突破 单位u
    public function SOS_UnSetUnitSpeed(unit u){
        StarOverSpeedGenerator this ;
        if(HaveSavedInteger(StarBaseHT,GetHandleId(u),StarOverSpeedGenerator.hashkey)){
            this = LoadInteger(StarBaseHT,GetHandleId(u),StarOverSpeedGenerator.hashkey);
            this.destroy();
        }
    }
}

//! endzinc


#endif





