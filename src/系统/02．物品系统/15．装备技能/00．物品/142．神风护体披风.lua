--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有第二章后段Boss战利品"]
local _____53D6_6700_5927_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取最大生命"]
local _____53D6_51B7_5374_952E = ____07_FF0E_88C5_5907_8F85_52A9["取冷却键"]
local _____51B7_5374_5C31_7EEA = ____07_FF0E_88C5_5907_8F85_52A9["冷却就绪"]
local _____8FDB_5165_51B7_5374 = ____07_FF0E_88C5_5907_8F85_52A9["进入冷却"]
local _____5F00_59CB_901A_7528_62A4_76FE = ____07_FF0E_88C5_5907_8F85_52A9["开始通用护盾"]
local _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["第二章后段Boss战利品装备名"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local function ____on_795E_98CE_62A4_4F53_62AB_98CE_4F24_5BB3_4FEE_6B63(context)
    local target = context.target
    local result = context.currentDamage
    if not (result > 0) or not _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1(target, _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["神风护体披风"]) then
        return result
    end
    if result < _____53D6_6700_5927_751F_547D(target) * 0.14 then
        return result
    end
    local key = _____53D6_51B7_5374_952E(target, "神风护体披风")
    if not _____51B7_5374_5C31_7EEA(key) then
        return result
    end
    _____8FDB_5165_51B7_5374(key, 16)
    _____5F00_59CB_901A_7528_62A4_76FE(
        target,
        target,
        900,
        5,
        "神风护体披风"
    )
    return result * 0.72
end
registerDamageModifier(____on_795E_98CE_62A4_4F53_62AB_98CE_4F24_5BB3_4FEE_6B63, 26)
return ____exports
