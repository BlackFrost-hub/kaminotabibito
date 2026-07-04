--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171 = require("系统.02．物品系统.15．装备技能.00．物品.154．第二章后段Boss战利品公共")
local _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["单位持有第二章后段Boss战利品"]
local _____662F_6280_80FD_4F24_5BB3 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["是技能伤害"]
local _____6982_7387_901A_8FC7 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["概率通过"]
local _____53D6_51B7_5374_952E = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["取冷却键"]
local _____51B7_5374_5C31_7EEA = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["冷却就绪"]
local _____8FDB_5165_51B7_5374 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["进入冷却"]
local _____9020_6210_88C5_5907_4F24_5BB3 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["造成装备伤害"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["播放单位特效"]
local _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["第二章后段Boss战利品装备名"]
local _____88C5_5907_4F24_5BB3_7C7B_578B = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["装备伤害类型"]
local _____88C5_5907_5C0F_7279_6548 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["装备小特效"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local _____65BD_52A0_6269_5C55_63A7_5236 = ____require_result_2["施加扩展控制"]
local function _____5EF6_8FDF_6839_987B_4F24_5BB3(source, target)
    _____9020_6210_88C5_5907_4F24_5BB3(source, target, 150, _____88C5_5907_4F24_5BB3_7C7B_578B["自然"])
end
local function ____on_8150_8D25_6839_987B_6CD5_6756_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied > 0) or not _____662F_6280_80FD_4F24_5BB3(snapshot) then
        return
    end
    if not _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1(attacker, _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["腐败根须法杖"]) then
        return
    end
    if not _____6982_7387_901A_8FC7(attacker, 0.15) then
        return
    end
    local key = _____53D6_51B7_5374_952E(attacker, "腐败根须法杖")
    if not _____51B7_5374_5C31_7EEA(key) then
        return
    end
    _____8FDB_5165_51B7_5374(key, 4)
    _____64AD_653E_5355_4F4D_7279_6548(_____88C5_5907_5C0F_7279_6548["根须"], target, "origin", 2.5)
    _____65BD_52A0_6269_5C55_63A7_5236(attacker, target, "roots", {["持续时间"] = 1.5})
    _____9020_6210_88C5_5907_4F24_5BB3(attacker, target, 180, _____88C5_5907_4F24_5BB3_7C7B_578B["自然"])
    addDelayedCallback(
        1000,
        function()
            _____5EF6_8FDF_6839_987B_4F24_5BB3(attacker, target)
        end
    )
    addDelayedCallback(
        2000,
        function()
            _____5EF6_8FDF_6839_987B_4F24_5BB3(attacker, target)
        end
    )
end
registerAppliedFinalDamageListener(____on_8150_8D25_6839_987B_6CD5_6756_4F24_5BB3)
return ____exports
