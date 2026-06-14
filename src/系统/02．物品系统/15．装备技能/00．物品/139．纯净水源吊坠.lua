--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____137_FF0E_7C73_4E9A_6218_5229_54C1_516C_5171 = require("系统.02．物品系统.15．装备技能.00．物品.137．米亚战利品公共")
local _____5355_4F4D_6301_6709_7C73_4E9A_6218_5229_54C1 = ____137_FF0E_7C73_4E9A_6218_5229_54C1_516C_5171["单位持有米亚战利品"]
local _____7C73_4E9A_6218_5229_54C1_88C5_5907_540D = ____137_FF0E_7C73_4E9A_6218_5229_54C1_516C_5171["米亚战利品装备名"]
local _____7C73_4E9A_88C5_5907_51B7_5374_4E2D = ____137_FF0E_7C73_4E9A_6218_5229_54C1_516C_5171["米亚装备冷却中"]
local _____8BBE_7F6E_7C73_4E9A_88C5_5907_51B7_5374 = ____137_FF0E_7C73_4E9A_6218_5229_54C1_516C_5171["设置米亚装备冷却"]
local _____53D6_7C73_4E9A_88C5_5907_51B7_5374_952E = ____137_FF0E_7C73_4E9A_6218_5229_54C1_516C_5171["取米亚装备冷却键"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6709_6548_5B58_6D3B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位有效存活"]
local _____53D6_6700_5927_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取最大生命"]
local _____6267_884C_7269_54C1_6CBB_7597 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["执行物品治疗"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local _____51C0_6C34_56DE_54CD_51B7_5374_79D2_6570 = 18
local _____51C0_6C34_56DE_54CD_6062_590D_6BD4_4F8B = 0.05
local _____51C0_6C34_56DE_54CD_7279_6548 = "Abilities\\Spells\\Items\\AIhe\\AIheTarget.mdl"
local function ____on_7EAF_51C0_6C34_6E90_540A_5760_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied > 0) then
        return
    end
    if not _____5355_4F4D_6709_6548_5B58_6D3B(target) then
        return
    end
    if not _____5355_4F4D_6301_6709_7C73_4E9A_6218_5229_54C1(target, _____7C73_4E9A_6218_5229_54C1_88C5_5907_540D["纯净水源吊坠"]) then
        return
    end
    local key = _____53D6_7C73_4E9A_88C5_5907_51B7_5374_952E(target, "纯净水源吊坠:净水回响")
    if _____7C73_4E9A_88C5_5907_51B7_5374_4E2D(key) then
        return
    end
    _____8BBE_7F6E_7C73_4E9A_88C5_5907_51B7_5374(key, _____51C0_6C34_56DE_54CD_51B7_5374_79D2_6570)
    _____6267_884C_7269_54C1_6CBB_7597(
        target,
        target,
        _____53D6_6700_5927_751F_547D(target) * _____51C0_6C34_56DE_54CD_6062_590D_6BD4_4F8B,
        _____51C0_6C34_56DE_54CD_7279_6548,
        0,
        nil,
        true
    )
end
registerAppliedFinalDamageListener(____on_7EAF_51C0_6C34_6E90_540A_5760_6700_7EC8_4F24_5BB3)
return ____exports
