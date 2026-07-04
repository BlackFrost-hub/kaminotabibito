--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____4E34_65F6_53D7_5230_6CBB_7597_7387 = ____07_FF0E_88C5_5907_8F85_52A9["临时受到治疗率"]
local _____5F00_59CB_901A_7528_62A4_76FE = ____07_FF0E_88C5_5907_8F85_52A9["开始通用护盾"]
local _____53D6_8303_56F4_53CB_65B9 = ____07_FF0E_88C5_5907_8F85_52A9["取范围友方"]
local _____53D6_51B7_5374_952E = ____07_FF0E_88C5_5907_8F85_52A9["取冷却键"]
local _____51B7_5374_5C31_7EEA = ____07_FF0E_88C5_5907_8F85_52A9["冷却就绪"]
local _____8FDB_5165_51B7_5374 = ____07_FF0E_88C5_5907_8F85_52A9["进入冷却"]
local _____53D6_6700_5927_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取最大生命"]
local _____53D6_5F53_524D_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取当前生命"]
local _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有第二章后段Boss战利品"]
local _____662F_6280_80FD_4F24_5BB3 = ____07_FF0E_88C5_5907_8F85_52A9["是技能伤害"]
local _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["第二章后段Boss战利品装备名"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local function ____on_653B_57CE_53F7_4EE4_5723_5370_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied > 0) or not _____662F_6280_80FD_4F24_5BB3(snapshot) then
        return
    end
    if not _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1(attacker, _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["攻城号令圣印"]) then
        return
    end
    local key = _____53D6_51B7_5374_952E(attacker, "攻城号令圣印")
    if not _____51B7_5374_5C31_7EEA(key) then
        return
    end
    _____8FDB_5165_51B7_5374(key, 14)
    local allies = _____53D6_8303_56F4_53CB_65B9(attacker, 650)
    do
        local i = 0
        while i < #allies do
            local unit = allies[i + 1]
            _____4E34_65F6_53D7_5230_6CBB_7597_7387(unit, 0.12, 6)
            if _____53D6_5F53_524D_751F_547D(unit) < _____53D6_6700_5927_751F_547D(unit) * 0.5 then
                _____5F00_59CB_901A_7528_62A4_76FE(
                    attacker,
                    unit,
                    650,
                    5,
                    "攻城号令圣印"
                )
            end
            i = i + 1
        end
    end
end
registerAppliedFinalDamageListener(____on_653B_57CE_53F7_4EE4_5723_5370_4F24_5BB3)
return ____exports
