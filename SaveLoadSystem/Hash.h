#ifdef YDLOC_New


# /*
#  *  局部变量、自定义值
#  *  
#  *  By actboy168
#  *
#  */
#
#ifndef INCLUDE_YDTRIGGER_HASH_H
#define INCLUDE_YDTRIGGER_HASH_H
#
#define YDUserDataClearTable(table_type, table) YDHashClearTable(YDHASH_HANDLE, YDHashAny2I(table_type, table))
#define YDUserDataClear(table_type, table, attribute, value_type) YDHashClear(YDHASH_HANDLE, value_type, YDHashAny2I(table_type, table), <?=StringHash(attribute)?>)
#define YDUserDataSet(table_type, table, attribute, value_type, value) YDHashSet(YDHASH_HANDLE, value_type, YDHashAny2I(table_type, table), <?=StringHash(attribute)?>, value)
#define YDUserDataGet(table_type, table, attribute, value_type) YDHashGet(YDHASH_HANDLE, value_type, YDHashAny2I(table_type, table), <?=StringHash(attribute)?>)
//Star 
#define YDUserDataSet2(table_type, table, attribute, value_type, value) YDHashSet(YDHASH_HANDLE, value_type, YDHashAny2I(table_type, table), StringHash(##attribute), value)
#define YDUserDataGet2(table_type, table, attribute, value_type) YDHashGet(YDHASH_HANDLE, value_type, YDHashAny2I(table_type, table), StringHash(##attribute))
#define YDUserDataClear2(table_type, table, value_type, attribute) YDHashClear(YDHASH_HANDLE, value_type, YDHashAny2I(table_type, table), StringHash(##attribute))
#define YDUserDataHas2(table_type, table, value_type, attribute) YDHashHas(YDHASH_HANDLE, value_type, YDHashAny2I(table_type, table), StringHash(##attribute))

#define YDUserDataHas(table_type, table, attribute, value_type) YDHashHas(YDHASH_HANDLE, value_type, YDHashAny2I(table_type, table), <?=StringHash(attribute)?>)
#
#
#  // GlobalsTriggerRunSteps & TriggerRunSteps
#  // 0xCFDE6C76是给当前触发器用的索引,它是个全局量  0xECE825E7 是给子动作的索引 它是个全局量
#define YDLocalInitialize() \
    local integer ydl_localvar_step = YDHashGet(YDLOC, integer, YDHashH2I(GetTriggeringTrigger()), 0xCFDE6C76) YDNL\
    local integer L_LIndex YDNL\
    set ydl_localvar_step = ydl_localvar_step + 3 YDNL\
    call YDHashSet(YDLOC, integer, YDHashH2I(GetTriggeringTrigger()), 0xCFDE6C76, ydl_localvar_step)           YDNL\
    call YDHashSet(YDLOC, integer, YDHashH2I(GetTriggeringTrigger()), 0xECE825E7, ydl_localvar_step) YDNL\
    set L_LIndex = G_SIndex YDNL\
    set G_SIndex = YDHashH2I(GetTriggeringTrigger())*ydl_localvar_step YDNL\
    set G_LIndex = G_SIndex
    // if ydl_localvar_step>250000 then YDNL\
    //     set ydl_localvar_step = ydl_localvar_step - 250000 YDNL \
    // endif YDNL\
    // call YDHashSet(YDLOC, integer, YDHashH2I(GetTriggeringTrigger()), 0xCFDE6C76, ydl_localvar_step)           YDNL\
    // call YDHashSet(YDLOC, integer, YDHashH2I(GetTriggeringTrigger()), 0xECE825E7, ydl_localvar_step)
#   //尝试修复逆天变量计数与handle碰撞 -- when 逆天-触发器运行
#define YDLocalExecuteTrigger(trg) \
    set ydl_triggerstep = YDHashH2I(trg)*(YDHashGet(YDLOC, integer, YDHashH2I(trg), 0xCFDE6C76) + 3) YDNL\
    // if ydl_triggerstep>60000 then YDNL\
    //     set ydl_triggerstep = 1000 YDNL \
    //     call YDHashSet(YDLOC, integer, YDHashH2I(trg), 0xCFDE6C76, ydl_triggerstep)           YDNL\
    // endif 
#define YDLocalExecuteFunc(trg) \
    set ydl_triggerstep = YDGetStep2(trg,LoadInteger(YDHT,StringHash(trg),0xCFDE6C76)+3  )
    //set ydl_triggerstep = StringHash(trg)*(YDHashGet(YDLOC, integer, StringHash(trg), 0xCFDE6C76) + 3) YDNL\
      
#define YDLocalReset()                             YDHashSet(YDLOC, integer, YDHashH2I(GetTriggeringTrigger()), 0xECE825E7, ydl_localvar_step)
#define YDFuncLocalInit(trg) \
    local integer ydl_localvar_step = LoadInteger(YDHT,StringHash(trg),0xCFDE6C76)YDNL\
    local integer L_LIndex YDNL\
    set ydl_localvar_step = ydl_localvar_step + 3 YDNL\
    call SaveInteger(YDHT,StringHash(trg),0xCFDE6C76,ydl_localvar_step)YDNL\
    set L_LIndex = G_SIndex YDNL\
    set G_SIndex = YDGetStep2(trg,ydl_localvar_step) YDNL\
    set G_LIndex = G_SIndex
# // 1. 根
#define YDLOCAL_1                                  G_SIndex/*YDHashH2I(GetTriggeringTrigger())*ydl_localvar_step*/
#define YDLocal1Set(type, name, value)             YDHashSet(YDLOC, type, G_SIndex, <?=StringHash(name)?>, value)
#define YDLocal1ArraySet(type, name, index, value) YDHashSet(YDLOC, type, G_SIndex, <?=StringHash(name)?> + (index), value)
#define YDLocal1Get(type, name)                    YDHashGet(YDLOC, type, G_LIndex, <?=StringHash(name)?>)
#define YDLocal1ArrayGet(type, name, index)        YDHashGet(YDLOC, type, G_LIndex, <?=StringHash(name)?> + (index))
#define YDLocal1Release()                          YDHashClearTable(YDLOC, YDLOCAL_1)   YDNL\
    set G_SIndex = L_LIndex    YDNL\
    set G_LIndex = L_LIndex
# // 2. 根
#define YDLOCAL_2                                  G_SIndex/*YDHashH2I(GetTriggeringTrigger())*YDHashGet(YDLOC, integer, YDHashH2I(GetTriggeringTrigger()), 0xECE825E7)*/
#define YDLocal2Set(type, name, value)             YDHashSet(YDLOC, type, G_SIndex, <?=StringHash(name)?>, value)
#define YDLocal2ArraySet(type, name, index, value) YDHashSet(YDLOC, type, G_SIndex, <?=StringHash(name)?> + (index), value)
#define YDLocal2Get(type, name)                    YDHashGet(YDLOC, type, G_LIndex, <?=StringHash(name)?>)
#define YDLocal2ArrayGet(type, name, index)        YDHashGet(YDLOC, type, G_LIndex, <?=StringHash(name)?> + (index))
# // 3. 逆天计时器
#define YDLOCAL_3                                  G_SIndex/*YDHashH2I(GetExpiredTimer())*/
#define YDLocal3Set(type, name, value)             YDHashSet(YDLOC, type, G_SIndex, <?=StringHash(name)?>, value)
#define YDLocal3ArraySet(type, name, index, value) YDHashSet(YDLOC, type, G_SIndex, <?=StringHash(name)?> + (index), value)
#define YDLocal3Get(type, name)                    YDHashGet(YDLOC, type, G_LIndex, <?=StringHash(name)?>)
#define YDLocal3ArrayGet(type, name, index)        YDHashGet(YDLOC, type, G_LIndex, <?=StringHash(name)?> + (index))
#define YDLocal3Release()                          YDHashClearTable(YDLOC, YDLOCAL_3) YDNL\
    set G_SIndex = L_LIndex    YDNL\
    set G_LIndex = L_LIndex
# // 4. 逆天触发器
#define YDLOCAL_4                                  G_SIndex/*YDHashH2I(GetTriggeringTrigger())*/
#define YDLocal4Set(type, name, value)             YDHashSet(YDLOC, type, G_SIndex, <?=StringHash(name)?>, value)
#define YDLocal4ArraySet(type, name, index, value) YDHashSet(YDLOC, type, G_SIndex, <?=StringHash(name)?> + (index), value)
#define YDLocal4Get(type, name)                    YDHashGet(YDLOC, type, G_LIndex, <?=StringHash(name)?>)
#define YDLocal4ArrayGet(type, name, index)        YDHashGet(YDLOC, type, G_LIndex, <?=StringHash(name)?> + (index))
#define YDLocal4Release()                          YDHashClearTable(YDLOC, YDLOCAL_4) YDNL\
    set G_SIndex = L_LIndex    YDNL\
    set G_LIndex = L_LIndex
# // 5.   传参
#define YDLOCAL_5                                  ydl_triggerstep
#define YDLocal5Set(type, name, value)             YDHashSet(YDLOC, type, YDLOCAL_5, <?=StringHash(name)?>, value)
#define YDLocal5ArraySet(type, name, index, value) YDHashSet(YDHASH_HYDLOCANDLE, type, YDLOCAL_5, <?=StringHash(name)?> + (index), value)
#define YDLocal5Get(type, name)                    YDHashGet(YDLOC, type, YDLOCAL_5, <?=StringHash(name)?>)
#define YDLocal5ArrayGet(type, name, index)        YDHashGet(YDLOC, type, YDLOCAL_5, <?=StringHash(name)?> + (index))
# // 7.   返回值
#define YDLOCAL_7                                  Star_PIndex
#define YDLocal7Set(type, name, value)             YDHashSet(YDLOC, type, YDLOCAL_7, <?=StringHash(name)?>, value)
#define YDLocal7ArraySet(type, name, index, value) YDHashSet(YDLOC, type, YDLOCAL_7, <?=StringHash(name)?> + (index), value)
#define YDLocal7Get(type, name)                    YDHashGet(YDLOC, type, YDLOCAL_7, <?=StringHash(name)?>)
#define YDLocal7ArrayGet(type, name, index)        YDHashGet(YDLOC, type, YDLOCAL_7, <?=StringHash(name)?> + (index))
# //  内置lua块
#define YDLOCAL_8                                  StarLuaKey
#define YDLocal8Set(type, name, value)             YDHashSet(YDLOC, type, YDLOCAL_8, <?=StringHash(name)?>, value)
#define YDLocal8ArraySet(type, name, index, value) YDHashSet(YDLOC, type, YDLOCAL_8, <?=StringHash(name)?> + (index), value)
#define YDLocal8Get(type, name)                    YDHashGet(YDLOC, type, YDLOCAL_8, <?=StringHash(name)?>)
#define YDLocal8ArrayGet(type, name, index)        YDHashGet(YDLOC, type, YDLOCAL_8, <?=StringHash(name)?> + (index))
# //  附属动作块
#define YDLOCAL_9                                  StarBlockKey
#define YDLocal9Set(type, name, value)             YDHashSet(YDLOC, type, YDLOCAL_9, <?=StringHash(name)?>, value)
#define YDLocal9ArraySet(type, name, index, value) YDHashSet(YDLOC, type, YDLOCAL_9, <?=StringHash(name)?> + (index), value)
#define YDLocal9Get(type, name)                    YDHashGet(YDLOC, type, YDLOCAL_9, <?=StringHash(name)?>)
#define YDLocal9ArrayGet(type, name, index)        YDHashGet(YDLOC, type, YDLOCAL_9, <?=StringHash(name)?> + (index))

#define YDLocalXSet(page, type, name, value)             YDHashSet(YDLOC, type, (G_SIndex), <?=StringHash(name)?>, value)
#define YDLocalXArraySet(page, type, name, index, value) YDHashSet(YDLOC, type, (G_SIndex), <?=StringHash(name)?> + (index), value)
#define YDLocalXGet(page, type, name)                    YDHashGet(YDLOC, type, (G_SIndex), <?=StringHash(name)?>)
#define YDLocalXArrayGet(page, type, name, index)        YDHashGet(YDLOC, type, (G_SIndex), <?=StringHash(name)?> + (index))
#define YDLocalXRelease(page)                            YDHashClearTable(YDLOC, (G_SIndex))
# // 6.  界面动作
#define YDLocal6Set(page, type, name, value)             YDHashSet(YDLOC, type, <?=StringHash(page)?>, <?=StringHash(name)?>, value)
#define YDLocal6ArraySet(page, type, name, index, value) YDHashSet(YDLOC, type, <?=StringHash(page)?>, <?=StringHash(name)?> + (index), value)
#define YDLocal6Get(page, type, name)                    YDHashGet(YDLOC, type, <?=StringHash(page)?>, <?=StringHash(name)?>)
#define YDLocal6ArrayGet(page, type, name, index)        YDHashGet(YDLOC, type, <?=StringHash(page)?>, <?=StringHash(name)?> + (index))
#define YDLocal6Release(page)                            YDHashClearTable(YDLOC, <?=StringHash(page)?>)
#
# //#define YDLocalSet(page, type, name, value)             YDHashSet(YDLOC, type, YDHashH2I(page), <?=StringHash(name)?>, value)
# //#define YDLocalArraySet(page, type, name, index, value) YDHashSet(YDLOC, type, YDHashH2I(page), <?=StringHash(name)?> + (index), value)
# //#define YDLocalGet(page, type, name)                    YDHashGet(YDLOC, type, YDHashH2I(page), <?=StringHash(name)?>)
# //#define YDLocalArrayGet(page, type, name, index)        YDHashGet(YDLOC, type, YDHashH2I(page), <?=StringHash(name)?> + (index))
# //#define YDLocalRelease(page)                            YDHashClearTable(YDLOC, YDHashH2I(page))
# // 逆天计时器/逆天触发器
#define YDLocalSet(page, type, name, value)             YDHashSet(YDLOC, type, G_SIndex, <?=StringHash(name)?>, value)
#define YDLocalArraySet(page, type, name, index, value) YDHashSet(YDLOC, type, G_SIndex, <?=StringHash(name)?> + (index), value)
#define YDLocalGet(page, type, name)                    YDHashGet(YDLOC, type, G_LIndex, <?=StringHash(name)?>)
#define YDLocalArrayGet(page, type, name, index)        YDHashGet(YDLOC, type, G_LIndex, <?=StringHash(name)?> + (index))
#define YDLocalRelease(page)                            YDHashClearTable(YDLOC,G_SIndex)YDNL\
    set G_SIndex = L_LIndex    YDNL\
    set G_LIndex = L_LIndex
#
#endif

#else
# /*
#  *  局部变量、自定义值
#  *  
#  *  By actboy168
#  *
#  */
#
#ifndef INCLUDE_YDTRIGGER_HASH_H
#define INCLUDE_YDTRIGGER_HASH_H
#
#define YDUserDataClearTable(table_type, table) YDHashClearTable(YDHASH_HANDLE, YDHashAny2I(table_type, table))
#define YDUserDataClear(table_type, table, attribute, value_type) YDHashClear(YDHASH_HANDLE, value_type, YDHashAny2I(table_type, table), <?=StringHash(attribute)?>)
#define YDUserDataSet(table_type, table, attribute, value_type, value) YDHashSet(YDHASH_HANDLE, value_type, YDHashAny2I(table_type, table), <?=StringHash(attribute)?>, value)
#define YDUserDataGet(table_type, table, attribute, value_type) YDHashGet(YDHASH_HANDLE, value_type, YDHashAny2I(table_type, table), <?=StringHash(attribute)?>)
//Star 
#define YDUserDataSet2(table_type, table, attribute, value_type, value) YDHashSet(YDHASH_HANDLE, value_type, YDHashAny2I(table_type, table), StringHash(##attribute), value)
#define YDUserDataGet2(table_type, table, attribute, value_type) YDHashGet(YDHASH_HANDLE, value_type, YDHashAny2I(table_type, table), StringHash(##attribute))
#define YDUserDataClear2(table_type, table, value_type, attribute) YDHashClear(YDHASH_HANDLE, value_type, YDHashAny2I(table_type, table), StringHash(##attribute))
#define YDUserDataHas2(table_type, table, value_type, attribute) YDHashHas(YDHASH_HANDLE, value_type, YDHashAny2I(table_type, table), StringHash(##attribute))

#define YDUserDataHas(table_type, table, attribute, value_type) YDHashHas(YDHASH_HANDLE, value_type, YDHashAny2I(table_type, table), <?=StringHash(attribute)?>)
#
#
#  // GlobalsTriggerRunSteps & TriggerRunSteps
#define YDLocalInitialize() \
    local integer ydl_localvar_step = YDHashGet(YDLOC, integer, YDHashH2I(GetTriggeringTrigger()), 0xCFDE6C76) YDNL\
    set ydl_localvar_step = ydl_localvar_step + 3 YDNL\
    call YDHashSet(YDLOC, integer, YDHashH2I(GetTriggeringTrigger()), 0xCFDE6C76, ydl_localvar_step)           YDNL\
    call YDHashSet(YDLOC, integer, YDHashH2I(GetTriggeringTrigger()), 0xECE825E7, ydl_localvar_step)
    // if ydl_localvar_step>250000 then YDNL\
    //     set ydl_localvar_step = ydl_localvar_step - 250000 YDNL \
    // endif YDNL\
    // call YDHashSet(YDLOC, integer, YDHashH2I(GetTriggeringTrigger()), 0xCFDE6C76, ydl_localvar_step)           YDNL\
    // call YDHashSet(YDLOC, integer, YDHashH2I(GetTriggeringTrigger()), 0xECE825E7, ydl_localvar_step)
#   //尝试修复逆天变量计数与handle碰撞 -- when 逆天-触发器运行
#define YDLocalExecuteTrigger(trg) \
    set ydl_triggerstep = YDHashH2I(trg)*(YDHashGet(YDLOC, integer, YDHashH2I(trg), 0xCFDE6C76) + 3) YDNL\
    // if ydl_triggerstep>60000 then YDNL\
    //     set ydl_triggerstep = 1000 YDNL \
    //     call YDHashSet(YDLOC, integer, YDHashH2I(trg), 0xCFDE6C76, ydl_triggerstep)           YDNL\
    // endif 
    
#define YDLocalReset()                             YDHashSet(YDLOC, integer, YDHashH2I(GetTriggeringTrigger()), 0xECE825E7, ydl_localvar_step)
# // 1.
#define YDLOCAL_1                                  YDHashH2I(GetTriggeringTrigger())*ydl_localvar_step
#define YDLocal1Set(type, name, value)             YDHashSet(YDLOC, type, YDLOCAL_1, <?=StringHash(name)?>, value)
#define YDLocal1ArraySet(type, name, index, value) YDHashSet(YDLOC, type, YDLOCAL_1, <?=StringHash(name)?> + (index), value)
#define YDLocal1Get(type, name)                    YDHashGet(YDLOC, type, YDLOCAL_1, <?=StringHash(name)?>)
#define YDLocal1ArrayGet(type, name, index)        YDHashGet(YDLOC, type, YDLOCAL_1, <?=StringHash(name)?> + (index))
#define YDLocal1Release()                          YDHashClearTable(YDLOC, YDLOCAL_1)
# // 2.
#define YDLOCAL_2                                  YDHashH2I(GetTriggeringTrigger())*YDHashGet(YDLOC, integer, YDHashH2I(GetTriggeringTrigger()), 0xECE825E7)
#define YDLocal2Set(type, name, value)             YDHashSet(YDLOC, type, YDLOCAL_2, <?=StringHash(name)?>, value)
#define YDLocal2ArraySet(type, name, index, value) YDHashSet(YDLOC, type, YDLOCAL_2, <?=StringHash(name)?> + (index), value)
#define YDLocal2Get(type, name)                    YDHashGet(YDLOC, type, YDLOCAL_2, <?=StringHash(name)?>)
#define YDLocal2ArrayGet(type, name, index)        YDHashGet(YDLOC, type, YDLOCAL_2, <?=StringHash(name)?> + (index))
# // 3.
#define YDLOCAL_3                                  YDHashH2I(GetExpiredTimer())
#define YDLocal3Set(type, name, value)             YDHashSet(YDLOC, type, YDLOCAL_3, <?=StringHash(name)?>, value)
#define YDLocal3ArraySet(type, name, index, value) YDHashSet(YDLOC, type, YDLOCAL_3, <?=StringHash(name)?> + (index), value)
#define YDLocal3Get(type, name)                    YDHashGet(YDLOC, type, YDLOCAL_3, <?=StringHash(name)?>)
#define YDLocal3ArrayGet(type, name, index)        YDHashGet(YDLOC, type, YDLOCAL_3, <?=StringHash(name)?> + (index))
#define YDLocal3Release()                          YDHashClearTable(YDLOC, YDLOCAL_3)
# // 4.
#define YDLOCAL_4                                  YDHashH2I(GetTriggeringTrigger())
#define YDLocal4Set(type, name, value)             YDHashSet(YDLOC, type, YDLOCAL_4, <?=StringHash(name)?>, value)
#define YDLocal4ArraySet(type, name, index, value) YDHashSet(YDLOC, type, YDLOCAL_4, <?=StringHash(name)?> + (index), value)
#define YDLocal4Get(type, name)                    YDHashGet(YDLOC, type, YDLOCAL_4, <?=StringHash(name)?>)
#define YDLocal4ArrayGet(type, name, index)        YDHashGet(YDLOC, type, YDLOCAL_4, <?=StringHash(name)?> + (index))
#define YDLocal4Release()                          YDHashClearTable(YDLOC, YDLOCAL_4)
# // 5.
#define YDLOCAL_5                                  ydl_triggerstep
#define YDLocal5Set(type, name, value)             YDHashSet(YDLOC, type, YDLOCAL_5, <?=StringHash(name)?>, value)
#define YDLocal5ArraySet(type, name, index, value) YDHashSet(YDHASH_HYDLOCANDLE, type, YDLOCAL_5, <?=StringHash(name)?> + (index), value)
#define YDLocal5Get(type, name)                    YDHashGet(YDLOC, type, YDLOCAL_5, <?=StringHash(name)?>)
#define YDLocal5ArrayGet(type, name, index)        YDHashGet(YDLOC, type, YDLOCAL_5, <?=StringHash(name)?> + (index))
# // 7.   
#define YDLOCAL_7                                  Star_PIndex
#define YDLocal7Set(type, name, value)             YDHashSet(YDLOC, type, YDLOCAL_7, <?=StringHash(name)?>, value)
#define YDLocal7ArraySet(type, name, index, value) YDHashSet(YDLOC, type, YDLOCAL_7, <?=StringHash(name)?> + (index), value)
#define YDLocal7Get(type, name)                    YDHashGet(YDLOC, type, YDLOCAL_7, <?=StringHash(name)?>)
#define YDLocal7ArrayGet(type, name, index)        YDHashGet(YDLOC, type, YDLOCAL_7, <?=StringHash(name)?> + (index))

#define YDLOCAL_8                                  StarLuaKey
#define YDLocal8Set(type, name, value)             YDHashSet(YDLOC, type, YDLOCAL_8, <?=StringHash(name)?>, value)
#define YDLocal8ArraySet(type, name, index, value) YDHashSet(YDLOC, type, YDLOCAL_8, <?=StringHash(name)?> + (index), value)
#define YDLocal8Get(type, name)                    YDHashGet(YDLOC, type, YDLOCAL_8, <?=StringHash(name)?>)
#define YDLocal8ArrayGet(type, name, index)        YDHashGet(YDLOC, type, YDLOCAL_8, <?=StringHash(name)?> + (index))

#define YDLOCAL_9                                  StarBlockKey
#define YDLocal9Set(type, name, value)             YDHashSet(YDLOC, type, YDLOCAL_9, <?=StringHash(name)?>, value)
#define YDLocal9ArraySet(type, name, index, value) YDHashSet(YDLOC, type, YDLOCAL_9, <?=StringHash(name)?> + (index), value)
#define YDLocal9Get(type, name)                    YDHashGet(YDLOC, type, YDLOCAL_9, <?=StringHash(name)?>)
#define YDLocal9ArrayGet(type, name, index)        YDHashGet(YDLOC, type, YDLOCAL_9, <?=StringHash(name)?> + (index))

#define YDLocalXSet(page, type, name, value)             YDHashSet(YDLOC, type, (page), <?=StringHash(name)?>, value)
#define YDLocalXArraySet(page, type, name, index, value) YDHashSet(YDLOC, type, (page), <?=StringHash(name)?> + (index), value)
#define YDLocalXGet(page, type, name)                    YDHashGet(YDLOC, type, (page), <?=StringHash(name)?>)
#define YDLocalXArrayGet(page, type, name, index)        YDHashGet(YDLOC, type, (page), <?=StringHash(name)?> + (index))
#define YDLocalXRelease(page)                            YDHashClearTable(YDLOC, (page))
# // 6.
#define YDLocal6Set(page, type, name, value)             YDHashSet(YDLOC, type, <?=StringHash(page)?>, <?=StringHash(name)?>, value)
#define YDLocal6ArraySet(page, type, name, index, value) YDHashSet(YDLOC, type, <?=StringHash(page)?>, <?=StringHash(name)?> + (index), value)
#define YDLocal6Get(page, type, name)                    YDHashGet(YDLOC, type, <?=StringHash(page)?>, <?=StringHash(name)?>)
#define YDLocal6ArrayGet(page, type, name, index)        YDHashGet(YDLOC, type, <?=StringHash(page)?>, <?=StringHash(name)?> + (index))
#define YDLocal6Release(page)                            YDHashClearTable(YDLOC, <?=StringHash(page)?>)
#
#define YDLocalSet(page, type, name, value)             YDHashSet(YDLOC, type, YDHashH2I(page), <?=StringHash(name)?>, value)
#define YDLocalArraySet(page, type, name, index, value) YDHashSet(YDLOC, type, YDHashH2I(page), <?=StringHash(name)?> + (index), value)
#define YDLocalGet(page, type, name)                    YDHashGet(YDLOC, type, YDHashH2I(page), <?=StringHash(name)?>)
#define YDLocalArrayGet(page, type, name, index)        YDHashGet(YDLOC, type, YDHashH2I(page), <?=StringHash(name)?> + (index))
#define YDLocalRelease(page)                            YDHashClearTable(YDLOC, YDHashH2I(page))
#
#endif


#endif
