--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 硬件输入 - 内部工具
local jass = require("jass.common")
local japi = require("jass.japi")
---
-- @deprecated 仅保留给历史兼容；新代码禁止用：TSTL 会对「取出再调」编成 f(nil,...) 导致 JAPI 参数错位。
-- 请改用 `const japi = require("jass.japi"); japi.DzXxx(...)` 直接点号调用。
function ____exports.japiFn(self, name)
    local f = japi[name]
    local ____temp_0
    if type(f) == "function" then
        ____temp_0 = f
    else
        ____temp_0 = nil
    end
    return ____temp_0
end
function ____exports.has(self, name)
    return type(japi[name]) == "function"
end
function ____exports.isHardwareAPIAvailable(self)
    return type(japi.DzIsKeyDown) == "function" and type(japi.DzGetMouseX) == "function" and type(japi.DzGetMouseY) == "function"
end
function ____exports.createTriggerOrNull(self)
    if type(jass.CreateTrigger) ~= "function" then
        return nil
    end
    return jass.CreateTrigger()
end
return ____exports
