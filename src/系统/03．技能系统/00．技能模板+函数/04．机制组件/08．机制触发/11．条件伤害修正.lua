local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local unregisterDamageModifier = ____require_result_0.unregisterDamageModifier
local _____6761_4EF6_4F24_5BB3_4FEE_6B63_5B9E_73B0 = __TS__Class()
_____6761_4EF6_4F24_5BB3_4FEE_6B63_5B9E_73B0.name = "条件伤害修正实现"
function _____6761_4EF6_4F24_5BB3_4FEE_6B63_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["修正ID"] = 0
    self["已停止"] = false
    self["参数"] = _____53C2_6570
    self["名称"] = _____53C2_6570["名称"] or "条件伤害修正"
    self["已启用"] = _____53C2_6570["初始启用"] ~= false
    local ____self = self
    self["修正ID"] = registerDamageModifier(
        function(context)
            return ____self["处理伤害"](____self, context)
        end,
        _____53C2_6570["优先级"] or 0
    )
end
_____6761_4EF6_4F24_5BB3_4FEE_6B63_5B9E_73B0.prototype["是否启用"] = function(self)
    return not self["已停止"] and self["已启用"]
end
_____6761_4EF6_4F24_5BB3_4FEE_6B63_5B9E_73B0.prototype["设置启用"] = function(self, _____542F_7528)
    if self["已停止"] then
        return
    end
    self["已启用"] = _____542F_7528
end
_____6761_4EF6_4F24_5BB3_4FEE_6B63_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    self["已启用"] = false
    if self["修正ID"] ~= 0 then
        unregisterDamageModifier(self["修正ID"])
        self["修正ID"] = 0
    end
end
_____6761_4EF6_4F24_5BB3_4FEE_6B63_5B9E_73B0.prototype["处理伤害"] = function(self, context)
    local currentDamage = context.currentDamage
    if not self["是否启用"](self) or not (currentDamage > 0) then
        return currentDamage
    end
    if not self["参数"]["条件"](context) then
        return currentDamage
    end
    local modifiedDamage = self["参数"]["修正"](context)
    return type(modifiedDamage) == "number" and modifiedDamage == modifiedDamage and modifiedDamage or currentDamage
end
____exports["创建条件伤害修正"] = function(_____53C2_6570)
    local _____63A7_5236_5668 = __TS__New(_____6761_4EF6_4F24_5BB3_4FEE_6B63_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_1 = _____53C2_6570["清理"]
        ____self_1["登记清理"](
            ____self_1,
            _____63A7_5236_5668["名称"] .. "-清理",
            function()
                _____63A7_5236_5668["停止"](_____63A7_5236_5668)
            end
        )
    end
    return _____63A7_5236_5668
end
return ____exports
