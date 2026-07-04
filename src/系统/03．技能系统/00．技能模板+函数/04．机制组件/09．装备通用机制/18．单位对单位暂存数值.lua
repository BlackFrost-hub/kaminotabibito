local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local GetHandleId = jass.GetHandleId
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____53D6_952E(source, target)
    local sourceId = _____53D6_5355_4F4DID(source)
    local targetId = _____53D6_5355_4F4DID(target)
    if sourceId == 0 or targetId == 0 then
        return ""
    end
    return (tostring(sourceId) .. ":") .. tostring(targetId)
end
____exports["创建单位对单位暂存数值"] = function(_____540D_79F0)
    local _____8868 = {}
    local function _____8BFB_53D6_8BB0_5F55(source, target)
        local key = _____53D6_952E(source, target)
        if key == "" then
            return nil
        end
        local record = _____8868[key]
        if record == nil then
            return nil
        end
        if record["到期"] >= getServerTime() then
            return record
        end
        __TS__Delete(_____8868, key)
        return nil
    end
    return {
        ["名称"] = _____540D_79F0,
        ["写入"] = function(source, target, _____503C, _____6301_7EED_79D2)
            local key = _____53D6_952E(source, target)
            local duration = _____6301_7EED_79D2 or 2
            if key == "" or not (duration > 0) then
                return
            end
            _____8868[key] = {
                ["值"] = _____503C,
                ["到期"] = getServerTime() + duration * 1000
            }
        end,
        ["读取"] = function(source, target)
            local ____opt_1 = _____8BFB_53D6_8BB0_5F55(source, target)
            return ____opt_1 and ____opt_1["值"]
        end,
        ["消耗"] = function(source, target)
            local key = _____53D6_952E(source, target)
            if key == "" then
                return nil
            end
            local record = _____8BFB_53D6_8BB0_5F55(source, target)
            if record == nil then
                return nil
            end
            __TS__Delete(_____8868, key)
            return record["值"]
        end,
        ["清空"] = function()
            _____8868 = {}
        end
    }
end
return ____exports
