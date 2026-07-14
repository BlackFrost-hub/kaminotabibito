local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local unregisterDamageModifier = ____require_result_0.unregisterDamageModifier
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local jass = require("jass.common")
local GetUnitState = jass.GetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local function _____89C4_6574_4E0B_9650(value, maxLife)
    if value == nil or value ~= value or value <= 0 then
        return 0
    end
    if maxLife > 0 and value > maxLife then
        return maxLife
    end
    return value
end
local _____4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4_5B9E_73B0 = __TS__Class()
_____4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4_5B9E_73B0.name = "伤害生命下限保护实现"
function _____4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["修正器ID"] = 0
    self["已停止"] = false
    self["已启用"] = true
    self["已触底"] = false
    self["正在处理伤害"] = false
    self["参数"] = _____53C2_6570
    self["名称"] = _____53C2_6570["名称"] or "伤害生命下限保护"
    self["已启用"] = _____53C2_6570["初始启用"] ~= false
    local ____self = self
    self["修正器ID"] = registerDamageModifier(
        function(context)
            return ____self["处理伤害"](____self, context)
        end,
        _____53C2_6570["修正优先级"] or -100
    )
end
_____4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4_5B9E_73B0.prototype["是否生效"] = function(self)
    return not self["已停止"] and self["已启用"]
end
_____4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4_5B9E_73B0.prototype["是否已触底"] = function(self)
    return self["已触底"]
end
_____4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4_5B9E_73B0.prototype["读取生命下限"] = function(self)
    return self["计算生命下限"](self)
end
_____4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4_5B9E_73B0.prototype["设置启用"] = function(self, _____542F_7528)
    if self["已停止"] then
        return
    end
    self["已启用"] = _____542F_7528
end
_____4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4_5B9E_73B0.prototype["重置触底状态"] = function(self)
    if self["已停止"] then
        return
    end
    self["已触底"] = false
end
_____4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    self["已启用"] = false
    if self["正在处理伤害"] then
        local ____self = self
        addDelayedCallback(
            0,
            function()
                ____self["注销修正器"](____self)
            end
        )
    else
        self["注销修正器"](self)
    end
    if self["参数"]["on停止"] ~= nil then
        self["参数"]["on停止"](self["参数"]["单位"])
    end
end
_____4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4_5B9E_73B0.prototype["处理伤害"] = function(self, context)
    local current = context.currentDamage
    if not self["是否生效"](self) or context.target ~= self["参数"]["单位"] or not (current > 0) then
        return current
    end
    if self["参数"]["过滤伤害"] ~= nil and not self["参数"]["过滤伤害"](context) then
        return current
    end
    local _____5F53_524D_751F_547D = GetUnitState(self["参数"]["单位"], UNIT_STATE_LIFE)
    local _____751F_547D_4E0B_9650 = self["计算生命下限"](self, context)
    if self["参数"]["离开下限后重置触底"] == true and _____5F53_524D_751F_547D > _____751F_547D_4E0B_9650 then
        self["已触底"] = false
    end
    local _____5B9E_9645_5141_8BB8_4F24_5BB3 = _____5F53_524D_751F_547D - _____751F_547D_4E0B_9650
    if _____5B9E_9645_5141_8BB8_4F24_5BB3 < 0 then
        _____5B9E_9645_5141_8BB8_4F24_5BB3 = 0
    end
    if current <= _____5B9E_9645_5141_8BB8_4F24_5BB3 then
        return current
    end
    local event = {
        ["单位"] = self["参数"]["单位"],
        ["攻击者"] = context.attacker,
        ["当前生命"] = _____5F53_524D_751F_547D,
        ["生命下限"] = _____751F_547D_4E0B_9650,
        ["原伤害"] = current,
        ["实际允许伤害"] = _____5B9E_9645_5141_8BB8_4F24_5BB3,
        ["被阻止伤害"] = current - _____5B9E_9645_5141_8BB8_4F24_5BB3,
        ["上下文"] = context,
        ["控制器"] = self
    }
    self["正在处理伤害"] = true
    if not self["已触底"] then
        self["已触底"] = true
        if self["参数"]["on首次触底"] ~= nil then
            self["参数"]["on首次触底"](event)
        end
    end
    if self["参数"]["on拦截"] ~= nil then
        self["参数"]["on拦截"](event)
    end
    self["正在处理伤害"] = false
    return _____5B9E_9645_5141_8BB8_4F24_5BB3
end
_____4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4_5B9E_73B0.prototype["计算生命下限"] = function(self, context)
    local _____6700_5927_751F_547D = GetUnitState(self["参数"]["单位"], UNIT_STATE_MAX_LIFE)
    if self["参数"]["取生命下限"] ~= nil then
        return _____89C4_6574_4E0B_9650(
            self["参数"]["取生命下限"](self["参数"]["单位"], context),
            _____6700_5927_751F_547D
        )
    end
    local _____4E0B_9650 = self["参数"]["固定生命下限"] or 0
    local _____6BD4_4F8B = self["参数"]["最大生命比例下限"] or 0
    if _____6BD4_4F8B > 0 then
        local _____6BD4_4F8B_4E0B_9650 = _____6700_5927_751F_547D * _____6BD4_4F8B
        if _____6BD4_4F8B_4E0B_9650 > _____4E0B_9650 then
            _____4E0B_9650 = _____6BD4_4F8B_4E0B_9650
        end
    end
    return _____89C4_6574_4E0B_9650(_____4E0B_9650, _____6700_5927_751F_547D)
end
_____4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4_5B9E_73B0.prototype["注销修正器"] = function(self)
    if self["修正器ID"] == 0 then
        return
    end
    unregisterDamageModifier(self["修正器ID"])
    self["修正器ID"] = 0
end
____exports["创建伤害生命下限保护"] = function(_____53C2_6570)
    local _____63A7_5236_5668 = __TS__New(_____4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_2 = _____53C2_6570["清理"]
        ____self_2["登记清理"](
            ____self_2,
            _____63A7_5236_5668["名称"] .. "-清理",
            function()
                _____63A7_5236_5668["停止"](_____63A7_5236_5668)
            end
        )
    end
    return _____63A7_5236_5668
end
return ____exports
