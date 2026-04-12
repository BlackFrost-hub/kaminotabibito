--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local cameraFunc = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local sdrDebug = require("lib.扩展函数.Star扩展函数.Star扩展库.01．SDR调试计时器")
local starEvent = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
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
end
return ____exports
