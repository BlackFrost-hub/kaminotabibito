local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local getServerTime = ____require_result_0.getServerTime
local function _____5355_4F4D_6709_6548(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) ~= true
end
local _____6301_7EED_6761_4EF6_89E6_53D1_63A7_5236_5668_5B9E_73B0 = __TS__Class()
_____6301_7EED_6761_4EF6_89E6_53D1_63A7_5236_5668_5B9E_73B0.name = "持续条件触发控制器实现"
function _____6301_7EED_6761_4EF6_89E6_53D1_63A7_5236_5668_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____53C2_6570)
    self["周期回调ID"] = 0
    self["已停止"] = false
    self["当前持续毫秒"] = 0
    self["上次开始毫秒"] = 0
    self["已触发"] = false
    self["名称"] = _____540D_79F0
    self["参数"] = _____53C2_6570
end
_____6301_7EED_6761_4EF6_89E6_53D1_63A7_5236_5668_5B9E_73B0.prototype["设置周期回调ID"] = function(self, id)
    self["周期回调ID"] = id
end
_____6301_7EED_6761_4EF6_89E6_53D1_63A7_5236_5668_5B9E_73B0.prototype["刷新"] = function(self)
    if self["已停止"] then
        return self["当前持续毫秒"]
    end
    if self["参数"]["单位"] ~= nil and not _____5355_4F4D_6709_6548(self["参数"]["单位"]) then
        self["重置"](self, "单位失效")
        return 0
    end
    local now = getServerTime()
    local _____6EE1_8DB3_6761_4EF6 = self["参数"]["判断条件"]()
    if not _____6EE1_8DB3_6761_4EF6 then
        if self["当前持续毫秒"] > 0 and self["参数"]["on中断"] ~= nil then
            self["参数"]["on中断"](self["当前持续毫秒"])
        end
        if self["参数"]["脱离后重置"] ~= false then
            self["当前持续毫秒"] = 0
            self["上次开始毫秒"] = 0
            self["已触发"] = false
        end
        self["触发刷新"](self, false)
        return self["当前持续毫秒"]
    end
    if self["上次开始毫秒"] <= 0 then
        self["上次开始毫秒"] = now
    end
    self["当前持续毫秒"] = now - self["上次开始毫秒"]
    if not self["已触发"] and self["当前持续毫秒"] >= self["参数"]["需求持续毫秒"] then
        self["已触发"] = true
        if self["参数"]["on满足"] ~= nil then
            self["参数"]["on满足"](self["当前持续毫秒"])
        end
    end
    self["触发刷新"](self, true)
    return self["当前持续毫秒"]
end
_____6301_7EED_6761_4EF6_89E6_53D1_63A7_5236_5668_5B9E_73B0.prototype["读取当前持续毫秒"] = function(self)
    return self["当前持续毫秒"]
end
_____6301_7EED_6761_4EF6_89E6_53D1_63A7_5236_5668_5B9E_73B0.prototype["是否已触发"] = function(self)
    return self["已触发"]
end
_____6301_7EED_6761_4EF6_89E6_53D1_63A7_5236_5668_5B9E_73B0.prototype["重置"] = function(self, ______539F_56E0)
    if ______539F_56E0 == nil then
        ______539F_56E0 = "重置"
    end
    self["当前持续毫秒"] = 0
    self["上次开始毫秒"] = 0
    self["已触发"] = false
end
_____6301_7EED_6761_4EF6_89E6_53D1_63A7_5236_5668_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    if self["周期回调ID"] ~= 0 then
        removePeriodicCallback(self["周期回调ID"])
        self["周期回调ID"] = 0
    end
end
_____6301_7EED_6761_4EF6_89E6_53D1_63A7_5236_5668_5B9E_73B0.prototype["触发刷新"] = function(self, _____662F_5426_6EE1_8DB3_6761_4EF6)
    if self["参数"]["on刷新"] == nil then
        return
    end
    self["参数"]["on刷新"]({["当前持续毫秒"] = self["当前持续毫秒"], ["是否满足条件"] = _____662F_5426_6EE1_8DB3_6761_4EF6, ["是否已触发"] = self["已触发"]})
end
____exports["创建持续条件触发器"] = function(_____53C2_6570)
    local _____540D_79F0 = _____53C2_6570["名称"] or "持续条件触发器"
    local _____63A7_5236_5668 = __TS__New(_____6301_7EED_6761_4EF6_89E6_53D1_63A7_5236_5668_5B9E_73B0, _____540D_79F0, _____53C2_6570)
    _____63A7_5236_5668["刷新"](_____63A7_5236_5668)
    local _____95F4_9694 = _____53C2_6570["检查间隔毫秒"] or 100
    if _____95F4_9694 > 0 then
        local id = addPeriodicCallback(
            _____95F4_9694,
            function()
                _____63A7_5236_5668["刷新"](_____63A7_5236_5668)
            end
        )
        _____63A7_5236_5668["设置周期回调ID"](_____63A7_5236_5668, id)
        if _____53C2_6570["清理篮子"] ~= nil then
            if _____53C2_6570["清理篮子"]["登记周期回调"] ~= nil then
                local ____self_1 = _____53C2_6570["清理篮子"]
                ____self_1["登记周期回调"](____self_1, _____540D_79F0 .. "-周期刷新", id)
            else
                local ____self_2 = _____53C2_6570["清理篮子"]
                ____self_2["登记清理"](
                    ____self_2,
                    _____540D_79F0 .. "-停止",
                    function()
                        _____63A7_5236_5668["停止"](_____63A7_5236_5668)
                    end
                )
            end
        end
    end
    return _____63A7_5236_5668
end
return ____exports
