local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____on_8DDD_79BB_4F24_5BB3_4FEE_6B63, _____8DDD_79BB_4F24_5BB3_4FEE_6B63_8868
function ____on_8DDD_79BB_4F24_5BB3_4FEE_6B63(context)
    local damage = context.currentDamage
    for key in pairs(_____8DDD_79BB_4F24_5BB3_4FEE_6B63_8868) do
        do
            local _____63A7_5236_5668 = _____8DDD_79BB_4F24_5BB3_4FEE_6B63_8868[key]
            if _____63A7_5236_5668 == nil then
                goto __continue28
            end
            context.currentDamage = damage
            damage = _____63A7_5236_5668["修正"](_____63A7_5236_5668, context)
        end
        ::__continue28::
    end
    return damage
end
---
-- @noSelfInFile
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local SquareRoot = jass.SquareRoot
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local unregisterDamageModifier = ____require_result_0.unregisterDamageModifier
_____8DDD_79BB_4F24_5BB3_4FEE_6B63_8868 = {}
local _____8DDD_79BB_4F24_5BB3_4FEE_6B63_8BA1_6570 = 0
local _____8DDD_79BB_4F24_5BB3_4FEE_6B63_5668ID = 0
local function _____5355_4F4D_6709_6548(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) ~= true
end
local function _____53D6_5355_4F4DID(_____5355_4F4D)
    if not _____5355_4F4D_6709_6548(_____5355_4F4D) then
        return 0
    end
    return GetHandleId(_____5355_4F4D) or 0
end
local function _____4E24_70B9_8DDD_79BB(a, b)
    local dx = GetUnitX(a) - GetUnitX(b)
    local dy = GetUnitY(a) - GetUnitY(b)
    return SquareRoot(dx * dx + dy * dy)
end
local function _____7EBF_6027_63D2_503C(a, b, t)
    return a + (b - a) * t
end
local function _____786E_4FDD_8DDD_79BB_4F24_5BB3_4FEE_6B63_5668(priority)
    if _____8DDD_79BB_4F24_5BB3_4FEE_6B63_5668ID ~= 0 then
        return
    end
    _____8DDD_79BB_4F24_5BB3_4FEE_6B63_5668ID = registerDamageModifier(____on_8DDD_79BB_4F24_5BB3_4FEE_6B63, priority)
end
local function _____5C1D_8BD5_79FB_9664_8DDD_79BB_4F24_5BB3_4FEE_6B63_5668()
    for key in pairs(_____8DDD_79BB_4F24_5BB3_4FEE_6B63_8868) do
        if _____8DDD_79BB_4F24_5BB3_4FEE_6B63_8868[key] ~= nil then
            return
        end
    end
    if _____8DDD_79BB_4F24_5BB3_4FEE_6B63_5668ID ~= 0 then
        unregisterDamageModifier(_____8DDD_79BB_4F24_5BB3_4FEE_6B63_5668ID)
        _____8DDD_79BB_4F24_5BB3_4FEE_6B63_5668ID = 0
    end
end
local _____8DDD_79BB_4F24_5BB3_4FEE_6B63_5B9E_73B0 = __TS__Class()
_____8DDD_79BB_4F24_5BB3_4FEE_6B63_5B9E_73B0.name = "距离伤害修正实现"
function _____8DDD_79BB_4F24_5BB3_4FEE_6B63_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____53C2_6570)
    self["已停止"] = false
    self["名称"] = _____540D_79F0
    self["参数"] = _____53C2_6570
    _____8DDD_79BB_4F24_5BB3_4FEE_6B63_8BA1_6570 = _____8DDD_79BB_4F24_5BB3_4FEE_6B63_8BA1_6570 + 1
    self["控制器ID"] = _____8DDD_79BB_4F24_5BB3_4FEE_6B63_8BA1_6570
    _____8DDD_79BB_4F24_5BB3_4FEE_6B63_8868[self["控制器ID"]] = self
    _____786E_4FDD_8DDD_79BB_4F24_5BB3_4FEE_6B63_5668(_____53C2_6570["优先级"] or 45)
end
_____8DDD_79BB_4F24_5BB3_4FEE_6B63_5B9E_73B0.prototype["修正"] = function(self, context)
    if self["已停止"] or context.currentDamage <= 0 then
        return context.currentDamage
    end
    if not _____5355_4F4D_6709_6548(context.target) or not _____5355_4F4D_6709_6548(context.attacker) then
        return context.currentDamage
    end
    if self["参数"]["单位"] ~= nil and _____53D6_5355_4F4DID(self["参数"]["单位"]) ~= _____53D6_5355_4F4DID(context.target) then
        return context.currentDamage
    end
    local distance = _____4E24_70B9_8DDD_79BB(context.target, context.attacker)
    if self["参数"]["过滤伤害"] ~= nil and not self["参数"]["过滤伤害"](context, distance) then
        return context.currentDamage
    end
    local min = self["参数"]["最小距离"]
    local max = self["参数"]["最大距离"] > min and self["参数"]["最大距离"] or min + 1
    local t = (distance - min) / (max - min)
    if t < 0 then
        t = 0
    end
    if t > 1 then
        t = 1
    end
    local reduce = _____7EBF_6027_63D2_503C(self["参数"]["最近减伤"], self["参数"]["最远减伤"], t)
    if reduce <= 0 then
        return context.currentDamage
    end
    if reduce >= 1 then
        return 0
    end
    return context.currentDamage * (1 - reduce)
end
_____8DDD_79BB_4F24_5BB3_4FEE_6B63_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    __TS__Delete(_____8DDD_79BB_4F24_5BB3_4FEE_6B63_8868, self["控制器ID"])
    _____5C1D_8BD5_79FB_9664_8DDD_79BB_4F24_5BB3_4FEE_6B63_5668()
end
____exports["创建距离伤害修正"] = function(_____53C2_6570)
    return __TS__New(_____8DDD_79BB_4F24_5BB3_4FEE_6B63_5B9E_73B0, _____53C2_6570["名称"] or "距离伤害修正", _____53C2_6570)
end
return ____exports
