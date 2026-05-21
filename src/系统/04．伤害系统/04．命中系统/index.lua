--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local ____require_result_1 = require("系统.04．伤害系统.04．命中系统.01．命中核心")
local _____6267_884C_547D_4E2D_5224_5B9A = ____require_result_1["执行命中判定"]
local ____require_result_2 = require("系统.04．伤害系统.05．闪避系统.01．闪避核心")
local _____6267_884C_95EA_907F_5224_5B9A = ____require_result_2["执行闪避判定"]
local ____require_result_3 = require("系统.04．伤害系统.06．暴击系统.01．暴击核心")
local _____6267_884C_66B4_51FB_5224_5B9A = ____require_result_3["执行暴击判定"]
local _____547D_4E2D_95EA_907F_66B4_51FB_4FEE_6B63_5668_4F18_5148_7EA7 = 100
local _____5DF2_6CE8_518C_547D_4E2D_95EA_907F_66B4_51FB_4FEE_6B63_5668 = false
--- 命中/闪避/暴击共用同一个伤害修正器，顺序固定：
-- 1. 命中失败：本次伤害直接归零，并且不再进入闪避/暴击。
-- 2. 闪避成功：按闪避系统结果结算，并且不再进入暴击。
-- 3. 暴击成功：只改写当前伤害数值，业务效果走暴击系统的最终伤害桥接。
local function _____547D_4E2D_95EA_907F_66B4_51FB_4F24_5BB3_4FEE_6B63(context)
    if context == nil then
        return 0
    end
    if context.currentDamage < 1.1 then
        return context.currentDamage
    end
    local _____547D_4E2D_7ED3_679C = _____6267_884C_547D_4E2D_5224_5B9A(context.attacker, context.target, context.currentDamage)
    if _____547D_4E2D_7ED3_679C["结束链路"] then
        return _____547D_4E2D_7ED3_679C["伤害"]
    end
    local _____95EA_907F_7ED3_679C = _____6267_884C_95EA_907F_5224_5B9A({
        attacker = context.attacker,
        target = context.target,
        currentDamage = _____547D_4E2D_7ED3_679C["伤害"],
        isPhysicalDamage = context.isPhysicalDamage == true,
        isNormalAttack = context.isNormalAttack == true
    })
    if _____95EA_907F_7ED3_679C["结束链路"] then
        return _____95EA_907F_7ED3_679C["伤害"]
    end
    local _____66B4_51FB_7ED3_679C = _____6267_884C_66B4_51FB_5224_5B9A({
        attacker = context.attacker,
        target = context.target,
        currentDamage = _____95EA_907F_7ED3_679C["伤害"],
        isPhysicalDamage = context.isPhysicalDamage == true,
        isEnhancedDamage = context.isEnhancedDamage == true,
        isNormalAttack = context.isNormalAttack == true,
        isRangedAttack = context.isRangedAttack == true,
        isSkillAttack = context.isSkillAttack == true
    })
    return _____66B4_51FB_7ED3_679C["伤害"]
end
____exports["init命中闪避暴击系统"] = function()
    if _____5DF2_6CE8_518C_547D_4E2D_95EA_907F_66B4_51FB_4FEE_6B63_5668 then
        return
    end
    _____5DF2_6CE8_518C_547D_4E2D_95EA_907F_66B4_51FB_4FEE_6B63_5668 = true
    registerDamageModifier(_____547D_4E2D_95EA_907F_66B4_51FB_4F24_5BB3_4FEE_6B63, _____547D_4E2D_95EA_907F_66B4_51FB_4FEE_6B63_5668_4F18_5148_7EA7)
end
____exports["init命中闪避暴击系统"]()
do
    local ____export = require("系统.04．伤害系统.04．命中系统.00．命中配置")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.04．命中系统.01．命中核心")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
return ____exports
