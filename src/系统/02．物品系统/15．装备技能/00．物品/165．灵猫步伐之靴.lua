--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6709_6548_5B58_6D3B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位有效存活"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["播放单位特效"]
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.03．最终伤害触发模板")
local _____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F = ____require_result_0["注册最终伤害触发模板"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.04．移速提升")
local _____65BD_52A0_79FB_901F_63D0_5347Buff = ____require_result_1["施加移速提升Buff"]
local _____7075_732B_8DC3_6B65_51B7_5374_79D2_6570 = 10
local _____7075_732B_8DC3_6B65_79FB_901F_6BD4_4F8B = 0.3
local _____7075_732B_8DC3_6B65_6301_7EED_79D2_6570 = 2
local _____7075_732B_8DC3_6B65_7279_6548 = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
local function ____on_7075_732B_6B65_4F10_4E4B_9774_6700_7EC8_4F24_5BB3(event)
    local target = event["目标"]
    if not _____5355_4F4D_6709_6548_5B58_6D3B(target) then
        return
    end
    _____65BD_52A0_79FB_901F_63D0_5347Buff(target, target, {
        BuffID = _____5E38_89C4BuffID["灵猫步伐之靴_灵猫跃步"],
        ["持续时间"] = _____7075_732B_8DC3_6B65_6301_7EED_79D2_6570,
        ["基础移速百分比"] = _____7075_732B_8DC3_6B65_79FB_901F_6BD4_4F8B,
        ["图标路径"] = "Equipment\\Icon\\Shoes\\spirit_cat_steps_boots.blp",
        ["效果来源名称"] = "灵猫步伐之靴",
        ["效果来源类型"] = "装备"
    })
    _____64AD_653E_5355_4F4D_7279_6548(target, _____7075_732B_8DC3_6B65_7279_6548, "origin", 1)
end
_____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F({
    ["名称"] = "灵猫步伐之靴",
    ["装备名"] = "灵猫步伐之靴",
    ["持有者"] = "受击者",
    ["要求双方存活"] = false,
    ["冷却秒数"] = _____7075_732B_8DC3_6B65_51B7_5374_79D2_6570,
    ["冷却标签"] = "灵猫步伐之靴:灵猫跃步",
    ["冷却前缀"] = "米亚战利品",
    ["on触发"] = ____on_7075_732B_6B65_4F10_4E4B_9774_6700_7EC8_4F24_5BB3
})
return ____exports
