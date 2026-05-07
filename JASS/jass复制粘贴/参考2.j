#ifndef StarChargeIncluded
#define StarChargeIncluded

#include "Star\\StarBase.j"
#include "Star\\X.j"

//! zinc
  
library StarCharge requires StarCommon,X,StarBase
{
    public integer SCD1EventID = 0; // 1=碰撞 2=撞墙 3=结束 
    public SCData1 SCData1List[];
    public group SC_tempg2 ;
    private trigger basetrig = CreateTrigger();
    private integer K_Value = StringHash("Value");
    //private integer K_Stop = StringHash("Stop"); 
    public function CheakLoc(real x,real y)->boolean
    {
        return (x>=GetRectMinX(bj_mapInitialPlayableArea))&&
        (y>=GetRectMinY(bj_mapInitialPlayableArea))&&
        (x<=GetRectMaxX(bj_mapInitialPlayableArea))&&
        (y<=GetRectMaxY(bj_mapInitialPlayableArea));
    }
    //排除死亡的单位
    public function SCD1Filter()->boolean
    {
        return (GetUnitState(GetFilterUnit(),UNIT_STATE_LIFE)>0.405);
    }
    //排除死亡的单位/友军
    public function SCD1Filter2()->boolean
    {
        return (
            GetUnitState(GetFilterUnit(),UNIT_STATE_LIFE)>0.405&& 
            (!(IsUnitInGroup(GetFilterUnit(),SC_tempg2)))
            );
    }
    //停止单位所有冲锋
    public function StarCharge_StopCharge(unit u)
    {
        integer i = 0;
        while(i<SCData1.index)
        {
            if(SCData1List[i].u == u)
            {
                SCData1List[i].disd += 999999;
            }
            i+=1;
        }
    }
    //结束本次冲锋
    public function SCD_StopCharge()
    {
        //Print("stop");
        SCD_Exit = true;
    }
    public boolean SCD_Exit = false;
    public integer scd_now_id = 0;
    //动作执行
    public function SCD1ForGroupFunc()
    {
        SCData1 scd = SCData1.tempSCData1;
        if(!SCD_Exit)
        {
            //Print("call");
            

            Star_TargetUnit = GetEnumUnit();
            // Print("Star_TriggerUnit->"+GetUnitName(Star_TriggerUnit));
            // Print("Star_TargetUnit->"+GetUnitName(Star_TargetUnit));
            if(IsUnitEnemy(Star_TargetUnit,GetOwningPlayer(Star_TriggerUnit)))
            {
                // Print("GetEnumUnit->"+GetUnitName(Star_TargetUnit));
                if(scd.onlyOne)
                {
                    GroupAddUnit(SC_tempg2,GetEnumUnit());
                }
                if(TriggerEvaluate(scd.callback))
                {   
                    TriggerExecute(scd.callback);
                }
            }
            Star_TargetUnit = null;
        }
        else
        {
            //Print("skip");
        }
    }
    struct SCData1{
        static integer index = 0;
        static timer STimer;
        static boolean Paused = false;
        static group tempg = CreateGroup();
        static SCData1 tempSCData1;
        unit u;
        real speed;
        group pg;
        real d;
        real range;
        real dis;
        real disd;
        boolean b;
        boolean onlyOne;
        trigger callback;
        static method create(unit u,real s,real d,real dis,real r,boolean b,trigger t)->SCData1
        {
            SCData1 scd = SCData1.allocate();
            scd.dis = dis;
            scd.disd = 0;
            scd.u = u;
            scd.speed = s;
            scd.d = d;
            scd.range=r;
            scd.b=b;
            scd.onlyOne = false;
            scd.pg = null;
            //BJDebugMsg("d="+R2S(scd.d));
            scd.callback = t;
            SCData1.index +=1;
            return scd;
        }
        public method enum(real x,real y)
        {
            //选取单位
            tempSCData1 = this;
            SC_tempg2 = null;
            if(this.onlyOne)
            {
                SC_tempg2 = this.pg;//LoadGroupHandle(StarBaseHT,GetHandleId(this.u),Key_One);
                GroupEnumUnitsInRange(tempg,x,y,this.range,function SCD1Filter2);
            }
            else
            {
                GroupEnumUnitsInRange(tempg,x,y,this.range,function SCD1Filter);
            }   
            SCD1EventID = 1;
            Star_TriggerUnit = this.u;
            ForGroup(tempg,function SCD1ForGroupFunc);
            GroupClear(tempg);
            if(SCD_Exit){
                this.disd+=999999;
                SCD_Exit = false;
            }
        }
        public method move()
        {
            real x;
            real y;
            x = GetUnitX(this.u) + CosBJ(this.d) * this.speed;
            y = GetUnitY(this.u) + SinBJ(this.d) * this.speed;
            SetUnitFacing(u,this.d);
            if(CheakLoc(x,y))
            {
                // //调用回调
                Star_TriggerUnit = this.u;
                //SCD1EventID = 4;//在移动时发生
                if(TriggerEvaluate(this.callback))
                {
                    TriggerExecute(this.callback);
                }
                SetUnitX(this.u,x);
                SetUnitY(this.u,y);
                this.disd+=this.speed;
                if(this.callback!=null)
                {
                    this.enum(x,y);
                }
            }
            else
            {
                this.disd+=999999;
            }
            //BJDebugMsg(R2S(this.dis)+"||"+R2S(this.disd));
        }
        //检查墙体碰撞
        public method move_b()
        {
            real x =0 ;
            real y =0 ;
            real s1 =0 ;
            integer i =0 ,max = 0;
            if(this.speed>31)
            {
                max=R2I(this.speed / 31);
                while(i<max)
                {
                    x = GetUnitX(this.u) + CosBJ(this.d) * 31;
                    y = GetUnitY(this.u) + SinBJ(this.d) * 31;
                    if(X_IsTerrainWalkable(x,y))
                    {
                        //SCD1EventID = 4;//在移动时发生
                        if(TriggerEvaluate(this.callback))
                        {
                            TriggerExecute(this.callback);
                        }
                        SetUnitX(this.u,x);
                        SetUnitY(this.u,y);
                        this.disd+=31;
                        if(this.callback!=null)
                        {
                            this.enum(x,y);
                        }
                    }
                    else
                    {
                        this.disd+=999999;
                        break;
                    }
                    i+=1;
                }
                if(this.dis<this.disd)
                {
                    s1 = Math.Modulo(this.speed,31);
                    x = GetUnitX(this.u) + CosBJ(this.d) * s1;
                    y = GetUnitY(this.u) + SinBJ(this.d) * s1;
                    if(X_IsTerrainWalkable(x,y))
                    {
                        //SCD1EventID = 4;//在移动时发生
                        if(TriggerEvaluate(this.callback))
                        {
                            TriggerExecute(this.callback);
                        }
                        SetUnitX(this.u,x);
                        SetUnitY(this.u,y);
                        this.disd+=s1;
                        if(this.callback!=null)
                        {
                            this.enum(x,y);
                        }
                    }
                    else
                    {
                        this.disd+=999999;
                    }
                }
            }
            else
            {
                x = GetUnitX(this.u) + CosBJ(this.d) * this.speed;
                y = GetUnitY(this.u) + SinBJ(this.d) * this.speed;
                if(X_IsTerrainWalkable(x,y))
                {
                    //SCD1EventID = 4;//在移动时发生
                    if(TriggerEvaluate(this.callback))
                    {
                        TriggerExecute(this.callback);
                    }
                    SetUnitX(this.u,x);
                    SetUnitY(this.u,y);
                    this.disd+=this.speed;
                    if(this.callback!=null)
                    {
                        this.enum(x,y);
                    }
                }
                else
                {
                    this.disd+=999999;
                }
            }
        }
        public method onDestroy()
        {
            // DestroyGroup(LoadGroupHandle(StarBaseHT,GetHandleId(this.u),Key_One));
            // RemoveSavedHandle(StarBaseHT,GetHandleId(this.u),Key_One);
            DestroyGroup(this.pg);
            this.u = null;
            this.callback = null;
        }
    }
    public function SCD1TE()
    {
        integer i = 0;
        SCData1 scd;
        if(SCData1.index==0)
        {
            SCData1.Paused = true;
            PauseTimer(GetExpiredTimer());
        }
        while(i<SCData1.index)
        {
            scd_now_id = i;
            scd = SCData1List[i];
            if(scd.b)
            {
                //BJDebugMsg("2");
                scd.move_b();
            }
            else
            {
                //BJDebugMsg("3");
                scd.move();
            }
            if(scd.disd>=scd.dis)
            {
                //BJDebugMsg("4");
                SCData1List[i] = SCData1List[SCData1.index];
                if(scd.callback!=null)
                {
                    Star_TriggerUnit = scd.u;
                    Star_TargetUnit = null;
                    if(scd.disd>99999)
                    {   
                        SCD1EventID = 2;
                    }
                    else
                    {
                        SCD1EventID = 3;
                    }
                    if(TriggerEvaluate(scd.callback))
                    {
                        TriggerExecute(scd.callback);
                    }
                }
                //BJDebugMsg("摧毁了一个成员");
                SCData1.index -=1;
                scd.destroy();
                i-=1;
            }
            i+=1;
        }
    }
    public integer Key_One = StringHash("onlyOne");
    //unit u,real s,real d,real dis,real r,boolean b,trigger t
    //命令单位向目标点发起冲锋，冲锋角度为，冲锋距离为，冲锋时间为，碰撞体积 ,检查墙体碰撞->,回调触发器为->
    public function StarChargeBase(unit u,real d,real dis,real time,real r,boolean b,trigger t){
        SCData1 scd ;
        real s ;
        s = dis/(time/0.02);
        scd = SCData1.create(u,s,d,dis,r,b,t);
        SCData1List[SCData1.index-1] = scd;
        scd.onlyOne = true;
        if(SCData1.Paused)
        {
            TimerStart(SCData1.STimer,0.02,true,function SCD1TE);
        }
    }
    //命令单位向目标点发起冲锋，冲锋角度为，冲锋距离为，冲锋时间为，碰撞体积 ,检查墙体碰撞->,禁止重复伤害->,回调触发器为->
    public function StarChargeII(unit u,real d,real dis,real time,real r,boolean b,boolean b2,trigger t){
        SCData1 scd ;
        real s ;
        s = dis/(time/0.02);
        scd = SCData1.create(u,s,d,dis,r,b,t);
        if(b2)
        {
            scd.pg = CreateGroup();
            // if(!HaveSavedHandle(StarBaseHT,GetHandleId(u),Key_One){SaveGroupHandle(StarBaseHT,GetHandleId(u),Key_One,CreateGroup());}
            scd.onlyOne = true;
        }
        SCData1List[SCData1.index-1] = scd;
        if(SCData1.Paused)
        {
            TimerStart(SCData1.STimer,0.02,true,function SCD1TE);
        }
    }
    //命令单位向目标点发起冲锋，冲锋角度为，冲锋距离为，冲锋时间为，碰撞体积 ,检查墙体碰撞->,禁止重复伤害->,回调触发器为->
    public function StarChargeEX(unit u,real d,real dis,real time,real r,boolean b,boolean b2,trigger t){
        SCData1 scd ;
        real s ;
        s = dis/(time/0.02);
        // scd = SCData1List[SCData1.index].create(u,s,d,dis,r,b,t);
        scd = SCData1.create(u,s,d,dis,r,b,t);
        if(b2)
        {
            scd.pg = CreateGroup();
            // if(!HaveSavedHandle(StarBaseHT,GetHandleId(u),Key_One){SaveGroupHandle(StarBaseHT,GetHandleId(u),Key_One,CreateGroup());}
            scd.onlyOne = true;
        }
        SCData1List[SCData1.index-1] = scd;
        if(SCData1.Paused)
        {
            TimerStart(SCData1.STimer,0.02,true,function SCD1TE);
        }
    }
    //命令单位向目标点发起冲锋，冲锋角度为，冲锋距离为，冲锋时间为，碰撞体积 ,伤害值 , 检查墙体碰撞-> 
    public function StarChargeI(unit u,real d,real dis,real time,real r,real value,boolean b){
        SCData1 scd ;
        real s ;
        s = dis/(time/0.02);
        scd = SCData1.create(u,s,d,dis,r,b,basetrig);
        scd.pg = CreateGroup();

        // if(!HaveSavedHandle(StarBaseHT,GetHandleId(u),Key_One))
        // {
        //     SaveGroupHandle(StarBaseHT,GetHandleId(u),Key_One,CreateGroup());
        // }

        if(!HaveSavedReal(StarBaseHT,GetHandleId(u),K_Value))
        {
            SaveReal(StarBaseHT,GetHandleId(u),K_Value,value);
        }
        scd.onlyOne = true;
        SCData1List[SCData1.index-1] = scd;
        if(SCData1.Paused)
        {
            TimerStart(SCData1.STimer,0.02,true,function SCD1TE);
        }
    }
    //获取触发的事件ID
    public function StarCharge_GetEventId()->integer{return SCD1EventID;}

    function onInit()
    {
        SCData1.STimer = CreateTimer();
        TimerStart(SCData1.STimer,0.02,true,function SCD1TE);
        TriggerAddAction(basetrig,function(){
            real v = LoadReal(StarBaseHT,GetHandleId(Star_GetTriggerUnit()),K_Value);
            if(IsUnitEnemy(Star_GetTargetUnit(),GetOwningPlayer(Star_GetTriggerUnit())))
            {
                UnitDamageTarget( Star_GetTriggerUnit(), Star_GetTargetUnit(), v, false, false, ATTACK_TYPE_MELEE, DAMAGE_TYPE_UNIVERSAL, WEAPON_TYPE_WHOKNOWS );
            }
        });
    }
    public function StarCharerEX(){
        
    }
}

//! endzinc



#endif

