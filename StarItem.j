
#ifndef StarItemIncluded
#define StarItemIncluded
#include "Star\\BZAPI.j"
#include "Star\\StarBase.j"
#include "Star\\X.j"

//! zinc

library StarItem requires X
{
    private{
        hashtable HT = InitHashtable();
    }
    public item CallBackItem;
    //Warnning:异步函数
    //获取玩家鼠标指针下的物品 - 异步函数
    public function GetItemUnderMouse()->item
    {
        FlushChildHashtable(HT,1);
        SaveFogStateHandle(HT, 1, 1, ConvertFogState(GetHandleId(DzGetUnitUnderMouse())));
        CallBackItem = LoadItemHandle(HT,1,1);
        return CallBackItem;
    }

    //转换整数地址为物品
    public function GetItemByHandle(integer i)->item
    {
        FlushChildHashtable(HT,2);
        SaveFogStateHandle(HT, 2, 1, ConvertFogState(i));
        CallBackItem = LoadItemHandle(HT,2,1);
        return CallBackItem;
    }
    // function SI2T takes integer i returns trigger
    //     call FlushChildHashtable(YDLOC,0)
    //     call SaveFogStateHandle(YDLOC,0,1,ConvertFogState(i) )
    //     return LoadTriggerHandle(YDLOC,0,1)
    //     endfunction
    private {
        //是否打开物品叠加
        boolean StackStatus = false;
        //是否已经注册物品叠加
        boolean StackRegd = false;
        //满格拾取范围
        real ItemRange = 600;
        trigger StarItem_TryPickUpTrigs[];
        integer StarItem_TryPickUpTrig_Index = 0;
        //星星-触发的物品
        item StarItem_TryPickUp_item = null;
        integer StarItem_bagLoc = 0;
        trigger StarItem_MoveItemTrigs[];
        integer StarItem_MoveItemTrig_Index = 0;
        trigger StarItem_StackItemTrigs[];
        integer StarItem_StackItemTrig_Index = 0;
        unit StarItem_CallBackUnit = null;
    }
    public function StarItem_GetTriggerUnit()->unit
    {
        return StarItem_CallBackUnit;
    }
    private
    {
        trigger temp_trig = null;
    }
    private function ItemStacked()
    {
        integer i = 0;
        while(i<StarItem_StackItemTrig_Index)
        {
            if(StarItem_StackItemTrigs[i]==null)
            {
                StarItem_StackItemTrigs[i] = StarItem_StackItemTrigs[StarItem_StackItemTrig_Index];
                StarItem_StackItemTrig_Index-=1;
            }
            TriggerExecute(StarItem_StackItemTrigs[i]);
            i+=1;
        }
    }
    private function ItemStack_Act3(item wp,unit u)
    {
        integer i = 0;
        item wp2=null;
        while(i<6)
        {
            wp2 = UnitItemInSlot(u,i);
            if (((GetItemTypeId(wp) == GetItemTypeId(wp2)) &&/*
            */ (wp!= wp2)))
            {
                //设置物品使用次数
                SetItemCharges(wp2 , /*
                */( GetItemCharges(wp2) + GetItemCharges(wp) ) );
                StarItem_TryPickUp_item = wp2;
                StarItem_CallBackUnit = u;
                ItemStacked();
                //IssueTargetOrderById( u, 851971, wp );
                IssueImmediateOrderById(u,851972);
                //清除逆天自定义值
                FlushChildHashtable(YDHT,GetHandleId(wp));
                //删除物品
                RemoveItem(wp);
                break;
            }
            i += 1;
        }
        wp2=null;
    }
    private function CheakPickUp()->boolean
    {
        unit u = null;
        item wp = null;
        if(GetTriggerEventId() == EVENT_GAME_TIMER_EXPIRED )
        {
            wp = LoadItemHandle(HT,GetHandleId(GetTriggeringTrigger()),10034);
            u = LoadUnitHandle(HT,GetHandleId(GetTriggeringTrigger()),10035);
            if(X_GDBC(GetUnitX(u),GetUnitY(u),GetItemX(wp),GetItemY(wp)) <=ItemRange+50)
            {
                ItemStack_Act3(wp,u);
                IssueImmediateOrderById(u,851972);
                u = null;   
                wp = null;   
                FlushChildHashtable(HT,GetHandleId(GetTriggeringTrigger()));
                DestroyTrigger(GetTriggeringTrigger());
            }
            u = null;   
            wp = null;        
        }
        else
        {
            //删除触发器
            FlushChildHashtable(HT,GetHandleId(GetTriggeringTrigger()));
            DestroyTrigger(GetTriggeringTrigger());
        }
        return false;
    }
    public function StarItem_ItemStack_Act2()
    {
        integer i = 0;
        item wp = GetOrderTargetItem() ;
        item wp2=null;
        unit u = GetTriggerUnit();
        while(i<6)
        {
            wp2 = UnitItemInSlot(u,i);
            if (((GetItemTypeId(wp) == GetItemTypeId(wp2)) &&(wp!= wp2)))
            {
                StackStatus = false;
                IssuePointOrderById( u, 851971, GetItemX(wp),GetItemY(wp));
                StackStatus = true;
                temp_trig = CreateTrigger();
                TriggerRegisterUnitEvent( temp_trig, u, EVENT_UNIT_ISSUED_TARGET_ORDER );
                TriggerRegisterUnitEvent( temp_trig, u, EVENT_UNIT_ISSUED_POINT_ORDER );
                TriggerRegisterUnitEvent( temp_trig, u, EVENT_UNIT_ISSUED_ORDER );
                TriggerRegisterUnitEvent( temp_trig, u, EVENT_UNIT_DEATH );
                TriggerRegisterTimerEvent(temp_trig,0.1,true);
                TriggerAddCondition(temp_trig,Condition(function CheakPickUp));
                //保存数据
                SaveItemHandle(HT,GetHandleId(temp_trig),10034,wp);
                SaveUnitHandle(HT,GetHandleId(temp_trig),10035,u);
                //BJDebugMsg(I2S(GetHandleId(temp_trig)));
                break;
            }
            i += 1;
        }
        wp2=null;
        wp = null;
        u = null;
    }

    //ACT
    public function StarItem_ItemStack_Act()
    {
        integer i = 0;
        item wp = GetOrderTargetItem() ;
        item wp2=null;
        unit u = GetTriggerUnit();
        while(i<6)
        {
            wp2 = UnitItemInSlot(u,i);
            if (((GetItemTypeId(wp) == GetItemTypeId(wp2)) &&/*
            */ (wp!= wp2)))
            {
                //设置物品使用次数
                SetItemCharges(wp2 , /*
                */( GetItemCharges(wp2) + GetItemCharges(wp) ) );
                StarItem_TryPickUp_item = wp2;
                StarItem_CallBackUnit = u;
                ItemStacked();
                //IssueTargetOrderById( u, 851971, wp );
                //清除逆天自定义值
                FlushChildHashtable(YDHT,GetHandleId(wp));
                //删除物品
                RemoveItem(wp);

                break;
            }
            i += 1;
        }
        wp2=null;
        wp = null;
        u = null;
    }
    //判断物品在单位的指定范围内
    public function StarItem_IsItemInRange(unit u,item ite,real r)->boolean
    {
        return (X_GDBC(GetUnitX(u),GetUnitY(u),GetItemX(ite),GetItemY(ite)) <=r);
    }
    public function StarItem_UnitMoveItem(trigger t)
    {
        StarItem_MoveItemTrigs[StarItem_MoveItemTrig_Index] = t;
        StarItem_MoveItemTrig_Index += 1;
    }
    //满格
    public function StarItem_ItemStack_Cond()->boolean
    {
        integer i = 0;
        integer j = 0;
        //如果开启了物品叠加
        //printi(GetIssuedOrderId());
        if(StackStatus)
        {
            if(GetIssuedOrderId()==851971)
            {
                if(GetOrderTargetItem()!=null)
                {
                    if(GetUnitAbilityLevel(GetTriggerUnit(),'AInv') != 0)
                    {
                        if (GetItemType(GetOrderTargetItem()) == ITEM_TYPE_CHARGED/*
                        */||GetItemType(GetOrderTargetItem()) == ITEM_TYPE_PURCHASABLE)
                        {
                            if(X_GDBC(GetUnitX(GetTriggerUnit()),GetUnitY(GetTriggerUnit()),/*
                            */GetItemX(GetOrderTargetItem()),GetItemY(GetOrderTargetItem())) <=ItemRange)
                            {
                                StarItem_ItemStack_Act();
                            }
                            else
                            {
                                StarItem_ItemStack_Act2();
                                //IssuePointOrderById(GetTriggerUnit(),851971,GetItemX(GetOrderTargetItem()),GetItemY(GetOrderTargetItem()));
                            }
                        }
                    }
                }
            }
        }
        if(StarItem_TryPickUpTrig_Index>0)
        {
            if(GetIssuedOrderId()==851971)
            {
                if(GetOrderTargetItem()!=null)
                {
                    if(GetUnitAbilityLevel(GetTriggerUnit(),'AInv') != 0)
                    {
                        i = 0;
                        StarItem_TryPickUp_item = GetOrderTargetItem();
                        StarItem_CallBackUnit = GetTriggerUnit();
                        while(i<StarItem_TryPickUpTrig_Index)
                        {
                                
                            if(StarItem_TryPickUp_item!= null)
                            {
                                if(StarItem_TryPickUpTrigs[i] == null)
                                {
                                    StarItem_TryPickUpTrigs[i] = StarItem_TryPickUpTrigs[StarItem_TryPickUpTrig_Index];
                                    StarItem_TryPickUpTrig_Index-=1;
                                }
                                TriggerExecute(StarItem_TryPickUpTrigs[i]);
                            }
                            else
                            {
                                break;
                            }
                            i+=1;
                        }
                        StarItem_TryPickUp_item = null;
                    }
                }
            }
        }
        if(StarItem_MoveItemTrig_Index>0)
        {
            i = 2;
            while(i<8)
            {
                if(GetIssuedOrderId()==852000+i)
                {
                    StarItem_bagLoc = i-2;
                    StarItem_TryPickUp_item = GetOrderTargetItem();
                    break;
                }
                i+=1;
            }
            if(StarItem_TryPickUp_item!= null)
            {
                i = 0;
                while(i<StarItem_MoveItemTrig_Index)
                {
                    if(StarItem_MoveItemTrigs[i]!=null)
                    {
                        TriggerExecute(StarItem_MoveItemTrigs[i]);
                    }
                    else
                    {
                        StarItem_MoveItemTrigs[i] = StarItem_MoveItemTrigs[StarItem_MoveItemTrig_Index];
                        TriggerExecute(StarItem_MoveItemTrigs[i]);
                        StarItem_MoveItemTrig_Index-=1;
                    }
                    
                    i+=1;
                }
            }
            StarItem_TryPickUp_item = null;
        }
        return true;
    }
    public function StarItem_GetTriggerItem()->item
    {
        return StarItem_TryPickUp_item;
    }
    public function StarItem_GetItemLocOnBag()->integer
    {
        return StarItem_bagLoc;
    }

    //单位可以捡起物品，但是物品栏已满时触发
    public function StarItem_TryPickUpItem(trigger t)
    {
        StarItem_TryPickUpTrigs[StarItem_TryPickUpTrig_Index] = t;
        StarItem_TryPickUpTrig_Index+=1;
    }
    private{
        integer SI_TargetType[];
        integer SI_NeedType[];
        integer SI_NeddCount[];
        integer SI_ItemSIndex = 0;
    }
    //返回物品在单位物品栏的位置
    public function GetUnitHaveItemLoc(unit u,integer wplx)->integer
    {
        integer i=0;
        while(i<6)
        {
            if(GetItemTypeId(UnitItemInSlot(u,i)) == wplx)
            {
                //printi(i);
                return i;
            }
            i+=1;
        }
        return -1;
    }
    private boolean skips[];
    //合成系统暂不支持相同物品不同数量 // 禁用
    public function StarItem_ItemSynthesis_Act(unit u,item wp,boolean needcheck)
    {
        integer wplx = 0;
        integer i=0,j=0,k,l=-1,m=0,j2;
        integer base= 0;
        boolean bools[];
        item wplxs[];
        integer itype ;//目标物品类型
        integer index = 0;
        item ite;
        itype = GetItemTypeId(wp);//获取的物品
        index = LoadInteger(HT,itype,Key_Index);//物品合成列表的index
        while(i<index)//遍历这个list
        {
            //重置变量组
            j2 = 0;
            while(j2<7)
            {
                bools[j2] = false;
                skips[j2] = false;//标识符 表示是否需要跳过当前位置的装备的检查
                wplxs[j2] = null;
                j2+=1;
            }
            base = LoadInteger(HT,itype,i);//加载对应的表单基值
            j = 0;//偏移量
            while(j<6)//6格物品
            {
                //检查物品类型相同
                wplx = SI_NeedType[base*6+j];//base * 6 = 基址 + j = 指定配方的物品类型
                if(wplx ==0)//是0的话 表示不需要检查 直接通过
                {
                    bools[j] = true;wplxs[j] = null;
                }
                else
                {
                    m = 0;k = -1;
                    while(m<6)
                    {
                        if(GetItemTypeId(UnitItemInSlot(u,m)) == wplx)//单位第m格存在物品
                        {
                            if(!skips[m])//如果不是已经被征收的物品
                            {
                                //Print("cheaked,"+I2S(m)+","+I2S(j));
                                bools[j] = true;//表示检查通过
                                skips[m] = true;//表示下次需要跳过它
                                wplxs[j] = (UnitItemInSlot(u,m));
                                m+=20;
                                break;
                            }
                        }
                        m = m + 1;
                    }
                    if(m<20)
                    {
                        //判断当前准备拾取的那件物品
                        if(GetItemTypeId(wp) == wplx)
                        {
                            if(!skips[6] && needcheck)//如果不是已经被征收的物品
                            {
                                //Print("cheaked,"+I2S(6)+","+I2S(j));
                                skips[6] = true;
                                bools[j] = true;
                                wplxs[j] = wp;
                            }
                        }
                    }
                }
                j2 = 0;
                while(j2<6)
                {
                    if(bools[j2])//如果全部为true 表示合成成功
                    {
                        //Print("j2="+I2S(j2));
                        bools[6] = true;
                    }
                    else
                    {
                        //Print("j2="+I2S(j2));
                        bools[6] = false;
                        j2+=6;//跳出
                    }
                    j2+=1;
                }
                if(bools[6])
                {
                    //合成成功//删除之前指定的物品
                    j2= 0;
                    while(j2<6)
                    {
                        if(wplxs[j2]!=null)
                        {
                            if(StarItem_TryPickUp_item==wplxs[j2])
                            {StarItem_TryPickUp_item = null;}
                            RemoveItem(wplxs[j2]);
                            wplxs[j2] = null;
                        }
                        j2+=1;
                    }
                    //给予新物品
                    wplxs[10] = CreateItem(SI_TargetType[base],GetUnitX(u),GetUnitY(u));
                    UnitAddItem(u,wplxs[10]);
                    DisplayTextToPlayer(GetOwningPlayer(u),0,0,"|cffffbb00【游戏】:合成了物品『"+GetItemName(wplxs[10])+"』|r");
                    wplxs[10] = null;
                    break;
                }
                j+=1;
            }
            
            
            i+=1;
        }

        //清除
        u = null;
    }
    private function CheakSynthesis()->boolean
    {
        unit u = null;
        item wp = null;
        if(GetTriggerEventId() == EVENT_GAME_TIMER_EXPIRED )
        {
            wp = LoadItemHandle(HT,GetHandleId(GetTriggeringTrigger()),10034);
            u = LoadUnitHandle(HT,GetHandleId(GetTriggeringTrigger()),10035);
            if(X_GDBC(GetUnitX(u),GetUnitY(u),GetItemX(wp),GetItemY(wp)) <=ItemRange+50)
            {
                //Print("Call");
                StarItem_TryPickUp_item = wp;
                StarItem_ItemSynthesis_Act(u,wp,true);
                IssueImmediateOrderById(u,851972);
                u = null;   
                wp = null;   
                FlushChildHashtable(HT,GetHandleId(GetTriggeringTrigger()));
                DestroyTrigger(GetTriggeringTrigger());
            }
            u = null;   
            wp = null;        
        }
        else
        {
            //Print("Destroy");
            //删除触发器
            FlushChildHashtable(HT,GetHandleId(GetTriggeringTrigger()));
            DestroyTrigger(GetTriggeringTrigger());
        }
        return false;
    }
    private integer loopi = 0;
    //满格合成 禁用
    public function StarItem_ItemSynthesis_IsPickupable()->boolean
    {
        unit u;
        item wp;
        if(SI_ItemSIndex>0)
        {
            if(GetIssuedOrderId()==851971)
            {
                wp = GetOrderTargetItem();
                if(wp!=null)
                {
                    u = GetTriggerUnit();
                    //Print("Target = "+GetItemName(GetOrderTargetItem()));
                    if(GetUnitAbilityLevel(u,'AInv') != 0)
                    {
                        if(X_GDBC(GetUnitX(u),GetUnitY(u),GetItemX(wp),GetItemY(wp)) <=ItemRange)
                        {
                            //Print("call");
                            //物品合成事件
                            StarItem_ItemSynthesis_Act(u,wp,true);
                            //StarItem_ItemSynthesis_Act(u,wp,true);
                        }
                        else if(HaveSavedInteger(HT,GetItemTypeId(wp),Key_Index))
                        {
                            loopi = 0;
                            while(loopi<6)
                            {
                                if(UnitItemInSlot(u,loopi)==null){
                                    loopi+=11;
                                }
                                loopi+=1;
                            }
                            if(loopi ==6)
                            {
                                //Print("满格");
                                StackStatus = false;
                                IssuePointOrderById( u, 851971, GetItemX(wp),GetItemY(wp));
                                StackStatus = true;
                                temp_trig = CreateTrigger();
                                TriggerRegisterUnitEvent( temp_trig, u, EVENT_UNIT_ISSUED_TARGET_ORDER );
                                TriggerRegisterUnitEvent( temp_trig, u, EVENT_UNIT_ISSUED_POINT_ORDER );
                                TriggerRegisterUnitEvent( temp_trig, u, EVENT_UNIT_ISSUED_ORDER );
                                TriggerRegisterUnitEvent( temp_trig, u, EVENT_UNIT_DEATH );
                                TriggerRegisterTimerEvent(temp_trig,0.1,true);
                                TriggerAddCondition(temp_trig,Condition(function CheakSynthesis));
                                //保存数据
                                SaveItemHandle(HT,GetHandleId(temp_trig),10034,wp);
                                SaveUnitHandle(HT,GetHandleId(temp_trig),10035,u);
                            }
                            //else{Print("没满格");}
                        }
                    }
                }
            }
        }
        wp = null;
        u = null;
        return false;
    }
    //为每个子物品类型存储一个table  （一个index和固定id增加的值）
    //物品合成 ... 咕咕咕
    public integer Key_Index = <?=StringHash("Index")?>;
    //public function StarItem_ItemSynthesis_Reg(integer i1,integer c1,integer i2,integer c2,integer i3,integer c3,integer i4,integer c4,integer i5,integer c5,integer i6,integer c6,integer i7)
    public function StarItem_ItemSynthesis_Reg(integer i1,integer i2,integer i3,integer i4,integer i5,integer i6,integer i7)
    {
        
        integer index = 0;
        integer ix2 = 0;
        integer i = SI_ItemSIndex;//表单ID
        integer j = SI_ItemSIndex*6;//基础类型偏移

        if(i1!=0)
        {
            index = LoadInteger(HT,i1,Key_Index);//读取物品类型的表单数量
            ix2 = index ;//旧的顶计数
            index = index +1;//新的顶计数
            SaveInteger(HT,i1,ix2,i);//物品index位置的表单id = i
            SaveInteger(HT,i1,Key_Index,index);// 物品的表单数量+=1
        }
        if(i2!=0)
        {
            index = LoadInteger(HT,i2,Key_Index);//读取物品类型的表单数量
            ix2 = index ;//旧的顶计数
            index = index +1;//新的顶计数
            SaveInteger(HT,i2,ix2,i);//保存当前合成表单到物品类型上
            SaveInteger(HT,i2,Key_Index,index);//修改物品类型的表单数量
        }
        if(i3!=0)   
        {
            index = LoadInteger(HT,i3,Key_Index);//读取物品类型的表单数量
            ix2 = index ;//旧的顶计数
            index = index +1;//新的顶计数
            SaveInteger(HT,i3,ix2,i);//保存当前合成表单到物品类型上
            SaveInteger(HT,i3,Key_Index,index);//修改物品类型的表单数量
        }
        if(i4!=0)
        {
            index = LoadInteger(HT,i4,Key_Index);//读取物品类型的表单数量
            ix2 = index ;//旧的顶计数
            index = index +1;//新的顶计数
            SaveInteger(HT,i4,ix2,i);//保存当前合成表单到物品类型上
            SaveInteger(HT,i4,Key_Index,index);//修改物品类型的表单数量
        }
        if(i5!=0)
        {
            index = LoadInteger(HT,i5,Key_Index);//读取物品类型的表单数量
            ix2 = index ;//旧的顶计数
            index = index +1;//新的顶计数
            SaveInteger(HT,i5,ix2,i);//保存当前合成表单到物品类型上
            SaveInteger(HT,i5,Key_Index,index);//修改物品类型的表单数量
        }
        if(i6!=0)
        {
            index = LoadInteger(HT,i6,Key_Index);//读取物品类型的表单数量
            ix2 = index ;//旧的顶计数
            index = index +1;//新的顶计数
            SaveInteger(HT,i6,ix2,i);//保存当前合成表单到物品类型上
            SaveInteger(HT,i6,Key_Index,index);//修改物品类型的表单数量
        }

        if(SI_ItemSIndex == 0)
        {
            TriggerAddCondition(StarTrig_UnitOrder,Condition(function StarItem_ItemSynthesis_IsPickupable));
        }

        //合成材料
        // 0 1 2 3 4 5
        SI_NeedType[j] = i1;
        //SI_NeddCount[j] = c1;
        SI_NeedType[j+1] = i2;
        //SI_NeddCount[j+1] = c2;
        SI_NeedType[j+2] = i3;
        //SI_NeddCount[j+2] = c3;   
        SI_NeedType[j+3] = i4;
        //SI_NeddCount[j+3] = c4;
        SI_NeedType[j+4] = i5;
        //SI_NeddCount[j+4] = c5;
        SI_NeedType[j+5] = i6; 
        //SI_NeddCount[j+5] = c6;
        //合成目标
        SI_TargetType[i] = i7;
        //表单总数+1
        SI_ItemSIndex += 1;
        //Print("注册成功");
    }
    public function StarItem_null()->integer
    {
        return 0;
    }
    //没满格
    public function StarItem_ItemStack_Cond2()->boolean{
        integer i = 0;
        
        if(StackStatus)
        {
            if (((GetItemType(GetManipulatedItem()) == ITEM_TYPE_CHARGED) || (GetItemType(GetManipulatedItem()) == ITEM_TYPE_PURCHASABLE)))
            {
                while(i<6)
                {
                    if (((GetItemTypeId(GetManipulatedItem()) == GetItemTypeId(UnitItemInSlot(GetTriggerUnit(),i))) && (GetManipulatedItem() != UnitItemInSlot(GetTriggerUnit(),i))))
                    {
                        SetItemCharges( UnitItemInSlot(GetTriggerUnit(),i), ( GetItemCharges(UnitItemInSlot(GetTriggerUnit(),i)) + GetItemCharges(GetManipulatedItem()) ) );
                        StarItem_TryPickUp_item =UnitItemInSlot(GetTriggerUnit(),i);
                        StarItem_CallBackUnit = GetTriggerUnit();
                        ItemStacked();
                        RemoveItem(GetManipulatedItem());
                        return true;
                    }
                    i+=1;
                }
            }
        }
        if(SI_ItemSIndex!=0)
        {
            StarItem_ItemSynthesis_Act(GetTriggerUnit(),GetManipulatedItem(),false);
        }
        return true;
    }
    //打开物品叠加
    public function StarItem_OpenStack(real r)
    {
        if(!StackRegd)
        {
            StackRegd = true;
            TriggerAddCondition(StarTrig_UnitOrder,Condition(function StarItem_ItemStack_Cond));
            TriggerAddCondition(StarTrig_ItemPickUP,Condition(function StarItem_ItemStack_Cond2));
        }
        ItemRange = r;
        StackStatus = true;
    }
    public function StarItem_TriggerAddItemStackedEvent(trigger t)
    {
        StarItem_StackItemTrigs[StarItem_StackItemTrig_Index] = t;
        StarItem_StackItemTrig_Index+=1;
    }
    //关闭物品叠加
    public function StarItem_CloseStack()
    {
        StackStatus = false;
    }
}

//! endzinc
#endif



