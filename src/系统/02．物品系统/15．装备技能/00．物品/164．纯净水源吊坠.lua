--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6709_6548_5B58_6D3B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位有效存活"]
local _____53D6_6700_5927_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取最大生命"]
local _____6267_884C_7269_54C1_6CBB_7597 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["执行物品治疗"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_88C5_5907 = ____require_result_1["单位持有装备"]
local _____53D6_88C5_5907_51B7_5374_952E = ____require_result_1["取装备冷却键"]
local _____88C5_5907_51B7_5374_4E2D = ____require_result_1["装备冷却中"]
local _____8FDB_5165_88C5_5907_51B7_5374 = ____require_result_1["进入装备冷却"]
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
    if not _____5355_4F4D_6301_6709_88C5_5907(target, "纯净水源吊坠") then
        return
    end
    local key = _____53D6_88C5_5907_51B7_5374_952E(target, "纯净水源吊坠:净水回响", "米亚战利品")
    if _____88C5_5907_51B7_5374_4E2D(key) then
        return
    end
    _____8FDB_5165_88C5_5907_51B7_5374(key, _____51C0_6C34_56DE_54CD_51B7_5374_79D2_6570)
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
