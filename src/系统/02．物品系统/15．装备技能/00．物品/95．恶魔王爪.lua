--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_653B_51FB_6548_679C_5DE5_5177 = require("系统.02．物品系统.15．装备技能.08．攻击效果.00．公共.01．攻击效果工具")
local _____5355_4F4D_6709_6548_5B58_6D3B = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["单位有效存活"]
local _____653B_51FB_8005_7C7B_578B_6EE1_8DB3 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["攻击者类型满足"]
local _____53D6_5F53_524D_751F_547D = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["取当前生命"]
local _____53D6_6700_5927_751F_547D = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["取最大生命"]
local ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.index")
local _____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F = ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F["注册最终伤害触发模板"]
local ____06_FF0E_5468_671F_76EE_6807_6548_679C_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.06．周期目标效果模板.index")
local _____65BD_52A0_6216_5237_65B0_5468_671F_76EE_6807_6548_679C = ____06_FF0E_5468_671F_76EE_6807_6548_679C_6A21_677F["施加或刷新周期目标效果"]
local ____10_FF0E_88C5_5907_6218_6597_6267_884C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行")
local _____9020_6210_88C5_5907_4F24_5BB3 = ____10_FF0E_88C5_5907_6218_6597_6267_884C["造成装备伤害"]
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口")
local SFB_setSlow = ____require_result_0.SFB_setSlow
local jass = require("jass.common")
local DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND
local _____88C5_5907_540D = "|cff993300恶魔王爪|r"
local _____6076_9B54_4F24_5BB3_63D0_9AD8 = 0.15
local _____6495_88C2_6301_7EED_6BEB_79D2 = 3000
local _____6495_88C2_95F4_9694_6BEB_79D2 = 1000
local _____5DF2_635F_5931_751F_547D_771F_5B9E_4F24_5BB3_6BD4_4F8B = 0.02
local _____51CF_901F_6BD4_4F8B = 0.15
local _____51CF_901F_6301_7EED_79D2 = 3
local function _____8BA1_7B97_5DF2_635F_5931_751F_547D_771F_5B9E_4F24_5BB3(target)
    local maxLife = _____53D6_6700_5927_751F_547D(target)
    local currentLife = _____53D6_5F53_524D_751F_547D(target)
    if not (maxLife > currentLife) then
        return 0
    end
    return (maxLife - currentLife) * _____5DF2_635F_5931_751F_547D_771F_5B9E_4F24_5BB3_6BD4_4F8B
end
local function _____9020_6210_6076_9B54_738B_722A_771F_5B9E_4F24_5BB3(source, target)
    if not _____5355_4F4D_6709_6548_5B58_6D3B(source) or not _____5355_4F4D_6709_6548_5B58_6D3B(target) then
        return
    end
    local amount = _____8BA1_7B97_5DF2_635F_5931_751F_547D_771F_5B9E_4F24_5BB3(target)
    if not (amount > 0) then
        return
    end
    _____9020_6210_88C5_5907_4F24_5BB3(
        source,
        target,
        amount,
        DAMAGE_TYPE_MIND,
        false,
        nil,
        {["伤害形态"] = "单体"}
    )
end
local function _____65BD_52A0_6216_5237_65B0_6495_88C2(source, target)
    _____65BD_52A0_6216_5237_65B0_5468_671F_76EE_6807_6548_679C({
        ["key前缀"] = "恶魔王爪撕裂",
        ["来源单位"] = source,
        ["目标单位"] = target,
        ["持续毫秒"] = _____6495_88C2_6301_7EED_6BEB_79D2,
        ["间隔毫秒"] = _____6495_88C2_95F4_9694_6BEB_79D2,
        ["on周期"] = function(_____4E0A_4E0B_6587)
            _____9020_6210_6076_9B54_738B_722A_771F_5B9E_4F24_5BB3(_____4E0A_4E0B_6587["来源单位"], _____4E0A_4E0B_6587["目标单位"])
        end
    })
end
_____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F({
    ["名称"] = "恶魔王爪",
    ["装备名"] = _____88C5_5907_540D,
    ["持有者"] = "攻击者",
    ["伤害过滤"] = "任意",
    ["自定义过滤"] = function(event)
        local snapshot = event["伤害快照"]
        if snapshot == nil or snapshot.isPhysicalDamage ~= true or snapshot.isTrueDamage == true then
            return false
        end
        return _____653B_51FB_8005_7C7B_578B_6EE1_8DB3(event["攻击者"], "近战")
    end,
    ["on触发"] = function(event)
        SFB_setSlow(
            event["攻击者"],
            event["目标"],
            0,
            _____51CF_901F_6BD4_4F8B,
            _____51CF_901F_6301_7EED_79D2
        )
        _____65BD_52A0_6216_5237_65B0_6495_88C2(event["攻击者"], event["目标"])
    end
})
return ____exports
