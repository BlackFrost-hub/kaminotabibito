--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local kkApi = require("lib.扩展函数.KK扩展API.00．KK扩展API")
local eventApi = require("lib.扩展函数.KK扩展API.01．事件注册函数")
do
    local ____export = require("lib.扩展函数.KK扩展API.00．KK扩展API")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.KK扩展API.01．事件注册函数")
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
    expose(nil, "DzDoodadCreate", kkApi.DzDoodadCreate)
    expose(nil, "DzDoodadGetTypeId", kkApi.DzDoodadGetTypeId)
    expose(nil, "DzDoodadSetModel", kkApi.DzDoodadSetModel)
    expose(nil, "DzDoodadSetTeamColor", kkApi.DzDoodadSetTeamColor)
    expose(nil, "DzDoodadSetColor", kkApi.DzDoodadSetColor)
    expose(nil, "DzDoodadGetX", kkApi.DzDoodadGetX)
    expose(nil, "DzDoodadGetY", kkApi.DzDoodadGetY)
    expose(nil, "DzDoodadGetZ", kkApi.DzDoodadGetZ)
    expose(nil, "DzDoodadSetPosition", kkApi.DzDoodadSetPosition)
    expose(nil, "DzDoodadSetOrientMatrixRotate", kkApi.DzDoodadSetOrientMatrixRotate)
    expose(nil, "DzDoodadSetOrientMatrixScale", kkApi.DzDoodadSetOrientMatrixScale)
    expose(nil, "DzDoodadSetOrientMatrixResize", kkApi.DzDoodadSetOrientMatrixResize)
    expose(nil, "DzDoodadSetVisible", kkApi.DzDoodadSetVisible)
    expose(nil, "DzDoodadSetAnimation", kkApi.DzDoodadSetAnimation)
    expose(nil, "DzDoodadSetTimeScale", kkApi.DzDoodadSetTimeScale)
    expose(nil, "DzDoodadGetTimeScale", kkApi.DzDoodadGetTimeScale)
    expose(nil, "DzDoodadGetCurrentAnimationIndex", kkApi.DzDoodadGetCurrentAnimationIndex)
    expose(nil, "DzDoodadGetAnimationCount", kkApi.DzDoodadGetAnimationCount)
    expose(nil, "DzDoodadGetAnimationName", kkApi.DzDoodadGetAnimationName)
    expose(nil, "DzDoodadGetAnimationTime", kkApi.DzDoodadGetAnimationTime)
    expose(nil, "DzTriggerRegisterMouseEventTrg", eventApi.DzTriggerRegisterMouseEventTrg)
    expose(nil, "DzTriggerRegisterKeyEventTrg", eventApi.DzTriggerRegisterKeyEventTrg)
    expose(nil, "DzTriggerRegisterMouseMoveEventTrg", eventApi.DzTriggerRegisterMouseMoveEventTrg)
    expose(nil, "DzTriggerRegisterMouseWheelEventTrg", eventApi.DzTriggerRegisterMouseWheelEventTrg)
    expose(nil, "DzTriggerRegisterWindowResizeEventTrg", eventApi.DzTriggerRegisterWindowResizeEventTrg)
    expose(nil, "DzF2I", eventApi.DzF2I)
    expose(nil, "DzI2F", eventApi.DzI2F)
    expose(nil, "DzK2I", eventApi.DzK2I)
    expose(nil, "DzI2K", eventApi.DzI2K)
    expose(nil, "DzTriggerRegisterMallItemSyncData", eventApi.DzTriggerRegisterMallItemSyncData)
    expose(nil, "DzGetTriggerMallItemPlayer", eventApi.DzGetTriggerMallItemPlayer)
    expose(nil, "DzGetTriggerMallItem", eventApi.DzGetTriggerMallItem)
end
return ____exports
