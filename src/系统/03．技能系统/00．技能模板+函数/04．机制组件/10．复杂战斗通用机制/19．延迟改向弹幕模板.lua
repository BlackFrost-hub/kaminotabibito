local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____03_FF0E_5BF9_5916_63A5_53E3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____03_FF0E_5BF9_5916_63A5_53E3["创建原生弹幕"]
local ____00_FF0E_5F39_5E55_6539_5411 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.06．改向与反弹.00．弹幕改向")
local _____8BBE_7F6E_539F_751F_5F39_5E55_6307_5B9A_89D2_5EA6_98DE_884C = ____00_FF0E_5F39_5E55_6539_5411["设置原生弹幕指定角度飞行"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
local function _____53D6_5EF6_8FDF_6BEB_79D2(_____53C2_6570)
    if _____53C2_6570["改向延迟毫秒"] ~= nil then
        return _____53C2_6570["改向延迟毫秒"]
    end
    return (_____53C2_6570["改向延迟秒"] or 0) * 1000
end
local function ____on_5EF6_8FDF_6539_5411_5F39_5E55(variable)
    local _____5B9E_4F8B = variable
    if _____5B9E_4F8B ~= nil then
        _____5B9E_4F8B["立即改向"](_____5B9E_4F8B)
    end
end
local _____5EF6_8FDF_6539_5411_5F39_5E55_5B9E_73B0 = __TS__Class()
_____5EF6_8FDF_6539_5411_5F39_5E55_5B9E_73B0.name = "延迟改向弹幕实现"
function _____5EF6_8FDF_6539_5411_5F39_5E55_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["延迟回调ID"] = 0
    self["已改向"] = false
    self["已取消"] = false
    self["参数"] = _____53C2_6570
    self["弹幕"] = _____521B_5EFA_539F_751F_5F39_5E55(_____53C2_6570["弹幕"])
    self["弹幕ID"] = self["弹幕"]["弹幕ID"]
    self["弹幕单位"] = self["弹幕"]["弹幕单位"]
    if _____53C2_6570["on创建"] ~= nil then
        _____53C2_6570["on创建"](self["创建上下文"](self))
    end
    if _____53C2_6570["自动改向"] ~= false then
        self["安排改向"](self)
    end
end
_____5EF6_8FDF_6539_5411_5F39_5E55_5B9E_73B0.prototype["取消延迟改向"] = function(self)
    if self["延迟回调ID"] ~= 0 then
        removeDelayedCallback(self["延迟回调ID"])
        self["延迟回调ID"] = 0
    end
    self["已取消"] = true
end
_____5EF6_8FDF_6539_5411_5F39_5E55_5B9E_73B0.prototype["立即改向"] = function(self)
    if self["已取消"] or self["已改向"] then
        return false
    end
    self["延迟回调ID"] = 0
    local _____4E0A_4E0B_6587 = self["创建上下文"](self)
    local angle = self["参数"]["取改向角度"] ~= nil and self["参数"]["取改向角度"](_____4E0A_4E0B_6587) or self["参数"]["改向角度"]
    if angle == nil then
        if self["参数"]["on改向失败"] ~= nil then
            self["参数"]["on改向失败"](_____4E0A_4E0B_6587)
        end
        return false
    end
    local speed = self["参数"]["取新速度"] ~= nil and self["参数"]["取新速度"](_____4E0A_4E0B_6587) or self["参数"]["新速度"]
    local ok = _____8BBE_7F6E_539F_751F_5F39_5E55_6307_5B9A_89D2_5EA6_98DE_884C(self["弹幕ID"], angle, speed)
    if ok then
        self["已改向"] = true
        if self["参数"]["on改向"] ~= nil then
            self["参数"]["on改向"](_____4E0A_4E0B_6587)
        end
    elseif self["参数"]["on改向失败"] ~= nil then
        self["参数"]["on改向失败"](_____4E0A_4E0B_6587)
    end
    return ok
end
_____5EF6_8FDF_6539_5411_5F39_5E55_5B9E_73B0.prototype["销毁弹幕"] = function(self)
    self["取消延迟改向"](self)
    self["弹幕"]["销毁"]("手动销毁")
end
_____5EF6_8FDF_6539_5411_5F39_5E55_5B9E_73B0.prototype["安排改向"] = function(self)
    local delay = _____53D6_5EF6_8FDF_6BEB_79D2(self["参数"])
    if delay <= 0 then
        self["立即改向"](self)
        return
    end
    self["延迟回调ID"] = addDelayedCallback(delay, ____on_5EF6_8FDF_6539_5411_5F39_5E55, self)
    if self["参数"]["清理"] ~= nil then
        local ____self_1 = self["参数"]["清理"]
        ____self_1["登记延迟回调"](____self_1, self["参数"]["名称"] or "延迟改向弹幕", self["延迟回调ID"])
    end
end
_____5EF6_8FDF_6539_5411_5F39_5E55_5B9E_73B0.prototype["创建上下文"] = function(self)
    return {["实例"] = self, ["弹幕"] = self["弹幕"], ["弹幕ID"] = self["弹幕ID"], ["弹幕单位"] = self["弹幕单位"]}
end
____exports["创建延迟改向弹幕"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(_____5EF6_8FDF_6539_5411_5F39_5E55_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil and _____53C2_6570["清理时销毁弹幕"] == true then
        local ____self_2 = _____53C2_6570["清理"]
        ____self_2["登记清理"](
            ____self_2,
            _____53C2_6570["名称"] or "延迟改向弹幕",
            function()
                _____5B9E_4F8B["销毁弹幕"](_____5B9E_4F8B)
            end
        )
    end
    return _____5B9E_4F8B
end
____exports["创建Boss延迟改向弹幕"] = function(_____53C2_6570)
    return ____exports["创建延迟改向弹幕"](_____53C2_6570)
end
return ____exports
