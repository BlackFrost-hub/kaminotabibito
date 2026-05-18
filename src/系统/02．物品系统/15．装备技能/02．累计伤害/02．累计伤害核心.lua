local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.01．debuff.index")
local _____662F_5426_4E3A_6697_5F71_7A81_88AD_6BD2_7D20_4F24_5BB3 = ____require_result_2["是否为暗影突袭毒素伤害"]
local ____require_result_3 = require("系统.02．物品系统.15．装备技能.00．物品.01．回沙之书")
local _____5904_7406_56DE_6C99_4E4B_4E66_7D2F_8BA1 = ____require_result_3["处理回沙之书累计"]
local ____require_result_4 = require("系统.02．物品系统.15．装备技能.00．物品.02．女妖头饰")
local _____5904_7406_5973_5996_5934_9970_7D2F_8BA1 = ____require_result_4["处理女妖头饰累计"]
local _____5DF2_521D_59CB_5316 = false
local function onAppliedFinalDamage(target, attacker, applied, snapshot)
    local ____debugLogForce_9 = debugLogForce
    local ____array_8 = __TS__SparseArrayNew(
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
    local ____opt_result_7
    if snapshot ~= nil then
        ____opt_result_7 = snapshot.isTrueDamage
    end
    __TS__SparseArrayPush(____array_8, ____opt_result_7)
    ____debugLogForce_9(__TS__SparseArraySpread(____array_8))
    if not (applied > 0) then
        debugLogForce("累计伤害核心", "applied=", applied, "不大于0，跳过")
        return
    end
    if snapshot ~= nil and snapshot.isTrueDamage == true then
        debugLogForce("累计伤害核心", "真实伤害，跳过")
        return
    end
    if _____662F_5426_4E3A_6697_5F71_7A81_88AD_6BD2_7D20_4F24_5BB3(target) then
        debugLogForce("累计伤害核心", "目标是暗影突袭毒素伤害，跳过")
        return
    end
    _____5904_7406_56DE_6C99_4E4B_4E66_7D2F_8BA1(target, attacker, applied)
    _____5904_7406_5973_5996_5934_9970_7D2F_8BA1(target, attacker, applied)
end
____exports["init累计伤害"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    registerAppliedFinalDamageListener(onAppliedFinalDamage)
end
____exports["init累计伤害"]()
return ____exports
