--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local trigEvent = require("lib.扩展函数.BJ函数.01．触发与事件")
local unitHero = require("lib.扩展函数.BJ函数.02．单位与英雄")
local itemInv = require("lib.扩展函数.BJ函数.03．物品与库存")
local rectArea = require("lib.扩展函数.BJ函数.04．矩形与区域")
local cine = require("lib.扩展函数.BJ函数.05A．电影函数")
local sound = require("lib.扩展函数.BJ函数.05B．音效函数")
local questMsg = require("lib.扩展函数.BJ函数.06．任务消息")
local misc = require("lib.扩展函数.BJ函数.07．杂项")
local unitBjExt = require("lib.扩展函数.BJ函数.08．单位BJ扩展")
local imageBj = require("lib.扩展函数.BJ函数.10．图像函数")
local ubersplatBj = require("lib.扩展函数.BJ函数.11．贴图函数")
local mathBj = require("lib.扩展函数.BJ函数.12．数学函数")
local multiboardBj = require("lib.扩展函数.BJ函数.13．多面板函数")
do
    local ____export = require("lib.扩展函数.BJ函数.00．BJ全局兜底")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.BJ函数.01．触发与事件")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.BJ函数.02．单位与英雄")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.BJ函数.03．物品与库存")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.BJ函数.04．矩形与区域")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.BJ函数.05A．电影函数")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.BJ函数.05B．音效函数")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.BJ函数.06．任务消息")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.BJ函数.07．杂项")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.BJ函数.08．单位BJ扩展")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.BJ函数.09．物品操作")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.BJ函数.10．图像函数")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.BJ函数.11．贴图函数")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.BJ函数.12．数学函数")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.BJ函数.12．数学函数")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.BJ函数.13．多面板函数")
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
    expose(nil, "TriggerRegisterAnyUnitEventBJ", trigEvent.TriggerRegisterAnyUnitEventBJ)
    expose(nil, "GetUnitCurrentOrder", unitHero.GetUnitCurrentOrder)
    expose(nil, "IsUnitDeadBJ", unitHero.IsUnitDeadBJ)
    expose(nil, "IsUnitAliveBJ", unitHero.IsUnitAliveBJ)
    expose(nil, "GetHeroStatBJ", unitHero.GetHeroStatBJ)
    expose(nil, "ModifyHeroStat", unitHero.ModifyHeroStat)
    expose(nil, "GetUnitManaPercentBJ", unitHero.GetUnitManaPercentBJ)
    expose(nil, "SetUnitManaPercentBJ", unitHero.SetUnitManaPercentBJ)
    expose(nil, "GetUnitLifePercentBJ", unitHero.GetUnitLifePercentBJ)
    expose(nil, "SetUnitLifePercentBJ", unitHero.SetUnitLifePercentBJ)
    expose(nil, "GetUnitLifePercent", unitHero.GetUnitLifePercent)
    expose(nil, "GetUnitManaPercent", unitHero.GetUnitManaPercent)
    expose(nil, "SetUnitLifeBJ", unitHero.SetUnitLifeBJ)
    expose(nil, "SetUnitManaBJ", unitHero.SetUnitManaBJ)
    expose(nil, "RemoveItemFromStockBJ", itemInv.RemoveItemFromStockBJ)
    expose(nil, "AddItemToStockBJ", itemInv.AddItemToStockBJ)
    expose(nil, "AddUnitToStockBJ", itemInv.AddUnitToStockBJ)
    expose(nil, "RemoveUnitFromStockBJ", itemInv.RemoveUnitFromStockBJ)
    expose(nil, "GetInventoryIndexOfItemTypeBJ", itemInv.GetInventoryIndexOfItemTypeBJ)
    expose(nil, "GetItemOfTypeFromUnitBJ", itemInv.GetItemOfTypeFromUnitBJ)
    expose(nil, "GetItemTypeCountInUnitBJ", itemInv.GetItemTypeCountInUnitBJ)
    expose(nil, "RemoveItemTypeFromUnitBJ", itemInv.RemoveItemTypeFromUnitBJ)
    expose(nil, "RectContainsCoords", rectArea.RectContainsCoords)
    expose(nil, "RectContainsLoc", rectArea.RectContainsLoc)
    expose(nil, "RectContainsUnit", rectArea.RectContainsUnit)
    expose(nil, "SetStackedSoundBJ", rectArea.SetStackedSoundBJ)
    expose(nil, "GetEntireMapRect", rectArea.GetEntireMapRect)
    expose(nil, "TriggerRegisterUnitInRangeSimple", trigEvent.TriggerRegisterUnitInRangeSimple)
    expose(nil, "GetAttackedUnitBJ", trigEvent.GetAttackedUnitBJ)
    expose(nil, "ConditionalTriggerExecute", trigEvent.ConditionalTriggerExecute)
    expose(nil, "AbortCinematicFadeBJ", cine.AbortCinematicFadeBJ)
    expose(nil, "PlaySoundBJ", sound.PlaySoundBJ)
    expose(nil, "SetCinematicSceneBJ", cine.SetCinematicSceneBJ)
    expose(nil, "DoTransmissionBasicsXYBJ", cine.DoTransmissionBasicsXYBJ)
    expose(nil, "TryInitCinematicBehaviorBJ", cine.TryInitCinematicBehaviorBJ)
    expose(nil, "TransmissionFromUnitWithNameBJ", cine.TransmissionFromUnitWithNameBJ)
    expose(nil, "PercentToInt", mathBj.PercentToInt)
    expose(nil, "PercentTo255", mathBj.PercentTo255)
    expose(nil, "CinematicModeExBJ", cine.CinematicModeExBJ)
    expose(nil, "CinematicModeBJ", cine.CinematicModeBJ)
    expose(nil, "CinematicFilterGenericBJ", cine.CinematicFilterGenericBJ)
    expose(nil, "StopSoundBJ", sound.StopSoundBJ)
    expose(nil, "CancelCineSceneBJ", sound.CancelCineSceneBJ)
    expose(nil, "CameraResetSmoothingFactorBJ", sound.CameraResetSmoothingFactorBJ)
    expose(nil, "SetCineModeVolumeGroupsImmediateBJ", sound.SetCineModeVolumeGroupsImmediateBJ)
    expose(nil, "SetCineModeVolumeGroupsBJ", sound.SetCineModeVolumeGroupsBJ)
    expose(nil, "GetSoundDurationBJ", sound.GetSoundDurationBJ)
    expose(nil, "GetTransmissionDuration", sound.GetTransmissionDuration)
    expose(nil, "WaitForSoundBJ", sound.WaitForSoundBJ)
    expose(nil, "WaitTransmissionDuration", sound.WaitTransmissionDuration)
    expose(nil, "EnableDawnDusk", sound.EnableDawnDusk)
    expose(nil, "IsDawnDuskEnabled", sound.IsDawnDuskEnabled)
    expose(nil, "QuestMessageBJ", questMsg.QuestMessageBJ)
    expose(nil, "ModifyGateBJ", misc.ModifyGateBJ)
    expose(nil, "GetUnitsInRectMatching", misc.GetUnitsInRectMatching)
    expose(nil, "ForGroupBJ", misc.ForGroupBJ)
    expose(nil, "GetPlayersAll", misc.GetPlayersAll)
    expose(nil, "GetRandomDirectionDeg", misc.GetRandomDirectionDeg)
    expose(nil, "GetSpellAbilityId", misc.GetSpellAbilityId)
    expose(nil, "OrderIdToString", misc.OrderIdToString)
    expose(nil, "AddSpecialEffectTargetUnitBJ", misc.AddSpecialEffectTargetUnitBJ)
    expose(nil, "OperatorDegreeMultiply", misc.OperatorDegreeMultiply)
    expose(nil, "OperatorRealAdd", misc.OperatorRealAdd)
    expose(nil, "OperatorRealMultiply", misc.OperatorRealMultiply)
    expose(nil, "String2OrderIdBJ", misc.String2OrderIdBJ)
    expose(nil, "IMaxBJ", mathBj.IMaxBJ)
    expose(nil, "IMinBJ", mathBj.IMinBJ)
    expose(nil, "RMaxBJ", mathBj.RMaxBJ)
    expose(nil, "RMinBJ", mathBj.RMinBJ)
    expose(nil, "String2UnitIdBJ", unitBjExt.String2UnitIdBJ)
    expose(nil, "GetIssuedOrderIdBJ", unitBjExt.GetIssuedOrderIdBJ)
    expose(nil, "GetKillingUnitBJ", unitBjExt.GetKillingUnitBJ)
    expose(nil, "UnitSuspendDecayBJ", unitBjExt.UnitSuspendDecayBJ)
    expose(nil, "GetUnitStateSwap", unitBjExt.GetUnitStateSwap)
    expose(nil, "SelectUnitSingle", unitBjExt.SelectUnitSingle)
    expose(nil, "SelectGroupBJ", unitBjExt.SelectGroupBJ)
    expose(nil, "SelectUnitAdd", unitBjExt.SelectUnitAdd)
    expose(nil, "SelectUnitRemove", unitBjExt.SelectUnitRemove)
    expose(nil, "IsUnitHiddenBJ", unitBjExt.IsUnitHiddenBJ)
    expose(nil, "ShowUnitHide", unitBjExt.ShowUnitHide)
    expose(nil, "IssueTrainOrderByIdBJ", unitBjExt.IssueTrainOrderByIdBJ)
    expose(nil, "GroupTrainOrderByIdBJ", unitBjExt.GroupTrainOrderByIdBJ)
    expose(nil, "IssueUpgradeOrderByIdBJ", unitBjExt.IssueUpgradeOrderByIdBJ)
    expose(nil, "SetUnitFlyHeightBJ", unitBjExt.SetUnitFlyHeightBJ)
    expose(nil, "SetUnitTurnSpeedBJ", unitBjExt.SetUnitTurnSpeedBJ)
    expose(nil, "GetUnitDefaultPropWindowBJ", unitBjExt.GetUnitDefaultPropWindowBJ)
    expose(nil, "SetUnitBlendTimeBJ", unitBjExt.SetUnitBlendTimeBJ)
    expose(nil, "SetUnitAcquireRangeBJ", unitBjExt.SetUnitAcquireRangeBJ)
    expose(nil, "UnitSetCanSleepBJ", unitBjExt.UnitSetCanSleepBJ)
    expose(nil, "UnitCanSleepBJ", unitBjExt.UnitCanSleepBJ)
    expose(nil, "UnitWakeUpBJ", unitBjExt.UnitWakeUpBJ)
    expose(nil, "UnitIsSleepingBJ", unitBjExt.UnitIsSleepingBJ)
    expose(nil, "UnitGenerateAlarms", unitBjExt.UnitGenerateAlarms)
    expose(nil, "PauseUnitBJ", unitBjExt.PauseUnitBJ)
    expose(nil, "IsUnitPausedBJ", unitBjExt.IsUnitPausedBJ)
    expose(nil, "UnitPauseTimedLifeBJ", unitBjExt.UnitPauseTimedLifeBJ)
    expose(nil, "UnitApplyTimedLifeBJ", unitBjExt.UnitApplyTimedLifeBJ)
    expose(nil, "UnitShareVisionBJ", unitBjExt.UnitShareVisionBJ)
    expose(nil, "UnitRemoveAbilityBJ", unitBjExt.UnitRemoveAbilityBJ)
    expose(nil, "UnitAddAbilityBJ", unitBjExt.UnitAddAbilityBJ)
    expose(nil, "UnitRemoveTypeBJ", unitBjExt.UnitRemoveTypeBJ)
    expose(nil, "UnitAddTypeBJ", unitBjExt.UnitAddTypeBJ)
    expose(nil, "UnitMakeAbilityPermanentBJ", unitBjExt.UnitMakeAbilityPermanentBJ)
    expose(nil, "SetUnitExplodedBJ", unitBjExt.SetUnitExplodedBJ)
    expose(nil, "GetTransportUnitBJ", unitBjExt.GetTransportUnitBJ)
    expose(nil, "GetLoadedUnitBJ", unitBjExt.GetLoadedUnitBJ)
    expose(nil, "IsUnitInTransportBJ", unitBjExt.IsUnitInTransportBJ)
    expose(nil, "IsUnitLoadedBJ", unitBjExt.IsUnitLoadedBJ)
    expose(nil, "IsUnitIllusionBJ", unitBjExt.IsUnitIllusionBJ)
    expose(nil, "SetUnitUseFoodBJ", unitBjExt.SetUnitUseFoodBJ)
    expose(nil, "UnitDamageTargetBJ", unitBjExt.UnitDamageTargetBJ)
    expose(nil, "UnitId2OrderIdBJ", unitBjExt.UnitId2OrderIdBJ)
    expose(nil, "GetLastCreatedUnit", unitBjExt.GetLastCreatedUnit)
    expose(nil, "GetLastReplacedUnitBJ", unitBjExt.GetLastReplacedUnitBJ)
    expose(nil, "DoesUnitGenerateAlarms", unitBjExt.DoesUnitGenerateAlarms)
    expose(nil, "GetUnitPropWindowBJ", unitBjExt.GetUnitPropWindowBJ)
    expose(nil, "CreateImageBJ", imageBj.CreateImageBJ)
    expose(nil, "ShowImageBJ", imageBj.ShowImageBJ)
    expose(nil, "SetImagePositionBJ", imageBj.SetImagePositionBJ)
    expose(nil, "SetImageColorBJ", imageBj.SetImageColorBJ)
    expose(nil, "GetLastCreatedImage", imageBj.GetLastCreatedImage)
    expose(nil, "CosBJ", mathBj.CosBJ)
    expose(nil, "SinBJ", mathBj.SinBJ)
    expose(nil, "TanBJ", mathBj.TanBJ)
    expose(nil, "AcosBJ", mathBj.AcosBJ)
    expose(nil, "AsinBJ", mathBj.AsinBJ)
    expose(nil, "AtanBJ", mathBj.AtanBJ)
    expose(nil, "Atan2BJ", mathBj.Atan2BJ)
    expose(nil, "RAbsBJ", mathBj.RAbsBJ)
    expose(nil, "RSignBJ", mathBj.RSignBJ)
    expose(nil, "IAbsBJ", mathBj.IAbsBJ)
    expose(nil, "ISignBJ", mathBj.ISignBJ)
    expose(nil, "GetRandomPercentageBJ", mathBj.GetRandomPercentageBJ)
    expose(nil, "ModuloInteger", mathBj.ModuloInteger)
    expose(nil, "ModuloReal", mathBj.ModuloReal)
    expose(nil, "AngleBetweenPoints", mathBj.AngleBetweenPoints)
    expose(nil, "DistanceBetweenPoints", mathBj.DistanceBetweenPoints)
    expose(nil, "SetHeroLevelBJ", unitHero.SetHeroLevelBJ)
    expose(nil, "AddHeroXPSwapped", unitHero.AddHeroXPSwapped)
    expose(nil, "SuspendHeroXPBJ", unitHero.SuspendHeroXPBJ)
    expose(nil, "IsSuspendedXPBJ", unitHero.IsSuspendedXPBJ)
    expose(nil, "ModifyHeroSkillPoints", unitHero.ModifyHeroSkillPoints)
    expose(nil, "UnitHasBuffBJ", unitHero.UnitHasBuffBJ)
    expose(nil, "UnitRemoveBuffBJ", unitHero.UnitRemoveBuffBJ)
    expose(nil, "GetLearnedSkillBJ", unitHero.GetLearnedSkillBJ)
    expose(nil, "CountUnitsInGroup", unitHero.CountUnitsInGroup)
    expose(nil, "GroupAddGroup", unitHero.GroupAddGroup)
    expose(nil, "GetItemLoc", itemInv.GetItemLoc)
    expose(nil, "CreateItemLoc", itemInv.CreateItemLoc)
    expose(nil, "SetItemPositionLoc", itemInv.SetItemPositionLoc)
    expose(nil, "UnitDropItemPointLoc", itemInv.UnitDropItemPointLoc)
    expose(nil, "UnitUseItemPointLoc", itemInv.UnitUseItemPointLoc)
    expose(nil, "CreateUbersplatBJ", ubersplatBj.CreateUbersplatBJ)
    expose(nil, "ShowUbersplatBJ", ubersplatBj.ShowUbersplatBJ)
    expose(nil, "GetLastCreatedUbersplat", ubersplatBj.GetLastCreatedUbersplat)
    expose(nil, "CreateMultiboardBJ", multiboardBj.CreateMultiboardBJ)
    expose(nil, "DestroyMultiboardBJ", multiboardBj.DestroyMultiboardBJ)
    expose(nil, "GetLastCreatedMultiboard", multiboardBj.GetLastCreatedMultiboard)
    expose(nil, "MultiboardDisplayBJ", multiboardBj.MultiboardDisplayBJ)
    expose(nil, "MultiboardMinimizeBJ", multiboardBj.MultiboardMinimizeBJ)
    expose(nil, "MultiboardSetTitleTextColorBJ", multiboardBj.MultiboardSetTitleTextColorBJ)
    expose(nil, "MultiboardAllowDisplayBJ", multiboardBj.MultiboardAllowDisplayBJ)
    expose(nil, "MultiboardSetItemStyleBJ", multiboardBj.MultiboardSetItemStyleBJ)
    expose(nil, "MultiboardSetItemValueBJ", multiboardBj.MultiboardSetItemValueBJ)
    expose(nil, "MultiboardSetItemColorBJ", multiboardBj.MultiboardSetItemColorBJ)
    expose(nil, "MultiboardSetItemWidthBJ", multiboardBj.MultiboardSetItemWidthBJ)
    expose(nil, "MultiboardSetItemIconBJ", multiboardBj.MultiboardSetItemIconBJ)
    expose(nil, "GetLastCreatedMultiboardItem", multiboardBj.GetLastCreatedMultiboardItem)
end
return ____exports
