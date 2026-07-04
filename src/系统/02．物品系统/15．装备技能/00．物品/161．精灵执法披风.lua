--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____24_FF0E_53E5_67C4_4E0A_4E0B_6587_6258_7BA1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.24．句柄上下文托管")
local _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668 = ____24_FF0E_53E5_67C4_4E0A_4E0B_6587_6258_7BA1["创建句柄上下文托管器"]
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_0.resolveItemIdByName
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.23．光环.01．范围光环")
local _____6CE8_518C_6301_6709_578B_8303_56F4_5149_73AF = ____require_result_2["注册持有型范围光环"]
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_3.SGSS_SetState
local ____require_result_4 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_4.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_4["移除单位指定Buff"]
local ____require_result_5 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____require_result_5["常规BuffID"]
local jass = require("jass.common")
local GetUnitName = jass.GetUnitName
local _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E = {
    ["物品名"] = "精灵执法披风",
    ["范围"] = 300,
    ["周期毫秒"] = 500,
    ["攻速降低"] = -0.15,
    ["攻速属性ID"] = 10,
    BuffID = _____5E38_89C4BuffID["精灵执法披风_秩序领域"],
    ["Buff持续时间"] = 1
}
local _____7CBE_7075_6267_6CD5_62AB_98CE_7269_54C1ID = stringToFourCCSafe(resolveItemIdByName(_____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E["物品名"]))
local _____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_6258_7BA1_5668 = _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668("精灵执法披风影响")
local _____5DF2_521D_59CB_5316_7CBE_7075_6267_6CD5_62AB_98CE = false
local function _____8BB0_5F55_7CBE_7075_6267_6CD5_62AB_98CE_6765_6E90(source, unit)
    local _____4E0A_4E0B_6587 = _____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_6258_7BA1_5668["读取"](unit)
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    _____4E0A_4E0B_6587["单位"] = unit
    if source ~= nil and source ~= 0 then
        _____4E0A_4E0B_6587["来源名称"] = ("『精灵执法披风』「" .. GetUnitName(source)) .. "」"
    end
end
local function _____8C03_6574_7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5C42_6570(unit, delta)
    if delta == 0 or unit == nil or unit == 0 then
        return
    end
    SGSS_SetState(unit, _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E["攻速属性ID"], _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E["攻速降低"] * delta)
end
local function _____5237_65B0_7CBE_7075_6267_6CD5_62AB_98CEBuff(unit)
    local _____4E0A_4E0B_6587 = _____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_6258_7BA1_5668["读取"](unit)
    if _____4E0A_4E0B_6587 == nil or _____4E0A_4E0B_6587["层数"] <= 0 then
        return
    end
    registerManualBuff(
        unit,
        _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E.BuffID,
        _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E["Buff持续时间"],
        15,
        {sourceName = _____4E0A_4E0B_6587["来源名称"]}
    )
end
local function _____5E94_7528_7CBE_7075_6267_6CD5_62AB_98CE_5149_73AF(target, holder, currentCount)
    local count = currentCount <= 0 and 1 or currentCount
    local _____5F53_524D_4E0A_4E0B_6587 = _____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_6258_7BA1_5668["读取"](target)
    local nextCount = (_____5F53_524D_4E0A_4E0B_6587 and _____5F53_524D_4E0A_4E0B_6587["层数"] or 0) + count
    _____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_6258_7BA1_5668["写入"](target, {["层数"] = nextCount, ["单位"] = target, ["来源名称"] = _____5F53_524D_4E0A_4E0B_6587 and _____5F53_524D_4E0A_4E0B_6587["来源名称"]})
    _____8BB0_5F55_7CBE_7075_6267_6CD5_62AB_98CE_6765_6E90(holder, target)
    _____8C03_6574_7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5C42_6570(target, count)
    _____5237_65B0_7CBE_7075_6267_6CD5_62AB_98CEBuff(target)
end
local function _____540C_6B65_7CBE_7075_6267_6CD5_62AB_98CE_5149_73AF(target, holder, _currentCount)
    _____8BB0_5F55_7CBE_7075_6267_6CD5_62AB_98CE_6765_6E90(holder, target)
    _____5237_65B0_7CBE_7075_6267_6CD5_62AB_98CEBuff(target)
end
local function _____79FB_9664_7CBE_7075_6267_6CD5_62AB_98CE_5149_73AF(target, _holder, currentCount)
    local count = currentCount <= 0 and 1 or currentCount
    local _____5F53_524D_4E0A_4E0B_6587 = _____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_6258_7BA1_5668["读取"](target)
    local nextCount = (_____5F53_524D_4E0A_4E0B_6587 and _____5F53_524D_4E0A_4E0B_6587["层数"] or 0) - count
    _____8C03_6574_7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5C42_6570(target, -count)
    if nextCount > 0 then
        _____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_6258_7BA1_5668["写入"](target, {["层数"] = nextCount, ["单位"] = target, ["来源名称"] = _____5F53_524D_4E0A_4E0B_6587 and _____5F53_524D_4E0A_4E0B_6587["来源名称"]})
        _____5237_65B0_7CBE_7075_6267_6CD5_62AB_98CEBuff(target)
        return
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(target, _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E.BuffID)
    _____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_6258_7BA1_5668["清空"](target)
end
____exports["初始化精灵执法披风效果"] = function()
    if _____5DF2_521D_59CB_5316_7CBE_7075_6267_6CD5_62AB_98CE then
        return
    end
    _____5DF2_521D_59CB_5316_7CBE_7075_6267_6CD5_62AB_98CE = true
    if _____7CBE_7075_6267_6CD5_62AB_98CE_7269_54C1ID == 0 then
        return
    end
    _____6CE8_518C_6301_6709_578B_8303_56F4_5149_73AF({
        ["物品类型ID"] = _____7CBE_7075_6267_6CD5_62AB_98CE_7269_54C1ID,
        ["间隔毫秒"] = _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E["周期毫秒"],
        ["半径"] = _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E["范围"],
        ["目标类型"] = "敌人",
        ["应用目标效果"] = _____5E94_7528_7CBE_7075_6267_6CD5_62AB_98CE_5149_73AF,
        ["同步目标效果"] = _____540C_6B65_7CBE_7075_6267_6CD5_62AB_98CE_5149_73AF,
        ["移除目标效果"] = _____79FB_9664_7CBE_7075_6267_6CD5_62AB_98CE_5149_73AF
    })
end
____exports["初始化精灵执法披风效果"]()
return ____exports
