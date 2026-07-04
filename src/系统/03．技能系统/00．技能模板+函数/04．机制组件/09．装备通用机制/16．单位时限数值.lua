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
____exports["创建单位时限数值"] = function(_____540D_79F0)
    local _____8868 = {}
    local function _____8BFB_53D6_8BB0_5F55(unit)
        local id = _____53D6_5355_4F4DID(unit)
        if id == 0 then
            return nil
        end
        local _____8BB0_5F55 = _____8868[id]
        if _____8BB0_5F55 == nil then
            return nil
        end
        if _____8BB0_5F55["到期"] >= getServerTime() then
            return _____8BB0_5F55
        end
        __TS__Delete(_____8868, id)
        return nil
    end
    return {
        ["名称"] = _____540D_79F0,
        ["写入"] = function(unit, _____503C, _____6301_7EED_79D2)
            local id = _____53D6_5355_4F4DID(unit)
            if id == 0 or not (_____6301_7EED_79D2 > 0) then
                return
            end
            _____8868[id] = {
                ["值"] = _____503C,
                ["到期"] = getServerTime() + _____6301_7EED_79D2 * 1000
            }
        end,
        ["读取"] = function(unit)
            local ____opt_1 = _____8BFB_53D6_8BB0_5F55(unit)
            return ____opt_1 and ____opt_1["值"]
        end,
        ["存在"] = function(unit)
            return _____8BFB_53D6_8BB0_5F55(unit) ~= nil
        end,
        ["消耗"] = function(unit)
            local id = _____53D6_5355_4F4DID(unit)
            if id == 0 then
                return nil
            end
            local _____8BB0_5F55 = _____8BFB_53D6_8BB0_5F55(unit)
            if _____8BB0_5F55 == nil then
                return nil
            end
            __TS__Delete(_____8868, id)
            return _____8BB0_5F55["值"]
        end,
        ["清空"] = function(unit)
            if unit == nil then
                _____8868 = {}
                return
            end
            __TS__Delete(
                _____8868,
                _____53D6_5355_4F4DID(unit)
            )
        end
    }
end
return ____exports
