local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local _print = _G.print
local _pcall = pcall
local _xpcall = _G.xpcall
local _luaDebug = _G.debug
local ____temp_0
if _luaDebug ~= nil then
    ____temp_0 = _luaDebug.traceback
else
    ____temp_0 = nil
end
local _traceback = ____temp_0
local ____temp_1
if _luaDebug ~= nil then
    ____temp_1 = _luaDebug.getinfo
else
    ____temp_1 = nil
end
local _getInfo = ____temp_1
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local Player = jass.Player
local DEBUG_FLAGS = {}
local _____8FD0_884C_65F6_9519_8BEF_63D0_793A_73A9_5BB6_6570 = 12
local _____8FD0_884C_65F6_9519_8BEF_63D0_793A_6301_7EED_65F6_95F4 = 20
local _____8FD0_884C_65F6_9519_8BEF_5C4F_5E55_6700_5927_884C_6570 = 6
local _____8FD0_884C_65F6_9519_8BEF_5C4F_5E55_6700_5927_5B57_7B26_6570 = 900
local _____5F53_524D_8FD0_884C_65F6_9519_8BEF_5806_6808_6808 = {}
local function toMessagePart(value)
    if value == nil then
        return "nil"
    end
    return tostring(nil, value)
end
local function normalizeModuleName(module)
    if module == nil or module == "" then
        return "未标记模块"
    end
    return tostring(nil, module)
end
local function joinMessageParts(args)
    local parts = {}
    do
        local i = 0
        while i < #args do
            parts[#parts + 1] = toMessagePart(args[i + 1])
            i = i + 1
        end
    end
    return table.concat(parts, " ")
end
local function runtimeErrorTracebackHandler(____error)
    local errorText = toMessagePart(____error)
    local tracebackText = errorText
    if type(_traceback) == "function" then
        tracebackText = _traceback(errorText, 2)
    end
    _____5F53_524D_8FD0_884C_65F6_9519_8BEF_5806_6808_6808[#_____5F53_524D_8FD0_884C_65F6_9519_8BEF_5806_6808_6808 + 1] = tracebackText
    return tracebackText
end
--- 取得回调的源码位置，供基础调度器把错误归属到实际业务回调。
-- Lua 的函数名在被保存到表后不一定可用，因此同时保留源码和定义行。
function ____exports.getCallbackDebugLabel(callback)
    if type(_getInfo) ~= "function" or type(callback) ~= "function" then
        return ""
    end
    local info = _getInfo(callback, "Snl")
    if info == nil then
        return ""
    end
    local source = info.short_src ~= nil and toMessagePart(info.short_src) or toMessagePart(info.source)
    local line = info.linedefined ~= nil and toMessagePart(info.linedefined) or ""
    if source ~= "nil" and source ~= "" then
        return line ~= "" and line ~= "nil" and (source .. ":") .. line or source
    end
    local name = info.name ~= nil and toMessagePart(info.name) or ""
    return name ~= "nil" and name or ""
end
local function limitRuntimeErrorText(text)
    local lines = __TS__StringSplit(text, "\n")
    local result = ""
    local count = #lines > _____8FD0_884C_65F6_9519_8BEF_5C4F_5E55_6700_5927_884C_6570 and _____8FD0_884C_65F6_9519_8BEF_5C4F_5E55_6700_5927_884C_6570 or #lines
    do
        local i = 0
        while i < count do
            if i > 0 then
                result = result .. "\n"
            end
            result = result .. lines[i + 1]
            i = i + 1
        end
    end
    if #lines > count then
        result = result .. "\n..."
    end
    if #result > _____8FD0_884C_65F6_9519_8BEF_5C4F_5E55_6700_5927_5B57_7B26_6570 then
        result = __TS__StringSubstring(result, 0, _____8FD0_884C_65F6_9519_8BEF_5C4F_5E55_6700_5927_5B57_7B26_6570) .. "\n..."
    end
    return result
end
function ____exports.setDebug(module, on)
    DEBUG_FLAGS[normalizeModuleName(module)] = on
end
function ____exports.isDebug(module)
    return DEBUG_FLAGS[normalizeModuleName(module)] == true
end
function ____exports.debugLog(module, ...)
    local moduleName = normalizeModuleName(module)
    if not ____exports.isDebug(moduleName) then
        return
    end
    if not _print then
        return
    end
    local prefix = ("[" .. moduleName) .. "] "
    _print(prefix, ...)
end
function ____exports.debugLogForce(module, ...)
    local moduleName = normalizeModuleName(module)
    if not _print then
        return
    end
    local prefix = ("[" .. moduleName) .. "] "
    _print(prefix, ...)
end
function ____exports.reportRuntimeError(module, ____error, ...)
    local details = {...}
    local moduleName = normalizeModuleName(module)
    local errorText = toMessagePart(____error)
    local detailText = #details > 0 and joinMessageParts(details) or ""
    ____exports.debugLogForce(moduleName, "运行时错误", errorText, detailText)
    local message = ((("|cffff2020[地图程序错误]|r |cffff8080" .. moduleName) .. "|r\n|cffffffff") .. limitRuntimeErrorText(errorText)) .. "|r"
    if detailText ~= "" then
        message = message .. ("\n|cffd8d8d8" .. limitRuntimeErrorText(detailText)) .. "|r"
    end
    do
        local i = 0
        while i < _____8FD0_884C_65F6_9519_8BEF_63D0_793A_73A9_5BB6_6570 do
            DisplayTimedTextToPlayer(
                Player(i),
                0,
                0,
                _____8FD0_884C_65F6_9519_8BEF_63D0_793A_6301_7EED_65F6_95F4,
                message
            )
            i = i + 1
        end
    end
end
function ____exports.safeExecute(module, callback)
    local moduleName = normalizeModuleName(module)
    local targetCallback = callback
    if type(module) == "function" then
        local callbackLabel = ____exports.getCallbackDebugLabel(module)
        moduleName = callbackLabel ~= "" and callbackLabel or "未标记模块"
        targetCallback = module
    end
    if type(targetCallback) ~= "function" then
        return false
    end
    if moduleName == "联机安全回调" then
        local callbackLabel = ____exports.getCallbackDebugLabel(targetCallback)
        if callbackLabel ~= "" then
            moduleName = moduleName .. " -> " .. callbackLabel
        end
    end
    if type(_xpcall) == "function" then
        local errorStackStart = #_____5F53_524D_8FD0_884C_65F6_9519_8BEF_5806_6808_6808
        local ok = _xpcall(targetCallback, runtimeErrorTracebackHandler)
        if not ok then
            local errorText = "未知运行时错误"
            if #_____5F53_524D_8FD0_884C_65F6_9519_8BEF_5806_6808_6808 > errorStackStart then
                errorText = _____5F53_524D_8FD0_884C_65F6_9519_8BEF_5806_6808_6808[#_____5F53_524D_8FD0_884C_65F6_9519_8BEF_5806_6808_6808]
            end
            while #_____5F53_524D_8FD0_884C_65F6_9519_8BEF_5806_6808_6808 > errorStackStart do
                table.remove(_____5F53_524D_8FD0_884C_65F6_9519_8BEF_5806_6808_6808)
            end
            ____exports.reportRuntimeError(moduleName, errorText)
            return false
        end
        while #_____5F53_524D_8FD0_884C_65F6_9519_8BEF_5806_6808_6808 > errorStackStart do
            table.remove(_____5F53_524D_8FD0_884C_65F6_9519_8BEF_5806_6808_6808)
        end
        return true
    end
    local ok = _pcall(targetCallback)
    if not ok then
        ____exports.reportRuntimeError(moduleName, "运行时错误，当前 Lua 环境未提供 xpcall 堆栈")
        return false
    end
    return true
end
return ____exports
