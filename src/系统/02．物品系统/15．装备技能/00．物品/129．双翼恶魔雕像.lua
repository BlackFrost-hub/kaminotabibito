--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.04．伤害系统.05．闪避系统.01．闪避核心")
local registerDodgeAppliedFinalDamageListener = ____require_result_1.registerDodgeAppliedFinalDamageListener
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_2.SGSS_SetState
local ____require_result_3 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_3.resolveItemIdByName
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_4.stringToFourCCSafe
local ____require_result_5 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_5.UnitHasItemOfTypeBJ
local _____53CC_7FFC_6076_9B54_96D5_50CF_7269_54C1ID = stringToFourCCSafe(resolveItemIdByName("双翼恶魔雕像"))
local _____5F85_79FB_9664_654F_6377_5217_8868 = {}
local function _____79FB_9664_4E00_6761_95EA_907F_4E4B_798F_654F_6377()
    local record = table.remove(_____5F85_79FB_9664_654F_6377_5217_8868, 1)
    if record == nil then
        return
    end
    SGSS_SetState(record.unit, 4, -record.value)
end
local function _____6DFB_52A0_95EA_907F_4E4B_798F_654F_6377(unit, value, durationMs)
    SGSS_SetState(unit, 4, value)
    _____5F85_79FB_9664_654F_6377_5217_8868[#_____5F85_79FB_9664_654F_6377_5217_8868 + 1] = {unit = unit, value = value}
    addDelayedCallback(durationMs, _____79FB_9664_4E00_6761_95EA_907F_4E4B_798F_654F_6377)
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
