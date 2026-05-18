local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.00．物品.01．回沙之书")
local _____5904_7406_56DE_6C99_4E4B_4E66_7D2F_8BA1 = ____require_result_2["处理回沙之书累计"]
local ____require_result_3 = require("系统.02．物品系统.15．装备技能.00．物品.02．女妖头饰")
local _____5904_7406_5973_5996_5934_9970_7D2F_8BA1 = ____require_result_3["处理女妖头饰累计"]
local _____5DF2_521D_59CB_5316 = false
local function onAppliedFinalDamage(target, attacker, applied, snapshot)
    local ____debugLogForce_8 = debugLogForce
    local ____array_7 = __TS__SparseArrayNew(
        "累计伤害核心",
        "收到最终伤害",
        "target:",
        target,
        "attacker:",
        attacker,
        "applied:",
        applied,
        "isTrueDamage:"
    )
    local ____opt_result_6
    if snapshot ~= nil then
        ____opt_result_6 = snapshot.isTrueDamage
    end
    __TS__SparseArrayPush(____array_7, ____opt_result_6)
    ____debugLogForce_8(__TS__SparseArraySpread(____array_7))
    local ____debugLogForce_13 = debugLogForce
    local ____temp_12 = applied > 0
    local ____opt_result_11
    if snapshot ~= nil then
        ____opt_result_11 = snapshot.isTrueDamage
    end
    ____debugLogForce_13(
        "累计伤害核心",
        "前置判断",
        "applied>0:",
        ____temp_12,
        "isTrueDamage:",
        ____opt_result_11
    )
    if not (applied > 0) then
        debugLogForce("累计伤害核心", "applied=", applied, "不大于0，跳过")
        return
    end
    if snapshot ~= nil and snapshot.isTrueDamage == true then
        debugLogForce("累计伤害核心", "真实伤害，跳过")
        return
    end
    debugLogForce("累计伤害核心", "准备调用回沙之书累计")
    _____5904_7406_56DE_6C99_4E4B_4E66_7D2F_8BA1(target, attacker, applied)
    debugLogForce("累计伤害核心", "回沙之书累计调用完成")
    debugLogForce("累计伤害核心", "准备调用女妖头饰累计")
    _____5904_7406_5973_5996_5934_9970_7D2F_8BA1(target, attacker, applied)
    debugLogForce("累计伤害核心", "女妖头饰累计调用完成")
end
____exports["init累计伤害"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    debugLogForce("累计伤害核心", "已初始化并注册最终伤害监听")
    registerAppliedFinalDamageListener(onAppliedFinalDamage)
end
____exports["init累计伤害"]()
return ____exports
