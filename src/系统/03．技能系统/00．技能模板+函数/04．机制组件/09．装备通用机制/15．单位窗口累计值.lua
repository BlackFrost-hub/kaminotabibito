local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__New = ____lualib.__TS__New
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
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
local _____7A97_53E3_4E8B_4EF6_8BA1_6570_5668_5B9E_73B0 = __TS__Class()
_____7A97_53E3_4E8B_4EF6_8BA1_6570_5668_5B9E_73B0.name = "窗口事件计数器实现"
function _____7A97_53E3_4E8B_4EF6_8BA1_6570_5668_5B9E_73B0.prototype.____constructor(self, _____540D_79F0)
    self["状态表"] = {}
    self["名称"] = _____540D_79F0
end
_____7A97_53E3_4E8B_4EF6_8BA1_6570_5668_5B9E_73B0.prototype["增加"] = function(self, key, _____7A97_53E3_79D2, _____89E6_53D1_540E_6E05_7A7A, _____89E6_53D1_9608_503C)
    if _____89E6_53D1_540E_6E05_7A7A == nil then
        _____89E6_53D1_540E_6E05_7A7A = false
    end
    if _____89E6_53D1_9608_503C == nil then
        _____89E6_53D1_9608_503C = 0
    end
    if key == "" then
        return 0
    end
    local now = getServerTime()
    local _____72B6_6001 = self["取或建状态"](self, key)
    local ____72B6_6001__8BB0_5F55_1 = _____72B6_6001["记录"]
    ____72B6_6001__8BB0_5F55_1[#____72B6_6001__8BB0_5F55_1 + 1] = {["时间毫秒"] = now}
    self["清理过期记录"](self, _____72B6_6001, now, _____7A97_53E3_79D2)
    local _____5F53_524D_6B21_6570 = #_____72B6_6001["记录"]
    if _____89E6_53D1_540E_6E05_7A7A and _____89E6_53D1_9608_503C > 0 and _____5F53_524D_6B21_6570 >= _____89E6_53D1_9608_503C then
        __TS__Delete(self["状态表"], key)
    end
    return _____5F53_524D_6B21_6570
end
_____7A97_53E3_4E8B_4EF6_8BA1_6570_5668_5B9E_73B0.prototype["读取"] = function(self, key, _____7A97_53E3_79D2)
    if _____7A97_53E3_79D2 == nil then
        _____7A97_53E3_79D2 = 0
    end
    if key == "" then
        return 0
    end
    local _____72B6_6001 = self["状态表"][key]
    if _____72B6_6001 == nil then
        return 0
    end
    self["清理过期记录"](
        self,
        _____72B6_6001,
        getServerTime(),
        _____7A97_53E3_79D2
    )
    return #_____72B6_6001["记录"]
end
_____7A97_53E3_4E8B_4EF6_8BA1_6570_5668_5B9E_73B0.prototype["撤销最近一次"] = function(self, key)
    if key == "" then
        return 0
    end
    local _____72B6_6001 = self["状态表"][key]
    if _____72B6_6001 == nil then
        return 0
    end
    table.remove(_____72B6_6001["记录"])
    local _____5F53_524D_6B21_6570 = #_____72B6_6001["记录"]
    if _____5F53_524D_6B21_6570 <= 0 then
        __TS__Delete(self["状态表"], key)
    end
    return _____5F53_524D_6B21_6570
end
_____7A97_53E3_4E8B_4EF6_8BA1_6570_5668_5B9E_73B0.prototype["清空"] = function(self, key)
    if key == nil then
        self["状态表"] = {}
        return
    end
    __TS__Delete(self["状态表"], key)
end
_____7A97_53E3_4E8B_4EF6_8BA1_6570_5668_5B9E_73B0.prototype["取或建状态"] = function(self, key)
    local _____72B6_6001 = self["状态表"][key]
    if _____72B6_6001 == nil then
        _____72B6_6001 = {["记录"] = {}}
        self["状态表"][key] = _____72B6_6001
    end
    return _____72B6_6001
end
_____7A97_53E3_4E8B_4EF6_8BA1_6570_5668_5B9E_73B0.prototype["清理过期记录"] = function(self, _____72B6_6001, now, _____7A97_53E3_79D2)
    if not (_____7A97_53E3_79D2 > 0) then
        return
    end
    local _____6700_65E9_6BEB_79D2 = now - _____7A97_53E3_79D2 * 1000
    do
        local i = #_____72B6_6001["记录"] - 1
        while i >= 0 do
            do
                if _____72B6_6001["记录"][i + 1]["时间毫秒"] >= _____6700_65E9_6BEB_79D2 then
                    goto __continue33
                end
                __TS__ArraySplice(_____72B6_6001["记录"], i, 1)
            end
            ::__continue33::
            i = i - 1
        end
    end
end
____exports["创建窗口事件计数器"] = function(_____540D_79F0)
    return __TS__New(_____7A97_53E3_4E8B_4EF6_8BA1_6570_5668_5B9E_73B0, _____540D_79F0)
end
return ____exports
