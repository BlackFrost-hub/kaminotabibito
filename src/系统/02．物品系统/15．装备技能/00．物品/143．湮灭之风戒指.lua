--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有第二章后段Boss战利品"]
local _____662F_6280_80FD_4F24_5BB3 = ____07_FF0E_88C5_5907_8F85_52A9["是技能伤害"]
local _____53D6_51B7_5374_952E = ____07_FF0E_88C5_5907_8F85_52A9["取冷却键"]
local _____51B7_5374_5C31_7EEA = ____07_FF0E_88C5_5907_8F85_52A9["冷却就绪"]
local _____8FDB_5165_51B7_5374 = ____07_FF0E_88C5_5907_8F85_52A9["进入冷却"]
local _____9020_6210_88C5_5907_4F24_5BB3 = ____07_FF0E_88C5_5907_8F85_52A9["造成装备伤害"]
local _____64AD_653E_70B9_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放点特效"]
local _____53D6_5355_4F4DX = ____07_FF0E_88C5_5907_8F85_52A9["取单位X"]
local _____53D6_5355_4F4DY = ____07_FF0E_88C5_5907_8F85_52A9["取单位Y"]
local _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["第二章后段Boss战利品装备名"]
local _____88C5_5907_4F24_5BB3_7C7B_578B = ____07_FF0E_88C5_5907_8F85_52A9["装备伤害类型"]
local _____88C5_5907_5C0F_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["装备小特效"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local _____65BD_52A0_6269_5C55_63A7_5236 = ____require_result_1["施加扩展控制"]
local function ____on_6E6E_706D_4E4B_98CE_6212_6307_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied > 0) or not _____662F_6280_80FD_4F24_5BB3(snapshot) then
        return
    end
    if not _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1(attacker, _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["湮灭之风戒指"]) then
        return
    end
    local key = _____53D6_51B7_5374_952E(attacker, "湮灭之风戒指")
    if not _____51B7_5374_5C31_7EEA(key) then
        return
    end
    _____8FDB_5165_51B7_5374(key, 12)
    _____64AD_653E_70B9_7279_6548(
        _____88C5_5907_5C0F_7279_6548["小风爆"],
        _____53D6_5355_4F4DX(target),
        _____53D6_5355_4F4DY(target),
        0.8
    )
    _____9020_6210_88C5_5907_4F24_5BB3(attacker, target, 300, _____88C5_5907_4F24_5BB3_7C7B_578B["风"])
    _____65BD_52A0_6269_5C55_63A7_5236(attacker, target, "silence", {["持续时间"] = 1.2})
end
registerAppliedFinalDamageListener(____on_6E6E_706D_4E4B_98CE_6212_6307_4F24_5BB3)
return ____exports
