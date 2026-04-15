



#ifndef EGIncluded
#define EGIncluded

// HT 0 0 effect

//! zinc
/*****************************************************************************************************************************
*****************************************************************************************************************************/
library EG
{
    private{
        hashtable HT = InitHashtable();
        integer EffectGroups = 5000000;
        integer K_Count = StringHash("Count");
    }
    public{
        effect EG_CallbackEffect = null;
        boolean EG_RemovedWhenForGroup = false;
        boolean EG_IsOnForGroup = false;
        //特效组
        integer Star_EG =0;
        integer Star_EG_ForValue;
        integer Star_EG_ForIndex;
    }

    //获取 - 选取特效
    public function EG_GetEnumEffect()->effect
    {
        return EG_CallbackEffect;
    }
    //初始化特效组
    private function EG_InitGroup(integer id)
    {
        SaveInteger(HT,id,K_Count,0);
    }
    //创建一个特效组
    public function EG_CreateEffectGroup()->integer
    {
        integer id ;
        EffectGroups += 1;
        id = EffectGroups - 1;
        EG_InitGroup(id);
        //BJDebugMsg("创建了一个特效组");
        return id;
        //新建一个特效组
    }
    //移除特效组
    public function EG_RemoveGroup(integer id)
    {
        FlushChildHashtable(HT,id);
        //BJDebugMsg("移除了一个特效组");
    }
    //清空特效组
    public function EG_ClearGroup(integer id)
    {
        SaveInteger(HT,id,K_Count,0);
        SaveEffectHandle(HT,id,0,null);
    }
    //遍历特效组 ${组} ${目标触发器}
    public function EG_ForGroup(integer id , trigger t)
    {
        integer i,max;
        max = LoadInteger(HT,id,K_Count);
        //BJDebugMsg("运行-ForGroup，Max ="+I2S(max));
        i = 0;
        EG_IsOnForGroup = true;
        while(i<max)
        {
            //BJDebugMsg(I2S(i));
            EG_CallbackEffect = LoadEffectHandle(HT,id,i);
            if(TriggerEvaluate(t)){
                TriggerExecute(t);
            }
            if(EG_RemovedWhenForGroup)
            {
                max-=1;
                i-=1;
            }
            EG_RemovedWhenForGroup = false;
            i+=1;
            
        }
        EG_IsOnForGroup = false;
        EG_CallbackEffect = null;
    }
    //获取特效组中第一个特效
    public function EG_GetFirstOfGroup(integer id)->effect
    {
        return LoadEffectHandle(HT,id,0);
    }
    public function EG_GetRandomOfGroup(integer id)->effect
    {
        integer max = LoadInteger(HT,id,K_Count)-1;

        return LoadEffectHandle(HT,id,GetRandomInt(0,max));
    }
    //判断特效是否在指定特效组中
    public function EG_IsEffectOnGroup(effect e,integer id)->integer
    {
        integer i,max;
        max = LoadInteger(HT,id,K_Count);
        i= 0;
        while(i<max) 
        {
            //BJDebugMsg("检查在指定特效组中");
            if(e == LoadEffectHandle(HT,id,i) )
            {
                //BJDebugMsg("检查-通过 - i = :"+I2S(i));
                return i;
            }
            i = i + 1;
        }
        return -1;
    }
    public function EG_IsGroupHaveEffect(effect e,integer id)->boolean
    {
        return EG_IsEffectOnGroup(e,id) != -1 ;
    }
    //从特效组中移除特效 如果移除成功返回true 否则返回false
    public function EG_RemoveEffectOfGroup(effect e,integer id)->boolean
    {
        integer i,max;
        //有效顶计数
        max = LoadInteger(HT,id,K_Count) -1;
        if(max<0)
        {
            return false;
        }
        i = EG_IsEffectOnGroup(e,id);
        //BJDebugMsg("----------EG_RemoveEffectOfGroup---------");
        //BJDebugMsg("EG_RemoveEffectOfGroup - i = :"+I2S(i));
        //BJDebugMsg("EG_RemoveEffectOfGroup - max = :"+I2S(max));
        //表示特效在特效组中
        if(i != -1)
        {
            if(i!=max)
            {
                SaveEffectHandle(HT,id,i,LoadEffectHandle(HT,id,max) );
                //BJDebugMsg("EG_RemoveEffectOfGroup 移除了在位置 :"+I2S(i)+"的特效并将"+I2S(max)+"处的数据填在此处");
            }
            else
            {
                RemoveSavedHandle(HT,id,i);
                //SaveEffectHandle(HT,id,i,null);
                //BJDebugMsg("EG_RemoveEffectOfGroup 移除了该组中的最后一个特效");
            }
            max -=1;
            SaveInteger(HT,id,K_Count,max+1);
            if(EG_IsOnForGroup)
            {
                EG_RemovedWhenForGroup = true;
            }
            return true;
        }
        return false;
    }
    //特效组添加特效 如果添加成功 返回true 否则返回false
    public function EG_GroupAddEffect(effect e,integer id)->boolean
    {
        integer i,max;
        max = LoadInteger(HT,id,K_Count);
        i =-1;// EG_IsEffectOnGroup(e,id);
        if(i == -1)
        {
            SaveEffectHandle(HT,id,max,e);
            max +=1;
            SaveInteger(HT,id,K_Count,max);
            return true;
        }
        return false;
    }
    public function EG_GroupAddEffectEx(effect e,integer id)->boolean
    {
        integer i,max;
        max = LoadInteger(HT,id,K_Count);
        SaveEffectHandle(HT,id,max,e);
        max +=1;
        SaveInteger(HT,id,K_Count,max);
        return true;
    }
    //为特效组a添加特效组b内所有成员
    public function EG_GroupAddGroup(integer sid, integer id)
    {
        integer i,max;
        max = LoadInteger(HT,id,K_Count);
        i = 0;
        EG_IsOnForGroup = true;
        while(i<max)
        {
            EG_CallbackEffect = LoadEffectHandle(HT,id,i);
            EG_GroupAddEffect(EG_CallbackEffect,sid);
            i+=1;
            
        }
        EG_IsOnForGroup = false;
        EG_CallbackEffect = null;
    }
    //特效组是否为空 
    public function EG_IsGroupEmpty(integer id)->boolean
    {
        if(LoadInteger(HT,id,K_Count)!=0)
        {
            return false;
        }
        return true;
    }
    //获取特效组中特效数量
    public function EG_GetCount(integer id)->integer
    { 
        return LoadInteger(HT,id,K_Count);
    }
    //转换整数为特效组
    public function EG_I2EG(integer id)->integer
    {
        return id;
    }
    //转换特效组为整数
    public function EG_EG2I(integer eg)->integer
    {
        return eg;
    }
    //获取特效组中第i个成员
    public function EG_GetAt(integer eg,integer i)->effect{
        return LoadEffectHandle(HT,eg,i);
    }
    public function EG_GetTable()->hashtable
    {
        return HT;
    }
    private function onInit()
    {
    }

}


//! endzinc

#endif










