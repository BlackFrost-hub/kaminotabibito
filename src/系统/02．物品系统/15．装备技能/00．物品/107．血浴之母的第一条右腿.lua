--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_653B_51FB_6548_679C_6CE8_518C_8868 = require("系统.02．物品系统.15．装备技能.08．攻击效果.00．公共.02．攻击效果注册表")
local _____6CE8_518C_653B_51FB_6548_679C_914D_7F6E = ____02_FF0E_653B_51FB_6548_679C_6CE8_518C_8868["注册攻击效果配置"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_79FB_901F_63D0_5347Buff = ____require_result_0["施加移速提升Buff"]
local function _____89E6_53D1_8840_6D74_53F3_817F_79FB_901F_63D0_5347(ctx)
    _____65BD_52A0_79FB_901F_63D0_5347Buff(ctx.source, ctx.source, {["持续时间"] = 3, ["基础移速百分比"] = 0.1})
end
_____6CE8_518C_653B_51FB_6548_679C_914D_7F6E({
    ["装备名"] = "血浴之母的第一条右腿",
    ["触发侧"] = "攻击者",
    ["效果类型"] = "额外伤害",
    ["最大距离"] = 200,
    ["自定义执行"] = _____89E6_53D1_8840_6D74_53F3_817F_79FB_901F_63D0_5347
})
return ____exports
