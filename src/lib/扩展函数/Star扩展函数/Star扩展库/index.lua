--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local cameraFunc = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local sdrDebug = require("lib.扩展函数.Star扩展函数.Star扩展库.01．SDR调试计时器")
local starEvent = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local suspend = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local fastBuff = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
local overSpeed = require("lib.扩展函数.Star扩展函数.Star扩展库.05．移动速度突破系统")
local xLib = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数")
local effectGroup = require("lib.扩展函数.Star扩展函数.Star扩展库.07．特效组系统")
local unitCondition = require("lib.扩展函数.Star扩展函数.Star扩展库.08．单位判定与筛选函数")
local unitBase = require("lib.扩展函数.Star扩展函数.Star扩展库.09．单位基础与生命周期函数")
local unitAttr = require("lib.扩展函数.Star扩展函数.Star扩展库.10．单位属性方位与攻击函数")
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
    local ____export = require("lib.扩展函数.Star扩展函数.Star扩展库.10．单位属性方位与攻击函数")
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
    expose(nil, "SFB_setBuff", fastBuff.SFB_setBuff)
    expose(nil, "SFB_setSlow", fastBuff.SFB_setSlow)
    expose(nil, "SFB_Init", fastBuff.SFB_Init)
    expose(nil, "SOS_SetUnitSpeed", overSpeed.SOS_SetUnitSpeed)
    expose(nil, "SOS_SetUnitSpeedTemp", overSpeed.SOS_SetUnitSpeedTemp)
    expose(nil, "SOS_GetUnitSpeed", overSpeed.SOS_GetUnitSpeed)
    expose(nil, "SOS_UnSetUnitSpeed", overSpeed.SOS_UnSetUnitSpeed)
    expose(nil, "X_IsTerrainWalkable", xLib.X_IsTerrainWalkable)
    expose(nil, "X_IsUnitTerrainWalkable", xLib.X_IsUnitTerrainWalkable)
    expose(nil, "X_GetAbleX", xLib.X_GetAbleX)
    expose(nil, "X_GetAbleY", xLib.X_GetAbleY)
    expose(nil, "X_IsTerrainDeepWater", xLib.X_IsTerrainDeepWater)
    expose(nil, "X_IsTerrainShallowWater", xLib.X_IsTerrainShallowWater)
    expose(nil, "X_IsTerrainLand", xLib.X_IsTerrainLand)
    expose(nil, "X_IsTerrainPlatform", xLib.X_IsTerrainPlatform)
    expose(nil, "X_SetUnitMovable", xLib.X_SetUnitMovable)
    expose(nil, "X_GDBC", xLib.X_GDBC)
    expose(nil, "X_GAFC", xLib.X_GAFC)
    expose(nil, "X_R2I2", xLib.X_R2I2)
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
    expose(nil, "SU_GetUnitModel", unitAttr.SU_GetUnitModel)
    expose(nil, "SU_GetHeroParmary", unitAttr.SU_GetHeroParmary)
    expose(nil, "SU_AddHeroState", unitAttr.SU_AddHeroState)
    expose(nil, "SU_GetHeroParmaryValue", unitAttr.SU_GetHeroParmaryValue)
    expose(nil, "SU_AddHeroAllState", unitAttr.SU_AddHeroAllState)
    expose(nil, "SU_SetHeroParmaryValue", unitAttr.SU_SetHeroParmaryValue)
    expose(nil, "SU_HeroISParmary", unitAttr.SU_HeroISParmary)
    expose(nil, "SU_DotBehindUnit", unitAttr.SU_DotBehindUnit)
    expose(nil, "SU_GetUnitOfUnit", unitAttr.SU_GetUnitOfUnit)
    expose(nil, "SU_IsUnitInfrontUnit2", unitAttr.SU_IsUnitInfrontUnit2)
    expose(nil, "SU_IsUnitInfrontUnit", unitAttr.SU_IsUnitInfrontUnit)
    expose(nil, "SU_IsUnitBehindUnit", unitAttr.SU_IsUnitBehindUnit)
    expose(nil, "SU_GetUnitWhiteAtk", unitAttr.SU_GetUnitWhiteAtk)
    expose(nil, "Star_CoordinateX", starBase.Star_CoordinateX)
    expose(nil, "Star_CoordinateY", starBase.Star_CoordinateY)
    expose(nil, "Star_GetLocZ", starBase.Star_GetLocZ)
    expose(nil, "GetRectByHandle", starBase.GetRectByHandle)
end
return ____exports
