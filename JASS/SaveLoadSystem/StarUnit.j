
#ifndef StarUnitIncluded
#define StarUnitIncluded
#ifndef YDWEYDWEJapiScriptIncluded 
#define YDWEYDWEJapiScriptIncluded


library YDWEYDWEJapiScript
	
	globals
    	constant integer YDWE_OBJECT_TYPE_ABILITY      = 0
    	constant integer YDWE_OBJECT_TYPE_BUFF         = 1
    	constant integer YDWE_OBJECT_TYPE_UNIT         = 2
    	constant integer YDWE_OBJECT_TYPE_ITEM         = 3
    	constant integer YDWE_OBJECT_TYPE_UPGRADE      = 4
    	constant integer YDWE_OBJECT_TYPE_DOODAD       = 5
    	constant integer YDWE_OBJECT_TYPE_DESTRUCTABLE = 6
	endglobals

	native EXExecuteScript     takes string script returns string

endlibrary

#endif  /// YDWEYDWEJapiScriptIncluded

#include "Star\\StarBase.j"

#include "Star\\X.j"

#include "Star/StarUnitTriggerList.j"

//! zinc

#ifdef OPEN
library StarUnit requires japi , X
#else
library StarUnit requires X,StarCommon
#endif
{
    private{
        hashtable HT = InitHashtable();
    }
    //判断单位是无敌的，单位无敌则返回true 否则返回false
    public function SU_IsUnitInvincible(unit u)->boolean{
        if(GetUnitAbilityLevel(u,'Avul')!=0){
            return true;
        }else{
            if(GetUnitAbilityLevel(u,'Bvul')!=0){
                return true;
            }else{
                if(GetUnitAbilityLevel(u,'BHds')!=0){
                    return true;
                }
            }
        }
        return false;
    }
    public {
        /*
            [SU_SetUnitFlyHeight]
            title = "改变单位飞行高度"
            description = "改变 ${单位} 的飞行高度为 ${数值} ,变换速率: ${数值}"
            comment = "包含了让单位可以飞行"
            category = TC_Star
            [[.args]]
            type = unit
            default = "GetTriggerUnit"
            [[.args]]
            type = real
            [[.args]]
            type = real
        */
        function SU_SetUnitFlyHeight(unit whichUnit, real newHeight, real rate)
        {
            UnitAddAbility(whichUnit,'Amrf');
            UnitRemoveAbility(whichUnit,'Amrf');
            SetUnitFlyHeight(whichUnit, newHeight, rate);
        }
    }
    //判断单位死亡
    // public function SU_IsUnitDie(unit u)->boolean{
    //     if(GetUnitState(u,UNIT_STATE_LIFE)<0.405){
    //         printi(GetUnitAbilityLevel(u,'XOre'));
    //         return true;
    //     }else{
    //         return false;
    //     }
    // }

    public unit CallBackUnit;
    //获取英雄全属性 单位 unit u 是否计算绿字 boolean b
    public function SU_GetHeroAllState(unit u,boolean b)->real{
        return I2R(GetHeroStr(u,b)+GetHeroAgi(u,b)+GetHeroInt(u,b));
    }
    //获取单位已经损失的生命值百分比
    public function SU_GetUnitLostHPPercent(unit u)->real{
        return ( GetUnitState(u,UNIT_STATE_MAX_LIFE) - GetUnitState(u,UNIT_STATE_LIFE) ) / GetUnitState(u,UNIT_STATE_MAX_LIFE);
    }
    //获取单位已经损失的生命值
    public function SU_GetUnitLostHP(unit u)->real{
        return GetUnitState(u,UNIT_STATE_MAX_LIFE) - GetUnitState(u,UNIT_STATE_LIFE);
    }
    //为单位u添加生命值 值为 value 是否百分比->bool
    public function UnitAddHp(unit u ,real value , boolean b)
    {
        real hp = GetUnitState(u,UNIT_STATE_LIFE);
        real maxhp = GetUnitState(u,UNIT_STATE_MAX_LIFE);
        real bfb = hp / maxhp;
        real t;
        if(b)
        {
            //百分比
            t = maxhp * value;
        }
        else
        {
            t = value;
        }
        //增加上限
        SetUnitState(u,UNIT_STATE_MAX_LIFE,t+maxhp);
        //设置生命值
        SetUnitState(u,UNIT_STATE_LIFE,(GetUnitState(u,UNIT_STATE_MAX_LIFE)*bfb));
    }
    //单位生命周期类型检查-是水元素 如果是水元素 则返回true
    public function IsWaterElement(unit u)->boolean
    {
        return GetUnitAbilityLevel(u,'BHwe') != 0;
    }

    //获取单位生命周期ID        
    public function GetUnitTimedLifeID(unit u)->integer
    {
        
        //操纵死尸
        if(GetUnitAbilityLevel(u,'BUan') != 0)
        {
            return 1;
        }
        //疾病云雾
        if(GetUnitAbilityLevel(u,'Bapl') != 0)
        {
            return 2;
        }
        //自然之力
        if(GetUnitAbilityLevel(u,'BEfn') != 0)
        {
            return 3;
        }
        //治疗守卫
        if(GetUnitAbilityLevel(u,'Bhwd') != 0)
        {
            return 4;
        }
        //复活死尸
        if(GetUnitAbilityLevel(u,'Brai') != 0)
        {
            return 5;
        }
        //水元素
        if(GetUnitAbilityLevel(u,'BHwe') != 0)
        {
            return 6;
        }
        //定时的生命
        if(GetUnitAbilityLevel(u,'BTLF') != 0)
        {
            return 7;
        }
        //什么也不是
        return 0;
    }
    //转换整数为生命周期枚举ID -> GUI封装
    public function I2TimedLifeID(integer i)->integer
    {
        return i;
    }
    //转换整数地址为单位
    public function GetUnitByHandle(integer i)->unit
    {
        FlushChildHashtable(HT,2);
        SaveFogStateHandle(HT, 2, 1, ConvertFogState(i));
        CallBackUnit = LoadUnitHandle(HT,2,1);
        return CallBackUnit;
    }
    public destructable CallBackDestructable;
    public function GetDestructableByHandle(integer i)->destructable
    {
        FlushChildHashtable(HT,2);
        SaveFogStateHandle(HT, 2, 1, ConvertFogState(i));
        CallBackDestructable = LoadDestructableHandle(HT,2,1);
        return CallBackDestructable;
    }
    public function Item2Unit(item wp)->unit{
        integer i = GetHandleId(wp);
        FlushChildHashtable(HT,2);
        SaveFogStateHandle(HT, 2, 1, ConvertFogState(i));
        printi(LoadInteger(HT,2,1));
        CallBackUnit = LoadUnitHandle(HT,2,1);
        return CallBackUnit;
    }
    public function SU_FHDWInit(){
        //单位初始化位置
        //选取所有单位位置
        //存到哈希表
    }
    //获取单位模型文件路径
    public function SU_GetUnitModel(unit u)->string
    {
        string file = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId(u), "file");
        string s ="";
        if (HaveSavedString(YDHT,GetHandleId(u),<?= StringHash("__model")?>) ){
            file = LoadStr(YDHT,GetHandleId(u),<?= StringHash("__model")?>);
        }
        s = SubString(file,StringLength(file)-4,StringLength(file));
        if(s!=".mdl" && s!=".mdx")
        {
            file+=".mdl";
        }
        
        return file;
    }
    //获取英雄主属性
    public function SU_GetHeroParmary(unit u)->integer
    {
        string str = "";
        if (GetHandleId(u) == 0){
            return -1;
        }
        str = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId(u), "Primary");
        if(str == "STR")
        {
            return 0;
        }
        if(str == "AGI")
        {
            return 1;
        }
        if(str == "INT")
        {
            return 2;
        }
        return -1;
    }
    //增加/设置/英雄属性 typ = 0 add typ = 1 set
    public function SU_AddHeroState(unit u,integer id,integer typ , integer value)
    {
        if(id ==0)
        {
            if(typ == 0)
            {
                SetHeroStr(u,GetHeroStr(u,false)+value,false);
            }
            else
            {
                SetHeroStr(u,value,false);
            }
        }
        if(id ==1)
        {
            if(typ == 0)
            {   
                SetHeroAgi(u,GetHeroAgi(u,false)+value,false);
            }
            else
            {
                SetHeroAgi(u,value,false);
            }
        }
        if(id ==2)
        {
            if(typ == 0)
            {
                SetHeroInt(u,GetHeroInt(u,false)+value,false);
            }
            else
            {
                SetHeroInt(u,value,false);
            }
        }
    }
    //获取英雄主属性的数值
    public function SU_GetHeroParmaryValue(unit u)->integer
    {
        integer typ = SU_GetHeroParmary(u);
        if(typ == 0)
        {
            return GetHeroStr(u,true);
        }
        else if(typ == 1)
        {
            return GetHeroAgi(u,true);
        }
        else if(typ == 2)
        {
            return GetHeroInt(u,true);
        }
        return -1;
    }
    //添加英雄三项属性
    public function SU_AddHeroAllState(unit u,integer a,integer b,integer c)
    {
        SU_AddHeroState(u,0,0,a);
        SU_AddHeroState(u,1,0,c);
        SU_AddHeroState(u,2,0,b);
    }
    ///增加/设置/英雄主属性的值 typ: 0 = add  1 = set 2 = sub
    public function SU_SetHeroParmaryValue(unit u,integer typ , integer value)
    {
        if(typ == 0)
        {
            SU_AddHeroState(u,SU_GetHeroParmary(u),0,value);
        }
        else if(typ ==1 )
        {
            SU_AddHeroState(u,SU_GetHeroParmary(u),1,value);
        }
        else if(typ == 2)
        {
            SU_AddHeroState(u,SU_GetHeroParmary(u),1,value*-1);
        }
    }
    //判断英雄主属性
    public function SU_HeroISParmary(unit u,integer i)->boolean
    {
        return (SU_GetHeroParmary(u) == i);
    }
    //这里是单位死亡事件回调
    public function SU_UnitOnDie(unit u)
    {
        //复活单位
    }
    
    public function SU_DotBehindUnit(real fac,real x,real y,real a,real b)->boolean{
        //real x = GetUnitX(u);real y = GetUnitY(u);
        fac = Math.GAFC(x,y,a,b) - fac;
        if(CosBJ(fac)<= -0.707106 ){
            return true;//单位在单位背面
        }
        return false;
    }
    //获取单位和单位间的角度关系
    public function SU_GetUnitOfUnit(unit u,unit tu)->integer{
        real x = GetUnitX(u);real y = GetUnitY(u);
        real a = GetUnitX(tu);real b = GetUnitY(tu);
        real fac = Math.GAFC(x,y,a,b) - GetUnitFacing(u);
        real c = CosBJ(fac);
        if(c>=0.866025){
            return 1;//单位在单位正面（更小范围）+-30
        }
        if(c>= 0.707106){
            return 4;//单位在单位正面 +-45
        }
        if(c<=-0.866025){
            return 2;//单位在单位背面（更小范围）
        }
        if(c<= -0.707106 ){
            return 5;//单位在单位背面
        }
        return 3;//单位在单位侧面
    }

    public function SU_IsUnitInfrontUnit2(unit u,unit tu)->boolean{
        real x = GetUnitX(u);real y = GetUnitY(u);
        real a = GetUnitX(tu);real b = GetUnitY(tu);
        real fac = Math.GAFC(x,y,a,b) - GetUnitFacing(u);
        real c = CosBJ(fac);
        if(c>0){
            return true;
        }
        return false;
    }
    //单位在单位正前方
    public function SU_IsUnitInfrontUnit(unit u,unit tu)->boolean
    {
       if(SU_GetUnitOfUnit(u,tu)==1)
       {
            return true;
       }
       return false;    
    }
    //单位在单位正后方
    public function SU_IsUnitBehindUnit(unit u,unit tu)->boolean
    {
        if(SU_GetUnitOfUnit(u,tu)==2)
        {
             return true;
        }
        return false;
    }
    //获取英雄/单位白字攻击力
    public function SU_GetUnitWhiteAtk(unit u,integer a)->real{
        integer i  = SU_GetHeroParmaryValue(u);
        integer v =0;
        real w;
        if(i==0){
            v=GetHeroStr(u,true)-GetHeroStr(u,false);
        }else if(i==1){
            v=GetHeroAgi(u,true)-GetHeroAgi(u,false);
        }else if(i==2){
            v=GetHeroInt(u,true)-GetHeroInt(u,false);
        }
        return GetUnitState(u, ConvertUnitState(0x12))+
        GetUnitState(u, ConvertUnitState(0x10))* 
        ( GetUnitState(u, ConvertUnitState(0x11))+1) /2 -(a*v);
        
    }
    public function SU_GetUnitMoveDis(unit u,trigger t)
    {
        
    }
    //检查单位是死亡的 高精度
    public function SU_IsUnitDie(unit u)->boolean{
        return (GetUnitState(u,UNIT_STATE_LIFE) > .405);
        //return !LoadBoolean(StarBaseHT,GetHandleId(u),<?= StringHash("是存活的")?>);
    }
    //是单位u的敌对单位且非无敌非建筑非死亡
    public function SUF_Base_1(unit u)->boolean{
        unit fu = GetFilterUnit();
        boolean b = IsUnitEnemy(fu,GetOwningPlayer(u)) &&
                GetUnitAbilityLevel( fu, 'Avul') == 0 &&
                !IsUnitType( fu, UNIT_TYPE_STRUCTURE) &&
                !SU_IsUnitDie(fu);
        fu = null;
        return b;   
    }
    public function SUF_Base_3(unit fu,unit u)->boolean{
        boolean b = IsUnitEnemy(fu,GetOwningPlayer(u)) &&
                GetUnitAbilityLevel( fu, 'Avul') == 0 &&
                !IsUnitType( fu, UNIT_TYPE_STRUCTURE) &&
                !SU_IsUnitDie(fu);
        return b;   
    }
    //不是单位u的敌对单位且非无敌非建筑非死亡
    public function SUF_Base_2(unit u)->boolean{
        unit fu = GetFilterUnit();
        boolean b = !IsUnitEnemy(fu,GetOwningPlayer(u)) &&
                GetUnitAbilityLevel( fu, 'Avul') == 0 &&
                !IsUnitType( fu, UNIT_TYPE_STRUCTURE) &&
                !SU_IsUnitDie(fu);
        fu = null;
        return b;   
    }
    //true为显示 false为隐藏
    //设置${单位}可见性为${boolean}
    public function SU_ShowOrHideUnit(unit u,boolean isShow){
        if(isShow){
            SetUnitVertexColor( u, 255, 255, 255, 255);
            SU_SetUnitFlyHeight(u,999999,0);
            
        }else{
            SetUnitVertexColor( u, 255, 255, 255, 0);
            SU_SetUnitFlyHeight(u,0,0);
        }
    }
    //初始化
    private function UnitDieListener(){
        group g = CreateGroup();
        region rectRegion = CreateRegion();
        RegionAddRect(rectRegion, bj_mapInitialPlayableArea);
        TriggerRegisterEnterRegion(StarTrig_EnterMap, rectRegion, null);
        rectRegion = null;
        TriggerAddAction(StarTrig_EnterMap,function(){//单位加入地图
            // Print(GetUnitName(GetTriggerUnit()));
            SaveBoolean(StarBaseHT,GetHandleId(GetTriggerUnit()),<?= StringHash("是存活的")?>,true);
        });
        TriggerAddAction(StarTrig_OnDie,function (){//单位死亡
            RemoveSavedBoolean(StarBaseHT,GetHandleId(GetTriggerUnit()),<?= StringHash("是存活的")?>);
            if (!IsUnitType( GetTriggerUnit(), UNIT_TYPE_HERO) ){
                FlushChildHashtable(StarBaseHT,GetHandleId(GetTriggerUnit()));
            }
        });
        GroupEnumUnitsInRect(g, GetWorldBounds(), function(){
            SaveBoolean(StarBaseHT,GetHandleId(GetFilterUnit()),<?= StringHash("是存活的")?>,true);
        });
        DestroyGroup(g);
        g = null;

    }
    //类型 句柄 名字 增量 增加？ 
    public function SU_UserIntDataSetAny(integer hd,integer i,integer iv,boolean b)->integer{
        integer value;
        if(b){
            value = LoadInteger(YDHT,hd,i)+iv;
            SaveInteger(YDHT,hd,i,value);
        }else{
            value = LoadInteger(YDHT,hd,i)-iv;
            if(value<=0)
            {
                RemoveSavedInteger(YDHT,hd,i);
            }
        }
        return value;
    }


    // 单位逆天自定义值整数自增带条件
    public function SU_UserIntDataSet(unit u,integer i,integer iv , boolean b){
        integer hd = GetHandleId(u);
        if(b){
            SaveInteger(YDHT,hd,i,LoadInteger(YDHT,hd,i)+iv);
        }else{
            SaveInteger(YDHT,hd,i,LoadInteger(YDHT,hd,i)-iv);
            if(LoadInteger(YDHT,hd,i)<=0)
            {
                RemoveSavedInteger(YDHT,hd,i);
            }
        }
    }
    // 单位逆天自定义值实数自增带条件
    public function SU_UserRealDataSet(unit u,integer i,real iv , boolean b){
        integer hd = GetHandleId(u);
        if(b){
            SaveReal(YDHT,hd,i,LoadReal(YDHT,hd,i)+iv);
        }else{
            SaveReal(YDHT,hd,i,LoadReal(YDHT,hd,i)-iv);
            if(LoadReal(YDHT,hd,i)<=0)
            {
                RemoveSavedReal(YDHT,hd,i);
            }
        }
    }

    //治疗单位 治疗来源 治疗目标 治疗值
    public function SU_TreatmentUnit(unit u,unit tu,real hp){
        real a = LoadReal(YDHT,GetHandleId(u),SUTL_GetHashCode(治疗增幅));
        real b = LoadReal(YDHT,GetHandleId(tu),SUTL_GetHashCode(治疗效果));
        trigger t;
        integer ydl_triggerstep;
        integer i,index,hash;
        //----------------------------------
        hp = hp * (1+a+b);
        hash = SUTL_GetHashCode( 受到治疗) + GetHandleId(u);
		index = LoadInteger(SUTL_HT,hash,skey_index);
        for(0<=i<index){
            t = LoadTriggerHandle(SUTL_HT,hash,i);
            ydl_triggerstep = YDHashH2I(t)*(YDHashGet(YDLOC, integer, YDHashH2I(t), 0xCFDE6C76) + 3);
            SaveInteger(YDHT,GetHandleId(t),SKey_PIndex,SUTL_GetHashCode(治疗单位指针));
            YDLocal5Set(real, "治疗值", hp);
            YDLocal5Set(unit, "来源", u);
            YDLocal5Set(unit, "目标",tu);
            TriggerExecute(t);
            hp = LoadReal(YDHT,SUTL_GetHashCode(治疗单位指针),SUTL_GetHashCode(治疗值));
        }
        //---------------------------------
        SetUnitState(tu,UNIT_STATE_LIFE,GetUnitState(tu,UNIT_STATE_LIFE)+hp);
        t = null;
    }
    private trigger su_ItemAbilityTrig = CreateTrigger();
    private trigger su_ItemAbilityTrig2 = CreateTrigger();
    public function SU_InititemAbilityListener_1(){//使用技能
        integer hd = GetHandleId(GetTriggerUnit());
        SaveInteger(StarBaseHT,hd,StrHEX(最后使用的技能),GetSpellAbilityId());
        SaveReal(StarBaseHT,hd,StrHEX(最后使用的技能X),GetSpellTargetX());
        SaveReal(StarBaseHT,hd,StrHEX(最后使用的技能Y),GetSpellTargetY());
    }
    public{
        integer Star_LastSpellItemAbility = 0;
        real Star_LastSpellItemAbilityTargetX = 0;
        real Star_LastSpellItemAbilityTargetY = 0;
        location Star_LastSpellItemAbilityTargetPoint = null;
    }
    private trigger su_iatList[];
    private integer su_iatIndex = 0;
    public function SU_AddItemAbilityEvent(trigger trg){
        integer hd = GetHandleId(trg);
        // integer i = 0;
        if(trg == null){
            return;
        }
        if (! HaveSavedInteger(YDHT,hd,StrHEX(物品技能事件索引)))
        {
            //i = LoadInteger(YDHT,hd,StrHEX(物品技能事件索引));
            SaveInteger(YDHT,hd,StrHEX(物品技能事件索引),su_iatIndex);
            su_iatList[su_iatIndex] = trg;
            su_iatIndex = su_iatIndex + 1;
        }
    }
    public function SU_InititemAbilityListener_2(){//使用物品技能
        integer hd = GetHandleId(GetTriggerUnit());
        integer i = 0;
        Star_LastSpellItemAbility = LoadInteger(StarBaseHT,hd,StrHEX(最后使用的技能));
        Star_LastSpellItemAbilityTargetX = LoadReal(StarBaseHT,hd,StrHEX(最后使用的技能X));
        Star_LastSpellItemAbilityTargetY = LoadReal(StarBaseHT,hd,StrHEX(最后使用的技能Y));
        if(su_iatIndex>0){
            Star_LastSpellItemAbilityTargetPoint = Location(Star_LastSpellItemAbilityTargetX,Star_LastSpellItemAbilityTargetY);
            while(i<su_iatIndex){
                if (su_iatList[i] != null 
                  && IsTriggerEnabled(su_iatList[i]) 
                  && TriggerEvaluate(su_iatList[i])){
                    TriggerExecute(su_iatList[i]);
                }
                i = i + 1;
            }
        }
        RemoveLocation(Star_LastSpellItemAbilityTargetPoint);
        Star_LastSpellItemAbilityTargetPoint = null;
    }
    public function SU_InititemAbilityListener(){
        TriggerRegisterAnyUnitEventBJ(su_ItemAbilityTrig,EVENT_PLAYER_UNIT_SPELL_EFFECT);//使用技能
        TriggerRegisterAnyUnitEventBJ(su_ItemAbilityTrig2, EVENT_PLAYER_UNIT_USE_ITEM);//使用物品
        TriggerAddAction(su_ItemAbilityTrig,function SU_InititemAbilityListener_1);
        TriggerAddAction(su_ItemAbilityTrig2,function SU_InititemAbilityListener_2);
    }
    private function onInit(){
        if(YDHT == null){
            BJDebugMsg("YDHT 没有初始化");
            YDHT = InitHashtable();
        }
        UnitDieListener();
        SU_InititemAbilityListener();
    }
}

//! endzinc


#endif



