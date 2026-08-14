local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitState = jass.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IssueImmediateOrder = jass.IssueImmediateOrder
local IssuePointOrder = jass.IssuePointOrder
local SetUnitFacing = jass.SetUnitFacing
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local _____8FD0_884C_4E2D_79FB_52A8_4EFB_52A1_5217_8868 = {}
local function _____5355_4F4D_53EF_79FB_52A8(unit)
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) ~= 0 and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
local function _____4ECE_8FD0_884C_5217_8868_79FB_9664(_____4EFB_52A1)
    local index = __TS__ArrayIndexOf(_____8FD0_884C_4E2D_79FB_52A8_4EFB_52A1_5217_8868, _____4EFB_52A1)
    if index >= 0 then
        __TS__ArraySplice(_____8FD0_884C_4E2D_79FB_52A8_4EFB_52A1_5217_8868, index, 1)
    end
end
local function _____505C_6B62_79FB_52A8_4EFB_52A1(_____4EFB_52A1, _____6267_884C_4E2D_6B62_56DE_8C03)
    if not _____4EFB_52A1["运行中"] then
        return
    end
    _____4EFB_52A1["运行中"] = false
    if _____4EFB_52A1["回调ID"] ~= 0 then
        removePeriodicCallback(_____4EFB_52A1["回调ID"])
        _____4EFB_52A1["回调ID"] = 0
    end
    _____4ECE_8FD0_884C_5217_8868_79FB_9664(_____4EFB_52A1)
    if _____6267_884C_4E2D_6B62_56DE_8C03 and _____4EFB_52A1["配置"]["中止回调"] ~= nil then
        _____4EFB_52A1["配置"]["中止回调"](_____4EFB_52A1["配置"]["单位"])
    end
end
local function ____on_5267_60C5_5355_4F4D_79FB_52A8Tick(variable)
    local _____4EFB_52A1 = variable
    if _____4EFB_52A1 == nil or not _____4EFB_52A1["运行中"] then
        return
    end
    local _____914D_7F6E = _____4EFB_52A1["配置"]
    if not _____5355_4F4D_53EF_79FB_52A8(_____914D_7F6E["单位"]) or _____914D_7F6E["是否继续"] ~= nil and not _____914D_7F6E["是否继续"](_____914D_7F6E["单位"]) then
        _____505C_6B62_79FB_52A8_4EFB_52A1(_____4EFB_52A1, true)
        return
    end
    local dx = GetUnitX(_____914D_7F6E["单位"]) - _____914D_7F6E["目标X"]
    local dy = GetUnitY(_____914D_7F6E["单位"]) - _____914D_7F6E["目标Y"]
    local _____5230_8FBE_8DDD_79BB = _____914D_7F6E["到达距离"] or 96
    if dx * dx + dy * dy <= _____5230_8FBE_8DDD_79BB * _____5230_8FBE_8DDD_79BB then
        _____4EFB_52A1["已到达"] = true
        local _____5230_8FBE_547D_4EE4 = _____914D_7F6E["到达命令"] == nil and "holdposition" or _____914D_7F6E["到达命令"]
        if _____5230_8FBE_547D_4EE4 ~= false then
            IssueImmediateOrder(_____914D_7F6E["单位"], _____5230_8FBE_547D_4EE4)
        end
        if _____914D_7F6E["到达朝向"] ~= nil then
            SetUnitFacing(_____914D_7F6E["单位"], _____914D_7F6E["到达朝向"])
        end
        _____505C_6B62_79FB_52A8_4EFB_52A1(_____4EFB_52A1, false)
        if _____914D_7F6E["到达回调"] ~= nil then
            _____914D_7F6E["到达回调"](_____914D_7F6E["单位"])
        end
        return
    end
    if _____914D_7F6E["补发移动命令"] ~= false then
        IssuePointOrder(_____914D_7F6E["单位"], _____914D_7F6E["移动命令"] or "move", _____914D_7F6E["目标X"], _____914D_7F6E["目标Y"])
    end
end
--- 驱动剧情单位走到目标并可靠停留。同一单位开始新任务时会自动取消旧任务，
-- 所有完成、失效和手动取消路径都会注销中心计时器回调。
____exports["开始剧情单位保持移动"] = function(_____914D_7F6E)
    if not _____5355_4F4D_53EF_79FB_52A8(_____914D_7F6E["单位"]) then
        return nil
    end
    do
        local i = #_____8FD0_884C_4E2D_79FB_52A8_4EFB_52A1_5217_8868 - 1
        while i >= 0 do
            local _____65E7_4EFB_52A1 = _____8FD0_884C_4E2D_79FB_52A8_4EFB_52A1_5217_8868[i + 1]
            if _____65E7_4EFB_52A1["配置"]["单位"] == _____914D_7F6E["单位"] then
                _____505C_6B62_79FB_52A8_4EFB_52A1(_____65E7_4EFB_52A1, false)
            end
            i = i - 1
        end
    end
    local _____4EFB_52A1 = {}
    local _____63A7_5236_5668 = {
        ["取消"] = function() return _____505C_6B62_79FB_52A8_4EFB_52A1(_____4EFB_52A1, false) end,
        ["是否运行"] = function() return _____4EFB_52A1["运行中"] end,
        ["是否到达"] = function() return _____4EFB_52A1["已到达"] end
    }
    _____4EFB_52A1["配置"] = _____914D_7F6E
    _____4EFB_52A1["控制器"] = _____63A7_5236_5668
    _____4EFB_52A1["回调ID"] = 0
    _____4EFB_52A1["运行中"] = true
    _____4EFB_52A1["已到达"] = false
    _____8FD0_884C_4E2D_79FB_52A8_4EFB_52A1_5217_8868[#_____8FD0_884C_4E2D_79FB_52A8_4EFB_52A1_5217_8868 + 1] = _____4EFB_52A1
    IssuePointOrder(_____914D_7F6E["单位"], _____914D_7F6E["移动命令"] or "move", _____914D_7F6E["目标X"], _____914D_7F6E["目标Y"])
    _____4EFB_52A1["回调ID"] = addPeriodicCallback(_____914D_7F6E["检查间隔毫秒"] or 400, ____on_5267_60C5_5355_4F4D_79FB_52A8Tick, _____4EFB_52A1)
    return _____63A7_5236_5668
end
return ____exports
