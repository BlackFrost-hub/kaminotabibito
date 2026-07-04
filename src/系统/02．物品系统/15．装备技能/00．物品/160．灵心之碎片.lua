--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171 = require("系统.02．物品系统.15．装备技能.00．物品.154．第二章后段Boss战利品公共")
local _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["单位持有第二章后段Boss战利品"]
local _____53D6_5F53_524D_751F_547D = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["取当前生命"]
local _____53D6_6700_5927_751F_547D = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["取最大生命"]
local _____53D6_51B7_5374_952E = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["取冷却键"]
local _____51B7_5374_5C31_7EEA = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["冷却就绪"]
local _____8FDB_5165_51B7_5374 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["进入冷却"]
local _____6062_590D_751F_547D_9B54_6CD5 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["恢复生命魔法"]
local _____77ED_6682_65E0_654C = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["短暂无敌"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["播放单位特效"]
local _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["第二章后段Boss战利品装备名"]
local _____88C5_5907_5C0F_7279_6548 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["装备小特效"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local function ____on_7075_5FC3_4E4B_788E_7247_4F24_5BB3_4FEE_6B63(context)
    local target = context.target
    local result = context.currentDamage
    if not (result > 0) or not _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1(target, _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["灵心之碎片"]) then
        return result
    end
    local life = _____53D6_5F53_524D_751F_547D(target)
    if life - result > 1 then
        return result
    end
    local key = _____53D6_51B7_5374_952E(target, "灵心之碎片")
    if not _____51B7_5374_5C31_7EEA(key) then
        return result
    end
    _____8FDB_5165_51B7_5374(key, 120)
    _____77ED_6682_65E0_654C(target, 1)
    _____6062_590D_751F_547D_9B54_6CD5(
        target,
        target,
        _____53D6_6700_5927_751F_547D(target) * 0.1
    )
    _____64AD_653E_5355_4F4D_7279_6548(_____88C5_5907_5C0F_7279_6548["护盾闪光"], target, "origin", 1)
    return life > 1 and life - 1 or 0
end
registerDamageModifier(____on_7075_5FC3_4E4B_788E_7247_4F24_5BB3_4FEE_6B63, 5)
return ____exports
