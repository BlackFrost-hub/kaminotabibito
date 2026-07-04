--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有第二章后段Boss战利品"]
local _____662F_654C_5BF9_5355_4F4D = ____07_FF0E_88C5_5907_8F85_52A9["是敌对单位"]
local _____6982_7387_901A_8FC7 = ____07_FF0E_88C5_5907_8F85_52A9["概率通过"]
local _____53D6_51B7_5374_952E = ____07_FF0E_88C5_5907_8F85_52A9["取冷却键"]
local _____51B7_5374_5C31_7EEA = ____07_FF0E_88C5_5907_8F85_52A9["冷却就绪"]
local _____8FDB_5165_51B7_5374_5E76_663E_793A = ____07_FF0E_88C5_5907_8F85_52A9["进入冷却并显示"]
local _____51C0_5316_8D1F_9762 = ____07_FF0E_88C5_5907_8F85_52A9["净化负面"]
local _____4E34_65F6_53D7_5230_6CBB_7597_7387 = ____07_FF0E_88C5_5907_8F85_52A9["临时受到治疗率"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["第二章后段Boss战利品装备名"]
local _____88C5_5907_5C0F_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["装备小特效"]
local ____require_result_0 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local registerAppliedFinalHealListener = ____require_result_0.registerAppliedFinalHealListener
local function ____on_51C0_571F_840C_82BD_5723_94C3_6CBB_7597(source, target, amount, isItemHeal)
    if not (amount > 0) or source == nil or source == 0 or target == nil or target == 0 then
        return
    end
    if _____662F_654C_5BF9_5355_4F4D(source, target) then
        return
    end
    if not _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1(source, _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["净土萌芽圣铃"]) then
        return
    end
    if not _____6982_7387_901A_8FC7(source, 0.22) then
        return
    end
    local key = _____53D6_51B7_5374_952E(source, "净土萌芽圣铃")
    if not _____51B7_5374_5C31_7EEA(key) then
        return
    end
    _____8FDB_5165_51B7_5374_5E76_663E_793A(key, 6, source, _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["净土萌芽圣铃"])
    if _____51C0_5316_8D1F_9762(target) then
        _____4E34_65F6_53D7_5230_6CBB_7597_7387(target, 0.18, 5)
    else
        _____4E34_65F6_53D7_5230_6CBB_7597_7387(target, 0.08, 4)
    end
    _____64AD_653E_5355_4F4D_7279_6548(_____88C5_5907_5C0F_7279_6548["护盾闪光"], target, "origin", 0.8)
end
registerAppliedFinalHealListener(____on_51C0_571F_840C_82BD_5723_94C3_6CBB_7597)
return ____exports
