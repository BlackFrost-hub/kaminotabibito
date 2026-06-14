--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____137_FF0E_7C73_4E9A_6218_5229_54C1_516C_5171 = require("系统.02．物品系统.15．装备技能.00．物品.137．米亚战利品公共")
local _____5355_4F4D_6301_6709_7C73_4E9A_6218_5229_54C1 = ____137_FF0E_7C73_4E9A_6218_5229_54C1_516C_5171["单位持有米亚战利品"]
local _____7C73_4E9A_6218_5229_54C1_88C5_5907_540D = ____137_FF0E_7C73_4E9A_6218_5229_54C1_516C_5171["米亚战利品装备名"]
local _____7C73_4E9A_88C5_5907_51B7_5374_4E2D = ____137_FF0E_7C73_4E9A_6218_5229_54C1_516C_5171["米亚装备冷却中"]
local _____8BBE_7F6E_7C73_4E9A_88C5_5907_51B7_5374 = ____137_FF0E_7C73_4E9A_6218_5229_54C1_516C_5171["设置米亚装备冷却"]
local _____53D6_7C73_4E9A_88C5_5907_51B7_5374_952E = ____137_FF0E_7C73_4E9A_6218_5229_54C1_516C_5171["取米亚装备冷却键"]
local _____65BD_52A0_7C73_4E9A_9879_5708_62A4_76FE = ____137_FF0E_7C73_4E9A_6218_5229_54C1_516C_5171["施加米亚项圈护盾"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6709_6548_5B58_6D3B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位有效存活"]
local _____53D6_5F53_524D_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取当前生命"]
local _____53D6_6700_5927_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取最大生命"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["播放单位特效"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local _____7075_732B_5E87_62A4_51B7_5374_79D2_6570 = 30
local _____7075_732B_5E87_62A4_89E6_53D1_751F_547D_6BD4_4F8B = 0.35
local _____7075_732B_5E87_62A4_62A4_76FE_503C = 1200
local _____7075_732B_5E87_62A4_6301_7EED_79D2_6570 = 5
local _____7075_732B_5E87_62A4_7279_6548 = "Abilities\\Spells\\NightElf\\Rejuvenation\\RejuvenationTarget.mdl"
local function ____on_7C73_4E9A_7684_9879_5708_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied > 0) then
        return
    end
    if not _____5355_4F4D_6709_6548_5B58_6D3B(target) then
        return
    end
    if not _____5355_4F4D_6301_6709_7C73_4E9A_6218_5229_54C1(target, _____7C73_4E9A_6218_5229_54C1_88C5_5907_540D["米亚的项圈"]) then
        return
    end
    local maxLife = _____53D6_6700_5927_751F_547D(target)
    if not (maxLife > 0) then
        return
    end
    if _____53D6_5F53_524D_751F_547D(target) > maxLife * _____7075_732B_5E87_62A4_89E6_53D1_751F_547D_6BD4_4F8B then
        return
    end
    local key = _____53D6_7C73_4E9A_88C5_5907_51B7_5374_952E(target, "米亚的项圈:灵猫庇护")
    if _____7C73_4E9A_88C5_5907_51B7_5374_4E2D(key) then
        return
    end
    _____8BBE_7F6E_7C73_4E9A_88C5_5907_51B7_5374(key, _____7075_732B_5E87_62A4_51B7_5374_79D2_6570)
    _____65BD_52A0_7C73_4E9A_9879_5708_62A4_76FE(target, _____7075_732B_5E87_62A4_62A4_76FE_503C, _____7075_732B_5E87_62A4_6301_7EED_79D2_6570)
    _____64AD_653E_5355_4F4D_7279_6548(target, _____7075_732B_5E87_62A4_7279_6548, "origin", 1)
end
registerAppliedFinalDamageListener(____on_7C73_4E9A_7684_9879_5708_6700_7EC8_4F24_5BB3)
return ____exports
