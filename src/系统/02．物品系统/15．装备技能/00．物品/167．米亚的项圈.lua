--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6709_6548_5B58_6D3B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位有效存活"]
local _____53D6_5F53_524D_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取当前生命"]
local _____53D6_6700_5927_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取最大生命"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["播放单位特效"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾")
local _____5F00_59CB_62A4_76FE = ____require_result_1["开始护盾"]
local _____62A4_76FE_7C7B_578B = ____require_result_1["护盾类型"]
local _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C = ____require_result_1["查询单位标签护盾值"]
local _____5145_80FD_5355_4F4D_6807_7B7E_62A4_76FE = ____require_result_1["充能单位标签护盾"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_88C5_5907 = ____require_result_2["单位持有装备"]
local _____53D6_88C5_5907_51B7_5374_952E = ____require_result_2["取装备冷却键"]
local _____88C5_5907_51B7_5374_4E2D = ____require_result_2["装备冷却中"]
local _____8FDB_5165_88C5_5907_51B7_5374 = ____require_result_2["进入装备冷却"]
local _____7075_732B_5E87_62A4_51B7_5374_79D2_6570 = 30
local _____7075_732B_5E87_62A4_89E6_53D1_751F_547D_6BD4_4F8B = 0.35
local _____7075_732B_5E87_62A4_62A4_76FE_503C = 1200
local _____7075_732B_5E87_62A4_6301_7EED_79D2_6570 = 5
local _____7075_732B_5E87_62A4_7279_6548 = "Abilities\\Spells\\NightElf\\Rejuvenation\\RejuvenationTarget.mdl"
local function _____65BD_52A0_7075_732B_5E87_62A4_62A4_76FE(unit, _____62A4_76FE_503C, _____6301_7EED_79D2_6570)
    if unit == nil or unit == 0 or not (_____62A4_76FE_503C > 0) or not (_____6301_7EED_79D2_6570 > 0) then
        return
    end
    local tag = "装备:米亚的项圈"
    local params = {
        ["类型"] = _____62A4_76FE_7C7B_578B["通用"],
        ["数值"] = _____62A4_76FE_503C,
        ["持续时间"] = _____6301_7EED_79D2_6570,
        ["来源单位"] = unit,
        ["标签"] = tag,
        ["显示护盾条"] = true,
        ["可驱散"] = false
    }
    local current = _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C(unit, tag)
    if current > 0 then
        _____5145_80FD_5355_4F4D_6807_7B7E_62A4_76FE(
            unit,
            tag,
            _____62A4_76FE_503C,
            _____62A4_76FE_503C,
            params
        )
        return
    end
    _____5F00_59CB_62A4_76FE(unit, params)
end
local function ____on_7C73_4E9A_7684_9879_5708_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied > 0) then
        return
    end
    if not _____5355_4F4D_6709_6548_5B58_6D3B(target) then
        return
    end
    if not _____5355_4F4D_6301_6709_88C5_5907(target, "米亚的项圈") then
        return
    end
    local maxLife = _____53D6_6700_5927_751F_547D(target)
    if not (maxLife > 0) then
        return
    end
    if _____53D6_5F53_524D_751F_547D(target) > maxLife * _____7075_732B_5E87_62A4_89E6_53D1_751F_547D_6BD4_4F8B then
        return
    end
    local key = _____53D6_88C5_5907_51B7_5374_952E(target, "米亚的项圈:灵猫庇护", "米亚战利品")
    if _____88C5_5907_51B7_5374_4E2D(key) then
        return
    end
    _____8FDB_5165_88C5_5907_51B7_5374(key, _____7075_732B_5E87_62A4_51B7_5374_79D2_6570)
    _____65BD_52A0_7075_732B_5E87_62A4_62A4_76FE(target, _____7075_732B_5E87_62A4_62A4_76FE_503C, _____7075_732B_5E87_62A4_6301_7EED_79D2_6570)
    _____64AD_653E_5355_4F4D_7279_6548(target, _____7075_732B_5E87_62A4_7279_6548, "origin", 1)
end
registerAppliedFinalDamageListener(____on_7C73_4E9A_7684_9879_5708_6700_7EC8_4F24_5BB3)
return ____exports
