--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local cameraFunc = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local sdrDebug = require("lib.扩展函数.Star扩展函数.Star扩展库.01．SDR调试计时器")
local starEvent = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local suspend = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local fastBuff = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
local overSpeed = require("lib.扩展函数.Star扩展函数.Star扩展库.05．移动速度突破系统")
local xLibSafe = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local effectGroup = require("lib.扩展函数.Star扩展函数.Star扩展库.07．特效组系统")
local unitCondition = require("lib.扩展函数.Star扩展函数.Star扩展库.08．单位判定与筛选函数")
local unitBase = require("lib.扩展函数.Star扩展函数.Star扩展库.09．单位基础与生命周期函数")
local heroAttr = require("lib.扩展函数.Star扩展函数.Star扩展库.10．英雄属性与攻击力函数")
local dirFunc = require("lib.扩展函数.Star扩展函数.Star扩展库.11．方位判断函数")
local starBase = require("lib.扩展函数.Star扩展函数.Star扩展库.12．StarBase基础函数")
do
    local ____export = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.Star扩展库.01．SDR调试计时器")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.Star扩展库.05．移动速度突破系统")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.Star扩展库.07．特效组系统")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.Star扩展库.08．单位判定与筛选函数")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.Star扩展库.09．单位基础与生命周期函数")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.Star扩展库.10．英雄属性与攻击力函数")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.Star扩展库.11．方位判断函数")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.Star扩展库.12．StarBase基础函数")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local function expose(self, name, fn)
    if type(fn) ~= "function" then
        return
    end
    local g = _G
    if type(g[name]) == "function" then
        return
    end
    g[name] = fn
end
function ____exports.registerBridge(self)
    expose(nil, "StarOther_PanCameraToTimedUnitForPlayer", cameraFunc.StarOther_PanCameraToTimedUnitForPlayer)
    expose(nil, "StarOther_PanCameraToTimedForPlayer", cameraFunc.StarOther_PanCameraToTimedForPlayer)
    expose(nil, "SDR_DebugTimer", sdrDebug.SDR_DebugTimer)
    expose(nil, "STES_Register", starEvent.STES_Register)
    expose(nil, "STES_RegisterEx", starEvent.STES_RegisterEx)
    expose(nil, "STES_GetTable", starEvent.STES_GetTable)
    expose(nil, "STES_Fire", starEvent.STES_Fire)
    expose(nil, "STES_FireWithReal11Step", starEvent.STES_FireWithReal11Step)
    expose(nil, "STES_Execute", starEvent.STES_Execute)
    expose(nil, "STES_GetUnitEvent", starEvent.STES_GetUnitEvent)
    expose(nil, "STES_RemoveEvent", starEvent.STES_RemoveEvent)
    expose(nil, "STES_Remove", starEvent.STES_Remove)
    expose(nil, "GS_Suspend", suspend.GS_Suspend)
    expose(nil, "GS_IsUnitSuspending", suspend.GS_IsUnitSuspending)
    expose(nil, "GS_LoadSuspend", suspend.GS_LoadSuspend)
    expose(nil, "GS_UnitSuspend", suspend.GS_UnitSuspend)
    expose(nil, "GS_AcquireUnitPause", suspend["申请单位暂停占用"])
    expose(nil, "GS_ReleaseUnitPause", suspend["释放单位暂停占用"])
    expose(nil, "GS_AcquireUnitPauseUnique", suspend["申请单位暂停独立占用"])
    expose(nil, "GS_SetUnitPauseUnique", suspend["设置单位暂停独立占用"])
    expose(nil, "GS_ReleaseUnitPauseSourceAll", suspend["释放单位暂停来源全部"])
    expose(nil, "GS_ClearUnitPauseAll", suspend["清除单位全部暂停占用"])
    expose(nil, "GS_AcquireUnitPauseTimed", suspend["申请单位暂停占用定时"])
    expose(nil, "GS_CancelUnitPauseTimed", suspend["取消单位暂停占用定时"])
    expose(nil, "GS_HasUnitPauseOccupancy", suspend["单位是否存在暂停占用"])
    expose(nil, "GS_HasOtherUnitPauseOccupancy", suspend["单位是否存在其他暂停占用"])
    expose(nil, "GS_GetUnitPauseOccupancyCount", suspend["获取单位暂停占用总数"])
    expose(nil, "GS_GetUnitPauseSourceCount", suspend["获取单位暂停来源计数"])
    expose(nil, "GS_GetUnitPauseSources", suspend["获取单位暂停来源列表"])
    expose(nil, "GS_GetUnitPauseSnapshot", suspend["获取单位暂停快照"])
    expose(nil, "GS_RefreshUnitPauseState", suspend["刷新单位暂停底层状态"])
    expose(nil, "SFB_setBuff", fastBuff.SFB_setBuff)
    expose(nil, "SFB_setSlow", fastBuff.SFB_setSlow)
    expose(nil, "SFB_Init", fastBuff.SFB_Init)
    expose(nil, "SOS_SetUnitSpeed", overSpeed.SOS_SetUnitSpeed)
    expose(nil, "SOS_SetUnitSpeedTemp", overSpeed.SOS_SetUnitSpeedTemp)
    expose(nil, "SOS_GetUnitSpeed", overSpeed.SOS_GetUnitSpeed)
    expose(nil, "SOS_UnSetUnitSpeed", overSpeed.SOS_UnSetUnitSpeed)
    expose(nil, "X_IsTerrainWalkable", xLibSafe.X_IsTerrainWalkableSafe)
    expose(nil, "X_IsTerrainWalkableSafe", xLibSafe.X_IsTerrainWalkableSafe)
    expose(nil, "X_IsUnitTerrainWalkable", xLibSafe.X_IsUnitTerrainWalkableSafe)
    expose(nil, "X_IsUnitTerrainWalkableSafe", xLibSafe.X_IsUnitTerrainWalkableSafe)
    expose(nil, "X_GetAbleX", xLibSafe.X_GetAbleXSafe)
    expose(nil, "X_GetAbleXSafe", xLibSafe.X_GetAbleXSafe)
    expose(nil, "X_GetAbleY", xLibSafe.X_GetAbleYSafe)
    expose(nil, "X_GetAbleYSafe", xLibSafe.X_GetAbleYSafe)
    expose(nil, "X_IsTerrainDeepWater", xLibSafe.X_IsTerrainDeepWaterSafe)
    expose(nil, "X_IsTerrainDeepWaterSafe", xLibSafe.X_IsTerrainDeepWaterSafe)
    expose(nil, "X_IsTerrainShallowWater", xLibSafe.X_IsTerrainShallowWaterSafe)
    expose(nil, "X_IsTerrainShallowWaterSafe", xLibSafe.X_IsTerrainShallowWaterSafe)
    expose(nil, "X_IsTerrainLand", xLibSafe.X_IsTerrainLandSafe)
    expose(nil, "X_IsTerrainLandSafe", xLibSafe.X_IsTerrainLandSafe)
    expose(nil, "X_IsTerrainPlatform", xLibSafe.X_IsTerrainPlatformSafe)
    expose(nil, "X_IsTerrainPlatformSafe", xLibSafe.X_IsTerrainPlatformSafe)
    expose(nil, "X_SetUnitMovable", xLibSafe.X_SetUnitMovableSafe)
    expose(nil, "X_SetUnitMovableSafe", xLibSafe.X_SetUnitMovableSafe)
    expose(nil, "X_FixUnitStandingSafe", xLibSafe.X_FixUnitStandingSafe)
    expose(nil, "X_RestoreUnitStandingSafe", xLibSafe.X_RestoreUnitStandingSafe)
    expose(nil, "X_GDBC", xLibSafe.X_GDBCSafe)
    expose(nil, "X_GDBCSafe", xLibSafe.X_GDBCSafe)
    expose(nil, "X_GAFC", xLibSafe.X_GAFCSafe)
    expose(nil, "X_GAFCSafe", xLibSafe.X_GAFCSafe)
    expose(nil, "X_R2I2", xLibSafe.X_R2I2Safe)
    expose(nil, "X_R2I2Safe", xLibSafe.X_R2I2Safe)
    expose(nil, "EG_CreateEffectGroup", effectGroup.EG_CreateEffectGroup)
    expose(nil, "EG_RemoveGroup", effectGroup.EG_RemoveGroup)
    expose(nil, "EG_ClearGroup", effectGroup.EG_ClearGroup)
    expose(nil, "EG_GroupAddEffect", effectGroup.EG_GroupAddEffect)
    expose(nil, "EG_GroupAddEffectEx", effectGroup.EG_GroupAddEffectEx)
    expose(nil, "EG_RemoveEffectOfGroup", effectGroup.EG_RemoveEffectOfGroup)
    expose(nil, "EG_ForGroup", effectGroup.EG_ForGroup)
    expose(nil, "EG_GetFirstOfGroup", effectGroup.EG_GetFirstOfGroup)
    expose(nil, "EG_GetRandomOfGroup", effectGroup.EG_GetRandomOfGroup)
    expose(nil, "EG_IsEffectOnGroup", effectGroup.EG_IsEffectOnGroup)
    expose(nil, "EG_IsGroupHaveEffect", effectGroup.EG_IsGroupHaveEffect)
    expose(nil, "EG_IsGroupEmpty", effectGroup.EG_IsGroupEmpty)
    expose(nil, "EG_GetCount", effectGroup.EG_GetCount)
    expose(nil, "EG_GetAt", effectGroup.EG_GetAt)
    expose(nil, "EG_GroupAddGroup", effectGroup.EG_GroupAddGroup)
    expose(nil, "EG_I2EG", effectGroup.EG_I2EG)
    expose(nil, "EG_EG2I", effectGroup.EG_EG2I)
    expose(nil, "SUC_IsValidUnit", unitCondition.SUC_IsValidUnit)
    expose(nil, "SUC_GetFilterUnitOrNull", unitCondition.SUC_GetFilterUnitOrNull)
    expose(nil, "SUC_GetUnitLife", unitCondition.SUC_GetUnitLife)
    expose(nil, "SUC_IsUnitAlive", unitCondition.SUC_IsUnitAlive)
    expose(nil, "SUC_IsUnitStructure", unitCondition.SUC_IsUnitStructure)
    expose(nil, "SUC_IsUnitInvincible", unitCondition.SUC_IsUnitInvincible)
    expose(nil, "SUC_IsUnitEnemyToUnit", unitCondition.SUC_IsUnitEnemyToUnit)
    expose(nil, "SUC_IsUnitAllyToUnit", unitCondition.SUC_IsUnitAllyToUnit)
    expose(nil, "SUC_MatchBasicTarget", unitCondition.SUC_MatchBasicTarget)
    expose(nil, "SUF_Base_1", unitCondition.SUF_Base_1)
    expose(nil, "SUF_Base_2", unitCondition.SUF_Base_2)
    expose(nil, "SUF_Base_3", unitCondition.SUF_Base_3)
    expose(nil, "SU_IsUnitInvincible", unitBase.SU_IsUnitInvincible)
    expose(nil, "SU_SetUnitFlyHeight", unitBase.SU_SetUnitFlyHeight)
    expose(nil, "SU_GetHeroAllState", unitBase.SU_GetHeroAllState)
    expose(nil, "SU_GetUnitLostHPPercent", unitBase.SU_GetUnitLostHPPercent)
    expose(nil, "SU_GetUnitLostHP", unitBase.SU_GetUnitLostHP)
    expose(nil, "UnitAddHp", unitBase.UnitAddHp)
    expose(nil, "SU_IsUnitDie", unitBase.SU_IsUnitDie)
    expose(nil, "SU_ShowOrHideUnit", unitBase.SU_ShowOrHideUnit)
    expose(nil, "IsWaterElement", unitBase.IsWaterElement)
    expose(nil, "GetUnitTimedLifeID", unitBase.GetUnitTimedLifeID)
    expose(nil, "I2TimedLifeID", unitBase.I2TimedLifeID)
    expose(nil, "SU_GetUnitModel", heroAttr.SU_GetUnitModel)
    expose(nil, "SU_GetHeroParmary", heroAttr.SU_GetHeroParmary)
    expose(nil, "SU_AddHeroState", heroAttr.SU_AddHeroState)
    expose(nil, "SU_GetHeroParmaryValue", heroAttr.SU_GetHeroParmaryValue)
    expose(nil, "SU_AddHeroAllState", heroAttr.SU_AddHeroAllState)
    expose(nil, "SU_SetHeroParmaryValue", heroAttr.SU_SetHeroParmaryValue)
    expose(nil, "SU_HeroISParmary", heroAttr.SU_HeroISParmary)
    expose(nil, "SU_GetUnitWhiteAtk", heroAttr.SU_GetUnitWhiteAtk)
    expose(nil, "是否在指定角度范围内", dirFunc["是否在指定角度范围内"])
    expose(nil, "是否在前方角度内", dirFunc["是否在前方角度内"])
    expose(nil, "是否在后方角度内", dirFunc["是否在后方角度内"])
    expose(nil, "是否在正前方", dirFunc["是否在正前方"])
    expose(nil, "是否在正后方", dirFunc["是否在正后方"])
    expose(nil, "是否在左侧", dirFunc["是否在左侧"])
    expose(nil, "是否在右侧", dirFunc["是否在右侧"])
    expose(nil, "是否在前方", dirFunc["是否在前方"])
    expose(nil, "是否在后方", dirFunc["是否在后方"])
    expose(nil, "获取方位区间", dirFunc["获取方位区间"])
    expose(nil, "SU_DotBehindUnit", dirFunc.SU_DotBehindUnit)
    expose(nil, "SU_GetUnitOfUnit", dirFunc.SU_GetUnitOfUnit)
    expose(nil, "SU_IsUnitInfrontUnit2", dirFunc.SU_IsUnitInfrontUnit2)
    expose(nil, "SU_IsUnitInfrontUnit", dirFunc.SU_IsUnitInfrontUnit)
    expose(nil, "SU_IsUnitBehindUnit", dirFunc.SU_IsUnitBehindUnit)
    expose(nil, "Star_CoordinateX", starBase.Star_CoordinateX)
    expose(nil, "Star_CoordinateY", starBase.Star_CoordinateY)
    expose(nil, "Star_GetLocZ", starBase.Star_GetLocZ)
    expose(nil, "GetRectByHandle", starBase.GetRectByHandle)
end
return ____exports
