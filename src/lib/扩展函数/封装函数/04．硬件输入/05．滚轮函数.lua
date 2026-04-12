--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_5185_90E8_5DE5_5177 = require("lib.扩展函数.封装函数.04．硬件输入.02．内部工具")
local createTriggerOrNull = ____02_FF0E_5185_90E8_5DE5_5177.createTriggerOrNull
--- 硬件输入 - 滚轮函数
-- 
-- 与 04．键盘函数 相同：勿用 japiFn 取出再调用，否则 TSTL 会编成 f(nil, ...) 导致参数错位、注册失败（errjhw 371 等）。
local japi = require("jass.japi")
function ____exports.getWheelDelta(self)
    if type(japi.DzGetWheelDelta) ~= "function" then
        return 0
    end
    return japi.DzGetWheelDelta()
end
function ____exports.registerMouseWheel(self, sync, action)
    local trig = createTriggerOrNull(nil)
    if not trig then
        return nil
    end
    if type(japi.DzTriggerRegisterMouseWheelEventByCode) ~= "function" then
        return nil
    end
    japi.DzTriggerRegisterMouseWheelEventByCode(trig, sync, action)
    return trig
end
return ____exports
