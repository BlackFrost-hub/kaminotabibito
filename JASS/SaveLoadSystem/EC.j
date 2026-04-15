#ifndef ECIncluded
#define ECIncluded

#include "Star\\StarBase.j"

#include "Star\\X.j"
#include "YDWETimerSystem.j"
//! zinc

#ifdef OPEN
    library EC requires StarBase,japi , X,YDWETimerSystem
#else
    library EC requires StarBase , X,YDWETimerSystem
#endif
{
    private 
    {
        effect tempef;
        integer i = 0;
        group g = CreateGroup();
        real ec_temp_t = 0;
    }
    public
    {
        effect Star_Effect = null;
        //角度
        real EC_D[];
        //已经行进的距离
        real EC_DisD[];
        //总需行进的距离
        real EC_Distance[];
        //特效高度
        real EC_Height[];
        //冲锋伤害范围
        real EC_Range[];
        //特效移动速度
        real EC_Speed[];
        //总冲锋时间
        real EC_TimeMax[];
        //已经冲锋时间
        real EC_Timed[];
        //顶计数
        integer EC_Index = 0;
        //结束模式 0为距离模式 1为时间模式
        integer EC_Mode[];
        //是否触发碰撞
        boolean EC_PZ[];
        boolean EC_Brush[];
        real EC_BrushTime[];
        real EC_BrushDis[];
        //触发单位
        unit EC_TargetUnit;
        //触发的特效
        effect EC_TargetEffect;
        player EC_EffectOwnningPlayer;
        //新的特效,在刷新时使用
        effect EC_NewEffect;
        //EC中心计时器
        timer EC_Timer;
        //特效的所有者
        player EC_OwnningPlayer[];
        //指示结束后是否删除特效-在结束触发器中设置为true
        boolean EC_KeepALive;
        boolean EC_Hitable = true;
        //途径单位触发器
        trigger EC_DamageTrig[];
        //结束触发器
        trigger EC_FinishTrig[];
        //刷新计时器 
        trigger EC_BrushTrig[];
        //碰撞触发器
        trigger EC_PZTrig[];
        //特效集
        effect EC_EffectList[];
        //事件ID 0 = 碰撞 1 = 结束 2 = 刷新 3 = 撞墙 4 =弹幕碰撞护盾
        integer EC_EventID;
        boolean EC_Exit = false;
        boolean EC_ShiledExit = false;
        integer EC_steepsMax[];
        integer EC_steeps[];
        //飞行模式： 0 ：锁定相对地面高度 1：抛物线的飞行模式 2：自定义
        integer EC_FlyMode[];
        //移动模式： 0 :直线 1:自定义(每次需要移动时 调用 刷新触发器，不再自主移动)
        integer EC_MoveMode[];
        /*
            护盾相关
            遍历所有护盾计算护盾与弹幕的距离，当弹幕在护盾内时，运行相应的处理触发器
            参数 
            EC_TargetEffect 当前冲锋的特效
            EC_TargetUnit 被触碰的护盾
        */
        unit EC_ShiledArray[];
        trigger EC_ShiledCallbackTrig[];
        real EC_ShiledSize[];
        integer EC_ShiledIndex = 0;    
    }
    ///立即删除特效,不显示动画
    public function EC_DestroyEffect(effect e)
    {
        EXSetEffectXY(e,99999,99999);
        DestroyEffect(e);
    }
    public function EC_A1(real a,real b , real c,real t)->real
    {
        return Pow((1-t),2)*a+2*t*(1-t)*b + Pow(t,2)*c;
    }
    public function EC_GetHeight(integer steeps  ,integer steepsMax, real heightMax ,real fly) ->real
    {
        real dheig=1.0/steepsMax;
        return (-(2*I2R(steeps)*dheig-1)*(2*I2R(steeps)*dheig-1)+1)*heightMax+fly;
    }
    //获取坐标位置的Z轴高度
    public function EC_GetPointZ(real x , real y)->real
    {
        if(Star_Location==null)
        {
            Star_Location = Location(x,y);
        }
        else
        {
            MoveLocation(Star_Location,x,y);
        }
        return GetLocationZ(Star_Location);
    }
    
    private function EC_TimerEvent()
    {
        unit u;
        real x;
        real y;
        real z;
        integer tempi =0;integer tempmax = 0;
        real tempr = 0;
        integer index;
        integer i2 = 0;
        EC_Running = true;
        if(EC_Index>0)
        {
        index = EC_Index - 1;i =0;
        //BJDebugMsg("============================");
        //BJDebugMsg("index = " + I2S(index)+"EC_Index = " + I2S(EC_Index));
        //BJDebugMsg("===========END===========");
        //BJDebugMsg("data at 0 = " + R2S(EC_D[0]));
        while(i<=index)
        {
            SaveInteger(EC_HT,GetHandleId(EC_EffectList[i]),1000,i);
            EC_Exit = false;
            EC_ShiledExit = false;
            tempi = 0;
            if(EC_Speed[i]==0)
            {
                EC_Exit = true;
            }
            if(EC_Speed[i] > 31)
            {
                tempmax = R2I(EC_Speed[i] / 31);
                //Print("tempmax = " +I2S(tempmax));
                tempr = ModuloReal(EC_Speed[i] , 31);
                ////Print("tempr = " +R2S(tempr));
                //BJDebugMsg("tempmax = "+I2S(tempmax) + "tempi = "+I2S(tempi));
            }
            else 
            {
                tempmax = 0;
                tempr = EC_Speed[i];
            }
            //移动特效 默认的移动模式
            if(EC_MoveMode[i]==0)
            {
                //特效移动部分
                while(tempi < tempmax)
                {
                    tempi = tempi + 1;
                    ////Print("tempi = " +I2S(tempi));
                    if(!EC_Exit)
                    {
                        //移动特效
                        
                        //Print("tempmax = "+I2S(tempmax) + "tempi = "+I2S(tempi));
                        x = EXGetEffectX(EC_EffectList[i]) + CosBJ(EC_D[i] ) * 31;
                        y = EXGetEffectY(EC_EffectList[i]) + SinBJ(EC_D[i] ) * 31;
                        if(EC_PZ[i])
                        {
                            //Print("PZ");
                            if(!X_IsTerrainWalkable(x,y) )
                            {
                                if(EC_PZTrig[i] != null)
                                {
                                    //Print("PZCALL");
                                    EC_TargetEffect = EC_EffectList[i];
                                    EC_EventID= 3;
                                    TriggerExecute( EC_PZTrig[i] );
                                }
                                else
                                {
                                    //Print("Exit");
                                    //停止移动，运行结束触发器
                                    EC_Exit = true;
                                    tempi = tempmax;
                                }
                            }
                            else
                            {
                                //Print("Move");
                                EXSetEffectXY(EC_EffectList[i],x,y);
                            }
                        }
                        else
                        {
                            //Print("Move");
                            EXSetEffectXY(EC_EffectList[i],x,y);
                        }
                        //Print("CheakPoint8");
                        //特效高度设置
                        if(EC_FlyMode[i] != 2)  // =2为自定义 即 不设置
                        {
                            //Print("EC_FlyMode");
                            //保持特效相对地面高度
                            z = EC_GetPointZ(x,y);
                            if(EC_FlyMode[i] == 0||EC_Height[i]==0)
                            {
                                //Print("CheakPoint6");
                                EXSetEffectZ(EC_EffectList[i],z+EC_Height[i]);
                            }
                            else if(EC_FlyMode[i] == 1)
                            {
                                //Print("CheakPoint7");
                                //抛物线
                                EC_steeps[i] = EC_steeps[i] + 1 ;
                                if(EC_DisD[i]>0)
                                {
                                    ec_temp_t = EC_DisD[i] / EC_Distance[i];
                                }
                                else{
                                    ec_temp_t = 1;
                                }
                                EXSetEffectZ(EC_EffectList[i],Math.Parabola(ec_temp_t,EC_Height[i],z)  );
                                //BJDebugMsg(R2S(EXGetEffectZ(EC_EffectList[i])));
                            }
                        }
                        ////Print("CheakPoint3");
                        i2 = 0;
                        //Print("CheakPoint2");
                        //检查护盾
                        //BJDebugMsg("i2 =:"+I2S(i2)+",Index = "+I2S(EC_ShiledIndex));
                        while(i2<EC_ShiledIndex)
                        {
                            //Print("EC_ShiledIndex");
                            //BJDebugMsg("i2 =:"+I2S(i2)+",Index = "+I2S(EC_ShiledIndex));
                            //友方护盾则不检查
                            if(!IsUnitAlly(EC_ShiledArray[i2],EC_OwnningPlayer[i]))
                            {
                                //检查弹幕与护盾的距离 小于 护盾尺寸
                                //特效x,y 与 护盾单位 x y 的距离  <= size
                                if(Math.LocInRange(x,y,GetUnitX(EC_ShiledArray[i2]),GetUnitY(EC_ShiledArray[i2]) ,EC_ShiledSize[i2]  ))
                                {
                                    //BJDebugMsg("触碰到护盾了！");
                                    //弹幕处于护盾范围内 运行护盾触碰弹幕回调
                                    EC_TargetEffect = EC_EffectList[i]; //触发特效
                                    EC_EffectOwnningPlayer = EC_OwnningPlayer[i]; //触发特效所有者
                                    EC_TargetUnit = EC_ShiledArray[i2]; //触发护盾
                                    EC_EventID= 4; //事件ID
                                    TriggerExecute( EC_ShiledCallbackTrig[i2] ); //运行回调
                                }
                            }
                            i2 = i2 + 1;
                        }
                        //Print("CheakPoint");
                        //弹幕触碰部分
                        if(EC_DamageTrig[i] != null)
                        {
                            //Print("Damage");
                            if(!EC_Exit)
                            {
                                //选取单位做动作
                                EC_Hitable = true;
                                GroupEnumUnitsInRange(g,x,y,EC_Range[i],null);
                                u = FirstOfGroup(g);
                                while(u!=null)
                                {
                                    //触发单位
                                    EC_TargetUnit = u;
                                    //触发特效
                                    EC_TargetEffect = EC_EffectList[i];
                                    EC_EffectOwnningPlayer = EC_OwnningPlayer[i];
                                    EC_EventID= 0;
                                    TriggerExecute( EC_DamageTrig[i] ); 
                                    //如果结束本次冲锋，则直接结束
                                    if(EC_Exit|| (!EC_Hitable))
                                    {
                                        break;
                                    }
                                    GroupRemoveUnit(g, u);
                                    u = FirstOfGroup(g);
                                }
                                GroupClear(g);
                            }
                        }
                        //Print("CheakPoint4");
                        if(EC_Mode[i] != 0)
                        {
                            //Print("Disd++");
                            EC_DisD[i] = EC_DisD[i] + 31;
                        }
                        else
                        {
                            //Print("Disd++");
                            //距离退出模式
                            EC_DisD[i] = EC_DisD[i] + 31;
                        }
                        //Print("CheakPoint5");
                        if( (EC_Mode[i] !=0 && EC_Timed[i]>= EC_TimeMax[i]) 
                        || (EC_Mode[i] == 0 && EC_DisD[i]>= EC_Distance[i]))
                        {
                            EC_Exit = true;
                            //Print("Exit");
                        }
                    }
                }
            }
            //Print("=========== " +R2S(tempr));
            if(!EC_Exit)
            {
                 //移动特效 默认模式
                 if(EC_MoveMode[i]==0)
                 {
                    x = EXGetEffectX(EC_EffectList[i]) + CosBJ(EC_D[i] ) * tempr;
                    y = EXGetEffectY(EC_EffectList[i]) + SinBJ(EC_D[i] ) * tempr;
                 }
                 if(EC_PZ[i])
                 {
                    if(!X_IsTerrainWalkable(x,y))
                    {
                        if(EC_PZTrig[i] != null)
                        {
                            EC_TargetEffect = EC_EffectList[i];
                            EC_EventID= 3;
                            TriggerExecute( EC_PZTrig[i] );
                            if(EC_Exit){tempi = tempmax;}
                        }
                        else
                        {
                            //停止移动，运行结束触发器
                            EC_Exit = true;
                            tempi = tempmax;
                        }
                    }
                    else
                    {
                        EXSetEffectXY(EC_EffectList[i],x,y);
                    }
                 }
                 else
                 {
                     EXSetEffectXY(EC_EffectList[i],x,y);
                 }
            
            //特效高度设置
            if(EC_FlyMode[i] != 2)  // =2为自定义 即 不设置
            {
                //保持特效相对地面高度
                z = EC_GetPointZ(x,y);
                if(EC_FlyMode[i] == 0||EC_Height[i]==0)
                {
                    EXSetEffectZ(EC_EffectList[i],z+EC_Height[i]);
                }
                else if(EC_FlyMode[i] == 1)
                {
                    //抛物线
                    if(EC_DisD[i]>0)
                    {
                        ec_temp_t = EC_DisD[i] / EC_Distance[i];
                    }
                    else{
                        ec_temp_t = 1;
                    }
                    EXSetEffectZ(EC_EffectList[i],Math.Parabola(ec_temp_t,EC_Height[i],z)  );
                }
            }
            i2 = 0;
            //检查护盾
            
            while(i2<EC_ShiledIndex)
            {
                //友方护盾则不检查
                if(!IsUnitAlly(EC_ShiledArray[i2],EC_OwnningPlayer[i]))
                {
                    //检查弹幕与护盾的距离 小于 护盾尺寸
                    //特效x,y 与 护盾单位 x y 的距离  <= size
                    if(Math.LocInRange(x,y,GetUnitX(EC_ShiledArray[i2]),GetUnitY(EC_ShiledArray[i2]) ,EC_ShiledSize[i2]  ))
                    {
                        //弹幕处于护盾范围内 运行护盾触碰弹幕回调
                        EC_TargetEffect = EC_EffectList[i]; //触发特效
                        EC_EffectOwnningPlayer = EC_OwnningPlayer[i]; //触发特效所有者
                        EC_TargetUnit = EC_ShiledArray[i2]; //触发护盾
                        EC_EventID= 4; //事件ID
                        TriggerExecute( EC_ShiledCallbackTrig[i2] ); //运行回调
                    }
                }
                i2 = i2 + 1;
            }


            //弹幕触碰部分
            if(EC_DamageTrig[i] != null)
            {
                if(!EC_Exit)
                {
                    //选取单位做动作
                    GroupEnumUnitsInRange(g,x,y,EC_Range[i],null);
                    EC_Hitable =true;
                    u = FirstOfGroup(g);
                    while(u!=null)
                    {
                        //触发单位
                        EC_TargetUnit = u;
                        //触发特效
                        EC_TargetEffect = EC_EffectList[i];
                        EC_EffectOwnningPlayer = EC_OwnningPlayer[i];
                        EC_EventID= 0;
                        TriggerExecute( EC_DamageTrig[i] ); 
                        //如果结束本次冲锋，则直接结束
                        if(EC_Exit|| (!EC_Hitable))
                        {
                            break;
                        }
                        GroupRemoveUnit(g, u);
                        u = FirstOfGroup(g);
                    }
                    GroupClear(g);
                }
            }
            //时间退出模式
            if(EC_Exit){
                EC_Timed[i]  = EC_Timed[i] + EC_TimeMax[i];
                EC_DisD[i] = EC_DisD[i] + EC_Distance[i];
            }
            else if(EC_Mode[i] != 0)
            {
                EC_Timed[i]  = EC_Timed[i] + 0.02;
                EC_DisD[i] = EC_DisD[i] + tempr;
            }
            else
            {
                //距离退出模式
                EC_DisD[i] = EC_DisD[i] + tempr;
            }
            //刷新特效
            if(EC_Brush[i]){
                EC_BrushTime[i] = EC_BrushTime[i] + 0.02;
                //计算周期
                if(EC_BrushTime[i]>=EC_BrushDis[i])
                {
                    EC_BrushTime[i] = 0;
                    EC_EventID= 2;
                    EC_TargetEffect = EC_EffectList[i];
                    if(EC_BrushTrig[i] != null)
                    {
                        TriggerExecute( EC_BrushTrig[i] );
                    }
                }
            }
            }
            index = EC_Index - 1;
            //检查冲锋是否需要结束
            if( (EC_Mode[i] !=0 && EC_Timed[i]>= EC_TimeMax[i]) || (EC_Mode[i] == 0 && EC_DisD[i]>= EC_Distance[i]) || EC_Exit )
            {
                //冲锋结束
                EC_KeepALive = false;
                //检查是否需要调用指定结束触发器
                if(EC_FinishTrig[i] != null)
                {
                    EC_TargetUnit = null;
                    EC_EffectOwnningPlayer = EC_OwnningPlayer[i];
                    EC_TargetEffect = EC_EffectList[i];
                    //清除ID接口
                    EC_EventID= 1;
                    TriggerExecute( EC_FinishTrig[i] );
                    FlushChildHashtable(EC_HT,GetHandleId(EC_TargetEffect));
                    index = EC_Index - 1;
                }
                else
                {
                    DestroyEffect(EC_EffectList[i]);
                }
                
                //是否保持特效存在
                if(!EC_KeepALive)
                {
                    //当前数据不在顶部
                    //清除特效数据
                    if(i != index)
                    {
                        //移动变量位置
                        EC_D[i] = EC_D[index];
                        EC_Height[i] = EC_Height[index];
                        EC_DamageTrig[i] = EC_DamageTrig[index];
                        EC_FinishTrig[i] = EC_FinishTrig[index];
                        EC_Mode[i] = EC_Mode[index];
                        EC_Distance[i] = EC_Distance[index];
                        EC_DisD[i] = EC_DisD[index];
                        EC_Timed[i] = EC_Timed[index];
                        EC_TimeMax[i] = EC_TimeMax[index];
                        EC_Speed[i] = EC_Speed[index];
                        EC_OwnningPlayer[i] = EC_OwnningPlayer[index];
                        EC_EffectList[i] = EC_EffectList[index];
                        EC_BrushTrig[i] = EC_BrushTrig[index];
                        EC_Brush[i] = EC_Brush[index];
                        EC_BrushTime[i] = EC_BrushTime[index];
                        EC_BrushDis[i] = EC_BrushDis[index];
                        EC_PZ[i] = EC_PZ[index];
                        EC_PZTrig[i] = EC_PZTrig[index];
                        EC_FlyMode[i] = EC_FlyMode[index];
                        EC_steeps[i] = EC_steeps[index];
                        EC_steepsMax[i] = EC_steepsMax[index];
                        EC_MoveMode[i] = EC_MoveMode[index];
                        //顶部计数-1
                        SaveInteger(EC_HT,GetHandleId(EC_EffectList[i]),1000,i);
                        EC_Index = EC_Index - 1;
                        // index = EC_Index - 1;
                        if(index > 0)
                        {
                            i = i - 1;
                        }
                    }
                    else
                    {
                        //在顶部只需要使顶部计数-1
                        //顶 - 1
                        EC_Index = EC_Index - 1;
                        // index = EC_Index - 1;
                    }


                }

            }
            
            //
            i = i + 1;
        }
        }
        EC_Running = false;
        u = null;

    }
    public function EC_EffectChargeDistance(effect e,real h,real r,real s,real d,player p,trigger dt,trigger ft,real dis)
    {
        integer index = EC_Index;
        //
        EC_DisD[index] = 0;
        EC_Distance[index] = dis;
        EC_EffectList[index] = e;
        EC_Height[index] = h;
        EC_Range[index] = r;
        EC_Speed[index] = s;
        EC_D[index] = d;
        EC_DamageTrig[index] = dt;
        EC_FinishTrig[index] = ft;
        EC_OwnningPlayer[index] =p;
        EC_Mode[index] = 0;
        EC_Timed[index]=0;
        EC_TimeMax[index] =0;
        EC_PZ[index] = false;
        EC_Brush[index] = false;
        EC_BrushTrig[index] = null;
        EC_BrushTime[index] = 0;
        EC_PZTrig[index] = null;
        EC_FlyMode[index] = 0;
        EC_steepsMax[index] = 0;
        EC_steeps[index] = 0;
        EC_MoveMode[index] = 0;
        //
        EC_Index = EC_Index + 1; 
    }
    //修正插入
    public function EC_EffectChargeDistance2(effect e,real h,real r,real s,real d,player p,trigger dt,real dis,boolean b)
    {
        integer index = EC_Index;
        // timer t;
        // integer hd;
        // //
        // if(!EC_Running){
        EC_DisD[index] = 0;
        EC_Distance[index] = dis;
        EC_EffectList[index] = e;
        EC_Height[index] = h;
        EC_Range[index] = r;
        EC_Speed[index] = s;
        EC_D[index] = d;
        EC_DamageTrig[index] = dt;
        EC_FinishTrig[index] = dt;
        EC_PZTrig[index] = dt;
        EC_OwnningPlayer[index] =p;
        EC_Mode[index] = 0;
        EC_Timed[index]=0;
        EC_TimeMax[index] =0;
        EC_PZ[index] = b;
        EC_Brush[index] = false;
        EC_BrushTrig[index] = null;
        EC_BrushTime[index] = 0;
        // EC_PZTrig[index] = null;
        EC_FlyMode[index] = 0;
        EC_steepsMax[index] = 0;
        EC_steeps[index] = 0;
        EC_MoveMode[index] = 0;
        //
        EC_Index = EC_Index + 1; 
        // }else{
        //     t = CreateTimer();
        //     hd= GetHandleId(t);
        //     SaveEffectHandle(StarBaseHT,hd,0,e);
        //     SaveReal(StarBaseHT,hd,1,h);
        //     SaveReal(StarBaseHT,hd,2,r);
        //     SaveReal(StarBaseHT,hd,3,s);
        //     SaveReal(StarBaseHT,hd,4,d);
        //     SavePlayerHandle(StarBaseHT,hd,5,p);
        //     SaveTriggerHandle(StarBaseHT,hd,6,dt);
        //     SaveReal(StarBaseHT,hd,7,dis);
        //     SaveBoolean(StarBaseHT,hd,8,b);
        //     t = null;
        // }
    }
    public function EC_EffectChargeDistance3(effect e,real h,real r,real s,real d,player p,trigger dt,real dis,boolean b,code handlerFunc)
    {
        integer index = EC_Index;
        //
        EC_DisD[index] = 0;
        EC_Distance[index] = dis;
        EC_EffectList[index] = e;
        EC_Height[index] = h;
        EC_Range[index] = r;
        EC_Speed[index] = s;
        EC_D[index] = d;
        EC_DamageTrig[index] = dt;
        EC_FinishTrig[index] = dt;
        EC_PZTrig[index] = dt;
        EC_OwnningPlayer[index] =p;
        EC_Mode[index] = 0;
        EC_Timed[index]=0;
        EC_TimeMax[index] =0;
        EC_PZ[index] = b;
        EC_Brush[index] = false;
        EC_BrushTrig[index] = null;
        EC_BrushTime[index] = 0;
        EC_PZTrig[index] = null;
        EC_FlyMode[index] = 0;
        EC_steepsMax[index] = 0;
        EC_steeps[index] = 0;
        EC_MoveMode[index] = 0;
        //
        EC_Index = EC_Index + 1; 
    }
    public function EC_EffectChargeTime(effect e,real h,real r,real s,real d,player p,trigger dt,trigger ft,real time)
    {
        integer index = EC_Index;
        //
        EC_DisD[index] = 0;
        EC_Distance[index] = 999999;
        EC_EffectList[index] = e;
        EC_Height[index] = h;
        EC_Range[index] = r;
        EC_Speed[index] = s;
        EC_D[index] = d;
        EC_DamageTrig[index] = dt;
        EC_FinishTrig[index] = ft;
        EC_OwnningPlayer[index] =p;
        EC_Mode[index] = 1;
        EC_Timed[index] = 0;
        EC_TimeMax[index] = time;
        EC_Brush[index] = false;
        EC_PZ[index] = false;
        EC_PZTrig[index] = null;
        EC_BrushTrig[index] = null;
        EC_BrushTime[index] = 0;
        EC_FlyMode[index] = 0;
        EC_steepsMax[index] = 0;
        EC_steeps[index] = 0;
        EC_MoveMode[index] = 0;
        //
        EC_Index = EC_Index + 1; 
    }
    public function EC_EffectChargeTime2(effect e,real h,real r,real s,real d,player p,trigger at,real time,boolean pz,real bruti,boolean brush)
    {
        integer index = EC_Index;
        //
        EC_DisD[index] = 0;
        EC_Distance[index] = 999999;
        EC_EffectList[index] = e;
        EC_Height[index] = h;
        EC_Range[index] = r;
        EC_Speed[index] = s;
        EC_D[index] = d;
        EC_DamageTrig[index] = at;
        EC_FinishTrig[index] = at;
        EC_PZTrig[index] = at;
        EC_BrushTrig[index] = at;
        EC_OwnningPlayer[index] =p;
        //时间模式
        EC_Mode[index] = 1;
        EC_Timed[index] = 0;
        EC_TimeMax[index] = time;
        //是否启用刷新
        EC_Brush[index] = brush;
        //是否启用碰撞
        EC_PZ[index] = pz;
        //刷新
        EC_BrushTime[index] = 0;
        EC_BrushDis[index] = bruti;
        //飞行模式
        EC_FlyMode[index] = 0;
        //移动模式
        EC_MoveMode[index] = 0;
        //抛物线
        EC_steepsMax[index] = 0;
        EC_steeps[index] = 0;
        //
        EC_Index = EC_Index + 1; 
    }
    //检查坐标在护盾的范围内 如果非null 则表示在护盾范围内
    public function EC_IsInShiled(real x,real y,player p)->unit
    {
        integer i2 = 0;
        //检查护盾
        while(i2<EC_ShiledIndex)
        {
            //友方护盾则不检查
            if(!IsUnitAlly(EC_ShiledArray[i2],p))
            {
                if(X_GDBC(x,y,GetUnitX(EC_ShiledArray[i2]),GetUnitY(EC_ShiledArray[i2]) ) <= EC_ShiledSize[i2]  )
                {
                    //返回持有这个护盾的单位
                    return EC_ShiledArray[i2];
                }
            }
            i2 = i2 + 1;
        }
        return null;
    }
    //正在冲锋的特效
    public function EC_GetChargingEffect()->effect
    {
        return EC_TargetEffect;
    }
    //设置特效飞行模式
    public function EC_SetFlyMode(integer effid ,integer modeid ,real maxHeight)
    {
        if(modeid>1)
        {
            modeid = 0;
        }
        EC_FlyMode[effid] = modeid;
        EC_Height[effid] = maxHeight;
        if(EC_Mode[effid]==0)
        {
            EC_steepsMax[effid] = R2I(EC_Distance[effid]/EC_Speed[effid]);
            //BJDebugMsg("Max=" + I2S(EC_steepsMax[effid]));
        }
        else
        {
            EC_steepsMax[effid] = R2I(EC_TimeMax[effid]/0.02);   
        }
        EC_steeps[effid] = 0;
    }
    //被冲锋到的单位
    public function EC_GetChargedUnit()->unit
    {
        return EC_TargetUnit;
    }
    //获取被触碰的护盾  仅在护盾触碰回调事件中可用
    public function EC_GetShiledUnit()->unit
    {
        if(EC_EventID == 4)
        {
            return EC_TargetUnit;
        }
        else
        {
            return null;
        }
    }
    //完成冲锋的特效
    public function EC_GetFinishingEffect()->effect
    {
        return EC_TargetEffect;
    }
    //是否保护特效 为true则需要手动清除特效
    public function EC_KeepEffectALive(boolean b)
    {
        EC_KeepALive = b;
    }
    //检查是否因为护盾事件结束
    public function EC_IsFinishByShiled()->boolean
    {
        return EC_ShiledExit;
    }
    //获得特效在冲锋库中的ID
    public function EC_GetEffectId()->integer
    {
        return i;
    }
    //获取正在冲锋的特效所有者
    public function EC_GetEffectOwnningPlayer()->player
    {
        return EC_EffectOwnningPlayer;
    }
    //重设结束触发器
    public function EC_ReSetEffectFinishTrigger(integer effid,trigger t)
    {
        EC_FinishTrig[effid] = t;
    }
    //重设刷新触发器
    public function EC_ReSetEffectBrushTrigger(integer effid,trigger t)
    {
        EC_BrushTrig[effid] = t;
    }
    //重设碰撞触发器
    public function EC_ReSetEffectDamageTrigger(integer effid,trigger t)
    {
        EC_DamageTrig[effid] = t;
    }
    //重设撞墙触发器
    public function EC_ReSetEffectPZTrigger(integer effid,trigger t,boolean b)
    {
        EC_PZTrig[effid] = t;
        EC_PZ[effid] = b;
    }
    //重设特效速度
    public function EC_ReSetEffectSpeed(integer effid,real s)
    {
        EC_Speed[effid] = s;
    }
    //重设特效高度
    public function EC_ReSetEffectHeight(integer effid,real s)
    {
        EC_Height[effid] = s;
    }
    //重设特效位移方向
    public function EC_ReSetEffectAngle(integer effid,real s)
    {
        EC_D[effid] = s;
    }
    //重设特效碰撞体积
    public function EC_ReSetEffectRange(integer effid,real s)
    {
        EC_Range[effid] = s;
    }
    //重设特效行程
    public function EC_ReSetEffectDistanced(integer effid,real s)
    {
        EC_DisD[effid] = s;
    }
    //重设特效总行程
    public function EC_ReSetEffectMaxDistance(integer effid,real s)
    {
        EC_Distance[effid] = s;
    }
    //重设特效位移时间
    public function EC_ReSetEffectTimed(integer effid,real s)
    {
        EC_Timed[effid] = s;
    }
    //重设特效位移总时间
    public function EC_ReSetEffectMaxTime(integer effid,real s)
    {
        EC_TimeMax[effid] = s;
    }
    //获取特效的碰撞体积
    public function EC_GetEffectRange(integer effid)->real
    {
        return EC_Range[effid];
    }
    //重设特效
    public function EC_ReSetEffect(integer effid,effect e)
    {
        EC_EffectList[effid] = e;
    }
    //获取特效的恒定高度
    public function EC_GetEffectHeight(integer effid)->real
    {
        return EC_Height[effid];
    }
    //获取特效的移动速度
    public function EC_GetEffectSpeed(integer effid)->real
    {
        return EC_Speed[effid];
    }
    //获取特效的移动方向
    public function EC_GetEffectAngle(integer effid)->real
    {   
        return EC_D[effid];
    }
    //获取特效的行程
    public function EC_GetEffectDisd(integer effid)->real
    {
        return EC_DisD[effid];
    }
    //获取特效的总行程
    public function EC_GetEffectMaxDis(integer effid)->real
    {
        return EC_Distance[effid];
    }
    //获取特效的总时间
    public function EC_GetEffectMaxTime(integer effid)->real
    {
        return EC_TimeMax[effid];
    }
    //获取特效的位移时间
    public function EC_GetEffectTimed(integer effid)->real
    {
        return EC_Timed[effid];
    }
    //获取特效在系统中的ID ， 需要判断非 -1 
    public function EC_GetEffectIdOnSystem(effect e)->integer
    {
        if(HaveSavedInteger(EC_HT,GetHandleId(e),1000))
        {
            return LoadInteger(EC_HT,GetHandleId(e),1000);
        }
        return -1;
    }

    //设置特效启用刷新
    public function EC_SetBrush(integer effid,real dis , boolean b)
    {
        EC_Brush[effid] = b;
        EC_BrushDis[effid] = dis;
    }
    //设置特效移动模式
    public function EC_SetMoveMode(integer effid,integer modeid)
    {
        if(modeid!=0)
        {
            EC_Brush[effid] = true;
            EC_BrushDis[effid] = 0.02;
        }
        EC_MoveMode[effid] = modeid;
    }
    //获取特效冲锋事件ID
    public function EC_GetEVentID()->integer
    {
        return EC_EventID;
    }
    //UI封装 - 转换 特效冲锋事件ID 为 整数
    public function EC_I2E(integer i)->integer
    {
        return i;
    }
    //UI封装 -空触发器
    public function EC_NilTrig()->trigger
    {
        return null;
    }
    //获取顶部计数
    public function EC_GetIndex()->integer
    {
        return EC_Index - 1;
    }
    //设置一个护盾
    public function EC_SetShiled(unit s,real size , trigger trig)
    {
        EC_ShiledArray[EC_ShiledIndex] = s;
        EC_ShiledSize[EC_ShiledIndex] = size;
        EC_ShiledCallbackTrig[EC_ShiledIndex] = trig;
        EC_ShiledIndex = EC_ShiledIndex + 1; 
        //Print(GetUnitName(s));
    }
    //移除一个护盾
    public function EC_RemoveShiled(unit u)
    {
        integer i = 0;
        integer index =EC_ShiledIndex-1;
        //遍历所有护盾单位 ，找到指定单位
        while(i<EC_ShiledIndex)
        {
            if(EC_ShiledArray[i] == u)
            {
                //移除指定的护盾
                EC_ShiledArray[i] = EC_ShiledArray[index];
                EC_ShiledSize[i] = EC_ShiledSize[index];
                EC_ShiledCallbackTrig[i] = EC_ShiledCallbackTrig[index];
                EC_ShiledIndex = EC_ShiledIndex - 1;
                break;
            }
            i = i + 1 ;
        }
    }
    //结束本次冲锋
    public function EC_FinishCharge()
    {
        EC_Exit = true;
        if(EC_EventID == 4)
        {
            EC_ShiledExit = true;
        }
    }
    
    //设置冲锋由于护盾碰撞而结束
    public function EC_FinishChargeByShiled()
    {
        EC_Exit = true;
        EC_ShiledExit = true;
    }
    //使弹幕反弹
    public function EC_SetEffectRebound(integer effid)
    {
        real x = EXGetEffectX(EC_EffectList[effid]);
        real y = EXGetEffectY(EC_EffectList[effid]);
        real d;
        real a,b,d2;
        if(EC_EventID==0||EC_EventID==4)//碰撞单位/碰撞护盾反弹
        {
            EC_Hitable = false;
            a = GetUnitX(EC_TargetUnit);
            b = GetUnitY(EC_TargetUnit);
            // d2 = Math.GAFC(a,b,x,y);
            d2 = Math.GAFC(x,y,a,b);
            d = 180 - EC_GetEffectAngle(effid) - (d2+d2);
            // if(! ( (d2>45&& d2 <135) ||(d2>-135&& d2 <-45)) ){
            //     d = 180 - EC_GetEffectAngle(effid);
            // }
        }
        else//墙体反弹
        {
            d = 360 - EC_GetEffectAngle(effid);
            a= x + CosBJ(d) * 31;
            b= y + SinBJ(d) * 31;
            if(!(X_IsTerrainWalkable(a,b))){d = 180 - EC_GetEffectAngle(effid);}
        }
        EC_ReSetEffectAngle(effid,d);
        EXEffectMatReset( EC_EffectList[effid]);
        EXEffectMatRotateZ( EC_EffectList[effid], d );
    }
    //新建闪电效果
    public function EC_AddLighting(string s , boolean bo,real x, real y,real a, real b )->lightning
    {
        return AddLightning(s, bo,x,y,a,b);
    }
    //获取单位的range范围内的随机点
    public function GetRandomLocNearUnit(unit u , real range)->location
    {
        real sd = GetRandomReal(0,range);
        real d = GetRandomReal(0,360);
        real x = GetUnitX(u);
        real y = GetUnitY(u);
        return Location(x+CosBJ(d)*sd , y + SinBJ(d) * sd);
    }
    //获取与单位在min~max距离之间的随机点
    public function GetRandomLocBetween(unit u , real min,real max)->location
    {
        real sd = GetRandomReal(min,max);
        real d = GetRandomReal(0,360);
        real x = GetUnitX(u);
        real y = GetUnitY(u);
        return Location(x+CosBJ(d)*sd , y + SinBJ(d) * sd);
    }
    //命令特效e 开始冲锋， 保持相对地面高度为 h 碰撞范围 r 冲锋速度 s 伤害来源单位为 u 伤害值为 damage 冲锋距离 dis 检查碰撞 b 是否穿透单位 b2
    public function EC_Charger(effect e,real h,real r,real s,real d,unit u,real damage,real dis,boolean b,boolean b2)
    {

        integer index = EC_Index;

        // Print("单位地址->"+I2S(GetHandleId(u)));
        // Print("特效地址->"+I2S(GetHandleId(e)));
        // Print("速度->"+R2S(s));
        if(e==null)
        {
            return;
        }
        //基本数据
        EC_DisD[index] = 0;
        EC_Distance[index] = dis;
        EC_EffectList[index] = e;
        EC_Height[index] = h;
        EC_Range[index] = r;
        EC_Speed[index] = s;
        EC_D[index] = d;
        EC_DamageTrig[index] = EC_TRIG;
        EC_FinishTrig[index] = EC_TRIG;
        EC_PZTrig[index] = EC_TRIG;
        EC_BrushTrig[index] = EC_TRIG;
        EC_PZTrig[index] = EC_TRIG;
        EC_OwnningPlayer[index] =GetOwningPlayer(u);
        EC_Mode[index] = 0;
        EC_Timed[index]=0;
        EC_TimeMax[index] =0;
        EC_PZ[index] = b;
        EC_Brush[index] = false;
        EC_BrushTime[index] = 1;
        EC_FlyMode[index] = 0;
        EC_steepsMax[index] = 0;
        EC_steeps[index] = 0;
        EC_MoveMode[index] = 0;
        EC_Index = EC_Index + 1; 
        //保存附加数据  --伤害来源u 伤害值damage
        //--伤害值
        SaveReal(EC_HT,GetHandleId(e),EC_K_Damage,damage);
        //--伤害来源
        SaveUnitHandle(EC_HT,GetHandleId(e),EC_K_Unit,u);
        //--保护组
        SaveGroupHandle(EC_HT,GetHandleId(e),EC_K_Group,CreateGroup());
        //--是否穿透
        SaveBoolean(EC_HT,GetHandleId(e),EC_K_Penetrate,b2);
        //Print("特效->"+I2S(GetHandleId(e)));
    }
    private function EC_TRIGEVT()
    {
        effect e = EC_TargetEffect;
        player p = EC_EffectOwnningPlayer;
        integer id = EC_EventID;
        real a,b;
        unit u;
        real damage;
        string str;
        boolean IsPenetrate = LoadBoolean(EC_HT,GetHandleId(e),EC_K_Penetrate);
        u = LoadUnitHandle(EC_HT,GetHandleId(e),EC_K_Unit);
        damage = LoadReal(EC_HT,GetHandleId(e),EC_K_Damage);
        EC_group = LoadGroupHandle(EC_HT,GetHandleId(e),EC_K_Group);
        //Print("特效->"+I2S(GetHandleId(e)));
        //固定流程：对被冲锋的敌人造成伤害一次
        if(id == 0)
        {
            //碰撞
            //是敌人
            if (IsUnitEnemy(EC_GetChargedUnit(),EC_GetEffectOwnningPlayer()) )
            {
                //非死亡单位
                if(IsUnitAliveBJ(EC_GetChargedUnit()))
                {
                    //不在单位组中
                    if(!IsUnitInGroup(EC_GetChargedUnit(),EC_group))
                    {
                        //造成伤害,添加到单位组
                        UnitDamageTarget( u, EC_GetChargedUnit(), damage, true, false, ATTACK_TYPE_MELEE, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS );
                        GroupAddUnit( EC_group, EC_GetChargedUnit() );
                        if(!IsPenetrate)
                        {
                            //不穿透就停止冲锋
                            EC_FinishCharge();
                        }
                    }
                }
            }
        }
        else if(id == 1)
        {
            //结束 
            //清除单位组，特效，哈希表数据
            FlushChildHashtable(EC_HT, GetHandleId(e) );
            DestroyGroup( EC_group );
            DestroyEffect( e );
            
        }
        else if(id == 2)
        {
            if(HaveSavedString(EC_HT,GetHandleId(e),EC_K_Brush))
            {
                a = EXGetEffectX(e);
                b = EXGetEffectY(e);
                EC_2_ID = EC_GetEffectIdOnSystem(e);
                if(EC_2_ID != -1)
                {
                    str = LoadStr(EC_HT,GetHandleId(e),EC_K_Brush);
                    EC_DestroyEffect( e );
                    FlushChildHashtable(EC_HT, GetHandleId(e) );
                    e = AddSpecialEffect(str,a,b);
                    //--伤害值
                    SaveReal(EC_HT,GetHandleId(e),EC_K_Damage,damage);
                    //--伤害来源
                    SaveUnitHandle(EC_HT,GetHandleId(e),EC_K_Unit,u);
                    //--保护组
                    SaveGroupHandle(EC_HT,GetHandleId(e),EC_K_Group,EC_group);
                    //--是否穿透
                    SaveBoolean(EC_HT,GetHandleId(e),EC_K_Penetrate,IsPenetrate);
                    SaveStr(EC_HT,GetHandleId(e),EC_K_Brush,str);
                    EC_ReSetEffect(EC_2_ID,e);
                }
            }
        }
        else if(id == 3)
        {
            //撞墙
            EC_SetEffectRebound(EC_GetEffectId());
        }
        e = null;
        p = null;
        u = null;
        EC_group = null;
    }
    //固定流程特效
    public{
         trigger EC_TRIG ;
         hashtable EC_HT ;
         integer EC_K_Damage = StringHash("Damage");
         integer EC_K_Unit = StringHash("Unit");
         integer EC_K_Group = StringHash("Group");
         integer EC_K_Penetrate = StringHash("Penetrate");
         integer EC_K_Brush = StringHash("Brush");
         integer EC_K_DT = <?=StringHash("DamageType")?>;
         integer EC_K_WT = <?=StringHash("WeaponType")?>;
         integer EC_K_AT = <?=StringHash("AttackType")?>;
         integer EC_2_ID = 0;
         group EC_group;
    }
    private function EC_TriggerInit()
    {
        EC_TRIG = CreateTrigger();
        TriggerAddAction(EC_TRIG, function EC_TRIGEVT);
    }
    public{
        real EC_CB_X=0;
        real EC_CB_Y=0;
        integer EC_CB_ID = 0;
        real EC_CB_angle=0;
        unit EC_CB_Unit= null;
        unit EC_CB_TargetUnit= null;
        effect EC_CB_Effect = null;
    }
    private function EC_SE1()
    {
        integer i = 0;
        integer lpi=0;
        integer id = 0;
        real x,y,a,b,x1,x2,y1,y2;
        real distance,speed,d,estimateTime,s,dis2;
        unit u ,tu;
        trigger trig;
        timer t = GetExpiredTimer();
        //读取数据
        a = LoadReal(EC_HT,GetHandleId(t),1);
        b = LoadReal(EC_HT,GetHandleId(t),2);
        speed = LoadReal(EC_HT,GetHandleId(t),3);
        estimateTime = LoadReal(EC_HT,GetHandleId(t),4);
        u = LoadUnitHandle(EC_HT,GetHandleId(t),5);
        tu = LoadUnitHandle(EC_HT,GetHandleId(t),6);
        trig = LoadTriggerHandle(EC_HT,GetHandleId(t),7);
        id = LoadInteger(EC_HT,GetHandleId(t),8);
        //-------------
        x1 = GetUnitX(u);y1 = GetUnitY(u);
        x = GetUnitX(tu);y = GetUnitY(tu);
        d = X_GAFC(a,b,x,y);distance = X_GDBC(a,b,x,y);
        s = distance * estimateTime;
        x2 = x + CosBJ(d) * s;y2 = y + SinBJ(d) * s;
        i = R2I(estimateTime) / 100;
        i += 3;
        while(i>lpi)
        {
            lpi+=1;
            dis2 = Math.GDBC(x1,y1,x2,y2);
            estimateTime = (dis2/speed)*100;
            s = distance * estimateTime;
            x2 = x + CosBJ(d) * s;y2 = y + SinBJ(d) * s;
        }
        //回调
        EC_CB_X = x2;
        EC_CB_Y = y2;
        EC_CB_angle = X_GAFC(x1,y1,x2,y2);
        EC_CB_Unit = u;
        EC_CB_TargetUnit = tu;
        EC_CB_ID= id;
        if(TriggerEvaluate(trig)){
            TriggerExecute(trig);
        }
        //清理
        FlushChildHashtable(EC_HT,GetHandleId(t));
        DestroyTimer(t);
        //
        t = null;
        u = null;
        tu = null;
        trig = null;

    }
    //贝塞尔 获取z轴 t, 最高, 起点, 终点 
    public function EC_Get2thBesselZ (real a, real height,real startz,real finz )-> real
    {
        return (a * a * startz/*起点高度*/ + 2 * a * (1 - a) * height + (1 - a) * (1 - a) * finz/*终点高度*/);
    }
    //平滑追踪角度(起点x,y 终点dx,dy)
    public function EC_GetTrackAngle_Effect(real x, real y,real dx,real dy)->real
    {
        dx -= x;
        dy -= y;
        return bj_RADTODEG * Atan2(dy,dx);
    }
    //创建特效->${特效路径},${x},${y},${z},${朝向},${尺寸},${动画速度},${持续时间}
    public function EC_CreateEffect(string path,real x,real y,real z,real fac,real size,real s,real time)->effect{
        bj_lastCreatedEffect = AddSpecialEffect(path,x,y);
        EXSetEffectSize(bj_lastCreatedEffect,size);
        EXSetEffectZ(bj_lastCreatedEffect,EC_GetPointZ(x,y)+z);
        if(time>=0){
            YDWETimerDestroyEffect(time,bj_lastCreatedEffect);
        }
        else if(time!=-1){ 
            DestroyEffect(bj_lastCreatedEffect);
        }
        EXEffectMatRotateZ(bj_lastCreatedEffect,fac);
        EXSetEffectSpeed(bj_lastCreatedEffect,s);
        return bj_lastCreatedEffect;
    }
    public real EC_CB_degree = 0;
    private function EC_SE2()
    {
        integer i = 0;
        integer lpi=0;
        integer id = 0;
        real x,y,a,b,x1,x2,y1,y2;
        real dis,speed,d,bbb,s,dis2;
        effect e;
        unit tu;
        trigger trig;
        timer t = GetExpiredTimer();
        //读取数据
        a = LoadReal(EC_HT,GetHandleId(t),1);
        b = LoadReal(EC_HT,GetHandleId(t),2);
        speed = LoadReal(EC_HT,GetHandleId(t),3);
        bbb = LoadReal(EC_HT,GetHandleId(t),4);
        e = LoadEffectHandle(EC_HT,GetHandleId(t),5);
        tu = LoadUnitHandle(EC_HT,GetHandleId(t),6);
        trig = LoadTriggerHandle(EC_HT,GetHandleId(t),7);
        id = LoadInteger(EC_HT,GetHandleId(t),8);
        if(e!=null)
        {
            //-------------
            x1 = EXGetEffectX(e);
            y1 = EXGetEffectY(e);
            x = GetUnitX(tu);
            y = GetUnitY(tu);
            d = Math.GAFC(a,b,x,y);
            dis = Math.GDBC(a,b,x,y);
            s = dis * bbb;
            x2 = x + CosBJ(d) * s;
            y2 = y + SinBJ(d) * s;
            i = R2I(bbb) / 100 + 3;
            while(i>lpi)
            {
                lpi+=1;
                s = dis * ((Math.GDBC(x1,y1,x2,y2)/speed)*100);
                x2 = x + CosBJ(d) * s;
                y2 = y + SinBJ(d) * s;
            }
            //回调
            EC_CB_angle = Math.GAFC(x1,y1,x2,y2);
            //EC_CB_degree = EC_GetTrackAngle_Effect(x1,y1,x2,y2);
            EC_CB_Effect = e;
            EC_CB_TargetUnit = tu;
            EC_CB_ID= id;
            if(TriggerEvaluate(trig)){
                TriggerExecute(trig);
            }
        }
        //清理
        FlushChildHashtable(EC_HT,GetHandleId(t));
        DestroyTimer(t);
        //
        t = null;
        e = null;
        tu = null;
        trig = null;

    }
    //xy为原点 扇形方向为d 范围为j 半径为r
    public function EC_GetGroup(real x,real y,real j,real d,real r) -> group
    {
        group g=CreateGroup();
        unit u;
        real x1;
        real y1;
        real d1;
        real a1,a2;
        bj_lastCreatedGroup=CreateGroup();
        GroupEnumUnitsInRange(g,x,y,r,null);
        u=FirstOfGroup(g);
        if (d<0)
        {
            d=360+d;
        }else if(d>360){
            d = d - 360;
        }
        a1 = d-j/2;
        a2 = d+j/2;
        while(u!=null)
        {
            x1=GetUnitX(u);
            y1=GetUnitY(u);
            d1=Atan2(y1-y,x1-x)*180/bj_PI;
            if (d1<0)
            {
                d1=360+d1;
            }
            else if(d1>360){
                d1 = d1 - 360;
            }
            if (d1>a1 && d1<a2)
            {
                GroupAddUnit(bj_lastCreatedGroup,u);
            }
            GroupRemoveUnit(g,u);
            u=FirstOfGroup(g);
        }
        DestroyGroup(g);
        g = null;
        u = null;
        return bj_lastCreatedGroup;
    }
    /*弹幕系统 - 弹道计算 - 计算从 单位u的位置出发的速度 为 speed 的子弹 命中匀速直线运动的目标tu需要的发射角度
    在获取计算结果后调用回调触发器callBack并携带事件ID : id
    参数：子弹飞行速度
    参数：起始单位
    参数：目标单位
    参数：瞄准结束回调触发器
    参数：事件ID
    */
    public function EC_ShootReady(unit u,real speed,unit tu,trigger callBack,integer id)
    {
        real x,y,a,b,x1,x2;
        real dis,d,bbb;
        timer t = CreateTimer();
        x = GetUnitX(u);
        y = GetUnitY(u);
        a = GetUnitX(tu);
        b = GetUnitY(tu);
        dis = X_GDBC(x,y,a,b);
        bbb = (dis / speed) * 100;
        //保存单位当前位置
        SaveReal(EC_HT,GetHandleId(t),1,a);
        SaveReal(EC_HT,GetHandleId(t),2,b);
        SaveReal(EC_HT,GetHandleId(t),3,speed);
        SaveReal(EC_HT,GetHandleId(t),4,bbb);
        SaveUnitHandle(EC_HT,GetHandleId(t),5,u);
        SaveUnitHandle(EC_HT,GetHandleId(t),6,tu);
        SaveTriggerHandle(EC_HT,GetHandleId(t),7,callBack);
        SaveInteger(EC_HT,GetHandleId(t),8,id);
        //运行计算
        TimerStart(t,0.01,false,function EC_SE1);
        t = null;
    }
    //弹道计算回调-StarWE版本
    private function EC_SE1EX()
    {
        integer i = 0;integer lpi=0;integer id = 0;
        real x,y,a,b,x1,x2,y1,y2;
        real dis,speed,d,bbb,s,dis2;unit u ,tu;trigger trig;timer t = GetExpiredTimer();
        //读取数据
        a = LoadReal(EC_HT,GetHandleId(t),1);
        b = LoadReal(EC_HT,GetHandleId(t),2);
        speed = LoadReal(EC_HT,GetHandleId(t),3);
        bbb = LoadReal(EC_HT,GetHandleId(t),4);
        u = LoadUnitHandle(EC_HT,GetHandleId(t),5);
        tu = LoadUnitHandle(EC_HT,GetHandleId(t),6);
        trig = LoadTriggerHandle(EC_HT,GetHandleId(t),7);
        //-------------
        x1 = GetUnitX(u);y1 = GetUnitY(u);
        x = GetUnitX(tu);y = GetUnitY(tu);
        d = X_GAFC(a,b,x,y);dis = X_GDBC(a,b,x,y);
        // printsr("当前速度:",dis*100);
        //初步计算预瞄点
        s = dis * bbb;
        //精度控制
        i = R2I(bbb) / 100 + 4;
        //重算——推演出着弹点
        while(i>lpi){lpi+=1;
            x2 = x + CosBJ(d) * s;
            y2 = y + SinBJ(d) * s;
            dis2 = Math.GDBC(x1,y1,x2,y2);
            bbb = (dis2/speed)*100;
            s = dis * bbb;
        }
        //预计命中位置
        EC_CB_X = x2;
        EC_CB_Y = y2;
        //回调
        EC_CB_angle = X_GAFC(x1,y1,x2,y2);EC_CB_Unit = u;EC_CB_TargetUnit = tu;
        TriggerEvaluate(trig);
        // if(TriggerEvaluate(trig)){}
        //清理
        FlushChildHashtable(EC_HT,GetHandleId(t));DestroyTimer(t);DestroyTrigger(trig);
        //
        t = null;u = null;tu = null;trig = null;

    }
    //弹道计算-StarWE版本
    public function EC_ShootReadyEx(unit u,real speed,unit tu,trigger trig)
    {
        real x,y,a,b,x1,x2;
        real dis,d,bbb;
        timer t;
        if(!(speed>0))
        {
            return;
        }
        t = CreateTimer();
        x = GetUnitX(u);
        y = GetUnitY(u);
        a = GetUnitX(tu);
        b = GetUnitY(tu);
        dis = X_GDBC(x,y,a,b);
        bbb = (dis / speed) * 100;
        //保存单位当前位置
        SaveReal(EC_HT,GetHandleId(t),1,a);
        SaveReal(EC_HT,GetHandleId(t),2,b);
        SaveReal(EC_HT,GetHandleId(t),3,speed);
        SaveReal(EC_HT,GetHandleId(t),4,bbb);
        SaveUnitHandle(EC_HT,GetHandleId(t),5,u);
        SaveUnitHandle(EC_HT,GetHandleId(t),6,tu);
        SaveTriggerHandle(EC_HT,GetHandleId(t),7,trig);
        //运行计算
        #ifdef Map_traveller2
            TimerStart(t,0.05,false,function EC_SE1EX);
        #else
            TimerStart(t,0.01,false,function EC_SE1EX);
        #endif
        t = null;
    }
    private function EC_SE2EX()
    {
        integer i = 0;
        integer lpi=0;
        integer id = 0;
        real x,y,a,b,x1,x2,y1,y2;
        real dis,speed,d,bbb,s,dis2;
        effect e;
        unit tu;
        trigger trig;
        timer t = GetExpiredTimer();
        //读取数据
        a = LoadReal(EC_HT,GetHandleId(t),1);
        b = LoadReal(EC_HT,GetHandleId(t),2);
        speed = LoadReal(EC_HT,GetHandleId(t),3);
        bbb = LoadReal(EC_HT,GetHandleId(t),4);
        e = LoadEffectHandle(EC_HT,GetHandleId(t),5);
        tu = LoadUnitHandle(EC_HT,GetHandleId(t),6);
        trig = LoadTriggerHandle(EC_HT,GetHandleId(t),7);
        if(e!=null)
        {
            //-------------
            x1 = EXGetEffectX(e);y1 = EXGetEffectY(e);//发射位置
            x = GetUnitX(tu);y = GetUnitY(tu);//目标位置
            d = X_GAFC(a,b,x,y);//目标移动方向
            dis = X_GDBC(a,b,x,y);//目标移动距离
            i = R2I(bbb) / 100 + 4;//
            while(i>lpi){lpi+=1;
                s = dis * bbb;
                x2 = x + CosBJ(d) * s;y2 = y + SinBJ(d) * s;//猜测可能出现位置
                //重推算
                dis2 = Math.GDBC(x1,y1,x2,y2);
                bbb = (dis2/speed)*100;
            }
            EC_CB_X = x2;EC_CB_Y = y2;
            EC_CB_angle = Math.GAFC(x1,y1,x2,y2);
            //EC_CB_degree = EC_GetTrackAngle_Effect(x1,y1,x2,y2);
            EC_CB_Effect = e;
            EC_CB_TargetUnit = tu;
            TriggerEvaluate(trig);
            // if(TriggerEvaluate(trig)){}
        }
        //清理
        FlushChildHashtable(EC_HT,GetHandleId(t));
        DestroyTimer(t);
        //
        t = null;
        e = null;
        tu = null;
        trig = null;

    }
    //弹道计算 特效版
    public function EC_ShootReady_EffectEX(effect e,real speed,unit tu,trigger callBack)
    {
        real x,y,a,b,x1,x2;
        real dis,d,bbb;
        timer t;
        if(!(speed>0))
        {
            return;
        }
        t = CreateTimer();
        x = EXGetEffectX(e);
        y = EXGetEffectY(e);
        a = GetUnitX(tu);
        b = GetUnitY(tu);
        dis = X_GDBC(x,y,a,b);
        bbb = (dis / speed) * 100;
        //保存单位当前位置
        SaveReal(EC_HT,GetHandleId(t),1,a);
        SaveReal(EC_HT,GetHandleId(t),2,b);
        SaveReal(EC_HT,GetHandleId(t),3,speed);
        SaveReal(EC_HT,GetHandleId(t),4,bbb);
        SaveEffectHandle(EC_HT,GetHandleId(t),5,e);
        SaveUnitHandle(EC_HT,GetHandleId(t),6,tu);
        SaveTriggerHandle(EC_HT,GetHandleId(t),7,callBack);
        //运行计算
        TimerStart(t,0.01,false,function EC_SE2EX);
        t = null;
    }
    public function EC_ShootReady_Effect(effect e,real speed,unit tu,trigger callBack,integer id)
    {
        real x,y,a,b,x1,x2;
        real dis,d,bbb;
        timer t = CreateTimer();
        x = EXGetEffectX(e);
        y = EXGetEffectY(e);
        a = GetUnitX(tu);
        b = GetUnitY(tu);
        dis = X_GDBC(x,y,a,b);
        bbb = (dis / speed) * 100;
        //保存单位当前位置
        SaveReal(EC_HT,GetHandleId(t),1,a);
        SaveReal(EC_HT,GetHandleId(t),2,b);
        SaveReal(EC_HT,GetHandleId(t),3,speed);
        SaveReal(EC_HT,GetHandleId(t),4,bbb);
        SaveEffectHandle(EC_HT,GetHandleId(t),5,e);
        SaveUnitHandle(EC_HT,GetHandleId(t),6,tu);
        SaveTriggerHandle(EC_HT,GetHandleId(t),7,callBack);
        SaveInteger(EC_HT,GetHandleId(t),8,id);
        //运行计算
        TimerStart(t,0.01,false,function EC_SE2);
        t = null;
    }
    //获取回调事件ID
    public function GetCallBackID()->integer
    {
        return EC_CB_ID;
    }
    //获取回调发射角度
    public function GetCallBackAngle()->real
    {
        return EC_CB_angle;
    }
    //获取回调源单位
    public function GetCallBackUnit()->unit
    {
        return EC_CB_Unit;
    }
    //获取回调源特效
    public function GetCallBackEffect()->effect
    {
        return EC_CB_Effect;
    }
    //获取回调目标单位
    public function GetCallBackTargetUnit()->unit
    {
        return EC_CB_TargetUnit;
    }
    public boolean EC_Running = false;
    //初始化
    private function onInit()
    {
        
        EC_Timer = CreateTimer();
        EC_HT = InitHashtable() ;
        EC_TriggerInit();
        TimerStart(EC_Timer,0.02,true,function EC_TimerEvent);
    }

}

//! endzinc

#endif



