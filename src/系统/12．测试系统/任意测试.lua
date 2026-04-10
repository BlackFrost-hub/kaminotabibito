--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_Register = ____require_result_0.STES_Register
local STES_GetTable = ____require_result_0.STES_GetTable
local STES_Fire = ____require_result_0.STES_Fire
local _print = _G.print
local function resolveGgTrgByKey(self, key)
    local a = jglobals[key]
    if a ~= nil and a ~= 0 then
        return a
    end
    local b = jass[key]
    if b ~= nil and b ~= 0 then
        return b
    end
    local c = _G[key]
    if c ~= nil and c ~= 0 then
        return c
    end
    return nil
end
local key = "gg_trg____________________001"
if type(jass.CreateTimer) == "function" and type(jass.TimerStart) == "function" then
    local tm = jass.CreateTimer()
    jass.TimerStart(
        tm,
        1,
        false,
        function()
            _print(
                nil,
                (((((("[任意测试] 延迟1s查找 " .. key) .. " | jglobals=") .. tostring(jglobals[key] or "nil")) .. " | jass=") .. tostring(jass[key] or "nil")) .. " | globalThis=") .. tostring(_G[key] or "nil")
            )
            local trg = resolveGgTrgByKey(nil, key)
            if trg then
                STES_Register(nil, trg, "测试")
                local ht = STES_GetTable(nil)
                _print(
                    nil,
                    (("STES_Register 成功 | HT=" .. tostring(ht or "nil")) .. " | trg=") .. tostring(trg or "nil")
                )
                _print(nil, "STES_Fire 开始触发事件 '测试' ...")
                STES_Fire(nil, "测试")
                _print(nil, "STES_Fire 执行完毕")
            else
                _print(nil, ("STES_Register 失败: " .. key) .. " 在三处来源均为 nil")
            end
            if type(jass.DestroyTimer) == "function" then
                jass.DestroyTimer(tm)
            end
        end
    )
else
    _print(nil, "[任意测试] CreateTimer/TimerStart 不可用")
end
return ____exports
