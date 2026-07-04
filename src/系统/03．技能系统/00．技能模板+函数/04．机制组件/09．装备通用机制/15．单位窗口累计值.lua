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
local _____5355_4F4D_7A97_53E3_7D2F_8BA1_503C_5B9E_73B0 = __TS__Class()
_____5355_4F4D_7A97_53E3_7D2F_8BA1_503C_5B9E_73B0.name = "单位窗口累计值实现"
function _____5355_4F4D_7A97_53E3_7D2F_8BA1_503C_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____7A97_53E3_79D2)
    self["记录表"] = {}
    self["名称"] = _____540D_79F0
    self["窗口毫秒"] = _____7A97_53E3_79D2 * 1000
end
_____5355_4F4D_7A97_53E3_7D2F_8BA1_503C_5B9E_73B0.prototype["增加"] = function(self, unit, _____6570_503C)
    local id = self["取单位ID"](self, unit)
    if id == 0 or not (_____6570_503C > 0) then
        return 0
    end
    local now = getServerTime()
    local _____8BB0_5F55 = self["记录表"][id]
    if _____8BB0_5F55 == nil or now >= _____8BB0_5F55["结束时间"] then
        _____8BB0_5F55 = {["数值"] = 0, ["结束时间"] = now + self["窗口毫秒"]}
        self["记录表"][id] = _____8BB0_5F55
    end
    _____8BB0_5F55["数值"] = _____8BB0_5F55["数值"] + _____6570_503C
    return _____8BB0_5F55["数值"]
end
_____5355_4F4D_7A97_53E3_7D2F_8BA1_503C_5B9E_73B0.prototype["读取"] = function(self, unit)
    local id = self["取单位ID"](self, unit)
    if id == 0 then
        return 0
    end
    local _____8BB0_5F55 = self["记录表"][id]
    if _____8BB0_5F55 == nil then
        return 0
    end
    if getServerTime() < _____8BB0_5F55["结束时间"] then
        return _____8BB0_5F55["数值"]
    end
    __TS__Delete(self["记录表"], id)
    return 0
end
_____5355_4F4D_7A97_53E3_7D2F_8BA1_503C_5B9E_73B0.prototype["清空"] = function(self, unit)
    if unit == nil then
        self["记录表"] = {}
        return
    end
    __TS__Delete(
        self["记录表"],
        self["取单位ID"](self, unit)
    )
end
_____5355_4F4D_7A97_53E3_7D2F_8BA1_503C_5B9E_73B0.prototype["取单位ID"] = function(self, unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
____exports["创建单位窗口累计值"] = function(_____540D_79F0, _____7A97_53E3_79D2)
    return __TS__New(_____5355_4F4D_7A97_53E3_7D2F_8BA1_503C_5B9E_73B0, _____540D_79F0, _____7A97_53E3_79D2)
end
return ____exports
