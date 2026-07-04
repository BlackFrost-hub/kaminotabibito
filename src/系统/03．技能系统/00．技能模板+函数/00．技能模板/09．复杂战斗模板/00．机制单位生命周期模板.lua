local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D["创建可攻击机制单位"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
local _____673A_5236_5355_4F4D_751F_547D_5468_671F_5B9E_73B0 = __TS__Class()
_____673A_5236_5355_4F4D_751F_547D_5468_671F_5B9E_73B0.name = "机制单位生命周期实现"
function _____673A_5236_5355_4F4D_751F_547D_5468_671F_5B9E_73B0.prototype.____constructor(self, _____57FA_7840_5B9E_4F8B, _____53C2_6570)
    self["超时回调ID"] = 0
    self["已结束"] = false
    self["基础实例"] = _____57FA_7840_5B9E_4F8B
    self["单位"] = _____57FA_7840_5B9E_4F8B["单位"]
    self["参数"] = _____53C2_6570
    if _____53C2_6570["超时秒"] ~= nil and _____53C2_6570["超时秒"] > 0 then
        local ____self = self
        self["超时回调ID"] = addDelayedCallback(
            _____53C2_6570["超时秒"] * 1000,
            function()
                ____self["处理超时"](____self)
            end
        )
    end
end
_____673A_5236_5355_4F4D_751F_547D_5468_671F_5B9E_73B0.prototype["是否存活"] = function(self)
    return not self["已结束"] and self["基础实例"]["是否存活"]()
end
_____673A_5236_5355_4F4D_751F_547D_5468_671F_5B9E_73B0.prototype["销毁"] = function(self, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "手动销毁"
    end
    if self["已结束"] then
        return
    end
    self["结束"](self, _____539F_56E0)
    self["基础实例"]["销毁"]()
end
_____673A_5236_5355_4F4D_751F_547D_5468_671F_5B9E_73B0.prototype["处理死亡"] = function(self, _____51FB_6740_8005)
    if self["已结束"] then
        return
    end
    if self["参数"]["on被摧毁"] ~= nil then
        self["参数"]["on被摧毁"](self, _____51FB_6740_8005)
    end
    self["结束"](self, "被摧毁")
end
_____673A_5236_5355_4F4D_751F_547D_5468_671F_5B9E_73B0.prototype["处理超时"] = function(self)
    if self["已结束"] then
        return
    end
    if self["参数"]["on超时"] ~= nil then
        self["参数"]["on超时"](self)
    end
    if self["参数"]["超时后销毁"] ~= false then
        self["销毁"](self, "超时")
    else
        self["结束"](self, "超时")
    end
end
_____673A_5236_5355_4F4D_751F_547D_5468_671F_5B9E_73B0.prototype["结束"] = function(self, _____539F_56E0)
    if self["已结束"] then
        return
    end
    self["已结束"] = true
    if self["超时回调ID"] ~= 0 then
        removeDelayedCallback(self["超时回调ID"])
        self["超时回调ID"] = 0
    end
    if self["参数"]["on结束"] ~= nil then
        self["参数"]["on结束"](self, _____539F_56E0)
    end
end
____exports["创建机制单位生命周期"] = function(_____53C2_6570)
    local _____5B9E_4F8B
    local _____57FA_7840_5B9E_4F8B = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D(__TS__ObjectAssign(
        {},
        _____53C2_6570,
        {
            ["on死亡"] = function(_____5355_4F4D, _____51FB_6740_8005)
                if _____53C2_6570["on死亡"] ~= nil then
                    _____53C2_6570["on死亡"](_____5355_4F4D, _____51FB_6740_8005)
                end
                if _____5B9E_4F8B ~= nil then
                    _____5B9E_4F8B["处理死亡"](_____5B9E_4F8B, _____51FB_6740_8005)
                end
            end,
            ["on销毁"] = function(_____5355_4F4D)
                if _____53C2_6570["on销毁"] ~= nil then
                    _____53C2_6570["on销毁"](_____5355_4F4D)
                end
            end
        }
    ))
    if _____57FA_7840_5B9E_4F8B == nil then
        return nil
    end
    _____5B9E_4F8B = __TS__New(_____673A_5236_5355_4F4D_751F_547D_5468_671F_5B9E_73B0, _____57FA_7840_5B9E_4F8B, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_1 = _____53C2_6570["清理"]
        ____self_1["登记清理"](
            ____self_1,
            _____53C2_6570["名称"],
            function()
                if _____5B9E_4F8B ~= nil then
                    _____5B9E_4F8B["销毁"](_____5B9E_4F8B)
                end
            end
        )
    end
    if _____53C2_6570["on创建"] ~= nil then
        _____53C2_6570["on创建"](_____5B9E_4F8B)
    end
    return _____5B9E_4F8B
end
return ____exports
