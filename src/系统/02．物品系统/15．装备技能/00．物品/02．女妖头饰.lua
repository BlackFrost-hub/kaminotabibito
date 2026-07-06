--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_0.resolveItemIdByName
local ____require_result_1 = require("lib.扩展函数.物品相关函数.物品累伤次数函数")
local _____5355_4F4D_7269_54C1_7D2F_4F24_6B21_6570 = ____require_result_1["单位物品累伤次数"]
local _____83B7_53D6_5355_4F4D_6307_5B9A_88C5_5907 = ____require_result_1["获取单位指定装备"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.01．debuff.01．暗影突袭")
local _____521B_5EFA_6697_5F71_7A81_88AD_8FFD_8E2A = ____require_result_2["创建暗影突袭追踪"]
local ____require_result_3 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local _____5EF6_540E_4E00_5E27_6267_884C_4F24_5BB3_6D3E_751F_6548_679C = ____require_result_3["延后一帧执行伤害派生效果"]
local ____require_result_4 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_4.doHeal
local ____require_result_5 = require("系统.02．物品系统.15．装备技能.02．累计伤害.01．累计伤害配置表")
local _____5973_5996_5934_9970_7D2F_8BA1_914D_7F6E = ____require_result_5["女妖头饰累计配置"]
local ____require_result_6 = require("系统.02．物品系统.15．装备技能.02．累计伤害.01．累计伤害配置表")
local _____5973_5996_5934_9970_5F3A_5316_7D2F_8BA1_914D_7F6E = ____require_result_6["女妖头饰强化累计配置"]
local jass = require("jass.common")
local GetItemCharges = jass.GetItemCharges
local SetItemCharges = jass.SetItemCharges
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local _____5973_5996_5934_9970ID = stringToFourCCSafe(resolveItemIdByName(_____5973_5996_5934_9970_7D2F_8BA1_914D_7F6E["物品名"]))
local _____5973_5996_5934_9970_5F3A_5316ID = stringToFourCCSafe(resolveItemIdByName(_____5973_5996_5934_9970_5F3A_5316_7D2F_8BA1_914D_7F6E["物品名"]))
____exports["处理女妖头饰累计"] = function(target, attacker, applied)
    if target == nil or target == 0 or attacker == nil or attacker == 0 or not (applied > 0) then
        return
    end
    local _____5973_5996_5934_9970_7269_54C1 = _____83B7_53D6_5355_4F4D_6307_5B9A_88C5_5907(target, _____5973_5996_5934_9970ID)
    local ____temp_8
    if resolveItemIdByName(_____5973_5996_5934_9970_5F3A_5316_7D2F_8BA1_914D_7F6E["物品名"]) ~= nil then
        ____temp_8 = _____83B7_53D6_5355_4F4D_6307_5B9A_88C5_5907(target, _____5973_5996_5934_9970_5F3A_5316ID)
    else
        ____temp_8 = nil
    end
    local _____5973_5996_5934_9970_5F3A_5316_7269_54C1 = ____temp_8
    local _____6709_5973_5996_5934_9970 = _____5973_5996_5934_9970_7269_54C1 ~= nil
    local _____6709_5973_5996_5934_9970_5F3A_5316 = _____5973_5996_5934_9970_5F3A_5316_7269_54C1 ~= nil
    if not _____6709_5973_5996_5934_9970 and not _____6709_5973_5996_5934_9970_5F3A_5316 then
        return
    end
    if _____6709_5973_5996_5934_9970 or _____6709_5973_5996_5934_9970_5F3A_5316 then
        local _____5230_8FBE_9608_503C = _____5355_4F4D_7269_54C1_7D2F_4F24_6B21_6570(
            target,
            _____5973_5996_5934_9970_7D2F_8BA1_914D_7F6E["物品名"],
            applied,
            1,
            _____5973_5996_5934_9970_7D2F_8BA1_914D_7F6E["累计阈值"],
            {["是否在CD中"] = false, ["达到阈值后重置"] = true}
        )
        if _____5230_8FBE_9608_503C then
            _____5EF6_540E_4E00_5E27_6267_884C_4F24_5BB3_6D3E_751F_6548_679C(function()
                _____521B_5EFA_6697_5F71_7A81_88AD_8FFD_8E2A(target, attacker, {["减益"] = {duration = 2, damagePerSecond = 500}})
            end)
            if _____6709_5973_5996_5934_9970_5F3A_5316 and _____5973_5996_5934_9970_5F3A_5316_7269_54C1 ~= nil then
                local _____5F53_524D_6B21_6570 = GetItemCharges(_____5973_5996_5934_9970_5F3A_5316_7269_54C1)
                local _____4E0B_6B21_6B21_6570 = _____5F53_524D_6B21_6570 + 1
                local _____8FBE_5230_6B21_6570_9608_503C = _____4E0B_6B21_6B21_6570 >= _____5973_5996_5934_9970_5F3A_5316_7D2F_8BA1_914D_7F6E["命中次数阈值"]
                local _____5199_56DE_6B21_6570 = _____8FBE_5230_6B21_6570_9608_503C and 1 or _____4E0B_6B21_6B21_6570
                SetItemCharges(_____5973_5996_5934_9970_5F3A_5316_7269_54C1, _____5199_56DE_6B21_6570)
                if _____8FBE_5230_6B21_6570_9608_503C then
                    doHeal({
                        HealSource = target,
                        HealTarget = target,
                        HealAmount = 1000,
                        HealManaAmount = 1000,
                        ItemHeal = true,
                        HealEffect = true,
                        ManaEffect = true
                    })
                end
            end
        end
    end
end
return ____exports
