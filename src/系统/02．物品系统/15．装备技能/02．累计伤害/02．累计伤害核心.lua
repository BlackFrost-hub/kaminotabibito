--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____88C5_5907_8C03_8BD5_65E5_5FD7 = ____20_FF0E_7269_54C1_8F85_52A9["装备调试日志"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.02．物品系统.15．装备技能.00．物品.01．回沙之书")
local _____5904_7406_56DE_6C99_4E4B_4E66_7D2F_8BA1 = ____require_result_1["处理回沙之书累计"]
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.00．物品.02．女妖头饰")
local _____5904_7406_5973_5996_5934_9970_7D2F_8BA1 = ____require_result_2["处理女妖头饰累计"]
local _____5DF2_521D_59CB_5316 = false
local function onAppliedFinalDamage(target, attacker, applied, snapshot)
    if not (applied >= 1) then
        return
    end
    if snapshot ~= nil and snapshot.isTrueDamage == true then
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
    _____88C5_5907_8C03_8BD5_65E5_5FD7("累计伤害核心", "已初始化并注册最终伤害监听")
    registerAppliedFinalDamageListener(onAppliedFinalDamage)
end
____exports["init累计伤害"]()
return ____exports
