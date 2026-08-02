local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local getServerTime = ____require_result_0.getServerTime
local _____4E2D_5FC3_8BA1_65F6_5668_6700_5C0F_5468_671F_6BEB_79D2 = 10
local function ____on_5468_671F_673A_5236_8C03_5EA6_5668Tick(variable)
    local _____5B9E_4F8B = variable
    if _____5B9E_4F8B ~= nil then
        _____5B9E_4F8B["执行Tick"](_____5B9E_4F8B)
    end
end
local function ____on_81EA_9002_5E94_5171_4EAB_5468_671F_9A71_52A8Tick(variable)
    local _____5B9E_4F8B = variable
    if _____5B9E_4F8B ~= nil then
        _____5B9E_4F8B["执行Tick"](_____5B9E_4F8B)
    end
end
local _____5468_671F_673A_5236_8C03_5EA6_5668_5B9E_73B0 = __TS__Class()
_____5468_671F_673A_5236_8C03_5EA6_5668_5B9E_73B0.name = "周期机制调度器实现"
function _____5468_671F_673A_5236_8C03_5EA6_5668_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["回调ID"] = 0
    self["参数"] = _____53C2_6570
end
_____5468_671F_673A_5236_8C03_5EA6_5668_5B9E_73B0.prototype["启动"] = function(self)
    if self["回调ID"] ~= 0 then
        return
    end
    self["回调ID"] = addPeriodicCallback(self["参数"]["间隔毫秒"], ____on_5468_671F_673A_5236_8C03_5EA6_5668Tick, self)
end
_____5468_671F_673A_5236_8C03_5EA6_5668_5B9E_73B0.prototype["停止"] = function(self)
    if self["回调ID"] == 0 then
        return
    end
    removePeriodicCallback(self["回调ID"])
    self["回调ID"] = 0
end
_____5468_671F_673A_5236_8C03_5EA6_5668_5B9E_73B0.prototype["是否运行中"] = function(self)
    return self["回调ID"] ~= 0
end
_____5468_671F_673A_5236_8C03_5EA6_5668_5B9E_73B0.prototype["执行Tick"] = function(self)
    local nowMs = self["参数"]["取当前时间"] ~= nil and self["参数"]["取当前时间"]() or 0
    local contexts = self["参数"]["取上下文列表"]()
    do
        local i = 0
        while i < #contexts do
            do
                local context = contexts[i + 1]
                if context == nil then
                    goto __continue14
                end
                if self["参数"]["可执行"] ~= nil and not self["参数"]["可执行"](context, nowMs) then
                    goto __continue14
                end
                self["参数"]["执行"](context, nowMs)
            end
            ::__continue14::
            i = i + 1
        end
    end
end
local _____81EA_9002_5E94_5171_4EAB_5468_671F_9A71_52A8_5B9E_73B0 = __TS__Class()
_____81EA_9002_5E94_5171_4EAB_5468_671F_9A71_52A8_5B9E_73B0.name = "自适应共享周期驱动实现"
function _____81EA_9002_5E94_5171_4EAB_5468_671F_9A71_52A8_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["回调ID"] = 0
    self["当前检查间隔毫秒"] = 0
    self["参数"] = _____53C2_6570
end
_____81EA_9002_5E94_5171_4EAB_5468_671F_9A71_52A8_5B9E_73B0.prototype["刷新"] = function(self)
    local _____5EFA_8BAE_95F4_9694 = self["参数"]["取建议检查间隔毫秒"](getServerTime())
    if not (_____5EFA_8BAE_95F4_9694 > 0) then
        self["停止"](self)
        return
    end
    local _____6700_5927_95F4_9694 = self["参数"]["最大检查间隔毫秒"]
    if _____6700_5927_95F4_9694 < _____4E2D_5FC3_8BA1_65F6_5668_6700_5C0F_5468_671F_6BEB_79D2 then
        _____6700_5927_95F4_9694 = _____4E2D_5FC3_8BA1_65F6_5668_6700_5C0F_5468_671F_6BEB_79D2
    end
    local _____65B0_95F4_9694 = _____5EFA_8BAE_95F4_9694 < _____6700_5927_95F4_9694 and _____5EFA_8BAE_95F4_9694 or _____6700_5927_95F4_9694
    if _____65B0_95F4_9694 < _____4E2D_5FC3_8BA1_65F6_5668_6700_5C0F_5468_671F_6BEB_79D2 then
        _____65B0_95F4_9694 = _____4E2D_5FC3_8BA1_65F6_5668_6700_5C0F_5468_671F_6BEB_79D2
    end
    if self["回调ID"] ~= 0 and self["当前检查间隔毫秒"] == _____65B0_95F4_9694 then
        return
    end
    if self["回调ID"] ~= 0 then
        removePeriodicCallback(self["回调ID"])
    end
    self["当前检查间隔毫秒"] = _____65B0_95F4_9694
    self["回调ID"] = addPeriodicCallback(_____65B0_95F4_9694, ____on_81EA_9002_5E94_5171_4EAB_5468_671F_9A71_52A8Tick, self)
end
_____81EA_9002_5E94_5171_4EAB_5468_671F_9A71_52A8_5B9E_73B0.prototype["停止"] = function(self)
    if self["回调ID"] ~= 0 then
        removePeriodicCallback(self["回调ID"])
    end
    self["回调ID"] = 0
    self["当前检查间隔毫秒"] = 0
end
_____81EA_9002_5E94_5171_4EAB_5468_671F_9A71_52A8_5B9E_73B0.prototype["是否运行中"] = function(self)
    return self["回调ID"] ~= 0
end
_____81EA_9002_5E94_5171_4EAB_5468_671F_9A71_52A8_5B9E_73B0.prototype["读取当前检查间隔毫秒"] = function(self)
    return self["当前检查间隔毫秒"]
end
_____81EA_9002_5E94_5171_4EAB_5468_671F_9A71_52A8_5B9E_73B0.prototype["执行Tick"] = function(self)
    if self["回调ID"] == 0 then
        return
    end
    self["参数"].onTick(getServerTime())
    self["刷新"](self)
end
____exports["创建周期机制调度器"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(_____5468_671F_673A_5236_8C03_5EA6_5668_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_1 = _____53C2_6570["清理"]
        ____self_1["登记清理"](
            ____self_1,
            _____53C2_6570["名称"],
            function()
                _____5B9E_4F8B["停止"](_____5B9E_4F8B)
            end
        )
    end
    if _____53C2_6570["自动启动"] ~= false then
        _____5B9E_4F8B["启动"](_____5B9E_4F8B)
    end
    return _____5B9E_4F8B
end
____exports["创建自适应共享周期驱动"] = function(_____53C2_6570)
    return __TS__New(_____81EA_9002_5E94_5171_4EAB_5468_671F_9A71_52A8_5B9E_73B0, _____53C2_6570)
end
return ____exports
