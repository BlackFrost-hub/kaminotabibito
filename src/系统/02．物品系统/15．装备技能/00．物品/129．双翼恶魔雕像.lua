--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____20_FF0E_7269_54C1_8F85_52A9["施加临时属性效果"]
local ____require_result_0 = require("系统.04．伤害系统.05．闪避系统.01．闪避核心")
local registerDodgeAppliedFinalDamageListener = ____require_result_0.registerDodgeAppliedFinalDamageListener
local ____require_result_1 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_1.resolveItemIdByName
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_3.UnitHasItemOfTypeBJ
local _____53CC_7FFC_6076_9B54_96D5_50CF_7269_54C1ID = stringToFourCCSafe(resolveItemIdByName("双翼恶魔雕像"))
local function _____6DFB_52A0_95EA_907F_4E4B_798F_654F_6377(unit, value, durationMs)
    _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(unit, durationMs, {{["类型"] = "状态ID", ["属性ID"] = 4, ["数值"] = value}})
end
local function _____53CC_7FFC_6076_9B54_96D5_50CF_95EA_907F_76D1_542C(record, _applied, _snapshot)
    if _____53CC_7FFC_6076_9B54_96D5_50CF_7269_54C1ID == 0 then
        return
    end
    if record.isNormalAttack == true then
        return
    end
    if not UnitHasItemOfTypeBJ(record.target, _____53CC_7FFC_6076_9B54_96D5_50CF_7269_54C1ID) then
        return
    end
    _____6DFB_52A0_95EA_907F_4E4B_798F_654F_6377(record.target, 3, 20000)
end
____exports["init双翼恶魔雕像闪避之福"] = function()
    registerDodgeAppliedFinalDamageListener(_____53CC_7FFC_6076_9B54_96D5_50CF_95EA_907F_76D1_542C)
end
____exports["init双翼恶魔雕像闪避之福"]()
return ____exports
