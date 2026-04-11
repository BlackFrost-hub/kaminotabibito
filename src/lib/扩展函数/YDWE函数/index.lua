--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ydweFunc = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local ydCompat = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local ydLocal = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local ydweMacro = require("lib.扩展函数.YDWE函数.03．YDWE_Base")
local ydTrigger = require("lib.扩展函数.YDWE函数.04．YDWE_trigger")
do
    local ____export = require("lib.扩展函数.YDWE函数.00．YDWE函数")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.YDWE函数.03．YDWE_Base")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.YDWE函数.04．YDWE_trigger")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
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
    expose(nil, "YDWEDistanceBetweenUnits", ydweFunc.YDWEDistanceBetweenUnits)
    expose(nil, "YDWEAngleBetweenUnits", ydweFunc.YDWEAngleBetweenUnits)
    expose(nil, "YDUserDataGet", ydCompat.YDUserDataGet)
    expose(nil, "YDUserDataSet", ydCompat.YDUserDataSet)
    expose(nil, "YDUserDataGet2", ydCompat.YDUserDataGet2)
    expose(nil, "YDUserDataSet2", ydCompat.YDUserDataSet2)
    expose(nil, "YDUserDataClearTable", ydCompat.YDUserDataClearTable)
    expose(nil, "YDUserDataClear", ydCompat.YDUserDataClear)
    expose(nil, "YDLocalInitialize", ydLocal.YDLocalInitialize)
    expose(nil, "YDLocal1Release", ydLocal.YDLocal1Release)
    expose(nil, "YDLocal1Get", ydLocal.YDLocal1Get)
    expose(nil, "YDLocal1Set", ydLocal.YDLocal1Set)
    expose(nil, "YDLocalSet", ydLocal.YDLocalSet)
    expose(nil, "YDLocal5Set", ydLocal.YDLocal5Set)
    expose(nil, "YDLocal5Get", ydLocal.YDLocal5Get)
    expose(nil, "flushYDLocal5ParamPage", ydLocal.flushYDLocal5ParamPage)
    expose(nil, "YDLocal7Set", ydLocal.YDLocal7Set)
    expose(nil, "YDLocal7Get", ydLocal.YDLocal7Get)
    expose(nil, "clearStar_PIndex", ydLocal.clearStar_PIndex)
    expose(nil, "getSKey_PIndex", ydLocal.getSKey_PIndex)
    expose(nil, "getSKey_Trigger", ydLocal.getSKey_Trigger)
    expose(nil, "OperatorDegreeAdd", ydweMacro.OperatorDegreeAdd)
    expose(nil, "OperatorDegreeSubtract", ydweMacro.OperatorDegreeSubtract)
    expose(nil, "OperatorDegreeMultiply", ydweMacro.OperatorDegreeMultiply)
    expose(nil, "OperatorDegreeDivide", ydweMacro.OperatorDegreeDivide)
    expose(nil, "OperatorRadianAdd", ydweMacro.OperatorRadianAdd)
    expose(nil, "OperatorRadianSubtract", ydweMacro.OperatorRadianSubtract)
    expose(nil, "OperatorRadianMultiply", ydweMacro.OperatorRadianMultiply)
    expose(nil, "OperatorRadianDivide", ydweMacro.OperatorRadianDivide)
    expose(nil, "OperatorIntegerAdd", ydweMacro.OperatorIntegerAdd)
    expose(nil, "OperatorIntegerSubtract", ydweMacro.OperatorIntegerSubtract)
    expose(nil, "OperatorIntegerMultiply", ydweMacro.OperatorIntegerMultiply)
    expose(nil, "OperatorIntegerDivide", ydweMacro.OperatorIntegerDivide)
    expose(nil, "OperatorRealAdd", ydweMacro.OperatorRealAdd)
    expose(nil, "OperatorRealSubtract", ydweMacro.OperatorRealSubtract)
    expose(nil, "OperatorRealMultiply", ydweMacro.OperatorRealMultiply)
    expose(nil, "OperatorRealDivide", ydweMacro.OperatorRealDivide)
    expose(nil, "YDWEOperatorInt3", ydweMacro.YDWEOperatorInt3)
    expose(nil, "YDWEOperatorReal3", ydweMacro.YDWEOperatorReal3)
    expose(nil, "YDWEOperatorString3", ydweMacro.YDWEOperatorString3)
    expose(nil, "YDWER2Rad", ydweMacro.YDWER2Rad)
    expose(nil, "YDWER2Deg", ydweMacro.YDWER2Deg)
    expose(nil, "YDWEDeg2R", ydweMacro.YDWEDeg2R)
    expose(nil, "YDWERad2R", ydweMacro.YDWERad2R)
    expose(nil, "YDWEInitHashtable", ydweMacro.YDWEInitHashtable)
    expose(nil, "YDWEIsTriggerEventId", ydweMacro.YDWEIsTriggerEventId)
    expose(nil, "YDWEH2I", ydweMacro.YDWEH2I)
    expose(nil, "YDWEGetUnitID", ydweMacro.YDWEGetUnitID)
    expose(nil, "YDWEGetItemID", ydweMacro.YDWEGetItemID)
    expose(nil, "YDWEGetPlayerID", ydweMacro.YDWEGetPlayerID)
    expose(nil, "YDWEGetTimerID", ydweMacro.YDWEGetTimerID)
    expose(nil, "YDWEGetTriggerID", ydweMacro.YDWEGetTriggerID)
    expose(nil, "YDWEGetGroupID", ydweMacro.YDWEGetGroupID)
    expose(nil, "YDWEGetLocationID", ydweMacro.YDWEGetLocationID)
    expose(nil, "YDWEGetMultiboardID", ydweMacro.YDWEGetMultiboardID)
    expose(nil, "YDWEGetMultiboardItemID", ydweMacro.YDWEGetMultiboardItemID)
    expose(nil, "YDWEGetTextTagID", ydweMacro.YDWEGetTextTagID)
    expose(nil, "YDWEGetLightningID", ydweMacro.YDWEGetLightningID)
    expose(nil, "YDWEGetRegionID", ydweMacro.YDWEGetRegionID)
    expose(nil, "YDWEGetRectID", ydweMacro.YDWEGetRectID)
    expose(nil, "YDWEGetLeaderboardID", ydweMacro.YDWEGetLeaderboardID)
    expose(nil, "YDWEGetEffectID", ydweMacro.YDWEGetEffectID)
    expose(nil, "YDWEGetDestructableID", ydweMacro.YDWEGetDestructableID)
    expose(nil, "YDWEGetTriggerConditionID", ydweMacro.YDWEGetTriggerConditionID)
    expose(nil, "YDWEGetTriggerActionID", ydweMacro.YDWEGetTriggerActionID)
    expose(nil, "YDWEGetTriggerEventID", ydweMacro.YDWEGetTriggerEventID)
    expose(nil, "YDWEGetForceID", ydweMacro.YDWEGetForceID)
    expose(nil, "YDWEGetBoolexprID", ydweMacro.YDWEGetBoolexprID)
    expose(nil, "YDWEGetSoundID", ydweMacro.YDWEGetSoundID)
    expose(nil, "YDWEGetTimerDialogID", ydweMacro.YDWEGetTimerDialogID)
    expose(nil, "YDWEGetTrackableID", ydweMacro.YDWEGetTrackableID)
    expose(nil, "YDWEGetDialogID", ydweMacro.YDWEGetDialogID)
    expose(nil, "YDWEGetButtonID", ydweMacro.YDWEGetButtonID)
    expose(nil, "YDWEConvert", ydweMacro.YDWEConvert)
    expose(nil, "YDWEGetUnitTypeID", ydweMacro.YDWEGetUnitTypeID)
    expose(nil, "YDWEGetAbilityTypeID", ydweMacro.YDWEGetAbilityTypeID)
    expose(nil, "YDWEGetItemTypeID", ydweMacro.YDWEGetItemTypeID)
    expose(nil, "YDWEConverUnitcodeToInt", ydweMacro.YDWEConverUnitcodeToInt)
    expose(nil, "YDWEConverItemcodeToInt", ydweMacro.YDWEConverItemcodeToInt)
    expose(nil, "YDWEConverAbilcodeToInt", ydweMacro.YDWEConverAbilcodeToInt)
    expose(nil, "YDWEConverOrdercodeToInt", ydweMacro.YDWEConverOrdercodeToInt)
    expose(nil, "YDWEUOrderId2OrderId", ydweMacro.YDWEUOrderId2OrderId)
    expose(nil, "YDWEPOrderId2OrderId", ydweMacro.YDWEPOrderId2OrderId)
    expose(nil, "YDWEDOrderId2OrderId", ydweMacro.YDWEDOrderId2OrderId)
    expose(nil, "YDWEIOrderId2OrderId", ydweMacro.YDWEIOrderId2OrderId)
    expose(nil, "YDWENOrderId2OrderId", ydweMacro.YDWENOrderId2OrderId)
    expose(nil, "YDLocalExecuteTrigger", ydTrigger.YDLocalExecuteTrigger)
    expose(nil, "YDTriggerExecuteTrigger", ydTrigger.YDTriggerExecuteTrigger)
    expose(nil, "saveParentIndex", ydTrigger.saveParentIndex)
    expose(nil, "removeParentIndex", ydTrigger.removeParentIndex)
    expose(nil, "YDWEI2UnitId", ydweMacro.YDWEI2UnitId)
    expose(nil, "YDWEI2ItemId", ydweMacro.YDWEI2ItemId)
end
return ____exports
