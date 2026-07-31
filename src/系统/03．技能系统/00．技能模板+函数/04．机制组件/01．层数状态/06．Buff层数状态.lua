local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____01_FF0E_53EF_914D_7F6E_5C42_6570_72B6_6001 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.01．层数状态.01．可配置层数状态")
local _____521B_5EFA_53EF_914D_7F6E_5C42_6570_72B6_6001 = ____01_FF0E_53EF_914D_7F6E_5C42_6570_72B6_6001["创建可配置层数状态"]
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["移除单位指定Buff"]
local function _____53D6_6301_7EED_79D2(_____53C2_6570, _____5355_4F4D, _____5C42_6570)
    return type(_____53C2_6570["Buff持续秒"]) == "number" and _____53C2_6570["Buff持续秒"] or _____53C2_6570["Buff持续秒"](_____5355_4F4D, _____5C42_6570)
end
local function _____540C_6B65Buff(_____53C2_6570, _____5355_4F4D, _____5C42_6570)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    if _____5C42_6570 <= 0 then
        if _____53C2_6570["归零移除Buff"] ~= false then
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____5355_4F4D, _____53C2_6570.BuffID)
        end
        return
    end
    local duration = _____53D6_6301_7EED_79D2(_____53C2_6570, _____5355_4F4D, _____5C42_6570)
    if duration <= 0 then
        return
    end
    local effectValue = _____53C2_6570["取Buff显示值"] == nil and _____5C42_6570 or _____53C2_6570["取Buff显示值"](_____5355_4F4D, _____5C42_6570)
    local ____temp_1
    if _____53C2_6570["取Buff附加参数"] == nil then
        ____temp_1 = nil
    else
        ____temp_1 = _____53C2_6570["取Buff附加参数"](_____5355_4F4D, _____5C42_6570)
    end
    local extras = ____temp_1
    local buffExtras = extras == nil and ({stack = _____5C42_6570}) or __TS__ObjectAssign({}, extras, {stack = _____5C42_6570})
    registerManualBuff(
        _____5355_4F4D,
        _____53C2_6570.BuffID,
        duration,
        effectValue,
        buffExtras
    )
end
local ____Buff_5C42_6570_72B6_6001_5B9E_73B0 = __TS__Class()
____Buff_5C42_6570_72B6_6001_5B9E_73B0.name = "Buff层数状态实现"
function ____Buff_5C42_6570_72B6_6001_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["参数"] = _____53C2_6570
    local _____539F_59CB_5C42_6570_53D8_5316 = _____53C2_6570["层数配置"]["on层数变化"]
    self["配置"] = __TS__ObjectAssign(
        {},
        _____53C2_6570["层数配置"],
        {["on层数变化"] = function(_____4E8B_4EF6)
            if _____539F_59CB_5C42_6570_53D8_5316 ~= nil then
                _____539F_59CB_5C42_6570_53D8_5316(_____4E8B_4EF6)
            end
            _____540C_6B65Buff(_____53C2_6570, _____4E8B_4EF6["单位"], _____4E8B_4EF6["新层数"])
        end}
    )
    self["基础控制器"] = _____521B_5EFA_53EF_914D_7F6E_5C42_6570_72B6_6001(self["配置"])
end
____Buff_5C42_6570_72B6_6001_5B9E_73B0.prototype["增加"] = function(self, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
    if _____5C42_6570 == nil then
        _____5C42_6570 = 1
    end
    if _____539F_56E0 == nil then
        _____539F_56E0 = "增加"
    end
    return self["设置"](
        self,
        _____5355_4F4D,
        self["取层数"](self, _____5355_4F4D) + _____5C42_6570,
        _____539F_56E0
    )
end
____Buff_5C42_6570_72B6_6001_5B9E_73B0.prototype["设置"] = function(self, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "设置"
    end
    local ____self_2 = self["基础控制器"]
    local old = ____self_2["取层数"](____self_2, _____5355_4F4D)
    local ____self_3 = self["基础控制器"]
    local next = ____self_3["设置"](____self_3, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
    if old == next and next > 0 then
        _____540C_6B65Buff(self["参数"], _____5355_4F4D, next)
    end
    return next
end
____Buff_5C42_6570_72B6_6001_5B9E_73B0.prototype["减少"] = function(self, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
    if _____5C42_6570 == nil then
        _____5C42_6570 = 1
    end
    if _____539F_56E0 == nil then
        _____539F_56E0 = "减少"
    end
    return self["设置"](
        self,
        _____5355_4F4D,
        self["取层数"](self, _____5355_4F4D) - _____5C42_6570,
        _____539F_56E0
    )
end
____Buff_5C42_6570_72B6_6001_5B9E_73B0.prototype["清空"] = function(self, _____5355_4F4D, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "清空"
    end
    local ____self_4 = self["基础控制器"]
    ____self_4["清空"](____self_4, _____5355_4F4D, _____539F_56E0)
end
____Buff_5C42_6570_72B6_6001_5B9E_73B0.prototype["取层数"] = function(self, _____5355_4F4D)
    local ____self_5 = self["基础控制器"]
    return ____self_5["取层数"](____self_5, _____5355_4F4D)
end
____Buff_5C42_6570_72B6_6001_5B9E_73B0.prototype["刷新Buff"] = function(self, _____5355_4F4D)
    local ____540C_6B65Buff_9 = _____540C_6B65Buff
    local ____self__53C2_6570_7 = self["参数"]
    local ____5355_4F4D_8 = _____5355_4F4D
    local ____self_6 = self["基础控制器"]
    ____540C_6B65Buff_9(
        ____self__53C2_6570_7,
        ____5355_4F4D_8,
        ____self_6["取层数"](____self_6, _____5355_4F4D)
    )
end
____Buff_5C42_6570_72B6_6001_5B9E_73B0.prototype["销毁"] = function(self)
    local ____self_10 = self["基础控制器"]
    ____self_10["销毁"](____self_10)
end
____exports["创建Buff层数状态"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(____Buff_5C42_6570_72B6_6001_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_11 = _____53C2_6570["清理"]
        ____self_11["登记清理"](
            ____self_11,
            _____53C2_6570["名称"] .. "-Buff层数状态",
            function()
                _____5B9E_4F8B["销毁"](_____5B9E_4F8B)
            end
        )
    end
    return _____5B9E_4F8B
end
return ____exports
