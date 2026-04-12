--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_6838_5FC3_7EDF_8BA1 = require("lib.扩展函数.封装函数.05．泄露审计.01．核心统计")
local track = ____01_FF0E_6838_5FC3_7EDF_8BA1.track
local untrack = ____01_FF0E_6838_5FC3_7EDF_8BA1.untrack
--- 泄露审计 - 计时器
local jass = require("jass.common")
--- 创建计时器（记得用 destroyTimer 回收），tag 代表来源模块
function ____exports.createTimer(self, tag)
    local t = jass.CreateTimer()
    track(nil, "timer", t, tag)
    return t
end
function ____exports.destroyTimer(self, t)
    if not t then
        return
    end
    untrack(nil, "timer", t)
    if type(jass.DestroyTimer) == "function" then
        jass.DestroyTimer(t)
    end
end
return ____exports
