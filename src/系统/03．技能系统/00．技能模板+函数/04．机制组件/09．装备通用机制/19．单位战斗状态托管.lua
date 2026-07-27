local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.07．战斗状态触发器")
local _____521B_5EFA_6218_6597_72B6_6001_89E6_53D1_5668 = ____require_result_0["创建战斗状态触发器"]
local GetHandleId = jass.GetHandleId
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
____exports["创建单位战斗状态托管器"] = function(_____53C2_6570)
    local _____63A7_5236_5668_8868 = {}
    local function _____5DF2_52A0_5165(unit)
        local unitId = _____53D6_5355_4F4DID(unit)
        return unitId ~= 0 and _____63A7_5236_5668_8868[unitId] ~= nil
    end
    local function _____52A0_5165(unit)
        local unitId = _____53D6_5355_4F4DID(unit)
        if unitId == 0 or _____63A7_5236_5668_8868[unitId] ~= nil then
            return
        end
        _____63A7_5236_5668_8868[unitId] = _____521B_5EFA_6218_6597_72B6_6001_89E6_53D1_5668({
            ["名称"] = _____53C2_6570["名称"],
            ["单位"] = unit,
            ["主体类型"] = _____53C2_6570["主体类型"],
            ["周期触发秒"] = _____53C2_6570["周期触发秒"],
            ["on周期触发"] = _____53C2_6570["on周期触发"]
        })
    end
    local function _____79FB_9664(unit)
        local unitId = _____53D6_5355_4F4DID(unit)
        if unitId == 0 then
            return
        end
        local _____63A7_5236_5668 = _____63A7_5236_5668_8868[unitId]
        if _____63A7_5236_5668 ~= nil then
            _____63A7_5236_5668["停止"](_____63A7_5236_5668)
            __TS__Delete(_____63A7_5236_5668_8868, unitId)
        end
    end
    return {["加入"] = _____52A0_5165, ["移除"] = _____79FB_9664, ["已加入"] = _____5DF2_52A0_5165}
end
return ____exports
