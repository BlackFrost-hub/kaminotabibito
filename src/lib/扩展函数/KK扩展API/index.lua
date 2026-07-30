--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local doodadApi = require("lib.扩展函数.KK扩展API.00．装饰物函数")
local eventApi = require("lib.扩展函数.KK扩展API.02．事件注册函数")
local utilApi = require("lib.扩展函数.KK扩展API.03．工具函数")
____exports.DzDoodadCreate = doodadApi.DzDoodadCreate
____exports.DzDoodadGetTypeId = doodadApi.DzDoodadGetTypeId
____exports.DzDoodadSetModel = doodadApi.DzDoodadSetModel
____exports.DzDoodadSetTeamColor = doodadApi.DzDoodadSetTeamColor
____exports.DzDoodadSetColor = doodadApi.DzDoodadSetColor
____exports.DzDoodadGetX = doodadApi.DzDoodadGetX
____exports.DzDoodadGetY = doodadApi.DzDoodadGetY
____exports.DzDoodadGetZ = doodadApi.DzDoodadGetZ
____exports.DzDoodadSetPosition = doodadApi.DzDoodadSetPosition
____exports.DzDoodadSetOrientMatrixRotate = doodadApi.DzDoodadSetOrientMatrixRotate
____exports.DzDoodadSetOrientMatrixScale = doodadApi.DzDoodadSetOrientMatrixScale
____exports.DzDoodadSetOrientMatrixResize = doodadApi.DzDoodadSetOrientMatrixResize
____exports.DzDoodadSetVisible = doodadApi.DzDoodadSetVisible
____exports.DzDoodadRemove = doodadApi.DzDoodadRemove
____exports.DzDoodadSetAnimation = doodadApi.DzDoodadSetAnimation
____exports.DzDoodadSetTimeScale = doodadApi.DzDoodadSetTimeScale
____exports.DzDoodadGetTimeScale = doodadApi.DzDoodadGetTimeScale
____exports.DzDoodadGetCurrentAnimationIndex = doodadApi.DzDoodadGetCurrentAnimationIndex
____exports.DzDoodadGetAnimationCount = doodadApi.DzDoodadGetAnimationCount
____exports.DzDoodadGetAnimationName = doodadApi.DzDoodadGetAnimationName
____exports.DzDoodadGetAnimationTime = doodadApi.DzDoodadGetAnimationTime
____exports.DzTriggerRegisterMouseEventTrg = eventApi.DzTriggerRegisterMouseEventTrg
____exports.DzTriggerRegisterKeyEventTrg = eventApi.DzTriggerRegisterKeyEventTrg
____exports.DzTriggerRegisterMouseMoveEventTrg = eventApi.DzTriggerRegisterMouseMoveEventTrg
____exports.DzTriggerRegisterMouseWheelEventTrg = eventApi.DzTriggerRegisterMouseWheelEventTrg
____exports.DzTriggerRegisterWindowResizeEventTrg = eventApi.DzTriggerRegisterWindowResizeEventTrg
____exports.DzF2I = eventApi.DzF2I
____exports.DzI2F = eventApi.DzI2F
____exports.DzK2I = eventApi.DzK2I
____exports.DzI2K = eventApi.DzI2K
____exports.DzTriggerRegisterMallItemSyncData = eventApi.DzTriggerRegisterMallItemSyncData
____exports.DzGetTriggerMallItemPlayer = eventApi.DzGetTriggerMallItemPlayer
____exports.DzGetTriggerMallItem = eventApi.DzGetTriggerMallItem
____exports.DzSyncData = eventApi.DzSyncData
____exports.DzSyncDataImmediately = eventApi.DzSyncDataImmediately
____exports.DzSyncBuffer = eventApi.DzSyncBuffer
____exports.DzTriggerRegisterDialogEntrySyncData = eventApi.DzTriggerRegisterDialogEntrySyncData
____exports.DzSyncDialogEntryData = eventApi.DzSyncDialogEntryData
____exports.DzGetTriggerDialogEntryPlayer = eventApi.DzGetTriggerDialogEntryPlayer
____exports.DzGetTriggerDialogEntryData = eventApi.DzGetTriggerDialogEntryData
____exports.DzTriggerRegisterSyncDataTrg = eventApi.DzTriggerRegisterSyncDataTrg
____exports.DzGetTriggerSyncPlayer = eventApi.DzGetTriggerSyncPlayer
____exports.DzGetTriggerSyncData = eventApi.DzGetTriggerSyncData
____exports.DzGetColor2 = utilApi.DzGetColor2
____exports.DzOpenQQGroupUrl = utilApi.DzOpenQQGroupUrl
____exports.DzExecuteFunc = utilApi.DzExecuteFunc
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
    expose(nil, "DzDoodadCreate", doodadApi.DzDoodadCreate)
    expose(nil, "DzDoodadGetTypeId", doodadApi.DzDoodadGetTypeId)
    expose(nil, "DzDoodadSetModel", doodadApi.DzDoodadSetModel)
    expose(nil, "DzDoodadSetTeamColor", doodadApi.DzDoodadSetTeamColor)
    expose(nil, "DzDoodadSetColor", doodadApi.DzDoodadSetColor)
    expose(nil, "DzDoodadGetX", doodadApi.DzDoodadGetX)
    expose(nil, "DzDoodadGetY", doodadApi.DzDoodadGetY)
    expose(nil, "DzDoodadGetZ", doodadApi.DzDoodadGetZ)
    expose(nil, "DzDoodadSetPosition", doodadApi.DzDoodadSetPosition)
    expose(nil, "DzDoodadSetOrientMatrixRotate", doodadApi.DzDoodadSetOrientMatrixRotate)
    expose(nil, "DzDoodadSetOrientMatrixScale", doodadApi.DzDoodadSetOrientMatrixScale)
    expose(nil, "DzDoodadSetOrientMatrixResize", doodadApi.DzDoodadSetOrientMatrixResize)
    expose(nil, "DzDoodadSetVisible", doodadApi.DzDoodadSetVisible)
    expose(nil, "DzDoodadRemove", doodadApi.DzDoodadRemove)
    expose(nil, "DzDoodadSetAnimation", doodadApi.DzDoodadSetAnimation)
    expose(nil, "DzDoodadSetTimeScale", doodadApi.DzDoodadSetTimeScale)
    expose(nil, "DzDoodadGetTimeScale", doodadApi.DzDoodadGetTimeScale)
    expose(nil, "DzDoodadGetCurrentAnimationIndex", doodadApi.DzDoodadGetCurrentAnimationIndex)
    expose(nil, "DzDoodadGetAnimationCount", doodadApi.DzDoodadGetAnimationCount)
    expose(nil, "DzDoodadGetAnimationName", doodadApi.DzDoodadGetAnimationName)
    expose(nil, "DzDoodadGetAnimationTime", doodadApi.DzDoodadGetAnimationTime)
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
    expose(nil, "DzSyncData", eventApi.DzSyncData)
    expose(nil, "DzSyncDataImmediately", eventApi.DzSyncDataImmediately)
    expose(nil, "DzSyncBuffer", eventApi.DzSyncBuffer)
    expose(nil, "DzTriggerRegisterDialogEntrySyncData", eventApi.DzTriggerRegisterDialogEntrySyncData)
    expose(nil, "DzSyncDialogEntryData", eventApi.DzSyncDialogEntryData)
    expose(nil, "DzGetTriggerDialogEntryPlayer", eventApi.DzGetTriggerDialogEntryPlayer)
    expose(nil, "DzGetTriggerDialogEntryData", eventApi.DzGetTriggerDialogEntryData)
    expose(nil, "DzTriggerRegisterSyncDataTrg", eventApi.DzTriggerRegisterSyncDataTrg)
    expose(nil, "DzGetTriggerSyncPlayer", eventApi.DzGetTriggerSyncPlayer)
    expose(nil, "DzGetTriggerSyncData", eventApi.DzGetTriggerSyncData)
    expose(nil, "DzGetColor2", utilApi.DzGetColor2)
    expose(nil, "DzOpenQQGroupUrl", utilApi.DzOpenQQGroupUrl)
    expose(nil, "DzExecuteFunc", utilApi.DzExecuteFunc)
end
return ____exports
