--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____16_FF0E_5355_4F4D_65F6_9650_6570_503C = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.16．单位时限数值")
local _____521B_5EFA_5355_4F4D_65F6_9650_6570_503C = ____16_FF0E_5355_4F4D_65F6_9650_6570_503C["创建单位时限数值"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local unregisterDamageModifier = ____require_result_0.unregisterDamageModifier
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.08．装备识别与冷却")
local _____5355_4F4D_6301_6709_88C5_5907 = ____require_result_1["单位持有装备"]
local _____53D6_88C5_5907_51B7_5374_952E = ____require_result_1["取装备冷却键"]
local _____88C5_5907_51B7_5374_5C31_7EEA = ____require_result_1["装备冷却就绪"]
local _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A = ____require_result_1["进入装备冷却并显示"]
local function _____53D6_4F24_5BB3_7C7B_578B(context)
    if context.isPhysicalDamage == true then
        return 1
    end
    if context.isMagicDamage == true then
        return 2
    end
    if context.isTrueDamage == true then
        return 3
    end
    if context.isMetalDamage == true then
        return 4
    end
    if context.isWoodDamage == true then
        return 5
    end
    if context.isWaterDamage == true then
        return 6
    end
    if context.isFireDamage == true then
        return 7
    end
    if context.isThunderDamage == true then
        return 8
    end
    if context.isLightDamage == true then
        return 9
    end
    if context.isDarkDamage == true then
        return 10
    end
    return 0
end
____exports["创建重复伤害类型适应"] = function(_____53C2_6570)
    local _____540D_79F0 = _____53C2_6570["名称"] or _____53C2_6570["装备名"]
    local _____8BB0_5F55 = _____521B_5EFA_5355_4F4D_65F6_9650_6570_503C(_____540D_79F0 .. "-伤害类型")
    local _____5DF2_505C_6B62 = false
    local _____4FEE_6B63_5668ID = registerDamageModifier(
        function(context)
            local current = context.currentDamage
            local unit = context.target
            if _____5DF2_505C_6B62 or not (current > 0) or unit == nil or unit == 0 or not _____5355_4F4D_6301_6709_88C5_5907(unit, _____53C2_6570["装备名"]) then
                return current
            end
            if _____53C2_6570["过滤伤害"] ~= nil and not _____53C2_6570["过滤伤害"](context) then
                return current
            end
            local ____type = _____53D6_4F24_5BB3_7C7B_578B(context)
            if ____type == 0 then
                return current
            end
            local cooldownKey = _____53D6_88C5_5907_51B7_5374_952E(unit, _____540D_79F0, "重复伤害类型适应")
            if not _____88C5_5907_51B7_5374_5C31_7EEA(cooldownKey) then
                return current
            end
            if _____8BB0_5F55["读取"](unit) ~= ____type then
                _____8BB0_5F55["写入"](unit, ____type, _____53C2_6570["记录持续秒"])
                return current
            end
            _____8BB0_5F55["清空"](unit)
            if (_____53C2_6570["冷却秒数"] or 0) > 0 then
                _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A(cooldownKey, _____53C2_6570["冷却秒数"], unit, _____53C2_6570["装备名"])
            end
            local result = current * _____53C2_6570["重复伤害倍率"]
            local ____opt_2 = _____53C2_6570["on适应"]
            if ____opt_2 ~= nil then
                ____opt_2({
                    ["单位"] = unit,
                    ["攻击者"] = context.attacker,
                    ["伤害类型"] = ____type,
                    ["原伤害"] = current,
                    ["修正后伤害"] = result,
                    ["上下文"] = context
                })
            end
            return result
        end,
        _____53C2_6570["优先级"] or 32
    )
    return {
        ["名称"] = _____540D_79F0,
        ["清空"] = function(unit)
            _____8BB0_5F55["清空"](unit)
        end,
        ["停止"] = function()
            if not _____5DF2_505C_6B62 then
                _____5DF2_505C_6B62 = true
                _____8BB0_5F55["清空"]()
                unregisterDamageModifier(_____4FEE_6B63_5668ID)
            end
        end
    }
end
return ____exports
