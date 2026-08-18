--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.00．配置")
local _____914D_7F6E = ____00_FF0E_914D_7F6E["十六夜咲夜基础技能配置"]
local jass = require("jass.common")
local ____require_result_0 = require("平台扩展API动作")
local _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4 = ____require_result_0["技能_设置技能冷却时间"]
local ____require_result_1 = require("系统.03．技能系统.01．技能冷却.01．冷却缩减计算")
local getCooldownReduction = ____require_result_1.getCooldownReduction
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local ____require_result_3 = require("lib.扩展函数.BJ函数.08．单位BJ扩展")
local ForceUICancelBJ = ____require_result_3.ForceUICancelBJ
local function _____5EF6_8FDF_53D6_6D88_5341_516D_591C_54B2_591C_7B26_5361_754C_9762(variable)
    ForceUICancelBJ(variable)
end
--- 对齐源JASS：符卡入口立即取消一次，并在0.20秒后再取消一次。
____exports["取消十六夜咲夜符卡界面"] = function(caster)
    if caster == nil or caster == 0 then
        return
    end
    local player = jass.GetOwningPlayer(caster)
    if player == nil or player == 0 then
        return
    end
    ForceUICancelBJ(player)
    addDelayedCallback(200, _____5EF6_8FDF_53D6_6D88_5341_516D_591C_54B2_591C_7B26_5361_754C_9762, player)
end
--- 符卡按钮本体有物编冷却；这里统一设置共享的 A00Y 符卡书冷却。
____exports["设置十六夜咲夜符卡书冷却"] = function(caster, baseCooldown, _____53D6_6D88_754C_9762)
    if _____53D6_6D88_754C_9762 == nil then
        _____53D6_6D88_754C_9762 = true
    end
    if caster == nil or caster == 0 or baseCooldown <= 0 then
        return false
    end
    if _____53D6_6D88_754C_9762 then
        ____exports["取消十六夜咲夜符卡界面"](caster)
    end
    local reduction = getCooldownReduction(caster) or 0
    if reduction < 0 then
        reduction = 0
    end
    if reduction > 0.35 then
        reduction = 0.35
    end
    local cooldown = baseCooldown * (1 - reduction)
    return _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(caster, _____914D_7F6E["技能"]["R魔法书"]["类型ID"], cooldown, baseCooldown)
end
return ____exports
