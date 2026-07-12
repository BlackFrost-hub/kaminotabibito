local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local _____6280_80FD_4E92_65A5_9501_5B9E_73B0 = __TS__Class()
_____6280_80FD_4E92_65A5_9501_5B9E_73B0.name = "技能互斥锁实现"
function _____6280_80FD_4E92_65A5_9501_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["占用表"] = {}
    self["名称"] = _____53C2_6570["名称"]
    self["取当前时间"] = _____53C2_6570["取当前时间"] or getServerTime
end
_____6280_80FD_4E92_65A5_9501_5B9E_73B0.prototype["尝试占用"] = function(self, _____4E92_65A5_7EC4, _____5360_7528_8005, _____6301_7EED_6BEB_79D2, nowMs)
    if _____4E92_65A5_7EC4 == "" or _____5360_7528_8005 == "" then
        return false
    end
    local now = nowMs == nil and self["取当前时间"]() or nowMs
    local _____5DF2_6709 = self["取占用信息"](self, _____4E92_65A5_7EC4, now)
    if _____5DF2_6709 ~= nil and _____5DF2_6709["占用者"] ~= _____5360_7528_8005 then
        return false
    end
    self["占用表"][_____4E92_65A5_7EC4] = {["互斥组"] = _____4E92_65A5_7EC4, ["占用者"] = _____5360_7528_8005, ["到期毫秒"] = _____6301_7EED_6BEB_79D2 > 0 and now + _____6301_7EED_6BEB_79D2 or now}
    return true
end
_____6280_80FD_4E92_65A5_9501_5B9E_73B0.prototype["释放"] = function(self, _____4E92_65A5_7EC4, _____5360_7528_8005)
    local _____5DF2_6709 = self["占用表"][_____4E92_65A5_7EC4]
    if _____5DF2_6709 == nil then
        return false
    end
    if _____5360_7528_8005 ~= nil and _____5360_7528_8005 ~= "" and _____5DF2_6709["占用者"] ~= _____5360_7528_8005 then
        return false
    end
    __TS__Delete(self["占用表"], _____4E92_65A5_7EC4)
    return true
end
_____6280_80FD_4E92_65A5_9501_5B9E_73B0.prototype["是否被占用"] = function(self, _____4E92_65A5_7EC4, nowMs)
    return self["取占用信息"](self, _____4E92_65A5_7EC4, nowMs) ~= nil
end
_____6280_80FD_4E92_65A5_9501_5B9E_73B0.prototype["取占用信息"] = function(self, _____4E92_65A5_7EC4, nowMs)
    local _____5DF2_6709 = self["占用表"][_____4E92_65A5_7EC4]
    if _____5DF2_6709 == nil then
        return nil
    end
    local now = nowMs == nil and self["取当前时间"]() or nowMs
    if _____5DF2_6709["到期毫秒"] <= now then
        __TS__Delete(self["占用表"], _____4E92_65A5_7EC4)
        return nil
    end
    return _____5DF2_6709
end
_____6280_80FD_4E92_65A5_9501_5B9E_73B0.prototype["清空"] = function(self)
    self["占用表"] = {}
end
____exports["创建技能互斥锁"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(_____6280_80FD_4E92_65A5_9501_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_1 = _____53C2_6570["清理"]
        ____self_1["登记清理"](
            ____self_1,
            _____53C2_6570["名称"] .. "-互斥锁",
            function()
                _____5B9E_4F8B["清空"](_____5B9E_4F8B)
            end
        )
    end
    return _____5B9E_4F8B
end
return ____exports
