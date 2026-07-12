local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
local getServerTime = ____require_result_0.getServerTime
local function ____on_53EF_62A2_5360_72B6_6001_5230_671F(variable)
    local data = variable
    if data == nil then
        return
    end
    local ____self_1 = data["管理器"]
    ____self_1["结束"](____self_1, data.token, "完成")
end
local _____53EF_62A2_5360_72EC_5360_72B6_6001_5B9E_73B0 = __TS__Class()
_____53EF_62A2_5360_72EC_5360_72B6_6001_5B9E_73B0.name = "可抢占独占状态实现"
function _____53EF_62A2_5360_72EC_5360_72B6_6001_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["下一个Token"] = 0
    self["名称"] = _____53C2_6570["名称"]
    self["取当前时间"] = _____53C2_6570["取当前时间"] or getServerTime
end
_____53EF_62A2_5360_72EC_5360_72B6_6001_5B9E_73B0.prototype["可开始"] = function(self, key, _____4F18_5148_7EA7, nowMs)
    local _____5F53_524D = self["取当前"](self, nowMs)
    if _____5F53_524D == nil or _____5F53_524D.key == key then
        return true
    end
    return _____5F53_524D["可被抢占"] and _____4F18_5148_7EA7 > _____5F53_524D["优先级"]
end
_____53EF_62A2_5360_72EC_5360_72B6_6001_5B9E_73B0.prototype["开始"] = function(self, _____8BF7_6C42, nowMs)
    if _____8BF7_6C42.key == "" then
        return 0
    end
    local now = nowMs == nil and self["取当前时间"]() or nowMs
    if not self["可开始"](self, _____8BF7_6C42.key, _____8BF7_6C42["优先级"], now) then
        return 0
    end
    local old = self["当前"]
    if old ~= nil then
        self["结束"](self, old.token, old.key == _____8BF7_6C42.key and "取消" or "抢占", _____8BF7_6C42.key)
    end
    local ____self_2, _____4E0B_4E00_4E2AToken_3 = self, "下一个Token"
    local ____self__4E0B_4E00_4E2AToken_4 = ____self_2[_____4E0B_4E00_4E2AToken_3] + 1
    ____self_2[_____4E0B_4E00_4E2AToken_3] = ____self__4E0B_4E00_4E2AToken_4
    local token = ____self__4E0B_4E00_4E2AToken_4
    if _____8BF7_6C42["持续毫秒"] <= 0 then
        if _____8BF7_6C42["on结束"] ~= nil then
            _____8BF7_6C42["on结束"]({
                token = token,
                key = _____8BF7_6C42.key,
                ["优先级"] = _____8BF7_6C42["优先级"],
                ["原因"] = "完成",
                ["数据"] = _____8BF7_6C42["数据"]
            })
        end
        return token
    end
    local runtime = {
        token = token,
        key = _____8BF7_6C42.key,
        ["优先级"] = _____8BF7_6C42["优先级"],
        ["开始毫秒"] = now,
        ["到期毫秒"] = now + _____8BF7_6C42["持续毫秒"],
        ["可被抢占"] = _____8BF7_6C42["可被抢占"] == true,
        ["数据"] = _____8BF7_6C42["数据"],
        ["到期回调ID"] = 0,
        ["on结束"] = _____8BF7_6C42["on结束"]
    }
    runtime["到期回调ID"] = addDelayedCallback(_____8BF7_6C42["持续毫秒"], ____on_53EF_62A2_5360_72B6_6001_5230_671F, {["管理器"] = self, token = token})
    self["当前"] = runtime
    return token
end
_____53EF_62A2_5360_72EC_5360_72B6_6001_5B9E_73B0.prototype["结束"] = function(self, token, _____539F_56E0, _____88AB_8C01_7ED3_675F)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "取消"
    end
    local _____5F53_524D = self["当前"]
    if _____5F53_524D == nil or _____5F53_524D.token ~= token then
        return false
    end
    self["当前"] = nil
    if _____5F53_524D["到期回调ID"] ~= 0 then
        removeDelayedCallback(_____5F53_524D["到期回调ID"])
    end
    if _____5F53_524D["on结束"] ~= nil then
        _____5F53_524D["on结束"]({
            token = _____5F53_524D.token,
            key = _____5F53_524D.key,
            ["优先级"] = _____5F53_524D["优先级"],
            ["原因"] = _____539F_56E0,
            ["被谁结束"] = _____88AB_8C01_7ED3_675F,
            ["数据"] = _____5F53_524D["数据"]
        })
    end
    return true
end
_____53EF_62A2_5360_72EC_5360_72B6_6001_5B9E_73B0.prototype["取消当前"] = function(self, _____539F_56E0, _____88AB_8C01_7ED3_675F)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "取消"
    end
    local _____5F53_524D = self["当前"]
    if _____5F53_524D == nil then
        return false
    end
    return self["结束"](self, _____5F53_524D.token, _____539F_56E0, _____88AB_8C01_7ED3_675F)
end
_____53EF_62A2_5360_72EC_5360_72B6_6001_5B9E_73B0.prototype["取当前"] = function(self, nowMs)
    local _____5F53_524D = self["当前"]
    if _____5F53_524D == nil then
        return nil
    end
    local now = nowMs == nil and self["取当前时间"]() or nowMs
    if _____5F53_524D["到期毫秒"] <= now then
        self["结束"](self, _____5F53_524D.token, "完成")
        return nil
    end
    return _____5F53_524D
end
_____53EF_62A2_5360_72EC_5360_72B6_6001_5B9E_73B0.prototype["是否运行中"] = function(self, nowMs)
    return self["取当前"](self, nowMs) ~= nil
end
_____53EF_62A2_5360_72EC_5360_72B6_6001_5B9E_73B0.prototype["清空"] = function(self)
    self["取消当前"](self, "清理")
end
____exports["创建可抢占独占状态管理器"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(_____53EF_62A2_5360_72EC_5360_72B6_6001_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_5 = _____53C2_6570["清理"]
        ____self_5["登记清理"](
            ____self_5,
            _____53C2_6570["名称"] .. "-可抢占状态",
            function()
                _____5B9E_4F8B["清空"](_____5B9E_4F8B)
            end
        )
    end
    return _____5B9E_4F8B
end
return ____exports
