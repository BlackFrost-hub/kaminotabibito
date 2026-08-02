local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____on_81F4_547D_4F24_5BB3_514D_75AB_5230_671F
local ____08_FF0E_6B21_6570_578B_4F24_5BB3_514D_75AB = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.08．次数型伤害免疫")
local _____521B_5EFA_6B21_6570_578B_4F24_5BB3_514D_75AB = ____08_FF0E_6B21_6570_578B_4F24_5BB3_514D_75AB["创建次数型伤害免疫"]
local ____09_FF0E_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.09．伤害生命下限保护")
local _____521B_5EFA_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4 = ____09_FF0E_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4["创建伤害生命下限保护"]
function ____on_81F4_547D_4F24_5BB3_514D_75AB_5230_671F(variable)
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil or _____53C2_6570["控制器"] == nil then
        return
    end
    local ____self_6 = _____53C2_6570["控制器"]
    ____self_6["处理免疫到期"](____self_6, _____53C2_6570["截止时间Ms"])
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
local getServerTime = ____require_result_0.getServerTime
local jass = require("jass.common")
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local _____81F4_547D_4F24_5BB3_4FDD_547D_4E0E_9650_65F6_514D_75AB_5B9E_73B0 = __TS__Class()
_____81F4_547D_4F24_5BB3_4FDD_547D_4E0E_9650_65F6_514D_75AB_5B9E_73B0.name = "致命伤害保命与限时免疫实现"
function _____81F4_547D_4F24_5BB3_4FDD_547D_4E0E_9650_65F6_514D_75AB_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["免疫截止时间Ms"] = 0
    self["免疫结束回调ID"] = 0
    self["已停止"] = false
    self["参数"] = _____53C2_6570
    self["名称"] = _____53C2_6570["名称"] or "致命伤害保命与限时免疫"
    local ____self = self
    local _____751F_547D_4E0B_9650_4F18_5148_7EA7 = _____53C2_6570["生命下限修正优先级"] or -100
    self["伤害免疫"] = _____521B_5EFA_6B21_6570_578B_4F24_5BB3_514D_75AB({
        ["名称"] = self["名称"] .. "-限时免疫",
        ["单位"] = _____53C2_6570["单位"],
        ["免疫类型"] = "任意伤害",
        ["无限次数"] = true,
        ["永久"] = true,
        ["修正优先级"] = _____53C2_6570["免疫修正优先级"] or _____751F_547D_4E0B_9650_4F18_5148_7EA7 + 1,
        ["过滤伤害"] = function(context)
            if not ____self["是否免疫中"](____self) then
                return false
            end
            return _____53C2_6570["过滤免疫伤害"] == nil or _____53C2_6570["过滤免疫伤害"](context)
        end,
        ["on抵挡"] = function(event)
            if _____53C2_6570["on免疫抵挡"] ~= nil then
                _____53C2_6570["on免疫抵挡"](event)
            end
        end
    })
    local _____9ED8_8BA4_56FA_5B9A_4E0B_9650 = _____53C2_6570["固定生命下限"] == nil and _____53C2_6570["最大生命比例下限"] == nil and _____53C2_6570["取生命下限"] == nil and 1 or _____53C2_6570["固定生命下限"]
    self["生命下限保护"] = _____521B_5EFA_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4({
        ["名称"] = self["名称"] .. "-生命下限",
        ["单位"] = _____53C2_6570["单位"],
        ["固定生命下限"] = _____9ED8_8BA4_56FA_5B9A_4E0B_9650,
        ["最大生命比例下限"] = _____53C2_6570["最大生命比例下限"],
        ["修正优先级"] = _____751F_547D_4E0B_9650_4F18_5148_7EA7,
        ["离开下限后重置触底"] = true,
        ["过滤伤害"] = _____53C2_6570["过滤致命伤害"],
        ["取生命下限"] = _____53C2_6570["取生命下限"],
        ["伤害预处理"] = function(context, _____5F53_524D_4F24_5BB3)
            return ____self["处理致命伤害"](____self, context, _____5F53_524D_4F24_5BB3)
        end
    })
    if _____53C2_6570["清理"] ~= nil then
        local ____self_1 = _____53C2_6570["清理"]
        ____self_1["登记清理"](
            ____self_1,
            self["名称"] .. "-清理",
            function()
                ____self["停止"](____self)
            end
        )
    end
end
_____81F4_547D_4F24_5BB3_4FDD_547D_4E0E_9650_65F6_514D_75AB_5B9E_73B0.prototype["是否生效"] = function(self)
    return not self["已停止"]
end
_____81F4_547D_4F24_5BB3_4FDD_547D_4E0E_9650_65F6_514D_75AB_5B9E_73B0.prototype["是否免疫中"] = function(self)
    return not self["已停止"] and self["免疫截止时间Ms"] > getServerTime()
end
_____81F4_547D_4F24_5BB3_4FDD_547D_4E0E_9650_65F6_514D_75AB_5B9E_73B0.prototype["读取生命下限"] = function(self)
    local ____self_2 = self["生命下限保护"]
    return ____self_2["读取生命下限"](____self_2)
end
_____81F4_547D_4F24_5BB3_4FDD_547D_4E0E_9650_65F6_514D_75AB_5B9E_73B0.prototype["读取免疫剩余毫秒"] = function(self)
    if not self["是否免疫中"](self) then
        return 0
    end
    local _____5269_4F59 = self["免疫截止时间Ms"] - getServerTime()
    return _____5269_4F59 > 0 and _____5269_4F59 or 0
end
_____81F4_547D_4F24_5BB3_4FDD_547D_4E0E_9650_65F6_514D_75AB_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    self["清除免疫结束回调"](self)
    self["免疫截止时间Ms"] = 0
    local ____self_3 = self["生命下限保护"]
    ____self_3["停止"](____self_3)
    local ____self_4 = self["伤害免疫"]
    ____self_4["取消"](____self_4, "清理")
end
_____81F4_547D_4F24_5BB3_4FDD_547D_4E0E_9650_65F6_514D_75AB_5B9E_73B0.prototype["处理免疫到期"] = function(self, _____622A_6B62_65F6_95F4Ms)
    if self["已停止"] or self["免疫截止时间Ms"] ~= _____622A_6B62_65F6_95F4Ms then
        return
    end
    self["免疫结束回调ID"] = 0
    self["免疫截止时间Ms"] = 0
    if self["参数"]["on免疫结束"] ~= nil then
        self["参数"]["on免疫结束"](self["参数"]["单位"])
    end
end
_____81F4_547D_4F24_5BB3_4FDD_547D_4E0E_9650_65F6_514D_75AB_5B9E_73B0.prototype["处理致命伤害"] = function(self, context, _____5F53_524D_4F24_5BB3)
    if self["已停止"] or not (_____5F53_524D_4F24_5BB3 > 0) then
        return _____5F53_524D_4F24_5BB3
    end
    local _____5F53_524D_751F_547D = GetUnitState(self["参数"]["单位"], UNIT_STATE_LIFE)
    if not (_____5F53_524D_751F_547D > 0) or _____5F53_524D_4F24_5BB3 < _____5F53_524D_751F_547D then
        return _____5F53_524D_4F24_5BB3
    end
    local ____self_5 = self["生命下限保护"]
    local _____4FDD_7559_751F_547D = ____self_5["读取生命下限"](____self_5)
    if _____4FDD_7559_751F_547D < 0 then
        _____4FDD_7559_751F_547D = 0
    end
    if _____4FDD_7559_751F_547D > _____5F53_524D_751F_547D then
        _____4FDD_7559_751F_547D = _____5F53_524D_751F_547D
    end
    SetUnitState(self["参数"]["单位"], UNIT_STATE_LIFE, _____4FDD_7559_751F_547D)
    self["启动限时免疫"](self)
    if self["参数"]["on触发"] ~= nil then
        self["参数"]["on触发"]({
            ["单位"] = self["参数"]["单位"],
            ["攻击者"] = context.attacker,
            ["触发前生命"] = _____5F53_524D_751F_547D,
            ["保留生命"] = _____4FDD_7559_751F_547D,
            ["被免疫致命伤害"] = _____5F53_524D_4F24_5BB3,
            ["免疫持续秒"] = self["参数"]["免疫持续秒"],
            ["上下文"] = context,
            ["控制器"] = self
        })
    end
    return 0
end
_____81F4_547D_4F24_5BB3_4FDD_547D_4E0E_9650_65F6_514D_75AB_5B9E_73B0.prototype["启动限时免疫"] = function(self)
    local _____6301_7EED_79D2 = self["参数"]["免疫持续秒"]
    if not (_____6301_7EED_79D2 > 0) then
        self["免疫截止时间Ms"] = 0
        return
    end
    self["清除免疫结束回调"](self)
    local _____622A_6B62_65F6_95F4Ms = getServerTime() + _____6301_7EED_79D2 * 1000
    self["免疫截止时间Ms"] = _____622A_6B62_65F6_95F4Ms
    local _____5230_671F_53C2_6570 = {["控制器"] = self, ["截止时间Ms"] = _____622A_6B62_65F6_95F4Ms}
    self["免疫结束回调ID"] = addDelayedCallback(_____6301_7EED_79D2 * 1000, ____on_81F4_547D_4F24_5BB3_514D_75AB_5230_671F, _____5230_671F_53C2_6570)
end
_____81F4_547D_4F24_5BB3_4FDD_547D_4E0E_9650_65F6_514D_75AB_5B9E_73B0.prototype["清除免疫结束回调"] = function(self)
    if self["免疫结束回调ID"] == 0 then
        return
    end
    removeDelayedCallback(self["免疫结束回调ID"])
    self["免疫结束回调ID"] = 0
end
____exports["创建致命伤害保命与限时免疫"] = function(_____53C2_6570)
    return __TS__New(_____81F4_547D_4F24_5BB3_4FDD_547D_4E0E_9650_65F6_514D_75AB_5B9E_73B0, _____53C2_6570)
end
return ____exports
