--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- STES 暴露模块 - 将 JASS 的 STES_* 暴露到 _G，供 Lua 模块使用
-- 在 main 中最早加载
local jass = require("jass.common")
local g = require("jass.globals")
local DEBUG = true
local P0 = jass.Player(0)
local function dbg(self, msg)
    if DEBUG then
        jass.DisplayTimedTextToPlayer(
            P0,
            0,
            0,
            12,
            "[STES] " .. msg
        )
    end
end
local function expose(self)
    local ____jass_STES_Register_0 = jass.STES_Register
    if ____jass_STES_Register_0 == nil then
        ____jass_STES_Register_0 = g.STES_Register
    end
    local sr = ____jass_STES_Register_0
    local ____jass_STES_Trigger_1 = jass.STES_Trigger
    if ____jass_STES_Trigger_1 == nil then
        ____jass_STES_Trigger_1 = g.STES_Trigger
    end
    local st = ____jass_STES_Trigger_1
    local ____jass_STES_GetTriggerPlayer_2 = jass.STES_GetTriggerPlayer
    if ____jass_STES_GetTriggerPlayer_2 == nil then
        ____jass_STES_GetTriggerPlayer_2 = g.STES_GetTriggerPlayer
    end
    local gp = ____jass_STES_GetTriggerPlayer_2
    if type(sr) == "function" then
        _G.STES_Register = sr
        if not jass.STES_Register then
            jass.STES_Register = sr
        end
        dbg(nil, "STES_Register: 已暴露")
    else
        dbg(nil, "STES_Register: 未找到 (jass.common 无此函数)")
    end
    if type(st) == "function" then
        _G.STES_Trigger = st
        if not jass.STES_Trigger then
            jass.STES_Trigger = st
        end
        dbg(nil, "STES_Trigger: 已暴露")
    end
    if type(gp) == "function" then
        _G.STES_GetTriggerPlayer = gp
        if not jass.STES_GetTriggerPlayer then
            jass.STES_GetTriggerPlayer = gp
        end
    end
end
expose(nil)
return ____exports
