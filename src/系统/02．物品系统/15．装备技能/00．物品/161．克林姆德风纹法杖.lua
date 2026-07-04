--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171 = require("系统.02．物品系统.15．装备技能.00．物品.154．第二章后段Boss战利品公共")
local _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["单位持有第二章后段Boss战利品"]
local _____662F_6280_80FD_4F24_5BB3 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["是技能伤害"]
local _____53D6_5355_4F4DID = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["取单位ID"]
local _____53D6_8303_56F4_654C_4EBA = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["取范围敌人"]
local _____9020_6210_88C5_5907_4F24_5BB3 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["造成装备伤害"]
local _____64AD_653E_70B9_7279_6548 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["播放点特效"]
local _____53D6_5355_4F4DX = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["取单位X"]
local _____53D6_5355_4F4DY = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["取单位Y"]
local _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["第二章后段Boss战利品装备名"]
local _____88C5_5907_4F24_5BB3_7C7B_578B = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["装备伤害类型"]
local _____88C5_5907_5C0F_7279_6548 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["装备小特效"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local _____98CE_8680_5C42_6570_8868 = {}
local function ____on_514B_6797_59C6_5FB7_98CE_7EB9_6CD5_6756_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied > 0) or not _____662F_6280_80FD_4F24_5BB3(snapshot) then
        return
    end
    if not _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1(attacker, _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["克林姆德风纹法杖"]) then
        return
    end
    local id = _____53D6_5355_4F4DID(target)
    if id == 0 then
        return
    end
    local next = (_____98CE_8680_5C42_6570_8868[id] or 0) + 1
    if next < 3 then
        _____98CE_8680_5C42_6570_8868[id] = next
        return
    end
    _____98CE_8680_5C42_6570_8868[id] = 0
    _____64AD_653E_70B9_7279_6548(
        _____88C5_5907_5C0F_7279_6548["小风爆"],
        _____53D6_5355_4F4DX(target),
        _____53D6_5355_4F4DY(target),
        0.9
    )
    local enemies = _____53D6_8303_56F4_654C_4EBA(attacker, target, 260)
    do
        local i = 0
        while i < #enemies do
            _____9020_6210_88C5_5907_4F24_5BB3(attacker, enemies[i + 1], 420, _____88C5_5907_4F24_5BB3_7C7B_578B["风"])
            i = i + 1
        end
    end
end
registerAppliedFinalDamageListener(____on_514B_6797_59C6_5FB7_98CE_7EB9_6CD5_6756_4F24_5BB3)
return ____exports
