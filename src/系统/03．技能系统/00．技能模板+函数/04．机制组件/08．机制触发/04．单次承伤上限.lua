local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local unregisterDamageModifier = ____require_result_0.unregisterDamageModifier
local function _____53D6_5355_4F4DID(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    return GetHandleId(_____5355_4F4D) or 0
end
local function _____8BA1_7B97_4E0A_9650(_____53C2_6570)
    local _____4E0A_9650 = _____53C2_6570["固定上限"] or 0
    if _____53C2_6570["最大生命比例"] ~= nil and _____53C2_6570["最大生命比例"] > 0 then
        local _____6700_5927_751F_547D = GetUnitStateJapi(_____53C2_6570["单位"], UNIT_STATE_MAX_LIFE)
        local _____767E_5206_6BD4_4E0A_9650 = _____6700_5927_751F_547D * _____53C2_6570["最大生命比例"]
        if _____4E0A_9650 <= 0 or _____767E_5206_6BD4_4E0A_9650 < _____4E0A_9650 then
            _____4E0A_9650 = _____767E_5206_6BD4_4E0A_9650
        end
    end
    return _____4E0A_9650
end
local _____5355_6B21_627F_4F24_4E0A_9650_63A7_5236_5668_5B9E_73B0 = __TS__Class()
_____5355_6B21_627F_4F24_4E0A_9650_63A7_5236_5668_5B9E_73B0.name = "单次承伤上限控制器实现"
function _____5355_6B21_627F_4F24_4E0A_9650_63A7_5236_5668_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____4FEE_6B63_5668ID)
    self["已停止"] = false
    self["名称"] = _____540D_79F0
    self["修正器ID"] = _____4FEE_6B63_5668ID
end
_____5355_6B21_627F_4F24_4E0A_9650_63A7_5236_5668_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    if self["修正器ID"] ~= 0 then
        unregisterDamageModifier(self["修正器ID"])
    end
end
____exports["创建单次承伤上限"] = function(_____53C2_6570)
    local _____540D_79F0 = _____53C2_6570["名称"] or "单次承伤上限"
    local _____76EE_6807ID = _____53D6_5355_4F4DID(_____53C2_6570["单位"])
    local _____4FEE_6B63_5668ID = registerDamageModifier(
        function(context)
            if _____76EE_6807ID == 0 or _____53D6_5355_4F4DID(context.target) ~= _____76EE_6807ID then
                return context.currentDamage
            end
            if _____53C2_6570["过滤伤害"] ~= nil and not _____53C2_6570["过滤伤害"](context) then
                return context.currentDamage
            end
            local _____4E0A_9650 = _____8BA1_7B97_4E0A_9650(_____53C2_6570)
            if _____4E0A_9650 <= 0 or context.currentDamage <= _____4E0A_9650 then
                return context.currentDamage
            end
            return _____4E0A_9650
        end,
        _____53C2_6570["优先级"] or 130
    )
    local _____63A7_5236_5668 = __TS__New(_____5355_6B21_627F_4F24_4E0A_9650_63A7_5236_5668_5B9E_73B0, _____540D_79F0, _____4FEE_6B63_5668ID)
    if _____53C2_6570["清理篮子"] ~= nil then
        local ____self_1 = _____53C2_6570["清理篮子"]
        ____self_1["登记清理"](
            ____self_1,
            _____540D_79F0 .. "-停止",
            function()
                _____63A7_5236_5668["停止"](_____63A7_5236_5668)
            end
        )
    end
    return _____63A7_5236_5668
end
return ____exports
