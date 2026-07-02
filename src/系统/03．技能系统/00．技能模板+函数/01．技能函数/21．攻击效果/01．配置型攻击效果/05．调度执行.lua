--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____04_FF0E_6301_7EED_4F24_5BB3_6267_884C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.01．配置型攻击效果.04．持续伤害执行")
local _____6267_884C_914D_7F6E_578B_6301_7EED_4F24_5BB3 = ____04_FF0E_6301_7EED_4F24_5BB3_6267_884C["执行配置型持续伤害"]
local ____03_FF0E_77AC_65F6_6267_884C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.01．配置型攻击效果.03．瞬时执行")
local _____6267_884C_914D_7F6E_578B_5355_4F53_4F24_5BB3 = ____03_FF0E_77AC_65F6_6267_884C["执行配置型单体伤害"]
local _____6267_884C_914D_7F6E_578B_989D_5916_4F24_5BB3 = ____03_FF0E_77AC_65F6_6267_884C["执行配置型额外伤害"]
local _____6267_884C_914D_7F6E_578B_8303_56F4_4F24_5BB3 = ____03_FF0E_77AC_65F6_6267_884C["执行配置型范围伤害"]
local _____6267_884C_914D_7F6E_578B_4F4E_8840_65A9_6740 = ____03_FF0E_77AC_65F6_6267_884C["执行配置型低血斩杀"]
local _____6267_884C_914D_7F6E_578B_8303_56F4_51FB_98DE = ____03_FF0E_77AC_65F6_6267_884C["执行配置型范围击飞"]
local ____01_FF0E_57FA_7840_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.01．配置型攻击效果.01．基础工具")
local _____914D_7F6E_578B_4E34_65F6_4FEE_6539_653B_901F = ____01_FF0E_57FA_7840_5DE5_5177["配置型临时修改攻速"]
local _____914D_7F6E_578B_64AD_653E_76EE_6807_7279_6548 = ____01_FF0E_57FA_7840_5DE5_5177["配置型播放目标特效"]
local _____914D_7F6E_578B_64AD_653E_5355_4F4D_5750_6807_7279_6548 = ____01_FF0E_57FA_7840_5DE5_5177["配置型播放单位坐标特效"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.01．debuff.04．护甲降低")
local _____65BD_52A0_5355_4F53_62A4_7532_964D_4F4EBuff = ____require_result_1["施加单体护甲降低Buff"]
local _____914D_7F6E_578B_4E34_65F6_5C5E_6027_961F_5217 = {}
local function _____7EDD_5BF9_503C(value)
    return value < 0 and -value or value
end
local function ____on_914D_7F6E_578B_4E34_65F6_5C5E_6027_7ED3_675F()
    local record = table.remove(_____914D_7F6E_578B_4E34_65F6_5C5E_6027_961F_5217, 1)
    if record == nil then
        return
    end
    _____914D_7F6E_578B_4E34_65F6_4FEE_6539_653B_901F(record.unit, record.value)
end
local function _____6267_884C_914D_7F6E_578B_4E34_65F6_653B_901F(_____914D_7F6E, ctx)
    local value = _____914D_7F6E["攻速加成"] or 0
    if value == 0 then
        return
    end
    _____914D_7F6E_578B_4E34_65F6_4FEE_6539_653B_901F(ctx.source, value)
    _____914D_7F6E_578B_4E34_65F6_5C5E_6027_961F_5217[#_____914D_7F6E_578B_4E34_65F6_5C5E_6027_961F_5217 + 1] = {unit = ctx.source, type = "攻速", value = -value}
    addDelayedCallback((_____914D_7F6E["持续时间"] or 2) * 1000, ____on_914D_7F6E_578B_4E34_65F6_5C5E_6027_7ED3_675F)
    _____6267_884C_914D_7F6E_578B_8303_56F4_4F24_5BB3(_____914D_7F6E, ctx)
end
local function _____6267_884C_914D_7F6E_578B_62A4_7532_524A_51CF(_____914D_7F6E, ctx)
    local value = _____7EDD_5BF9_503C(_____914D_7F6E["固定伤害"] or 0)
    if not (value > 0) then
        return
    end
    _____65BD_52A0_5355_4F53_62A4_7532_964D_4F4EBuff(ctx.source, ctx.target, {["持续时间"] = _____914D_7F6E["持续时间"] or 5, ["护甲"] = value, ["叠加键"] = _____914D_7F6E["护甲降低叠加键"]})
end
____exports["执行配置型攻击效果配置"] = function(_____914D_7F6E, ctx, _____6982_7387_901A_8FC7)
    if _____914D_7F6E["特效"] ~= nil and _____914D_7F6E["特效"] ~= "" then
        _____914D_7F6E_578B_64AD_653E_76EE_6807_7279_6548(ctx.target, _____914D_7F6E["特效"])
    end
    if _____914D_7F6E["点特效"] ~= nil and _____914D_7F6E["点特效"] ~= "" then
        _____914D_7F6E_578B_64AD_653E_5355_4F4D_5750_6807_7279_6548(ctx.target, _____914D_7F6E["点特效"], _____914D_7F6E["点特效缩放"])
    end
    if _____914D_7F6E["自定义执行"] ~= nil then
        _____914D_7F6E["自定义执行"](ctx)
        return
    end
    if _____914D_7F6E["效果类型"] == "反击伤害" then
        _____6267_884C_914D_7F6E_578B_5355_4F53_4F24_5BB3(_____914D_7F6E, ctx)
    elseif _____914D_7F6E["效果类型"] == "额外伤害" then
        _____6267_884C_914D_7F6E_578B_989D_5916_4F24_5BB3(_____914D_7F6E, ctx, _____6982_7387_901A_8FC7)
    elseif _____914D_7F6E["效果类型"] == "范围伤害" then
        _____6267_884C_914D_7F6E_578B_8303_56F4_4F24_5BB3(_____914D_7F6E, ctx)
    elseif _____914D_7F6E["效果类型"] == "持续伤害" then
        _____6267_884C_914D_7F6E_578B_6301_7EED_4F24_5BB3(_____914D_7F6E, ctx)
    elseif _____914D_7F6E["效果类型"] == "低血斩杀" then
        _____6267_884C_914D_7F6E_578B_4F4E_8840_65A9_6740(_____914D_7F6E, ctx)
    elseif _____914D_7F6E["效果类型"] == "范围击飞" then
        _____6267_884C_914D_7F6E_578B_8303_56F4_51FB_98DE(_____914D_7F6E, ctx)
    elseif _____914D_7F6E["效果类型"] == "临时攻速" then
        _____6267_884C_914D_7F6E_578B_4E34_65F6_653B_901F(_____914D_7F6E, ctx)
    elseif _____914D_7F6E["效果类型"] == "护甲削减" then
        _____6267_884C_914D_7F6E_578B_62A4_7532_524A_51CF(_____914D_7F6E, ctx)
    elseif _____914D_7F6E["效果类型"] == "资源偷取" then
        _____6267_884C_914D_7F6E_578B_989D_5916_4F24_5BB3(_____914D_7F6E, ctx, _____6982_7387_901A_8FC7)
    end
end
return ____exports
