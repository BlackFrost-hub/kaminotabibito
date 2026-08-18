--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local trigEvent = require("lib.扩展函数.BJ函数.01．触发与事件")
local unitHero = require("lib.扩展函数.BJ函数.02．单位与英雄")
local itemInv = require("lib.扩展函数.BJ函数.03．物品与库存")
local rectArea = require("lib.扩展函数.BJ函数.04．矩形与区域")
local cine = require("lib.扩展函数.BJ函数.05A．电影函数")
local sound = require("lib.扩展函数.BJ函数.14．音效函数")
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
    local ____export = require("lib.扩展函数.BJ函数.14．音效函数")
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
local function expose(name, fn)
    if type(fn) ~= "function" then
        return
    end
    local g = _G
    if type(g[name]) == "function" then
        return
    end
    g[name] = fn
end
function ____exports.registerBridge()
    expose("TriggerRegisterAnyUnitEventBJ", trigEvent.TriggerRegisterAnyUnitEventBJ)
    expose("GetUnitCurrentOrder", unitHero.GetUnitCurrentOrder)
    expose("IsUnitDeadBJ", unitHero.IsUnitDeadBJ)
    expose("IsUnitAliveBJ", unitHero.IsUnitAliveBJ)
    expose("GetHeroStatBJ", unitHero.GetHeroStatBJ)
    expose("ModifyHeroStat", unitHero.ModifyHeroStat)
    expose("SetUnitFacingToFaceUnitTimed", unitHero.SetUnitFacingToFaceUnitTimed)
    expose("GetUnitManaPercentBJ", unitHero.GetUnitManaPercentBJ)
    expose("SetUnitManaPercentBJ", unitHero.SetUnitManaPercentBJ)
    expose("GetUnitLifePercentBJ", unitHero.GetUnitLifePercentBJ)
    expose("SetUnitLifePercentBJ", unitHero.SetUnitLifePercentBJ)
    expose("GetUnitLifePercent", unitHero.GetUnitLifePercent)
    expose("GetUnitManaPercent", unitHero.GetUnitManaPercent)
    expose("SetUnitLifeBJ", unitHero.SetUnitLifeBJ)
    expose("SetUnitManaBJ", unitHero.SetUnitManaBJ)
    expose("RemoveItemFromStockBJ", itemInv.RemoveItemFromStockBJ)
    expose("AddItemToStockBJ", itemInv.AddItemToStockBJ)
    expose("AddUnitToStockBJ", itemInv.AddUnitToStockBJ)
    expose("RemoveUnitFromStockBJ", itemInv.RemoveUnitFromStockBJ)
    expose("GetInventoryIndexOfItemTypeBJ", itemInv.GetInventoryIndexOfItemTypeBJ)
    expose("GetItemOfTypeFromUnitBJ", itemInv.GetItemOfTypeFromUnitBJ)
    expose("GetItemTypeCountInUnitBJ", itemInv.GetItemTypeCountInUnitBJ)
    expose("RemoveItemTypeFromUnitBJ", itemInv.RemoveItemTypeFromUnitBJ)
    expose("RectContainsCoords", rectArea.RectContainsCoords)
    expose("RectContainsLoc", rectArea.RectContainsLoc)
    expose("RectContainsUnit", rectArea.RectContainsUnit)
    expose("SetStackedSoundBJ", rectArea.SetStackedSoundBJ)
    expose("CreateDestructableLoc", rectArea.CreateDestructableLoc)
    expose("GetEntireMapRect", rectArea.GetEntireMapRect)
    expose("TriggerRegisterUnitInRangeSimple", trigEvent.TriggerRegisterUnitInRangeSimple)
    expose("GetAttackedUnitBJ", trigEvent.GetAttackedUnitBJ)
    expose("ConditionalTriggerExecute", trigEvent.ConditionalTriggerExecute)
    expose("AbortCinematicFadeBJ", cine.AbortCinematicFadeBJ)
    expose("PlaySoundBJ", sound.PlaySoundBJ)
    expose("SetCinematicSceneBJ", cine.SetCinematicSceneBJ)
    expose("DoTransmissionBasicsXYBJ", cine.DoTransmissionBasicsXYBJ)
    expose("TryInitCinematicBehaviorBJ", cine.TryInitCinematicBehaviorBJ)
    expose("TransmissionFromUnitWithNameBJ", cine.TransmissionFromUnitWithNameBJ)
    expose("PercentToInt", mathBj.PercentToInt)
    expose("PercentTo255", mathBj.PercentTo255)
    expose("CinematicModeExBJ", cine.CinematicModeExBJ)
    expose("CinematicModeBJ", cine.CinematicModeBJ)
    expose("CinematicFilterGenericBJ", cine.CinematicFilterGenericBJ)
    expose("StopSoundBJ", sound.StopSoundBJ)
    expose("CancelCineSceneBJ", sound.CancelCineSceneBJ)
    expose("CameraResetSmoothingFactorBJ", sound.CameraResetSmoothingFactorBJ)
    expose("SetCineModeVolumeGroupsImmediateBJ", sound.SetCineModeVolumeGroupsImmediateBJ)
    expose("SetCineModeVolumeGroupsBJ", sound.SetCineModeVolumeGroupsBJ)
    expose("GetSoundDurationBJ", sound.GetSoundDurationBJ)
    expose("GetTransmissionDuration", sound.GetTransmissionDuration)
    expose("WaitForSoundBJ", sound.WaitForSoundBJ)
    expose("WaitTransmissionDuration", sound.WaitTransmissionDuration)
    expose("EnableDawnDusk", sound.EnableDawnDusk)
    expose("IsDawnDuskEnabled", sound.IsDawnDuskEnabled)
    expose("QuestMessageBJ", questMsg.QuestMessageBJ)
    expose("CreateQuestBJ", questMsg.CreateQuestBJ)
    expose("GetLastCreatedQuestBJ", questMsg.GetLastCreatedQuestBJ)
    expose("ModifyGateBJ", misc.ModifyGateBJ)
    expose("GetUnitsInRectMatching", misc.GetUnitsInRectMatching)
    expose("ForGroupBJ", misc.ForGroupBJ)
    expose("GetPlayersAll", misc.GetPlayersAll)
    expose("GetRandomDirectionDeg", misc.GetRandomDirectionDeg)
    expose("GetSpellAbilityId", misc.GetSpellAbilityId)
    expose("OrderIdToString", misc.OrderIdToString)
    expose("AddSpecialEffectTargetUnitBJ", misc.AddSpecialEffectTargetUnitBJ)
    expose("OperatorDegreeMultiply", misc.OperatorDegreeMultiply)
    expose("OperatorRealAdd", misc.OperatorRealAdd)
    expose("OperatorRealMultiply", misc.OperatorRealMultiply)
    expose("String2OrderIdBJ", misc.String2OrderIdBJ)
    expose("IMaxBJ", mathBj.IMaxBJ)
    expose("IMinBJ", mathBj.IMinBJ)
    expose("RMaxBJ", mathBj.RMaxBJ)
    expose("RMinBJ", mathBj.RMinBJ)
    expose("String2UnitIdBJ", unitBjExt.String2UnitIdBJ)
    expose("GetIssuedOrderIdBJ", unitBjExt.GetIssuedOrderIdBJ)
    expose("GetKillingUnitBJ", unitBjExt.GetKillingUnitBJ)
    expose("UnitSuspendDecayBJ", unitBjExt.UnitSuspendDecayBJ)
    expose("GetUnitStateSwap", unitBjExt.GetUnitStateSwap)
    expose("SelectUnitSingle", unitBjExt.SelectUnitSingle)
    expose("SelectGroupBJ", unitBjExt.SelectGroupBJ)
    expose("SelectUnitAdd", unitBjExt.SelectUnitAdd)
    expose("SelectUnitRemove", unitBjExt.SelectUnitRemove)
    expose("ForceUICancelBJ", unitBjExt.ForceUICancelBJ)
    expose("IsUnitHiddenBJ", unitBjExt.IsUnitHiddenBJ)
    expose("ShowUnitHide", unitBjExt.ShowUnitHide)
    expose("IssueTrainOrderByIdBJ", unitBjExt.IssueTrainOrderByIdBJ)
    expose("GroupTrainOrderByIdBJ", unitBjExt.GroupTrainOrderByIdBJ)
    expose("IssueUpgradeOrderByIdBJ", unitBjExt.IssueUpgradeOrderByIdBJ)
    expose("SetUnitFlyHeightBJ", unitBjExt.SetUnitFlyHeightBJ)
    expose("SetUnitTurnSpeedBJ", unitBjExt.SetUnitTurnSpeedBJ)
    expose("GetUnitDefaultPropWindowBJ", unitBjExt.GetUnitDefaultPropWindowBJ)
    expose("SetUnitBlendTimeBJ", unitBjExt.SetUnitBlendTimeBJ)
    expose("SetUnitAcquireRangeBJ", unitBjExt.SetUnitAcquireRangeBJ)
    expose("UnitSetCanSleepBJ", unitBjExt.UnitSetCanSleepBJ)
    expose("UnitCanSleepBJ", unitBjExt.UnitCanSleepBJ)
    expose("UnitWakeUpBJ", unitBjExt.UnitWakeUpBJ)
    expose("UnitIsSleepingBJ", unitBjExt.UnitIsSleepingBJ)
    expose("UnitGenerateAlarms", unitBjExt.UnitGenerateAlarms)
    expose("PauseUnitBJ", unitBjExt.PauseUnitBJ)
    expose("IsUnitPausedBJ", unitBjExt.IsUnitPausedBJ)
    expose("ResetUnitAnimation", unitBjExt.ResetUnitAnimation)
    expose("UnitPauseTimedLifeBJ", unitBjExt.UnitPauseTimedLifeBJ)
    expose("UnitApplyTimedLifeBJ", unitBjExt.UnitApplyTimedLifeBJ)
    expose("UnitShareVisionBJ", unitBjExt.UnitShareVisionBJ)
    expose("UnitRemoveAbilityBJ", unitBjExt.UnitRemoveAbilityBJ)
    expose("UnitAddAbilityBJ", unitBjExt.UnitAddAbilityBJ)
    expose("UnitRemoveTypeBJ", unitBjExt.UnitRemoveTypeBJ)
    expose("UnitAddTypeBJ", unitBjExt.UnitAddTypeBJ)
    expose("UnitMakeAbilityPermanentBJ", unitBjExt.UnitMakeAbilityPermanentBJ)
    expose("SetUnitExplodedBJ", unitBjExt.SetUnitExplodedBJ)
    expose("GetTransportUnitBJ", unitBjExt.GetTransportUnitBJ)
    expose("GetLoadedUnitBJ", unitBjExt.GetLoadedUnitBJ)
    expose("IsUnitInTransportBJ", unitBjExt.IsUnitInTransportBJ)
    expose("IsUnitLoadedBJ", unitBjExt.IsUnitLoadedBJ)
    expose("IsUnitIllusionBJ", unitBjExt.IsUnitIllusionBJ)
    expose("SetUnitUseFoodBJ", unitBjExt.SetUnitUseFoodBJ)
    expose("UnitDamageTargetBJ", unitBjExt.UnitDamageTargetBJ)
    expose("UnitId2OrderIdBJ", unitBjExt.UnitId2OrderIdBJ)
    expose("GetLastCreatedUnit", unitBjExt.GetLastCreatedUnit)
    expose("GetLastReplacedUnitBJ", unitBjExt.GetLastReplacedUnitBJ)
    expose("DoesUnitGenerateAlarms", unitBjExt.DoesUnitGenerateAlarms)
    expose("GetUnitPropWindowBJ", unitBjExt.GetUnitPropWindowBJ)
    expose("CreateImageBJ", imageBj.CreateImageBJ)
    expose("ShowImageBJ", imageBj.ShowImageBJ)
    expose("SetImagePositionBJ", imageBj.SetImagePositionBJ)
    expose("SetImageColorBJ", imageBj.SetImageColorBJ)
    expose("GetLastCreatedImage", imageBj.GetLastCreatedImage)
    expose("CosBJ", mathBj.CosBJ)
    expose("SinBJ", mathBj.SinBJ)
    expose("TanBJ", mathBj.TanBJ)
    expose("AcosBJ", mathBj.AcosBJ)
    expose("AsinBJ", mathBj.AsinBJ)
    expose("AtanBJ", mathBj.AtanBJ)
    expose("Atan2BJ", mathBj.Atan2BJ)
    expose("RAbsBJ", mathBj.RAbsBJ)
    expose("RSignBJ", mathBj.RSignBJ)
    expose("IAbsBJ", mathBj.IAbsBJ)
    expose("ISignBJ", mathBj.ISignBJ)
    expose("GetRandomPercentageBJ", mathBj.GetRandomPercentageBJ)
    expose("ModuloInteger", mathBj.ModuloInteger)
    expose("ModuloReal", mathBj.ModuloReal)
    expose("AngleBetweenPoints", mathBj.AngleBetweenPoints)
    expose("DistanceBetweenPoints", mathBj.DistanceBetweenPoints)
    expose("SetHeroLevelBJ", unitHero.SetHeroLevelBJ)
    expose("AddHeroXPSwapped", unitHero.AddHeroXPSwapped)
    expose("SuspendHeroXPBJ", unitHero.SuspendHeroXPBJ)
    expose("IsSuspendedXPBJ", unitHero.IsSuspendedXPBJ)
    expose("ModifyHeroSkillPoints", unitHero.ModifyHeroSkillPoints)
    expose("UnitHasBuffBJ", unitHero.UnitHasBuffBJ)
    expose("UnitRemoveBuffBJ", unitHero.UnitRemoveBuffBJ)
    expose("GetLearnedSkillBJ", unitHero.GetLearnedSkillBJ)
    expose("CountUnitsInGroup", unitHero.CountUnitsInGroup)
    expose("GroupAddGroup", unitHero.GroupAddGroup)
    expose("GetItemLoc", itemInv.GetItemLoc)
    expose("CreateItemLoc", itemInv.CreateItemLoc)
    expose("SetItemPositionLoc", itemInv.SetItemPositionLoc)
    expose("UnitDropItemPointLoc", itemInv.UnitDropItemPointLoc)
    expose("UnitUseItemPointLoc", itemInv.UnitUseItemPointLoc)
    expose("CreateUbersplatBJ", ubersplatBj.CreateUbersplatBJ)
    expose("ShowUbersplatBJ", ubersplatBj.ShowUbersplatBJ)
    expose("GetLastCreatedUbersplat", ubersplatBj.GetLastCreatedUbersplat)
    expose("CreateMultiboardBJ", multiboardBj.CreateMultiboardBJ)
    expose("DestroyMultiboardBJ", multiboardBj.DestroyMultiboardBJ)
    expose("GetLastCreatedMultiboard", multiboardBj.GetLastCreatedMultiboard)
    expose("MultiboardDisplayBJ", multiboardBj.MultiboardDisplayBJ)
    expose("MultiboardMinimizeBJ", multiboardBj.MultiboardMinimizeBJ)
    expose("MultiboardSetTitleTextColorBJ", multiboardBj.MultiboardSetTitleTextColorBJ)
    expose("MultiboardAllowDisplayBJ", multiboardBj.MultiboardAllowDisplayBJ)
    expose("MultiboardSetItemStyleBJ", multiboardBj.MultiboardSetItemStyleBJ)
    expose("MultiboardSetItemValueBJ", multiboardBj.MultiboardSetItemValueBJ)
    expose("MultiboardSetItemColorBJ", multiboardBj.MultiboardSetItemColorBJ)
    expose("MultiboardSetItemWidthBJ", multiboardBj.MultiboardSetItemWidthBJ)
    expose("MultiboardSetItemIconBJ", multiboardBj.MultiboardSetItemIconBJ)
    expose("GetLastCreatedMultiboardItem", multiboardBj.GetLastCreatedMultiboardItem)
end
return ____exports
