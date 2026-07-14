local ____lualib = require("lualib_bundle")
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local ____Boss_81EA_52A8_6280_80FD_4E0A_4E0B_6587_8868 = {}
local ____Boss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C_8868 = {}
local _____4E0B_4E00_4E2ABoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542CID = 0
local function _____542F_52A8_76D1_542C_5339_914D(_____76D1_542C, context)
    if _____76D1_542C["单位类型ID"] == nil then
        return true
    end
    return GetUnitTypeId(context["Boss单位"]) == _____76D1_542C["单位类型ID"]
end
local function _____901A_77E5Boss_81EA_52A8_6280_80FD_542F_52A8(context)
    for key in pairs(____Boss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C_8868) do
        local _____76D1_542C = ____Boss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C_8868[key]
        if _____76D1_542C ~= nil and _____542F_52A8_76D1_542C_5339_914D(_____76D1_542C, context) then
            _____76D1_542C["on启动"](context)
        end
    end
end
____exports["记录Boss自动技能启动"] = function(unit, source)
    if unit == nil or unit == 0 then
        return nil
    end
    local handleId = GetHandleId(unit)
    local context = {
        ["Boss单位"] = unit,
        ["来源"] = source,
        ["注册时间"] = getServerTime()
    }
    ____Boss_81EA_52A8_6280_80FD_4E0A_4E0B_6587_8868[handleId] = context
    _____901A_77E5Boss_81EA_52A8_6280_80FD_542F_52A8(context)
    return context
end
____exports["读取Boss自动技能启动上下文"] = function(unit)
    if unit == nil or unit == 0 then
        return nil
    end
    return ____Boss_81EA_52A8_6280_80FD_4E0A_4E0B_6587_8868[GetHandleId(unit)]
end
____exports["是否已登记Boss自动技能"] = function(unit)
    return ____exports["读取Boss自动技能启动上下文"](unit) ~= nil
end
____exports["获取所有Boss自动技能启动上下文"] = function()
    local result = {}
    for key in pairs(____Boss_81EA_52A8_6280_80FD_4E0A_4E0B_6587_8868) do
        local context = ____Boss_81EA_52A8_6280_80FD_4E0A_4E0B_6587_8868[key]
        if context ~= nil then
            result[#result + 1] = context
        end
    end
    __TS__ArraySort(
        result,
        function(____, a, b) return a["注册时间"] - b["注册时间"] end
    )
    return result
end
____exports["注册Boss自动技能启动监听"] = function(_____53C2_6570)
    _____4E0B_4E00_4E2ABoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542CID = _____4E0B_4E00_4E2ABoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542CID + 1
    local ID = _____4E0B_4E00_4E2ABoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542CID
    local _____76D1_542C = __TS__ObjectAssign({}, _____53C2_6570, {ID = ID})
    ____Boss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C_8868[ID] = _____76D1_542C
    if _____53C2_6570["回放已有"] ~= false then
        local contexts = ____exports["获取所有Boss自动技能启动上下文"]()
        do
            local i = 0
            while i < #contexts do
                local context = contexts[i + 1]
                if context ~= nil and _____542F_52A8_76D1_542C_5339_914D(_____76D1_542C, context) then
                    _____76D1_542C["on启动"](context)
                end
                i = i + 1
            end
        end
    end
    return ID
end
____exports["注销Boss自动技能启动监听"] = function(ID)
    ____Boss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C_8868[ID] = nil
end
____exports["清理Boss自动技能启动上下文"] = function(unit)
    if unit == nil or unit == 0 then
        return
    end
    ____Boss_81EA_52A8_6280_80FD_4E0A_4E0B_6587_8868[GetHandleId(unit)] = nil
end
return ____exports
