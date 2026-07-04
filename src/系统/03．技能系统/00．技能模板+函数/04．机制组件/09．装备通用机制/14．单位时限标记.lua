local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__New = ____lualib.__TS__New
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local GetHandleId = jass.GetHandleId
local _____5355_4F4D_65F6_9650_6807_8BB0_5B9E_73B0 = __TS__Class()
_____5355_4F4D_65F6_9650_6807_8BB0_5B9E_73B0.name = "单位时限标记实现"
function _____5355_4F4D_65F6_9650_6807_8BB0_5B9E_73B0.prototype.____constructor(self, _____540D_79F0)
    self["到期表"] = {}
    self["名称"] = _____540D_79F0
end
_____5355_4F4D_65F6_9650_6807_8BB0_5B9E_73B0.prototype["标记"] = function(self, unit, _____6301_7EED_79D2)
    local id = self["取单位ID"](self, unit)
    if id == 0 or not (_____6301_7EED_79D2 > 0) then
        return
    end
    self["到期表"][id] = getServerTime() + _____6301_7EED_79D2 * 1000
end
_____5355_4F4D_65F6_9650_6807_8BB0_5B9E_73B0.prototype["存在"] = function(self, unit)
    local id = self["取单位ID"](self, unit)
    if id == 0 then
        return false
    end
    local expire = self["到期表"][id] or 0
    if expire >= getServerTime() then
        return true
    end
    __TS__Delete(self["到期表"], id)
    return false
end
_____5355_4F4D_65F6_9650_6807_8BB0_5B9E_73B0.prototype["消耗"] = function(self, unit)
    if not self["存在"](self, unit) then
        return false
    end
    __TS__Delete(
        self["到期表"],
        self["取单位ID"](self, unit)
    )
    return true
end
_____5355_4F4D_65F6_9650_6807_8BB0_5B9E_73B0.prototype["清空"] = function(self, unit)
    if unit == nil then
        self["到期表"] = {}
        return
    end
    __TS__Delete(
        self["到期表"],
        self["取单位ID"](self, unit)
    )
end
_____5355_4F4D_65F6_9650_6807_8BB0_5B9E_73B0.prototype["取单位ID"] = function(self, unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
____exports["创建单位时限标记"] = function(_____540D_79F0)
    return __TS__New(_____5355_4F4D_65F6_9650_6807_8BB0_5B9E_73B0, _____540D_79F0)
end
return ____exports
