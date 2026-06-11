local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_0.resolveItemIdByName
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.06．获取丢弃.index")
local _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03 = ____require_result_2["监听指定物品获取丢弃"]
local _____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF = ____require_result_2["获取单位当前持有指定物品数量"]
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_3.addPeriodicCallback
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_4.getUnitsInRange
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_5.isUnitEnemy
local ____require_result_6 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_6.SGSS_SetState
local ____require_result_7 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_7.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_7["移除单位指定Buff"]
local ____require_result_8 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____require_result_8["常规BuffID"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local GetUnitName = jass.GetUnitName
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
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
local _____7CBE_7075_6267_6CD5_62AB_98CE_6301_6709_8005_5217_8868 = {}
local _____7CBE_7075_6267_6CD5_62AB_98CE_6301_6709_8005_8868 = {}
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
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
local function _____52A0_5165_7CBE_7075_6267_6CD5_62AB_98CE_6301_6709_8005(unit)
    local unitId = _____53D6_5355_4F4DID(unit)
    if unitId == 0 or _____7CBE_7075_6267_6CD5_62AB_98CE_6301_6709_8005_8868[unitId] ~= nil then
        return
    end
    _____7CBE_7075_6267_6CD5_62AB_98CE_6301_6709_8005_8868[unitId] = unit
    _____7CBE_7075_6267_6CD5_62AB_98CE_6301_6709_8005_5217_8868[#_____7CBE_7075_6267_6CD5_62AB_98CE_6301_6709_8005_5217_8868 + 1] = unit
end
local function _____79FB_9664_7CBE_7075_6267_6CD5_62AB_98CE_6301_6709_8005(unit)
    local unitId = _____53D6_5355_4F4DID(unit)
    if unitId == 0 then
        return
    end
    __TS__Delete(_____7CBE_7075_6267_6CD5_62AB_98CE_6301_6709_8005_8868, unitId)
    do
        local i = #_____7CBE_7075_6267_6CD5_62AB_98CE_6301_6709_8005_5217_8868 - 1
        while i >= 0 do
            if _____53D6_5355_4F4DID(_____7CBE_7075_6267_6CD5_62AB_98CE_6301_6709_8005_5217_8868[i + 1]) == unitId then
                __TS__ArraySplice(_____7CBE_7075_6267_6CD5_62AB_98CE_6301_6709_8005_5217_8868, i, 1)
            end
            i = i - 1
        end
    end
end
local function ____on_83B7_5F97_7CBE_7075_6267_6CD5_62AB_98CE(unit, _item, currentCount, _previousCount)
    if currentCount > 0 then
        _____52A0_5165_7CBE_7075_6267_6CD5_62AB_98CE_6301_6709_8005(unit)
    end
end
local function ____on_5931_53BB_7CBE_7075_6267_6CD5_62AB_98CE(unit, _item, currentCount, _previousCount)
    if currentCount <= 0 then
        _____79FB_9664_7CBE_7075_6267_6CD5_62AB_98CE_6301_6709_8005(unit)
    end
end
local function _____8BB0_5F55_7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD(next, source, unit)
    local id = _____53D6_5355_4F4DID(unit)
    if id == 0 then
        return
    end
    next[id] = (next[id] or 0) + 1
    _____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5355_4F4D_8868[id] = unit
    if _____7CBE_7075_6267_6CD5_62AB_98CE_6765_6E90_540D_79F0_8868[id] == nil and source ~= nil and source ~= 0 then
        _____7CBE_7075_6267_6CD5_62AB_98CE_6765_6E90_540D_79F0_8868[id] = ("『精灵执法披风』「" .. GetUnitName(source)) .. "」"
    end
end
local function _____8C03_6574_7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5C42_6570(unit, delta)
    if delta == 0 or unit == nil or unit == 0 then
        return
    end
    SGSS_SetState(unit, _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E["攻速属性ID"], _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E["攻速降低"] * delta)
end
local function _____540C_6B65_7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD(next)
    for id in pairs(_____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5C42_6570_8868) do
        if next[id] == nil then
            next[id] = 0
        end
    end
    for id in pairs(next) do
        local oldCount = _____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5C42_6570_8868[id] or 0
        local newCount = next[id] or 0
        if oldCount ~= newCount then
            _____8C03_6574_7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5C42_6570(_____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5355_4F4D_8868[id], newCount - oldCount)
        end
        if newCount > 0 then
            _____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5C42_6570_8868[id] = newCount
            registerManualBuff(
                _____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5355_4F4D_8868[id],
                _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E.BuffID,
                _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E["Buff持续时间"],
                15,
                {sourceName = _____7CBE_7075_6267_6CD5_62AB_98CE_6765_6E90_540D_79F0_8868[id]}
            )
        else
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5355_4F4D_8868[id], _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E.BuffID)
            __TS__Delete(_____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5C42_6570_8868, id)
            __TS__Delete(_____7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD_5355_4F4D_8868, id)
            __TS__Delete(_____7CBE_7075_6267_6CD5_62AB_98CE_6765_6E90_540D_79F0_8868, id)
        end
    end
end
local function ____on_7CBE_7075_6267_6CD5_62AB_98CE_5468_671F()
    local next = {}
    for id in pairs(_____7CBE_7075_6267_6CD5_62AB_98CE_6765_6E90_540D_79F0_8868) do
        __TS__Delete(_____7CBE_7075_6267_6CD5_62AB_98CE_6765_6E90_540D_79F0_8868, id)
    end
    do
        local i = #_____7CBE_7075_6267_6CD5_62AB_98CE_6301_6709_8005_5217_8868 - 1
        while i >= 0 do
            do
                local holder = _____7CBE_7075_6267_6CD5_62AB_98CE_6301_6709_8005_5217_8868[i + 1]
                if not _____5355_4F4D_5B58_6D3B(holder) or _____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF(holder, _____7CBE_7075_6267_6CD5_62AB_98CE_7269_54C1ID) <= 0 then
                    _____79FB_9664_7CBE_7075_6267_6CD5_62AB_98CE_6301_6709_8005(holder)
                    goto __continue34
                end
                local targets = getUnitsInRange(
                    GetUnitX(holder),
                    GetUnitY(holder),
                    _____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E["范围"]
                )
                do
                    local j = 0
                    while j < #targets do
                        do
                            local target = targets[j + 1]
                            if not _____5355_4F4D_5B58_6D3B(target) then
                                goto __continue37
                            end
                            if isUnitEnemy(target, holder) ~= true then
                                goto __continue37
                            end
                            _____8BB0_5F55_7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD(next, holder, target)
                        end
                        ::__continue37::
                        j = j + 1
                    end
                end
            end
            ::__continue34::
            i = i - 1
        end
    end
    _____540C_6B65_7CBE_7075_6267_6CD5_62AB_98CE_5F71_54CD(next)
end
____exports["初始化精灵执法披风效果"] = function()
    if _____5DF2_521D_59CB_5316_7CBE_7075_6267_6CD5_62AB_98CE then
        return
    end
    _____5DF2_521D_59CB_5316_7CBE_7075_6267_6CD5_62AB_98CE = true
    if _____7CBE_7075_6267_6CD5_62AB_98CE_7269_54C1ID == 0 then
        return
    end
    _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03(_____7CBE_7075_6267_6CD5_62AB_98CE_7269_54C1ID, ____on_83B7_5F97_7CBE_7075_6267_6CD5_62AB_98CE, ____on_5931_53BB_7CBE_7075_6267_6CD5_62AB_98CE)
    addPeriodicCallback(_____7CBE_7075_6267_6CD5_62AB_98CE_914D_7F6E["周期毫秒"], ____on_7CBE_7075_6267_6CD5_62AB_98CE_5468_671F)
end
____exports["初始化精灵执法披风效果"]()
return ____exports
