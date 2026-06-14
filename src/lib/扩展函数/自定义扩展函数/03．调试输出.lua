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
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local Player = jass.Player
local DEBUG_FLAGS = {}
local _____8FD0_884C_65F6_9519_8BEF_63D0_793A_73A9_5BB6_6570 = 12
local _____8FD0_884C_65F6_9519_8BEF_63D0_793A_6301_7EED_65F6_95F4 = 20
local _____8FD0_884C_65F6_9519_8BEF_5C4F_5E55_6700_5927_884C_6570 = 6
local _____8FD0_884C_65F6_9519_8BEF_5C4F_5E55_6700_5927_5B57_7B26_6570 = 900
local _____5F53_524D_8FD0_884C_65F6_9519_8BEF_5806_6808 = ""
local function toMessagePart(value)
    if value == nil then
        return "nil"
    end
    return tostring(value)
end
local function normalizeModuleName(module)
    if module == nil or module == "" then
        return "未标记模块"
    end
    return tostring(module)
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
local function runtimeErrorTracebackHandler(self, ____error)
    local errorText = toMessagePart(____error)
    if type(_traceback) == "function" then
        _____5F53_524D_8FD0_884C_65F6_9519_8BEF_5806_6808 = _traceback(errorText, 2)
        return _____5F53_524D_8FD0_884C_65F6_9519_8BEF_5806_6808
    end
    _____5F53_524D_8FD0_884C_65F6_9519_8BEF_5806_6808 = errorText
    return errorText
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
        moduleName = "未标记模块"
        targetCallback = module
    end
    if type(targetCallback) ~= "function" then
        return false
    end
    if type(_xpcall) == "function" then
        _____5F53_524D_8FD0_884C_65F6_9519_8BEF_5806_6808 = ""
        local ok = _xpcall(targetCallback, runtimeErrorTracebackHandler)
        if not ok then
            ____exports.reportRuntimeError(moduleName, _____5F53_524D_8FD0_884C_65F6_9519_8BEF_5806_6808 ~= "" and _____5F53_524D_8FD0_884C_65F6_9519_8BEF_5806_6808 or "未知运行时错误")
            return false
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
