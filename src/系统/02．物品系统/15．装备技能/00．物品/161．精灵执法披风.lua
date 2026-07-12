--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_0.resolveItemIdByName
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.23．光环.02．数值Buff范围光环")
local _____6CE8_518C_6570_503CBuff_8303_56F4_5149_73AF = ____require_result_2["注册数值Buff范围光环"]
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_3.SGSS_SetState
local ____require_result_4 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____require_result_4["常规BuffID"]
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
local _____5DF2_521D_59CB_5316_7CBE_7075_6267_6CD5_62AB_98CE = false
local function _____8BA1_7B97_7CBE_7075_6267_6CD5_62AB_98CE_653B_901F(_target, _____5C42_6570)
    return _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E["攻速降低"] * _____5C42_6570
end
local function _____5E94_7528_7CBE_7075_6267_6CD5_62AB_98CE_653B_901F_5DEE_503C(target, delta)
    SGSS_SetState(target, _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E["攻速属性ID"], delta)
end
local function _____53D6_7CBE_7075_6267_6CD5_62AB_98CEBuff_9644_52A0(_target, ______5C42_6570, holder)
    local sourceName = (holder == nil or holder == 0) and "精灵执法披风" or ("『精灵执法披风』「" .. GetUnitName(holder)) .. "」"
    return {sourceName = sourceName}
end
____exports["初始化精灵执法披风效果"] = function()
    if _____5DF2_521D_59CB_5316_7CBE_7075_6267_6CD5_62AB_98CE then
        return
    end
    _____5DF2_521D_59CB_5316_7CBE_7075_6267_6CD5_62AB_98CE = true
    if _____7CBE_7075_6267_6CD5_62AB_98CE_7269_54C1ID == 0 then
        return
    end
    _____6CE8_518C_6570_503CBuff_8303_56F4_5149_73AF({
        ["状态ID"] = "精灵执法披风影响",
        ["物品类型ID"] = _____7CBE_7075_6267_6CD5_62AB_98CE_7269_54C1ID,
        ["间隔毫秒"] = _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E["周期毫秒"],
        ["半径"] = _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E["范围"],
        ["目标类型"] = "敌人",
        ["数值效果列表"] = {{key = "攻速", ["计算总值"] = _____8BA1_7B97_7CBE_7075_6267_6CD5_62AB_98CE_653B_901F, ["应用差值"] = _____5E94_7528_7CBE_7075_6267_6CD5_62AB_98CE_653B_901F_5DEE_503C}},
        Buff = {
            BuffID = _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E.BuffID,
            ["持续秒"] = _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E["Buff持续时间"],
            ["取显示值"] = function()
                return 15
            end,
            ["取附加参数"] = _____53D6_7CBE_7075_6267_6CD5_62AB_98CEBuff_9644_52A0
        }
    })
end
____exports["初始化精灵执法披风效果"]()
return ____exports
