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
    expose(nil, "SetUnitFacingToFaceUnitTimed", unitHero.SetUnitFacingToFaceUnitTimed)
    expose(nil, "RemoveItemFromStockBJ", itemInv.RemoveItemFromStockBJ)
    expose(nil, "AddItemToStockBJ", itemInv.AddItemToStockBJ)
    expose(nil, "GetInventoryIndexOfItemTypeBJ", itemInv.GetInventoryIndexOfItemTypeBJ)
    expose(nil, "GetItemOfTypeFromUnitBJ", itemInv.GetItemOfTypeFromUnitBJ)
    expose(nil, "GetItemTypeCountInUnitBJ", itemInv.GetItemTypeCountInUnitBJ)
    expose(nil, "RemoveItemTypeFromUnitBJ", itemInv.RemoveItemTypeFromUnitBJ)
    expose(nil, "RectContainsCoords", rectArea.RectContainsCoords)
    expose(nil, "RectContainsLoc", rectArea.RectContainsLoc)
    expose(nil, "RectContainsUnit", rectArea.RectContainsUnit)
    expose(nil, "SetStackedSoundBJ", rectArea.SetStackedSoundBJ)
    expose(nil, "TriggerRegisterUnitInRangeSimple", trigEvent.TriggerRegisterUnitInRangeSimple)
    expose(nil, "ConditionalTriggerExecute", trigEvent.ConditionalTriggerExecute)
    expose(nil, "AbortCinematicFadeBJ", cine.AbortCinematicFadeBJ)
    expose(nil, "RMaxBJ", sound.RMaxBJ)
    expose(nil, "PlaySoundBJ", sound.PlaySoundBJ)
    expose(nil, "SetCinematicSceneBJ", cine.SetCinematicSceneBJ)
    expose(nil, "DoTransmissionBasicsXYBJ", cine.DoTransmissionBasicsXYBJ)
    expose(nil, "TryInitCinematicBehaviorBJ", cine.TryInitCinematicBehaviorBJ)
    expose(nil, "TransmissionFromUnitWithNameBJ", cine.TransmissionFromUnitWithNameBJ)
    expose(nil, "PercentToInt", sound.PercentToInt)
    expose(nil, "PercentTo255", sound.PercentTo255)
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
    expose(nil, "IMaxBJ", misc.IMaxBJ)
    expose(nil, "IMinBJ", misc.IMinBJ)
end
return ____exports
