local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local function ____onBoss_5468_671F_673A_5236_8C03_5EA6_5668Tick(variable)
    local _____5B9E_4F8B = variable
    if _____5B9E_4F8B ~= nil then
        _____5B9E_4F8B["执行Tick"](_____5B9E_4F8B)
    end
end
local ____Boss_5468_671F_673A_5236_8C03_5EA6_5668_5B9E_73B0 = __TS__Class()
____Boss_5468_671F_673A_5236_8C03_5EA6_5668_5B9E_73B0.name = "Boss周期机制调度器实现"
function ____Boss_5468_671F_673A_5236_8C03_5EA6_5668_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["回调ID"] = 0
    self["参数"] = _____53C2_6570
end
____Boss_5468_671F_673A_5236_8C03_5EA6_5668_5B9E_73B0.prototype["启动"] = function(self)
    if self["回调ID"] ~= 0 then
        return
    end
    self["回调ID"] = addPeriodicCallback(self["参数"]["间隔毫秒"], ____onBoss_5468_671F_673A_5236_8C03_5EA6_5668Tick, self)
end
____Boss_5468_671F_673A_5236_8C03_5EA6_5668_5B9E_73B0.prototype["停止"] = function(self)
    if self["回调ID"] == 0 then
        return
    end
    removePeriodicCallback(self["回调ID"])
    self["回调ID"] = 0
end
____Boss_5468_671F_673A_5236_8C03_5EA6_5668_5B9E_73B0.prototype["是否运行中"] = function(self)
    return self["回调ID"] ~= 0
end
____Boss_5468_671F_673A_5236_8C03_5EA6_5668_5B9E_73B0.prototype["执行Tick"] = function(self)
    local nowMs = self["参数"]["取当前时间"] ~= nil and self["参数"]["取当前时间"]() or 0
    local contexts = self["参数"]["取上下文列表"]()
    do
        local i = 0
        while i < #contexts do
            do
                local context = contexts[i + 1]
                if context == nil then
                    goto __continue12
                end
                if self["参数"]["可执行"] ~= nil and not self["参数"]["可执行"](context, nowMs) then
                    goto __continue12
                end
                self["参数"]["执行"](context, nowMs)
            end
            ::__continue12::
            i = i + 1
        end
    end
end
____exports["创建Boss周期机制调度器"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(____Boss_5468_671F_673A_5236_8C03_5EA6_5668_5B9E_73B0, _____53C2_6570)
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
return ____exports
