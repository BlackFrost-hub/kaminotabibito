--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电")
local _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535 = ____require_result_1["创建单位绑定闪电"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____8DDD_79BB_5E73_65B9(a, b)
    local dx = GetUnitX(a) - GetUnitX(b)
    local dy = GetUnitY(a) - GetUnitY(b)
    return dx * dx + dy * dy
end
local function _____5355_4F4D_5728_5217_8868_4E2D(unit, list)
    if list == nil then
        return false
    end
    do
        local i = 0
        while i < #list do
            if list[i + 1] == unit then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____9009_62E9_672A_5360_7528_76EE_6807(_____53C2_6570)
    local _____53D6_5019_9009 = _____53C2_6570["候选目标列表"]
    local targets = _____53D6_5019_9009()
    do
        local i = 0
        while i < #targets do
            local target = targets[i + 1]
            if _____5355_4F4D_6709_6548(target) and not _____5355_4F4D_5728_5217_8868_4E2D(target, _____53C2_6570["已占用目标"]) then
                return target
            end
            i = i + 1
        end
    end
    return nil
end
local function _____542F_52A8_8FDE_63A5Tick(_____53C2_6570, target)
    if _____53C2_6570["Tick间隔秒"] == nil or not (_____53C2_6570["Tick间隔秒"] > 0) then
        return
    end
    if _____53C2_6570["on距离超出"] == nil or _____53C2_6570["连接半径"] == nil or not (_____53C2_6570["连接半径"] > 0) then
        return
    end
    local radius2 = _____53C2_6570["连接半径"] * _____53C2_6570["连接半径"]
    local tickMs = _____53C2_6570["Tick间隔秒"] * 1000
    local timerId
    timerId = addPeriodicCallback(
        tickMs,
        function()
            if not _____5355_4F4D_6709_6548(_____53C2_6570["来源单位"]) or not _____5355_4F4D_6709_6548(_____53C2_6570["连接单位"]) or not _____5355_4F4D_6709_6548(target) then
                removePeriodicCallback(timerId)
                return
            end
            if _____8DDD_79BB_5E73_65B9(_____53C2_6570["连接单位"], target) > radius2 then
                local ____on_8DDD_79BB_8D85_51FA = _____53C2_6570["on距离超出"]
                if ____on_8DDD_79BB_8D85_51FA ~= nil then
                    ____on_8DDD_79BB_8D85_51FA(_____53C2_6570["来源单位"], _____53C2_6570["连接单位"], target)
                end
            end
        end
    )
    addDelayedCallback(
        _____53C2_6570["持续秒"] * 1000,
        function()
            removePeriodicCallback(timerId)
        end
    )
end
____exports["启动独占单位连接"] = function(_____53C2_6570)
    if not _____5355_4F4D_6709_6548(_____53C2_6570["来源单位"]) or not _____5355_4F4D_6709_6548(_____53C2_6570["连接单位"]) or _____53C2_6570["持续秒"] <= 0 then
        return false
    end
    local _____5DF2_7ED1_5B9A = false
    local _____5DF2_7ECF_8FC7_671F = false
    local retryTimerId = 0
    local function _____5C1D_8BD5_8FDE_63A5_76EE_6807()
        if _____5DF2_7ED1_5B9A or _____5DF2_7ECF_8FC7_671F then
            return
        end
        if not _____5355_4F4D_6709_6548(_____53C2_6570["来源单位"]) or not _____5355_4F4D_6709_6548(_____53C2_6570["连接单位"]) then
            _____5DF2_7ECF_8FC7_671F = true
            if retryTimerId ~= 0 then
                removePeriodicCallback(retryTimerId)
            end
            return
        end
        local target = _____9009_62E9_672A_5360_7528_76EE_6807(_____53C2_6570)
        if not _____5355_4F4D_6709_6548(target) then
            return
        end
        _____5DF2_7ED1_5B9A = true
        if _____53C2_6570["已占用目标"] ~= nil then
            local ____53C2_6570__5DF2_5360_7528_76EE_6807_2 = _____53C2_6570["已占用目标"]
            ____53C2_6570__5DF2_5360_7528_76EE_6807_2[#____53C2_6570__5DF2_5360_7528_76EE_6807_2 + 1] = target
        end
        if retryTimerId ~= 0 then
            removePeriodicCallback(retryTimerId)
        end
        _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535({
            ["效果代码"] = _____53C2_6570["闪电类型"],
            ["起点单位"] = _____53C2_6570["连接单位"],
            ["终点单位"] = target,
            ["持续时间"] = _____53C2_6570["持续秒"],
            ["起点高度偏移"] = _____53C2_6570["闪电起点高度偏移"],
            ["终点高度偏移"] = _____53C2_6570["闪电终点高度偏移"],
            ["任一死亡时销毁"] = true,
            ["颜色"] = _____53C2_6570["闪电颜色"]
        })
        _____542F_52A8_8FDE_63A5Tick(_____53C2_6570, target)
        local ____on_8FDE_63A5_6210_529F = _____53C2_6570["on连接成功"]
        if ____on_8FDE_63A5_6210_529F ~= nil then
            ____on_8FDE_63A5_6210_529F(_____53C2_6570["连接单位"], target)
        end
    end
    _____5C1D_8BD5_8FDE_63A5_76EE_6807()
    if not _____5DF2_7ED1_5B9A and _____53C2_6570["重试间隔秒"] ~= nil and _____53C2_6570["重试间隔秒"] > 0 then
        retryTimerId = addPeriodicCallback(_____53C2_6570["重试间隔秒"] * 1000, _____5C1D_8BD5_8FDE_63A5_76EE_6807)
    end
    addDelayedCallback(
        _____53C2_6570["持续秒"] * 1000,
        function()
            _____5DF2_7ECF_8FC7_671F = true
            if retryTimerId ~= 0 then
                removePeriodicCallback(retryTimerId)
            end
        end
    )
    return _____5DF2_7ED1_5B9A
end
return ____exports
