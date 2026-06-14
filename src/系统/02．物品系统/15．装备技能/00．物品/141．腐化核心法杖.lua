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
local _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["造成伤害事件伤害"]
local _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["伤害事件伤害类型"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["播放单位特效"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local _____8150_5316_6838_5FC3_51B7_5374_79D2_6570 = 2
local _____8150_5316_6838_5FC3_9644_52A0_4F24_5BB3 = 180
local _____8150_5316_6838_5FC3_7279_6548 = "Abilities\\Spells\\Other\\AcidBomb\\BottleImpact.mdl"
local function _____662F_6280_80FD_4F24_5BB3_5FEB_7167(snapshot)
    return snapshot ~= nil and (snapshot.isSkillAttack == true or snapshot.isSkillDamage == true)
end
local function ____on_8150_5316_6838_5FC3_6CD5_6756_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied > 0) then
        return
    end
    if not _____662F_6280_80FD_4F24_5BB3_5FEB_7167(snapshot) then
        return
    end
    if not _____5355_4F4D_6709_6548_5B58_6D3B(attacker) or not _____5355_4F4D_6709_6548_5B58_6D3B(target) then
        return
    end
    if not _____5355_4F4D_6301_6709_7C73_4E9A_6218_5229_54C1(attacker, _____7C73_4E9A_6218_5229_54C1_88C5_5907_540D["腐化核心法杖"]) then
        return
    end
    local key = _____53D6_7C73_4E9A_88C5_5907_51B7_5374_952E(attacker, "腐化核心法杖:腐化核心")
    if _____7C73_4E9A_88C5_5907_51B7_5374_4E2D(key) then
        return
    end
    _____8BBE_7F6E_7C73_4E9A_88C5_5907_51B7_5374(key, _____8150_5316_6838_5FC3_51B7_5374_79D2_6570)
    _____64AD_653E_5355_4F4D_7279_6548(target, _____8150_5316_6838_5FC3_7279_6548, "origin", 1)
    _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3(attacker, target, _____8150_5316_6838_5FC3_9644_52A0_4F24_5BB3, _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["毒素"])
end
registerAppliedFinalDamageListener(____on_8150_5316_6838_5FC3_6CD5_6756_6700_7EC8_4F24_5BB3)
return ____exports
