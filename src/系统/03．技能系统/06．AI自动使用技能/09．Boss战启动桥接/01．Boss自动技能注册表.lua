local ____lualib = require("lualib_bundle")
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__Number = ____lualib.__TS__Number
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local GetHandleId = jass.GetHandleId
local ____Boss_81EA_52A8_6280_80FD_4E0A_4E0B_6587_8868 = {}
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
    local ids = __TS__ObjectKeys(____Boss_81EA_52A8_6280_80FD_4E0A_4E0B_6587_8868)
    do
        local i = 0
        while i < #ids do
            local context = ____Boss_81EA_52A8_6280_80FD_4E0A_4E0B_6587_8868[__TS__Number(ids[i + 1]) or 0]
            if context ~= nil then
                result[#result + 1] = context
            end
            i = i + 1
        end
    end
    __TS__ArraySort(
        result,
        function(____, a, b) return a["注册时间"] - b["注册时间"] end
    )
    return result
end
____exports["清理Boss自动技能启动上下文"] = function(unit)
    if unit == nil or unit == 0 then
        return
    end
    ____Boss_81EA_52A8_6280_80FD_4E0A_4E0B_6587_8868[GetHandleId(unit)] = nil
end
return ____exports
