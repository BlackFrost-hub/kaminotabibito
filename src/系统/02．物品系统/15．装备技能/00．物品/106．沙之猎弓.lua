--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_653B_51FB_6548_679C_6CE8_518C_8868 = require("系统.02．物品系统.15．装备技能.08．攻击效果.00．公共.02．攻击效果注册表")
local _____6CE8_518C_653B_51FB_6548_679C_914D_7F6E = ____02_FF0E_653B_51FB_6548_679C_6CE8_518C_8868["注册攻击效果配置"]
local ____01_FF0E_653B_51FB_6548_679C_5DE5_5177 = require("系统.02．物品系统.15．装备技能.08．攻击效果.00．公共.01．攻击效果工具")
local _____65BD_52A0_653B_51FB_6548_679C_7729_6655 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["施加攻击效果眩晕"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.01．debuff.04．护甲降低")
local _____65BD_52A0_5355_4F53_62A4_7532_964D_4F4EBuff = ____require_result_0["施加单体护甲降低Buff"]
local _____6C99_4E4B_730E_5F13_76EE_6807_51B7_5374 = {}
local _____53D6_670D_52A1_5668_65F6_95F4 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = _____53D6_670D_52A1_5668_65F6_95F4.getServerTime
local function _____6267_884C_6C99_4E4B_730E_5F13(_____4E0A_4E0B_6587)
    local sourceId = GetHandleId(_____4E0A_4E0B_6587.source)
    local targetId = GetHandleId(_____4E0A_4E0B_6587.target)
    local key = (tostring(sourceId) .. ":") .. tostring(targetId)
    local now = getServerTime()
    local last = _____6C99_4E4B_730E_5F13_76EE_6807_51B7_5374[key]
    if last ~= nil and now - last < 6000 then
        return
    end
    _____6C99_4E4B_730E_5F13_76EE_6807_51B7_5374[key] = now
    _____65BD_52A0_5355_4F53_62A4_7532_964D_4F4EBuff(_____4E0A_4E0B_6587.source, _____4E0A_4E0B_6587.target, {["持续时间"] = 6, ["护甲"] = 15, ["叠加键"] = "沙之猎弓"})
    _____65BD_52A0_653B_51FB_6548_679C_7729_6655(_____4E0A_4E0B_6587.source, _____4E0A_4E0B_6587.target, 1)
end
_____6CE8_518C_653B_51FB_6548_679C_914D_7F6E({
    ["装备名"] = "沙之猎弓",
    ["触发侧"] = "攻击者",
    ["效果类型"] = "护甲削减",
    ["仅普通攻击"] = true,
    ["最小距离"] = 500,
    ["自定义执行"] = _____6267_884C_6C99_4E4B_730E_5F13
})
return ____exports
