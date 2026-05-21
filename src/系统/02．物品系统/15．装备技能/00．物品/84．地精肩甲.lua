--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_653B_51FB_6548_679C_6CE8_518C_8868 = require("系统.02．物品系统.15．装备技能.08．攻击效果.00．公共.02．攻击效果注册表")
local _____6CE8_518C_653B_51FB_6548_679C_914D_7F6E = ____02_FF0E_653B_51FB_6548_679C_6CE8_518C_8868["注册攻击效果配置"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
debugLogForce("地精肩甲", "地精肩甲.ts 已加载，配置 仅普通攻击=true 最大距离=200 固定伤害=10 攻击系数=0.5")
_____6CE8_518C_653B_51FB_6548_679C_914D_7F6E({
    ["装备名"] = "地精肩甲",
    ["触发侧"] = "受击者",
    ["效果类型"] = "反击伤害",
    ["仅普通攻击"] = true,
    ["最大距离"] = 200,
    ["固定伤害"] = 10,
    ["攻击系数"] = 0.5,
    ["伤害类型"] = "物理"
})
return ____exports
