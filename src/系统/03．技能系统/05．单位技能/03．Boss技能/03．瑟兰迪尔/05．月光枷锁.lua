--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local stringToFourCC, _____5355_4F4D_6709_6548, _____64AD_653E_6708_5149_67B7_9501_65BD_6CD5_52A8_4F5C, _____64AD_653E_6708_5149_67B7_9501_7279_6548, _____7ED3_7B97_6708_5149_67B7_9501Tick_4F24_5BB3, jass, addDelayedCallback, _____65BD_52A0_6269_5C55_63A7_5236, registerManualBuff, YDWETimerDestroyEffectSafe, GetUnitName, R2I, SetUnitAnimationByIndex, SetUnitTimeScale, AddSpecialEffectTarget, UnitDamageTarget
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．瑟兰迪尔.02．数值与表现配置")
local _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["瑟兰迪尔数值与表现配置"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．瑟兰迪尔.00．配置")
local _____745F_5170_8FEA_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["瑟兰迪尔单位技能配置"]
function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0
end
function _____64AD_653E_6708_5149_67B7_9501_65BD_6CD5_52A8_4F5C(caster)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    SetUnitTimeScale(caster, 1.5)
    SetUnitAnimationByIndex(caster, config["动画编号"])
    addDelayedCallback(
        R2I(config["施法硬直秒"] * 1000),
        function()
            if not _____5355_4F4D_6709_6548(caster) then
                return
            end
            SetUnitTimeScale(caster, 1)
            SetUnitAnimationByIndex(caster, 0)
        end
    )
end
function _____64AD_653E_6708_5149_67B7_9501_7279_6548(caster, target)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    local casterEffect = AddSpecialEffectTarget(config["飞行特效"], caster, "weapon")
    if casterEffect ~= nil and casterEffect ~= 0 then
        YDWETimerDestroyEffectSafe(0.8, casterEffect)
    end
    local targetEffect = AddSpecialEffectTarget(config["命中特效"], target, "origin")
    if targetEffect ~= nil and targetEffect ~= 0 then
        YDWETimerDestroyEffectSafe(config["定身秒"], targetEffect)
    end
end
function _____7ED3_7B97_6708_5149_67B7_9501Tick_4F24_5BB3(caster, target, tickIndex)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    addDelayedCallback(
        R2I(config["Tick间隔秒"] * tickIndex * 1000),
        function()
            if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
                return
            end
            UnitDamageTarget(
                caster,
                target,
                config["Tick伤害"],
                false,
                false,
                jass.ATTACK_TYPE_NORMAL,
                jass.DAMAGE_TYPE_PLANT,
                jass.WEAPON_TYPE_WHOKNOWS
            )
        end
    )
end
____exports["释放瑟兰迪尔月光枷锁效果"] = function(caster, target)
    if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    _____64AD_653E_6708_5149_67B7_9501_65BD_6CD5_52A8_4F5C(caster)
    _____64AD_653E_6708_5149_67B7_9501_7279_6548(caster, target)
    _____65BD_52A0_6269_5C55_63A7_5236(caster, target, "roots", {["持续时间"] = config["定身秒"]})
    registerManualBuff(
        target,
        config.BuffID,
        config["定身秒"],
        0,
        {
            sourceName = GetUnitName(caster),
            iconOverride = "BuffIcon\\Boss\\Thranduil\\yueguangjiasuo.blp",
            effectModelOverride = config["命中特效"]
        }
    )
    do
        local i = 1
        while i <= config["定身秒"] do
            _____7ED3_7B97_6708_5149_67B7_9501Tick_4F24_5BB3(caster, target, i)
            i = i + 1
        end
    end
end
jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
_____65BD_52A0_6269_5C55_63A7_5236 = ____require_result_2["施加扩展控制"]
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_3.registerManualBuff
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDWETimerDestroyEffectSafe = ____require_result_4.YDWETimerDestroyEffectSafe
local GetUnitTypeId = jass.GetUnitTypeId
local GetSpellTargetUnit = jass.GetSpellTargetUnit
GetUnitName = jass.GetUnitName
R2I = jass.R2I
SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
SetUnitTimeScale = jass.SetUnitTimeScale
AddSpecialEffectTarget = jass.AddSpecialEffectTarget
UnitDamageTarget = jass.UnitDamageTarget
local _____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID = stringToFourCC(_____745F_5170_8FEA_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____6708_5149_67B7_9501_6280_80FDID = stringToFourCC(_____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]["技能槽位"])
local _____6708_5149_67B7_9501_5DF2_6CE8_518C = false
____exports["释放瑟兰迪尔月光枷锁"] = function(_context, _target)
    ____exports["释放瑟兰迪尔月光枷锁效果"](_context["Boss单位"], _target)
end
local function ____on_745F_5170_8FEA_5C14_6708_5149_67B7_9501_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____6708_5149_67B7_9501_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID then
        return
    end
    local target = GetSpellTargetUnit()
    ____exports["释放瑟兰迪尔月光枷锁效果"](castingUnit, target)
end
____exports["注册瑟兰迪尔月光枷锁"] = function()
    if _____6708_5149_67B7_9501_5DF2_6CE8_518C then
        return
    end
    _____6708_5149_67B7_9501_5DF2_6CE8_518C = true
    registerSpellEffectListener(____on_745F_5170_8FEA_5C14_6708_5149_67B7_9501_751F_6548)
end
return ____exports
