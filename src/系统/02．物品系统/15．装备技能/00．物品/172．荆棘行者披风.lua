--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171 = require("系统.02．物品系统.15．装备技能.00．物品.154．第二章后段Boss战利品公共")
local _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["单位持有第二章后段Boss战利品"]
local _____662F_7EAF_666E_653B = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["是纯普攻"]
local _____9020_6210_88C5_5907_4F24_5BB3 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["造成装备伤害"]
local _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["第二章后段Boss战利品装备名"]
local _____88C5_5907_4F24_5BB3_7C7B_578B = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["装备伤害类型"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local function ____on_8346_68D8_884C_8005_62AB_98CE_53D7_51FB(target, attacker, applied, snapshot)
    if not (applied > 0) or not _____662F_7EAF_666E_653B(snapshot) then
        return
    end
    if not _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1(target, _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["荆棘行者披风"]) then
        return
    end
    _____9020_6210_88C5_5907_4F24_5BB3(target, attacker, 190, _____88C5_5907_4F24_5BB3_7C7B_578B["自然"])
end
registerAppliedFinalDamageListener(____on_8346_68D8_884C_8005_62AB_98CE_53D7_51FB)
return ____exports
