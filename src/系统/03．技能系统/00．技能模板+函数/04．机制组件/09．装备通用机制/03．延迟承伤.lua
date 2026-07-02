local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__New = ____lualib.__TS__New
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____5355_4F4D_6709_6548, _____5C1D_8BD5_505C_6B62_5EF6_8FDF_627F_4F24_7CFB_7EDF, ____on_5EF6_8FDF_627F_4F24_4FEE_6B63, ____on_5EF6_8FDF_6263_8840Tick, IsUnitType, UNIT_TYPE_DEAD, unregisterDamageModifier, removePeriodicCallback, getServerTime, _____51CF_5C11_751F_547D_503C, _____5EF6_8FDF_627F_4F24_8868, _____5EF6_8FDF_627F_4F24_4FEE_6B63_5668ID, _____5EF6_8FDF_6263_8840TickID, _____5EF6_8FDF_6263_8840_961F_5217
function _____5355_4F4D_6709_6548(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) ~= true
end
function _____5C1D_8BD5_505C_6B62_5EF6_8FDF_627F_4F24_7CFB_7EDF()
    local hasController = false
    for key in pairs(_____5EF6_8FDF_627F_4F24_8868) do
        if _____5EF6_8FDF_627F_4F24_8868[key] ~= nil then
            hasController = true
        end
    end
    if not hasController and _____5EF6_8FDF_627F_4F24_4FEE_6B63_5668ID ~= 0 then
        unregisterDamageModifier(_____5EF6_8FDF_627F_4F24_4FEE_6B63_5668ID)
        _____5EF6_8FDF_627F_4F24_4FEE_6B63_5668ID = 0
    end
    if #_____5EF6_8FDF_6263_8840_961F_5217 <= 0 and _____5EF6_8FDF_6263_8840TickID ~= 0 then
        removePeriodicCallback(_____5EF6_8FDF_6263_8840TickID)
        _____5EF6_8FDF_6263_8840TickID = 0
    end
end
function ____on_5EF6_8FDF_627F_4F24_4FEE_6B63(context)
    local damage = context.currentDamage
    for key in pairs(_____5EF6_8FDF_627F_4F24_8868) do
        do
            local _____63A7_5236_5668 = _____5EF6_8FDF_627F_4F24_8868[key]
            if _____63A7_5236_5668 == nil then
                goto __continue29
            end
            context.currentDamage = damage
            damage = _____63A7_5236_5668["修正"](_____63A7_5236_5668, context)
        end
        ::__continue29::
    end
    return damage
end
function ____on_5EF6_8FDF_6263_8840Tick()
    local now = getServerTime()
    do
        local i = #_____5EF6_8FDF_6263_8840_961F_5217 - 1
        while i >= 0 do
            do
                local _____8BB0_5F55 = _____5EF6_8FDF_6263_8840_961F_5217[i + 1]
                if now < _____8BB0_5F55["下次毫秒"] then
                    goto __continue34
                end
                if _____5355_4F4D_6709_6548(_____8BB0_5F55["目标"]) then
                    _____51CF_5C11_751F_547D_503C(
                        _____8BB0_5F55["目标"],
                        _____8BB0_5F55["每跳伤害"],
                        _____8BB0_5F55["显示扣血"],
                        _____8BB0_5F55["扣血特效"] ~= nil and _____8BB0_5F55["扣血特效"] ~= "",
                        _____8BB0_5F55["扣血特效"],
                        1
                    )
                end
                _____8BB0_5F55["剩余跳数"] = _____8BB0_5F55["剩余跳数"] - 1
                if _____8BB0_5F55["剩余跳数"] <= 0 then
                    __TS__ArraySplice(_____5EF6_8FDF_6263_8840_961F_5217, i, 1)
                else
                    _____8BB0_5F55["下次毫秒"] = now + _____8BB0_5F55["间隔毫秒"]
                end
            end
            ::__continue34::
            i = i - 1
        end
    end
    _____5C1D_8BD5_505C_6B62_5EF6_8FDF_627F_4F24_7CFB_7EDF()
end
---
-- @noSelfInFile
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
IsUnitType = jass.IsUnitType
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
unregisterDamageModifier = ____require_result_0.unregisterDamageModifier
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
removePeriodicCallback = ____require_result_1.removePeriodicCallback
getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
_____51CF_5C11_751F_547D_503C = ____require_result_2["减少生命值"]
_____5EF6_8FDF_627F_4F24_8868 = {}
local _____5EF6_8FDF_627F_4F24_8BA1_6570 = 0
_____5EF6_8FDF_627F_4F24_4FEE_6B63_5668ID = 0
_____5EF6_8FDF_6263_8840TickID = 0
_____5EF6_8FDF_6263_8840_961F_5217 = {}
local function _____53D6_5355_4F4DID(_____5355_4F4D)
    if not _____5355_4F4D_6709_6548(_____5355_4F4D) then
        return 0
    end
    return GetHandleId(_____5355_4F4D) or 0
end
local function _____786E_4FDD_5EF6_8FDF_627F_4F24_4FEE_6B63_5668(priority)
    if _____5EF6_8FDF_627F_4F24_4FEE_6B63_5668ID ~= 0 then
        return
    end
    _____5EF6_8FDF_627F_4F24_4FEE_6B63_5668ID = registerDamageModifier(____on_5EF6_8FDF_627F_4F24_4FEE_6B63, priority)
end
local function _____786E_4FDD_5EF6_8FDF_6263_8840Tick()
    if _____5EF6_8FDF_6263_8840TickID ~= 0 then
        return
    end
    _____5EF6_8FDF_6263_8840TickID = addPeriodicCallback(100, ____on_5EF6_8FDF_6263_8840Tick)
end
local _____5EF6_8FDF_627F_4F24_5B9E_73B0 = __TS__Class()
_____5EF6_8FDF_627F_4F24_5B9E_73B0.name = "延迟承伤实现"
function _____5EF6_8FDF_627F_4F24_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____53C2_6570)
    self["已停止"] = false
    self["名称"] = _____540D_79F0
    self["参数"] = _____53C2_6570
    _____5EF6_8FDF_627F_4F24_8BA1_6570 = _____5EF6_8FDF_627F_4F24_8BA1_6570 + 1
    self["控制器ID"] = _____5EF6_8FDF_627F_4F24_8BA1_6570
    _____5EF6_8FDF_627F_4F24_8868[self["控制器ID"]] = self
    _____786E_4FDD_5EF6_8FDF_627F_4F24_4FEE_6B63_5668(_____53C2_6570["优先级"] or 40)
end
_____5EF6_8FDF_627F_4F24_5B9E_73B0.prototype["修正"] = function(self, context)
    if self["已停止"] or context.currentDamage <= 0 then
        return context.currentDamage
    end
    if not _____5355_4F4D_6709_6548(context.target) then
        return context.currentDamage
    end
    if self["参数"]["单位"] ~= nil and _____53D6_5355_4F4DID(self["参数"]["单位"]) ~= _____53D6_5355_4F4DID(context.target) then
        return context.currentDamage
    end
    if self["参数"]["过滤伤害"] ~= nil and not self["参数"]["过滤伤害"](context) then
        return context.currentDamage
    end
    local ratio = self["参数"]["减免比例"]
    if ratio <= 0 then
        return context.currentDamage
    end
    if ratio > 1 then
        ratio = 1
    end
    local delayed = context.currentDamage * ratio
    self["登记延迟扣血"](self, context.target, delayed)
    return context.currentDamage - delayed
end
_____5EF6_8FDF_627F_4F24_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    __TS__Delete(_____5EF6_8FDF_627F_4F24_8868, self["控制器ID"])
    _____5C1D_8BD5_505C_6B62_5EF6_8FDF_627F_4F24_7CFB_7EDF()
end
_____5EF6_8FDF_627F_4F24_5B9E_73B0.prototype["登记延迟扣血"] = function(self, target, amount)
    if amount <= 0 then
        return
    end
    local ticks = self["参数"]["跳数"] ~= nil and self["参数"]["跳数"] > 0 and self["参数"]["跳数"] or 10
    local interval = self["参数"]["跳间隔毫秒"] ~= nil and self["参数"]["跳间隔毫秒"] > 0 and self["参数"]["跳间隔毫秒"] or self["参数"]["持续秒"] * 1000 / ticks
    _____5EF6_8FDF_6263_8840_961F_5217[#_____5EF6_8FDF_6263_8840_961F_5217 + 1] = {
        ["目标"] = target,
        ["每跳伤害"] = amount / ticks,
        ["剩余跳数"] = ticks,
        ["下次毫秒"] = getServerTime() + interval,
        ["间隔毫秒"] = interval,
        ["显示扣血"] = self["参数"]["显示扣血"] ~= false,
        ["扣血特效"] = self["参数"]["扣血特效"]
    }
    _____786E_4FDD_5EF6_8FDF_6263_8840Tick()
end
____exports["创建延迟承伤"] = function(_____53C2_6570)
    return __TS__New(_____5EF6_8FDF_627F_4F24_5B9E_73B0, _____53C2_6570["名称"] or "延迟承伤", _____53C2_6570)
end
return ____exports
