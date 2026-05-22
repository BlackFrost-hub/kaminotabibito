local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_1.onTick10ms
local getServerTime = ____require_result_1.getServerTime
local GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local RemoveUnit = jass.RemoveUnit
local _____5355_4F4D_6392_6CC4_5EF6_8FDF_6BEB_79D2 = 20000
local _____6B7B_4EA1_751F_547D_9608_503C = 0.405
local _____5DF2_767B_8BB0_5355_4F4D_8868 = {}
local _____5DF2_8FDB_5165_6392_6CC4_961F_5217 = {}
local _____5F85_6392_6CC4_5355_4F4D_5217_8868 = {}
local _____5DF2_6CE8_518C_5355_4F4D_6B7B_4EA1_76D1_542C = false
local _____5DF2_6CE8_518C_5355_4F4D_6392_6CC4Tick = false
local function _____5355_4F4D_662F_5426_4ECD_4E3A_5C38_4F53(unit)
    if unit == nil or unit == 0 then
        return false
    end
    if IsUnitType(unit, jass.UNIT_TYPE_DEAD) then
        return true
    end
    return GetUnitState(unit, jass.UNIT_STATE_LIFE) <= _____6B7B_4EA1_751F_547D_9608_503C
end
local function ____on_5355_4F4D_6392_6CC4Tick()
    local now = getServerTime()
    do
        local i = #_____5F85_6392_6CC4_5355_4F4D_5217_8868 - 1
        while i >= 0 do
            do
                local entry = _____5F85_6392_6CC4_5355_4F4D_5217_8868[i + 1]
                if now < entry.dueTimeMs then
                    goto __continue7
                end
                __TS__Delete(_____5DF2_8FDB_5165_6392_6CC4_961F_5217, entry.handleId)
                if _____5355_4F4D_662F_5426_4ECD_4E3A_5C38_4F53(entry.unit) then
                    RemoveUnit(entry.unit)
                end
                __TS__ArraySplice(_____5F85_6392_6CC4_5355_4F4D_5217_8868, i, 1)
            end
            ::__continue7::
            i = i - 1
        end
    end
end
local function ____on_5DF2_767B_8BB0_5355_4F4D_6B7B_4EA1(dyingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    local handleId = GetHandleId(dyingUnit)
    if handleId == 0 then
        return
    end
    if _____5DF2_767B_8BB0_5355_4F4D_8868[handleId] ~= true then
        return
    end
    __TS__Delete(_____5DF2_767B_8BB0_5355_4F4D_8868, handleId)
    if _____5DF2_8FDB_5165_6392_6CC4_961F_5217[handleId] == true then
        return
    end
    _____5DF2_8FDB_5165_6392_6CC4_961F_5217[handleId] = true
    _____5F85_6392_6CC4_5355_4F4D_5217_8868[#_____5F85_6392_6CC4_5355_4F4D_5217_8868 + 1] = {
        handleId = handleId,
        unit = dyingUnit,
        dueTimeMs = getServerTime() + _____5355_4F4D_6392_6CC4_5EF6_8FDF_6BEB_79D2
    }
end
local function _____786E_4FDD_5355_4F4D_6392_6CC4_521D_59CB_5316()
    if not _____5DF2_6CE8_518C_5355_4F4D_6B7B_4EA1_76D1_542C then
        _____5DF2_6CE8_518C_5355_4F4D_6B7B_4EA1_76D1_542C = true
        registerDeathListener(____on_5DF2_767B_8BB0_5355_4F4D_6B7B_4EA1)
    end
    if not _____5DF2_6CE8_518C_5355_4F4D_6392_6CC4Tick then
        _____5DF2_6CE8_518C_5355_4F4D_6392_6CC4Tick = true
        onTick10ms(____on_5355_4F4D_6392_6CC4Tick)
    end
end
____exports["登记单位排泄"] = function(unit)
    if unit == nil or unit == 0 then
        return unit
    end
    _____786E_4FDD_5355_4F4D_6392_6CC4_521D_59CB_5316()
    local handleId = GetHandleId(unit)
    if handleId == 0 then
        return unit
    end
    _____5DF2_767B_8BB0_5355_4F4D_8868[handleId] = true
    __TS__Delete(_____5DF2_8FDB_5165_6392_6CC4_961F_5217, handleId)
    return unit
end
____exports["取消单位排泄登记"] = function(unit)
    if unit == nil or unit == 0 then
        return unit
    end
    local handleId = GetHandleId(unit)
    if handleId == 0 then
        return unit
    end
    __TS__Delete(_____5DF2_767B_8BB0_5355_4F4D_8868, handleId)
    __TS__Delete(_____5DF2_8FDB_5165_6392_6CC4_961F_5217, handleId)
    do
        local i = #_____5F85_6392_6CC4_5355_4F4D_5217_8868 - 1
        while i >= 0 do
            if _____5F85_6392_6CC4_5355_4F4D_5217_8868[i + 1].handleId == handleId then
                __TS__ArraySplice(_____5F85_6392_6CC4_5355_4F4D_5217_8868, i, 1)
            end
            i = i - 1
        end
    end
    return unit
end
____exports["立即移除单位并取消排泄登记"] = function(unit)
    if unit == nil or unit == 0 then
        return
    end
    ____exports["取消单位排泄登记"](unit)
    RemoveUnit(unit)
end
____exports["注册单位排泄监听"] = ____exports["登记单位排泄"]
____exports["注销单位排泄监听"] = ____exports["取消单位排泄登记"]
____exports["立即移除单位并注销排泄监听"] = ____exports["立即移除单位并取消排泄登记"]
return ____exports
