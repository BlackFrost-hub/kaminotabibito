--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_653B_51FB_6548_679C_6CE8_518C_8868 = require("系统.02．物品系统.15．装备技能.08．攻击效果.00．公共.02．攻击效果注册表")
local _____6CE8_518C_653B_51FB_6548_679C_914D_7F6E = ____02_FF0E_653B_51FB_6548_679C_6CE8_518C_8868["注册攻击效果配置"]
local ____149_FF0E_5F71_9AA8_6218_5229_54C1_516C_5171 = require("系统.02．物品系统.15．装备技能.00．物品.149．影骨战利品公共")
local _____5F71_9AA8_6218_5229_54C1_88C5_5907_540D = ____149_FF0E_5F71_9AA8_6218_5229_54C1_516C_5171["影骨战利品装备名"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local Atan2 = jass.Atan2
local bj_RADTODEG = jass.bj_RADTODEG
local _____5E7D_5F71_547D_4E2D_5C0F_7206_70B9_7279_6548 = "Common\\Effect\\Element\\Dark\\ShadowHitBurst.mdx"
local _____5E7D_5F71_5315_9996_4FA7_540E_65B9_89E6_53D1_6982_7387 = 0.25
local function _____5F52_4E00_89D2_5EA6(angle)
    local result = angle
    while result < 0 do
        result = result + 360
    end
    while result >= 360 do
        result = result - 360
    end
    return result
end
local function _____89D2_5EA6_5DEE(a, b)
    local diff = _____5F52_4E00_89D2_5EA6(a - b)
    if diff > 180 then
        diff = 360 - diff
    end
    return diff
end
local function _____653B_51FB_8005_5728_76EE_6807_4FA7_540E_65B9(attacker, target)
    if attacker == nil or attacker == 0 or target == nil or target == 0 then
        return false
    end
    local angle = Atan2(
        GetUnitY(attacker) - GetUnitY(target),
        GetUnitX(attacker) - GetUnitX(target)
    ) * bj_RADTODEG
    return _____89D2_5EA6_5DEE(
        angle,
        GetUnitFacing(target)
    ) >= 90
end
local function _____8BA1_7B97_5E7D_5F71_5315_9996_89E6_53D1_6982_7387(ctx)
    return _____653B_51FB_8005_5728_76EE_6807_4FA7_540E_65B9(ctx.source, ctx.target) and _____5E7D_5F71_5315_9996_4FA7_540E_65B9_89E6_53D1_6982_7387 or 0
end
_____6CE8_518C_653B_51FB_6548_679C_914D_7F6E({
    ["装备名"] = _____5F71_9AA8_6218_5229_54C1_88C5_5907_540D["幽影匕首"],
    ["触发侧"] = "攻击者",
    ["效果类型"] = "额外伤害",
    ["仅普通攻击"] = true,
    ["概率计算"] = _____8BA1_7B97_5E7D_5F71_5315_9996_89E6_53D1_6982_7387,
    ["固定伤害"] = 260,
    ["攻击系数"] = 0.35,
    ["伤害类型"] = "暗影",
    ["特效"] = _____5E7D_5F71_547D_4E2D_5C0F_7206_70B9_7279_6548
})
return ____exports
