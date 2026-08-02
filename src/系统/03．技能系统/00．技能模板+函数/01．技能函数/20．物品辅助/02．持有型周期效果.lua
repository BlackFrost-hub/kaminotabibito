local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.17．周期机制调度器")
local _____521B_5EFA_81EA_9002_5E94_5171_4EAB_5468_671F_9A71_52A8 = ____require_result_1["创建自适应共享周期驱动"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听")
local _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03 = ____require_result_2["监听指定物品获取丢弃"]
local _____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF = ____require_result_2["获取单位当前持有指定物品数量"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetItemTypeId = jass.GetItemTypeId
local _____6301_6709_578B_5468_671F_6548_679C_5B9E_4F8B_8868 = {}
local _____5DF2_6CE8_518C_76D1_542C_7269_54C1_7C7B_578B = {}
local _____6301_6709_578B_5468_671F_6548_679C_9A71_52A8
local function _____83B7_53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____6570_5B57_5347_5E8F_6392_5E8F(a, b)
    return a - b
end
local function _____83B7_53D6_6709_5E8F_5355_4F4D_72B6_6001ID_5217_8868(_____72B6_6001_8868)
    local ids = {}
    for unitKey in pairs(_____72B6_6001_8868) do
        local unitId = __TS__Number(unitKey)
        if not __TS__NumberIsNaN(__TS__Number(unitId)) then
            ids[#ids + 1] = unitId
        end
    end
    __TS__ArraySort(ids, _____6570_5B57_5347_5E8F_6392_5E8F)
    return ids
end
local function _____5904_7406_83B7_5F97(_____914D_7F6E, unit, _item, currentCount, previousCount)
    local unitId = _____83B7_53D6_5355_4F4DID(unit)
    if unitId == 0 then
        return
    end
    if currentCount <= 0 then
        __TS__Delete(_____914D_7F6E["单位状态"], unitId)
        if previousCount > 0 then
            local ____opt_3 = _____914D_7F6E["丢弃回调"]
            if ____opt_3 ~= nil then
                ____opt_3(unit, previousCount)
            end
        end
        return
    end
    _____914D_7F6E["单位状态"][unitId] = {
        ["单位"] = unit,
        ["数量"] = 1,
        ["下次触发时间"] = getServerTime() + _____914D_7F6E["间隔毫秒"]
    }
    if previousCount <= 0 then
        local ____opt_5 = _____914D_7F6E["获取回调"]
        if ____opt_5 ~= nil then
            ____opt_5(unit, 1)
        end
    end
end
local function _____5904_7406_4E22_5F03(_____914D_7F6E, unit, _item, currentCount, previousCount)
    local unitId = _____83B7_53D6_5355_4F4DID(unit)
    if unitId == 0 then
        return
    end
    if currentCount <= 0 then
        __TS__Delete(_____914D_7F6E["单位状态"], unitId)
        if previousCount > 0 then
            local ____opt_7 = _____914D_7F6E["丢弃回调"]
            if ____opt_7 ~= nil then
                ____opt_7(unit, previousCount)
            end
        end
        return
    end
    local _____539F_72B6_6001 = _____914D_7F6E["单位状态"][unitId]
    _____914D_7F6E["单位状态"][unitId] = {
        ["单位"] = unit,
        ["数量"] = 1,
        ["下次触发时间"] = _____539F_72B6_6001 and _____539F_72B6_6001["下次触发时间"] or getServerTime() + _____914D_7F6E["间隔毫秒"]
    }
end
local function ____on_6301_6709_578B_5468_671F_6548_679CTick(now)
    do
        local i = 0
        while i < #_____6301_6709_578B_5468_671F_6548_679C_5B9E_4F8B_8868 do
            do
                local _____914D_7F6E = _____6301_6709_578B_5468_671F_6548_679C_5B9E_4F8B_8868[i + 1]
                if _____914D_7F6E["按单位独立计时"] ~= true then
                    if now < _____914D_7F6E["下次触发时间"] then
                        goto __continue20
                    end
                    _____914D_7F6E["下次触发时间"] = now + _____914D_7F6E["间隔毫秒"]
                end
                local _____5F85_6E05_7406 = {}
                local _____5355_4F4DID_5217_8868 = _____83B7_53D6_6709_5E8F_5355_4F4D_72B6_6001ID_5217_8868(_____914D_7F6E["单位状态"])
                do
                    local unitIndex = 0
                    while unitIndex < #_____5355_4F4DID_5217_8868 do
                        do
                            local unitId = _____5355_4F4DID_5217_8868[unitIndex + 1]
                            local _____72B6_6001 = _____914D_7F6E["单位状态"][unitId]
                            if _____72B6_6001 == nil or _____72B6_6001["单位"] == nil or _____72B6_6001["单位"] == 0 then
                                _____5F85_6E05_7406[#_____5F85_6E05_7406 + 1] = unitId
                                goto __continue24
                            end
                            local currentCount = _____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF(_____72B6_6001["单位"], _____914D_7F6E["物品类型ID"])
                            if currentCount <= 0 then
                                _____5F85_6E05_7406[#_____5F85_6E05_7406 + 1] = unitId
                                local ____opt_11 = _____914D_7F6E["丢弃回调"]
                                if ____opt_11 ~= nil then
                                    ____opt_11(_____72B6_6001["单位"], _____72B6_6001["数量"])
                                end
                                goto __continue24
                            end
                            _____72B6_6001["数量"] = 1
                            if _____914D_7F6E["按单位独立计时"] == true then
                                if now < _____72B6_6001["下次触发时间"] then
                                    goto __continue24
                                end
                                _____72B6_6001["下次触发时间"] = now + _____914D_7F6E["间隔毫秒"]
                            end
                            _____914D_7F6E["周期回调"](_____72B6_6001["单位"], 1)
                        end
                        ::__continue24::
                        unitIndex = unitIndex + 1
                    end
                end
                do
                    local j = 0
                    while j < #_____5F85_6E05_7406 do
                        __TS__Delete(_____914D_7F6E["单位状态"], _____5F85_6E05_7406[j + 1])
                        j = j + 1
                    end
                end
            end
            ::__continue20::
            i = i + 1
        end
    end
end
local function _____53D6_6301_6709_578B_5468_671F_6548_679C_5EFA_8BAE_68C0_67E5_95F4_9694(_nowMs)
    local _____6700_77ED_95F4_9694 = 0
    do
        local i = 0
        while i < #_____6301_6709_578B_5468_671F_6548_679C_5B9E_4F8B_8868 do
            local _____95F4_9694 = _____6301_6709_578B_5468_671F_6548_679C_5B9E_4F8B_8868[i + 1]["间隔毫秒"]
            if _____95F4_9694 > 0 and (_____6700_77ED_95F4_9694 == 0 or _____95F4_9694 < _____6700_77ED_95F4_9694) then
                _____6700_77ED_95F4_9694 = _____95F4_9694
            end
            i = i + 1
        end
    end
    return _____6700_77ED_95F4_9694
end
local function _____786E_4FDD_6301_6709_578B_5468_671F_6548_679C_4E2D_5FC3_5DF2_6CE8_518C()
    if _____6301_6709_578B_5468_671F_6548_679C_9A71_52A8 == nil then
        _____6301_6709_578B_5468_671F_6548_679C_9A71_52A8 = _____521B_5EFA_81EA_9002_5E94_5171_4EAB_5468_671F_9A71_52A8({["名称"] = "持有型周期效果驱动", ["最大检查间隔毫秒"] = 100, ["取建议检查间隔毫秒"] = _____53D6_6301_6709_578B_5468_671F_6548_679C_5EFA_8BAE_68C0_67E5_95F4_9694, onTick = ____on_6301_6709_578B_5468_671F_6548_679CTick})
    end
    _____6301_6709_578B_5468_671F_6548_679C_9A71_52A8["刷新"](_____6301_6709_578B_5468_671F_6548_679C_9A71_52A8)
end
local function ____on_6301_6709_578B_5468_671F_6548_679C_83B7_53D6(unit, item, currentCount, previousCount)
    if item == nil or item == 0 then
        return
    end
    local itemTypeId = GetItemTypeId(item)
    do
        local i = 0
        while i < #_____6301_6709_578B_5468_671F_6548_679C_5B9E_4F8B_8868 do
            local _____914D_7F6E = _____6301_6709_578B_5468_671F_6548_679C_5B9E_4F8B_8868[i + 1]
            if _____914D_7F6E["物品类型ID"] == itemTypeId then
                _____5904_7406_83B7_5F97(
                    _____914D_7F6E,
                    unit,
                    item,
                    currentCount,
                    previousCount
                )
            end
            i = i + 1
        end
    end
end
local function ____on_6301_6709_578B_5468_671F_6548_679C_4E22_5F03(unit, item, currentCount, previousCount)
    if item == nil or item == 0 then
        return
    end
    local itemTypeId = GetItemTypeId(item)
    do
        local i = 0
        while i < #_____6301_6709_578B_5468_671F_6548_679C_5B9E_4F8B_8868 do
            local _____914D_7F6E = _____6301_6709_578B_5468_671F_6548_679C_5B9E_4F8B_8868[i + 1]
            if _____914D_7F6E["物品类型ID"] == itemTypeId then
                _____5904_7406_4E22_5F03(
                    _____914D_7F6E,
                    unit,
                    item,
                    currentCount,
                    previousCount
                )
            end
            i = i + 1
        end
    end
end
local function _____8865_767B_8BB0_521D_59CB_5355_4F4D(_____914D_7F6E)
    if _____914D_7F6E["初始单位列表"] == nil then
        return
    end
    local _____5355_4F4D_5217_8868 = _____914D_7F6E["初始单位列表"]()
    if _____5355_4F4D_5217_8868 == nil then
        return
    end
    do
        local i = 0
        while i < #_____5355_4F4D_5217_8868 do
            do
                local unit = _____5355_4F4D_5217_8868[i + 1]
                local unitId = _____83B7_53D6_5355_4F4DID(unit)
                if unitId == 0 then
                    goto __continue51
                end
                local currentCount = _____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF(unit, _____914D_7F6E["物品类型ID"])
                if currentCount <= 0 then
                    goto __continue51
                end
                _____914D_7F6E["单位状态"][unitId] = {
                    ["单位"] = unit,
                    ["数量"] = 1,
                    ["下次触发时间"] = getServerTime() + _____914D_7F6E["间隔毫秒"]
                }
                local ____opt_13 = _____914D_7F6E["获取回调"]
                if ____opt_13 ~= nil then
                    ____opt_13(unit, 1)
                end
            end
            ::__continue51::
            i = i + 1
        end
    end
end
local function _____521B_5EFA_6301_6709_578B_5468_671F_6548_679C_63A7_5236_5668(_____914D_7F6E)
    return {
        ["获取单位列表"] = function()
            local result = {}
            local ids = _____83B7_53D6_6709_5E8F_5355_4F4D_72B6_6001ID_5217_8868(_____914D_7F6E["单位状态"])
            do
                local i = 0
                while i < #ids do
                    local _____72B6_6001 = _____914D_7F6E["单位状态"][ids[i + 1]]
                    if _____72B6_6001 ~= nil and _____72B6_6001["单位"] ~= nil and _____72B6_6001["单位"] ~= 0 then
                        result[#result + 1] = _____72B6_6001["单位"]
                    end
                    i = i + 1
                end
            end
            return result
        end,
        ["获取单位数量"] = function()
            return #_____83B7_53D6_6709_5E8F_5355_4F4D_72B6_6001ID_5217_8868(_____914D_7F6E["单位状态"])
        end,
        ["读取单位下次触发剩余毫秒"] = function(unit)
            local unitId = _____83B7_53D6_5355_4F4DID(unit)
            local _____5355_4F4D_72B6_6001 = _____914D_7F6E["单位状态"][unitId]
            if unitId == 0 or _____5355_4F4D_72B6_6001 == nil then
                return 0
            end
            local _____89E6_53D1_65F6_95F4 = _____914D_7F6E["按单位独立计时"] == true and _____5355_4F4D_72B6_6001["下次触发时间"] or _____914D_7F6E["下次触发时间"]
            local _____5269_4F59_6BEB_79D2 = _____89E6_53D1_65F6_95F4 - getServerTime()
            return _____5269_4F59_6BEB_79D2 > 0 and _____5269_4F59_6BEB_79D2 or 0
        end
    }
end
____exports["注册持有型周期效果"] = function(_____53C2_6570)
    if _____53C2_6570 == nil or _____53C2_6570["物品类型ID"] == 0 or _____53C2_6570["间隔毫秒"] <= 0 or _____53C2_6570["周期回调"] == nil then
        return nil
    end
    local _____914D_7F6E = __TS__ObjectAssign(
        {},
        _____53C2_6570,
        {
            ["下次触发时间"] = getServerTime() + _____53C2_6570["间隔毫秒"],
            ["单位状态"] = {}
        }
    )
    local _____63A7_5236_5668 = _____521B_5EFA_6301_6709_578B_5468_671F_6548_679C_63A7_5236_5668(_____914D_7F6E)
    _____914D_7F6E["获取单位列表"] = _____63A7_5236_5668["获取单位列表"]
    _____914D_7F6E["获取单位数量"] = _____63A7_5236_5668["获取单位数量"]
    _____914D_7F6E["读取单位下次触发剩余毫秒"] = _____63A7_5236_5668["读取单位下次触发剩余毫秒"]
    _____6301_6709_578B_5468_671F_6548_679C_5B9E_4F8B_8868[#_____6301_6709_578B_5468_671F_6548_679C_5B9E_4F8B_8868 + 1] = _____914D_7F6E
    _____786E_4FDD_6301_6709_578B_5468_671F_6548_679C_4E2D_5FC3_5DF2_6CE8_518C()
    _____8865_767B_8BB0_521D_59CB_5355_4F4D(_____914D_7F6E)
    if _____5DF2_6CE8_518C_76D1_542C_7269_54C1_7C7B_578B[_____53C2_6570["物品类型ID"]] ~= true then
        _____5DF2_6CE8_518C_76D1_542C_7269_54C1_7C7B_578B[_____53C2_6570["物品类型ID"]] = true
        _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03(_____53C2_6570["物品类型ID"], ____on_6301_6709_578B_5468_671F_6548_679C_83B7_53D6, ____on_6301_6709_578B_5468_671F_6548_679C_4E22_5F03)
    end
    return _____63A7_5236_5668
end
return ____exports
