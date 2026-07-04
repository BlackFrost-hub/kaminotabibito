local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
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
local GetHandleId = jass.GetHandleId
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
local _____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5C42_6570_8868 = {}
local _____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5355_4F4D_8868 = {}
local _____7CBE_7075_6267_6CD5_62AB_98CE_6765_6E90_540D_79F0_8868 = {}
local _____5DF2_521D_59CB_5316_7CBE_7075_6267_6CD5_62AB_98CE = false
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____8BB0_5F55_7CBE_7075_6267_6CD5_62AB_98CE_6765_6E90(source, unit)
    local id = _____53D6_5355_4F4DID(unit)
    if id == 0 then
        return
    end
    _____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5355_4F4D_8868[id] = unit
    if source ~= nil and source ~= 0 then
        _____7CBE_7075_6267_6CD5_62AB_98CE_6765_6E90_540D_79F0_8868[id] = ("『精灵执法披风』「" .. GetUnitName(source)) .. "」"
    end
end
local function _____8C03_6574_7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5C42_6570(unit, delta)
    if delta == 0 or unit == nil or unit == 0 then
        return
    end
    SGSS_SetState(unit, _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E["攻速属性ID"], _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E["攻速降低"] * delta)
end
local function _____5237_65B0_7CBE_7075_6267_6CD5_62AB_98CEBuff(unit)
    local id = _____53D6_5355_4F4DID(unit)
    if id == 0 or (_____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5C42_6570_8868[id] or 0) <= 0 then
        return
    end
    registerManualBuff(
        unit,
        _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E.BuffID,
        _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E["Buff持续时间"],
        15,
        {sourceName = _____7CBE_7075_6267_6CD5_62AB_98CE_6765_6E90_540D_79F0_8868[id]}
    )
end
local function _____5E94_7528_7CBE_7075_6267_6CD5_62AB_98CE_5149_73AF(target, holder, currentCount)
    local id = _____53D6_5355_4F4DID(target)
    if id == 0 then
        return
    end
    local count = currentCount <= 0 and 1 or currentCount
    _____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5C42_6570_8868[id] = (_____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5C42_6570_8868[id] or 0) + count
    _____8BB0_5F55_7CBE_7075_6267_6CD5_62AB_98CE_6765_6E90(holder, target)
    _____8C03_6574_7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5C42_6570(target, count)
    _____5237_65B0_7CBE_7075_6267_6CD5_62AB_98CEBuff(target)
end
local function _____540C_6B65_7CBE_7075_6267_6CD5_62AB_98CE_5149_73AF(target, holder, _currentCount)
    _____8BB0_5F55_7CBE_7075_6267_6CD5_62AB_98CE_6765_6E90(holder, target)
    _____5237_65B0_7CBE_7075_6267_6CD5_62AB_98CEBuff(target)
end
local function _____79FB_9664_7CBE_7075_6267_6CD5_62AB_98CE_5149_73AF(target, _holder, currentCount)
    local id = _____53D6_5355_4F4DID(target)
    if id == 0 then
        return
    end
    local count = currentCount <= 0 and 1 or currentCount
    local nextCount = (_____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5C42_6570_8868[id] or 0) - count
    _____8C03_6574_7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5C42_6570(target, -count)
    if nextCount > 0 then
        _____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5C42_6570_8868[id] = nextCount
        _____5237_65B0_7CBE_7075_6267_6CD5_62AB_98CEBuff(target)
        return
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(target, _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E.BuffID)
    __TS__Delete(_____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5C42_6570_8868, id)
    __TS__Delete(_____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5355_4F4D_8868, id)
    __TS__Delete(_____7CBE_7075_6267_6CD5_62AB_98CE_6765_6E90_540D_79F0_8868, id)
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
