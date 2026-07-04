--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有第二章后段Boss战利品"]
local _____53D6_6700_5927_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取最大生命"]
local _____53D6_51B7_5374_952E = ____07_FF0E_88C5_5907_8F85_52A9["取冷却键"]
local _____51B7_5374_5C31_7EEA = ____07_FF0E_88C5_5907_8F85_52A9["冷却就绪"]
local _____8FDB_5165_51B7_5374 = ____07_FF0E_88C5_5907_8F85_52A9["进入冷却"]
local _____6062_590D_751F_547D_9B54_6CD5 = ____07_FF0E_88C5_5907_8F85_52A9["恢复生命魔法"]
local _____4E34_65F6_73A9_5BB6_5C5E_6027 = ____07_FF0E_88C5_5907_8F85_52A9["临时玩家属性"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["第二章后段Boss战利品装备名"]
local _____88C5_5907_5C0F_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["装备小特效"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local function ____on_89E6_624B_6B8B_7247_62A4_7B26_4F24_5BB3_4FEE_6B63(context)
    local target = context.target
    local result = context.currentDamage
    if not (result > 0) or not _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1(target, _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["触手残片护符"]) then
        return result
    end
    if result < _____53D6_6700_5927_751F_547D(target) * 0.15 then
        return result
    end
    local key = _____53D6_51B7_5374_952E(target, "触手残片护符")
    if not _____51B7_5374_5C31_7EEA(key) then
        return result
    end
    _____8FDB_5165_51B7_5374(key, 20)
    _____6062_590D_751F_547D_9B54_6CD5(
        target,
        target,
        _____53D6_6700_5927_751F_547D(target) * 0.12
    )
    _____4E34_65F6_73A9_5BB6_5C5E_6027(target, "水属性抗性", 0.15, 5)
    _____64AD_653E_5355_4F4D_7279_6548(_____88C5_5907_5C0F_7279_6548["护盾闪光"], target, "origin", 0.8)
    return result
end
registerDamageModifier(____on_89E6_624B_6B8B_7247_62A4_7B26_4F24_5BB3_4FEE_6B63, 27)
return ____exports
