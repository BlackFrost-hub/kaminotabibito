--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local _____83B7_53D6_53E5_67C4Id = jass.GetHandleId
local _____51B7_5374_8BB0_5F55_8868 = {}
local function _____6784_5EFA_8BB0_5F55_952E(whichUnit, abilityId)
    return (tostring(_____83B7_53D6_53E5_67C4Id(whichUnit)) .. ":") .. tostring(abilityId)
end
____exports["记录技能冷却"] = function(whichUnit, abilityId, cooldownSeconds)
    if whichUnit == nil or whichUnit == 0 then
        return
    end
    if abilityId == 0 then
        return
    end
    if not (cooldownSeconds > 0.05) then
        return
    end
    local _____51B7_5374_6BEB_79D2 = jass.R2I(cooldownSeconds * 1000 + 0.5)
    _____51B7_5374_8BB0_5F55_8868[_____6784_5EFA_8BB0_5F55_952E(whichUnit, abilityId)] = {["结束时间毫秒"] = getServerTime() + _____51B7_5374_6BEB_79D2}
end
____exports["获取技能剩余冷却"] = function(whichUnit, abilityId)
    if whichUnit == nil or whichUnit == 0 then
        return -1
    end
    if abilityId == 0 then
        return -1
    end
    local _____8BB0_5F55 = _____51B7_5374_8BB0_5F55_8868[_____6784_5EFA_8BB0_5F55_952E(whichUnit, abilityId)]
    if _____8BB0_5F55 == nil then
        return -1
    end
    local _____5269_4F59_6BEB_79D2 = _____8BB0_5F55["结束时间毫秒"] - getServerTime()
    if _____5269_4F59_6BEB_79D2 <= 50 then
        _____51B7_5374_8BB0_5F55_8868[_____6784_5EFA_8BB0_5F55_952E(whichUnit, abilityId)] = nil
        return 0
    end
    return _____5269_4F59_6BEB_79D2 / 1000
end
return ____exports
