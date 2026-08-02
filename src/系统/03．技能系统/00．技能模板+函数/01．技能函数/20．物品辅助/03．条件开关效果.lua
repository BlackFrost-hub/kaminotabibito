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
local _____6761_4EF6_5F00_5173_5B9E_4F8B_8868 = {}
local _____6761_4EF6_5F00_5173_9A71_52A8
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
local function _____5207_6362_6761_4EF6_72B6_6001(_____914D_7F6E, _____72B6_6001)
    if _____72B6_6001["数量"] <= 0 then
        if _____72B6_6001["已开启"] then
            _____72B6_6001["已开启"] = false
            local ____opt_3 = _____914D_7F6E["关闭回调"]
            if ____opt_3 ~= nil then
                ____opt_3(_____72B6_6001["单位"], _____72B6_6001["数量"])
            end
        end
        return
    end
    local _____5E94_5F00_542F = _____914D_7F6E["条件回调"](_____72B6_6001["单位"], _____72B6_6001["数量"])
    if _____5E94_5F00_542F and not _____72B6_6001["已开启"] then
        _____72B6_6001["已开启"] = true
        _____914D_7F6E["开启回调"](_____72B6_6001["单位"], _____72B6_6001["数量"])
        return
    end
    if not _____5E94_5F00_542F and _____72B6_6001["已开启"] then
        _____72B6_6001["已开启"] = false
        local ____opt_5 = _____914D_7F6E["关闭回调"]
        if ____opt_5 ~= nil then
            ____opt_5(_____72B6_6001["单位"], _____72B6_6001["数量"])
        end
    end
end
local function _____5904_7406_83B7_5F97(_____914D_7F6E, unit, _item, currentCount, previousCount)
    local unitId = _____83B7_53D6_5355_4F4DID(unit)
    if unitId == 0 then
        return
    end
    if currentCount <= 0 then
        local _____72B6_6001 = _____914D_7F6E["单位状态"][unitId]
        if _____72B6_6001 ~= nil and _____72B6_6001["已开启"] then
            _____72B6_6001["已开启"] = false
            local ____opt_7 = _____914D_7F6E["关闭回调"]
            if ____opt_7 ~= nil then
                ____opt_7(unit, previousCount)
            end
        end
        __TS__Delete(_____914D_7F6E["单位状态"], unitId)
        return
    end
    local _____72B6_6001 = _____914D_7F6E["单位状态"][unitId] or ({["单位"] = unit, ["数量"] = currentCount, ["已开启"] = false})
    _____72B6_6001["单位"] = unit
    _____72B6_6001["数量"] = currentCount
    _____914D_7F6E["单位状态"][unitId] = _____72B6_6001
    _____5207_6362_6761_4EF6_72B6_6001(_____914D_7F6E, _____72B6_6001)
end
local function _____5904_7406_4E22_5F03(_____914D_7F6E, unit, _item, currentCount, previousCount)
    local unitId = _____83B7_53D6_5355_4F4DID(unit)
    if unitId == 0 then
        return
    end
    if currentCount <= 0 then
        local _____72B6_6001 = _____914D_7F6E["单位状态"][unitId]
        if _____72B6_6001 ~= nil and _____72B6_6001["已开启"] then
            _____72B6_6001["已开启"] = false
            local ____opt_9 = _____914D_7F6E["关闭回调"]
            if ____opt_9 ~= nil then
                ____opt_9(unit, previousCount)
            end
        end
        __TS__Delete(_____914D_7F6E["单位状态"], unitId)
        return
    end
    local _____72B6_6001 = _____914D_7F6E["单位状态"][unitId] or ({["单位"] = unit, ["数量"] = currentCount, ["已开启"] = false})
    _____72B6_6001["单位"] = unit
    _____72B6_6001["数量"] = currentCount
    _____914D_7F6E["单位状态"][unitId] = _____72B6_6001
    _____5207_6362_6761_4EF6_72B6_6001(_____914D_7F6E, _____72B6_6001)
end
local function ____on_6761_4EF6_5F00_5173_6548_679CTick(now)
    do
        local i = 0
        while i < #_____6761_4EF6_5F00_5173_5B9E_4F8B_8868 do
            do
                local _____914D_7F6E = _____6761_4EF6_5F00_5173_5B9E_4F8B_8868[i + 1]
                if now < _____914D_7F6E["下次触发时间"] then
                    goto __continue24
                end
                _____914D_7F6E["下次触发时间"] = now + _____914D_7F6E["检查间隔毫秒"]
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
                                goto __continue27
                            end
                            local currentCount = _____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF(_____72B6_6001["单位"], _____914D_7F6E["物品类型ID"])
                            if currentCount <= 0 then
                                if _____72B6_6001["已开启"] then
                                    _____72B6_6001["已开启"] = false
                                    local ____opt_11 = _____914D_7F6E["关闭回调"]
                                    if ____opt_11 ~= nil then
                                        ____opt_11(_____72B6_6001["单位"], _____72B6_6001["数量"])
                                    end
                                end
                                _____5F85_6E05_7406[#_____5F85_6E05_7406 + 1] = unitId
                                goto __continue27
                            end
                            _____72B6_6001["数量"] = currentCount
                            _____5207_6362_6761_4EF6_72B6_6001(_____914D_7F6E, _____72B6_6001)
                        end
                        ::__continue27::
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
            ::__continue24::
            i = i + 1
        end
    end
end
local function _____53D6_6761_4EF6_5F00_5173_5EFA_8BAE_68C0_67E5_95F4_9694(_nowMs)
    local _____6700_77ED_95F4_9694 = 0
    do
        local i = 0
        while i < #_____6761_4EF6_5F00_5173_5B9E_4F8B_8868 do
            local _____95F4_9694 = _____6761_4EF6_5F00_5173_5B9E_4F8B_8868[i + 1]["检查间隔毫秒"]
            if _____95F4_9694 > 0 and (_____6700_77ED_95F4_9694 == 0 or _____95F4_9694 < _____6700_77ED_95F4_9694) then
                _____6700_77ED_95F4_9694 = _____95F4_9694
            end
            i = i + 1
        end
    end
    return _____6700_77ED_95F4_9694
end
local function _____786E_4FDD_4E2D_5FC3_5DF2_6CE8_518C()
    if _____6761_4EF6_5F00_5173_9A71_52A8 == nil then
        _____6761_4EF6_5F00_5173_9A71_52A8 = _____521B_5EFA_81EA_9002_5E94_5171_4EAB_5468_671F_9A71_52A8({["名称"] = "条件开关效果驱动", ["最大检查间隔毫秒"] = 100, ["取建议检查间隔毫秒"] = _____53D6_6761_4EF6_5F00_5173_5EFA_8BAE_68C0_67E5_95F4_9694, onTick = ____on_6761_4EF6_5F00_5173_6548_679CTick})
    end
    _____6761_4EF6_5F00_5173_9A71_52A8["刷新"](_____6761_4EF6_5F00_5173_9A71_52A8)
end
local function ____on_6761_4EF6_5F00_5173_7269_54C1_83B7_53D6(unit, item, currentCount, previousCount, variable)
    local _____914D_7F6E = variable
    if _____914D_7F6E ~= nil then
        _____5904_7406_83B7_5F97(
            _____914D_7F6E,
            unit,
            item,
            currentCount,
            previousCount
        )
    end
end
local function ____on_6761_4EF6_5F00_5173_7269_54C1_4E22_5F03(unit, item, currentCount, previousCount, variable)
    local _____914D_7F6E = variable
    if _____914D_7F6E ~= nil then
        _____5904_7406_4E22_5F03(
            _____914D_7F6E,
            unit,
            item,
            currentCount,
            previousCount
        )
    end
end
____exports["注册持有型条件开关效果"] = function(_____53C2_6570)
    if _____53C2_6570 == nil or _____53C2_6570["物品类型ID"] == 0 or _____53C2_6570["检查间隔毫秒"] <= 0 or _____53C2_6570["条件回调"] == nil or _____53C2_6570["开启回调"] == nil then
        return
    end
    local _____914D_7F6E = __TS__ObjectAssign(
        {},
        _____53C2_6570,
        {
            ["下次触发时间"] = getServerTime() + _____53C2_6570["检查间隔毫秒"],
            ["单位状态"] = {}
        }
    )
    _____6761_4EF6_5F00_5173_5B9E_4F8B_8868[#_____6761_4EF6_5F00_5173_5B9E_4F8B_8868 + 1] = _____914D_7F6E
    _____786E_4FDD_4E2D_5FC3_5DF2_6CE8_518C()
    _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03(_____53C2_6570["物品类型ID"], ____on_6761_4EF6_5F00_5173_7269_54C1_83B7_53D6, ____on_6761_4EF6_5F00_5173_7269_54C1_4E22_5F03, _____914D_7F6E)
end
return ____exports
