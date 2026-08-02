local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local function ____on_9650_6B21_5468_671F_6267_884C_5668Tick(variable)
    local _____5B9E_4F8B = variable
    if _____5B9E_4F8B ~= nil then
        _____5B9E_4F8B["执行Tick"](_____5B9E_4F8B)
    end
end
local function ____on_5468_671F_884C_4E3ATick(variable)
    local _____5B9E_4F8B = variable
    if _____5B9E_4F8B ~= nil then
        _____5B9E_4F8B["执行Tick"](_____5B9E_4F8B)
    end
end
local _____9650_6B21_5468_671F_6267_884C_5668_5B9E_73B0 = __TS__Class()
_____9650_6B21_5468_671F_6267_884C_5668_5B9E_73B0.name = "限次周期执行器实现"
function _____9650_6B21_5468_671F_6267_884C_5668_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["回调ID"] = 0
    self["执行次数"] = 0
    self["参数"] = _____53C2_6570
    self["最大执行次数"] = _____53C2_6570["最大执行次数"] > 0 and _____53C2_6570["最大执行次数"] or 0
    if self["最大执行次数"] > 0 and _____53C2_6570["间隔毫秒"] > 0 then
        self["回调ID"] = addPeriodicCallback(_____53C2_6570["间隔毫秒"], ____on_9650_6B21_5468_671F_6267_884C_5668Tick, self)
    end
end
_____9650_6B21_5468_671F_6267_884C_5668_5B9E_73B0.prototype["停止"] = function(self)
    if self["回调ID"] == 0 then
        return
    end
    removePeriodicCallback(self["回调ID"])
    self["回调ID"] = 0
end
_____9650_6B21_5468_671F_6267_884C_5668_5B9E_73B0.prototype["是否运行中"] = function(self)
    return self["回调ID"] ~= 0
end
_____9650_6B21_5468_671F_6267_884C_5668_5B9E_73B0.prototype["读取执行次数"] = function(self)
    return self["执行次数"]
end
_____9650_6B21_5468_671F_6267_884C_5668_5B9E_73B0.prototype["执行Tick"] = function(self)
    if self["回调ID"] == 0 or self["执行次数"] >= self["最大执行次数"] then
        self["停止"](self)
        return
    end
    self["执行次数"] = self["执行次数"] + 1
    local _____7EE7_7EED_6267_884C = self["参数"].onTick(self["执行次数"], self["参数"]["变量"])
    if _____7EE7_7EED_6267_884C == false or self["执行次数"] >= self["最大执行次数"] then
        self["停止"](self)
    end
end
local _____5468_671F_884C_4E3A_5B9E_73B0 = __TS__Class()
_____5468_671F_884C_4E3A_5B9E_73B0.name = "周期行为实现"
function _____5468_671F_884C_4E3A_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["回调ID"] = 0
    self["执行次数"] = 0
    self["参数"] = _____53C2_6570
    if _____53C2_6570["间隔毫秒"] > 0 then
        self["回调ID"] = addPeriodicCallback(_____53C2_6570["间隔毫秒"], ____on_5468_671F_884C_4E3ATick, self)
    end
end
_____5468_671F_884C_4E3A_5B9E_73B0.prototype["停止"] = function(self)
    if self["回调ID"] == 0 then
        return
    end
    removePeriodicCallback(self["回调ID"])
    self["回调ID"] = 0
end
_____5468_671F_884C_4E3A_5B9E_73B0.prototype["是否运行中"] = function(self)
    return self["回调ID"] ~= 0
end
_____5468_671F_884C_4E3A_5B9E_73B0.prototype["读取执行次数"] = function(self)
    return self["执行次数"]
end
_____5468_671F_884C_4E3A_5B9E_73B0.prototype["执行Tick"] = function(self)
    if self["回调ID"] == 0 then
        return
    end
    self["执行次数"] = self["执行次数"] + 1
    if self["参数"].onTick(self["执行次数"], self["参数"]["变量"]) == false then
        self["停止"](self)
    end
end
____exports["创建限次周期执行器"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(_____9650_6B21_5468_671F_6267_884C_5668_5B9E_73B0, _____53C2_6570)
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
    return _____5B9E_4F8B
end
____exports["创建周期行为"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(_____5468_671F_884C_4E3A_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_2 = _____53C2_6570["清理"]
        ____self_2["登记清理"](
            ____self_2,
            _____53C2_6570["名称"],
            function()
                _____5B9E_4F8B["停止"](_____5B9E_4F8B)
            end
        )
    end
    return _____5B9E_4F8B
end
return ____exports
