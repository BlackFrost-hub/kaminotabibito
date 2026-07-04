--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6709_6548_5B58_6D3B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位有效存活"]
local _____53D6_5F53_524D_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取当前生命"]
local _____53D6_6700_5927_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取最大生命"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["播放单位特效"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾")
local _____5F00_59CB_62A4_76FE = ____require_result_0["开始护盾"]
local _____62A4_76FE_7C7B_578B = ____require_result_0["护盾类型"]
local _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C = ____require_result_0["查询单位标签护盾值"]
local _____5145_80FD_5355_4F4D_6807_7B7E_62A4_76FE = ____require_result_0["充能单位标签护盾"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.11．最终伤害触发模板")
local _____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F = ____require_result_1["注册最终伤害触发模板"]
local _____7075_732B_5E87_62A4_51B7_5374_79D2_6570 = 30
local _____7075_732B_5E87_62A4_89E6_53D1_751F_547D_6BD4_4F8B = 0.35
local _____7075_732B_5E87_62A4_57FA_7840_62A4_76FE_503C = 500
local _____7075_732B_5E87_62A4_6700_5927_751F_547D_62A4_76FE_7CFB_6570 = 0.2
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
local function _____7C73_4E9A_7684_9879_5708_4F4E_8840_8FC7_6EE4(event)
    local target = event["目标"]
    if not _____5355_4F4D_6709_6548_5B58_6D3B(target) then
        return false
    end
    local maxLife = _____53D6_6700_5927_751F_547D(target)
    return maxLife > 0 and _____53D6_5F53_524D_751F_547D(target) <= maxLife * _____7075_732B_5E87_62A4_89E6_53D1_751F_547D_6BD4_4F8B
end
local function ____on_7C73_4E9A_7684_9879_5708_6700_7EC8_4F24_5BB3(event)
    local target = event["目标"]
    local maxLife = _____53D6_6700_5927_751F_547D(target)
    _____65BD_52A0_7075_732B_5E87_62A4_62A4_76FE(target, _____7075_732B_5E87_62A4_57FA_7840_62A4_76FE_503C + maxLife * _____7075_732B_5E87_62A4_6700_5927_751F_547D_62A4_76FE_7CFB_6570, _____7075_732B_5E87_62A4_6301_7EED_79D2_6570)
    _____64AD_653E_5355_4F4D_7279_6548(target, _____7075_732B_5E87_62A4_7279_6548, "origin", 1)
end
_____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F({
    ["名称"] = "米亚的项圈",
    ["装备名"] = "米亚的项圈",
    ["持有者"] = "受击者",
    ["要求双方存活"] = false,
    ["冷却秒数"] = _____7075_732B_5E87_62A4_51B7_5374_79D2_6570,
    ["冷却标签"] = "米亚的项圈:灵猫庇护",
    ["冷却前缀"] = "米亚战利品",
    ["自定义过滤"] = _____7C73_4E9A_7684_9879_5708_4F4E_8840_8FC7_6EE4,
    ["on触发"] = ____on_7C73_4E9A_7684_9879_5708_6700_7EC8_4F24_5BB3
})
return ____exports
