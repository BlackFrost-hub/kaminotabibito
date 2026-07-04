local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_1.getUnitsInRange
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local _____65BD_52A0_6269_5C55_63A7_5236 = ____require_result_2["施加扩展控制"]
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitEnemy = jass.IsUnitEnemy
local IsUnitType = jass.IsUnitType
local GetUnitState = jass.GetUnitState
local UnitDamageTarget = jass.UnitDamageTarget
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local EXSetEffectSize = japi.EXSetEffectSize
____exports["默认主动陷阱模型"] = "Abilities\\Spells\\Orc\\StasisTrap\\StasisTotemTarget.mdl"
local _____4E0B_4E00_4E2A_4E3B_52A8_9677_9631ID = 0
local function _____5355_4F4D_6709_6548_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
local function ____on_4E3B_52A8_9677_9631Tick(variable)
    local _____5B9E_4F8B = variable
    if _____5B9E_4F8B ~= nil then
        _____5B9E_4F8B["推进"](_____5B9E_4F8B)
    end
end
local _____4E3B_52A8_9677_9631_5B9E_73B0 = __TS__Class()
_____4E3B_52A8_9677_9631_5B9E_73B0.name = "主动陷阱实现"
function _____4E3B_52A8_9677_9631_5B9E_73B0.prototype.____constructor(self, ID, _____53C2_6570, _____7279_6548)
    self["回调ID"] = 0
    self["已销毁"] = false
    self.ID = ID
    self["名称"] = _____53C2_6570["名称"] or "主动陷阱#" .. tostring(ID)
    self["参数"] = _____53C2_6570
    self["特效"] = _____7279_6548
    self.X = _____53C2_6570.X
    self.Y = _____53C2_6570.Y
    self["到期时间"] = getServerTime() + _____53C2_6570["持续秒数"] * 1000
end
_____4E3B_52A8_9677_9631_5B9E_73B0.prototype["启动"] = function(self)
    if self["回调ID"] ~= 0 then
        return
    end
    self["回调ID"] = addPeriodicCallback(self["参数"]["检测间隔毫秒"] or 100, ____on_4E3B_52A8_9677_9631Tick, self)
end
_____4E3B_52A8_9677_9631_5B9E_73B0.prototype["销毁"] = function(self, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "手动销毁"
    end
    if self["已销毁"] then
        return
    end
    self["已销毁"] = true
    if self["回调ID"] ~= 0 then
        removePeriodicCallback(self["回调ID"])
        self["回调ID"] = 0
    end
    if self["特效"] ~= nil and self["特效"] ~= 0 then
        DestroyEffect(self["特效"])
    end
    if self["参数"]["on结束"] ~= nil then
        self["参数"]["on结束"](self, _____539F_56E0)
    end
end
_____4E3B_52A8_9677_9631_5B9E_73B0.prototype["推进"] = function(self)
    if self["已销毁"] then
        return
    end
    if getServerTime() >= self["到期时间"] then
        self["销毁"](self, "过期")
        return
    end
    local targets = getUnitsInRange(self.X, self.Y, self["参数"]["触发半径"])
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                if not self["目标可触发"](self, target) then
                    goto __continue17
                end
                self["触发"](self, target)
                return
            end
            ::__continue17::
            i = i + 1
        end
    end
end
_____4E3B_52A8_9677_9631_5B9E_73B0.prototype["目标可触发"] = function(self, target)
    if not _____5355_4F4D_6709_6548_5B58_6D3B(target) then
        return false
    end
    if self["参数"]["只触发敌人"] ~= false and not IsUnitEnemy(
        target,
        GetOwningPlayer(self["参数"]["施法者"])
    ) then
        return false
    end
    if self["参数"]["过滤目标"] ~= nil and not self["参数"]["过滤目标"](target, self) then
        return false
    end
    return true
end
_____4E3B_52A8_9677_9631_5B9E_73B0.prototype["触发"] = function(self, target)
    if self["参数"]["触发特效路径"] ~= nil and self["参数"]["触发特效路径"] ~= "" then
        local effect = AddSpecialEffect(self["参数"]["触发特效路径"], self.X, self.Y)
        if effect ~= nil and effect ~= 0 then
            DestroyEffect(effect)
        end
    end
    if (self["参数"]["触发伤害"] or 0) > 0 then
        local ____self__53C2_6570__653B_51FB_7C7B_578B_3 = self["参数"]["攻击类型"]
        if ____self__53C2_6570__653B_51FB_7C7B_578B_3 == nil then
            ____self__53C2_6570__653B_51FB_7C7B_578B_3 = ATTACK_TYPE_NORMAL
        end
        local attackType = ____self__53C2_6570__653B_51FB_7C7B_578B_3
        local ____self__53C2_6570__4F24_5BB3_7C7B_578B_4 = self["参数"]["伤害类型"]
        if ____self__53C2_6570__4F24_5BB3_7C7B_578B_4 == nil then
            ____self__53C2_6570__4F24_5BB3_7C7B_578B_4 = DAMAGE_TYPE_MAGIC
        end
        local damageType = ____self__53C2_6570__4F24_5BB3_7C7B_578B_4
        local ____self__53C2_6570__6B66_5668_7C7B_578B_5 = self["参数"]["武器类型"]
        if ____self__53C2_6570__6B66_5668_7C7B_578B_5 == nil then
            ____self__53C2_6570__6B66_5668_7C7B_578B_5 = WEAPON_TYPE_WHOKNOWS
        end
        local weaponType = ____self__53C2_6570__6B66_5668_7C7B_578B_5
        UnitDamageTarget(
            self["参数"]["施法者"],
            target,
            self["参数"]["触发伤害"] or 0,
            false,
            false,
            attackType,
            damageType,
            weaponType
        )
    end
    if self["参数"]["控制类型"] ~= nil and (self["参数"]["控制持续秒数"] or 0) > 0 then
        _____65BD_52A0_6269_5C55_63A7_5236(self["参数"]["施法者"], target, self["参数"]["控制类型"], {["持续时间"] = self["参数"]["控制持续秒数"] or 0})
    end
    if self["参数"]["on触发"] ~= nil then
        self["参数"]["on触发"](target, self)
    end
    if self["参数"]["触发后销毁"] ~= false then
        self["销毁"](self, "触发")
    end
end
____exports["创建主动陷阱"] = function(_____53C2_6570)
    if _____53C2_6570["施法者"] == nil or _____53C2_6570["施法者"] == 0 then
        return nil
    end
    if not (_____53C2_6570["持续秒数"] > 0) or not (_____53C2_6570["触发半径"] > 0) then
        return nil
    end
    local effect = AddSpecialEffect(_____53C2_6570["模型路径"] or ____exports["默认主动陷阱模型"], _____53C2_6570.X, _____53C2_6570.Y)
    if effect == nil or effect == 0 then
        return nil
    end
    if _____53C2_6570["缩放"] ~= nil and type(EXSetEffectSize) == "function" then
        EXSetEffectSize(effect, _____53C2_6570["缩放"])
    end
    local ____4E3B_52A8_9677_9631_5B9E_73B0_6 = _____4E3B_52A8_9677_9631_5B9E_73B0
    _____4E0B_4E00_4E2A_4E3B_52A8_9677_9631ID = _____4E0B_4E00_4E2A_4E3B_52A8_9677_9631ID + 1
    local _____5B9E_4F8B = __TS__New(____4E3B_52A8_9677_9631_5B9E_73B0_6, _____4E0B_4E00_4E2A_4E3B_52A8_9677_9631ID, _____53C2_6570, effect)
    _____5B9E_4F8B["启动"](_____5B9E_4F8B)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_7 = _____53C2_6570["清理"]
        ____self_7["登记清理"](
            ____self_7,
            _____5B9E_4F8B["名称"],
            function()
                _____5B9E_4F8B["销毁"](_____5B9E_4F8B)
            end
        )
    end
    return _____5B9E_4F8B
end
return ____exports
