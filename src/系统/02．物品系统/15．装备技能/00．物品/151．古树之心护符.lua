--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有第二章后段Boss战利品"]
local _____53D6_5355_4F4DID = ____07_FF0E_88C5_5907_8F85_52A9["取单位ID"]
local _____51C0_5316_8D1F_9762 = ____07_FF0E_88C5_5907_8F85_52A9["净化负面"]
local _____6062_590D_751F_547D_9B54_6CD5 = ____07_FF0E_88C5_5907_8F85_52A9["恢复生命魔法"]
local _____53D6_6700_5927_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取最大生命"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["第二章后段Boss战利品装备名"]
local _____88C5_5907_5C0F_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["装备小特效"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local _____53E4_6811_4E4B_5FC3_5C42_6570_8868 = {}
local function ____on_53E4_6811_4E4B_5FC3_62A4_7B26_53D7_4F24(target, attacker, applied, snapshot)
    if not (applied > 0) then
        return
    end
    if not _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1(target, _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["古树之心护符"]) then
        return
    end
    local id = _____53D6_5355_4F4DID(target)
    if id == 0 then
        return
    end
    local next = (_____53E4_6811_4E4B_5FC3_5C42_6570_8868[id] or 0) + 1
    if next < 4 then
        _____53E4_6811_4E4B_5FC3_5C42_6570_8868[id] = next
        return
    end
    _____53E4_6811_4E4B_5FC3_5C42_6570_8868[id] = 0
    _____51C0_5316_8D1F_9762(target)
    _____6062_590D_751F_547D_9B54_6CD5(
        target,
        target,
        _____53D6_6700_5927_751F_547D(target) * 0.08
    )
    _____64AD_653E_5355_4F4D_7279_6548(_____88C5_5907_5C0F_7279_6548["护盾闪光"], target, "origin", 0.8)
end
registerAppliedFinalDamageListener(____on_53E4_6811_4E4B_5FC3_62A4_7B26_53D7_4F24)
return ____exports
