local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____79FB_9664_6301_7EED_4F24_5BB3, _____786E_4FDD_6301_7EED_4F24_5BB3_7CFB_7EDF_542F_52A8, _____6301_7EED_4F24_5BB3_7CFB_7EDFTick, UnitDamageTarget, GetUnitAbilityLevel, IsUnitPaused, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_PLANT, WEAPON_TYPE_WHOKNOWS, addPeriodicCallback, removePeriodicCallback, getServerTime, _____6301_7EED_4F24_5BB3_5B9E_4F8B_8868, _____6301_7EED_4F24_5BB3ID_5217_8868, _____6301_7EED_4F24_5BB3_56DE_8C03ID
function _____79FB_9664_6301_7EED_4F24_5BB3(id)
    if _____6301_7EED_4F24_5BB3_5B9E_4F8B_8868[id] == nil then
        return
    end
    __TS__Delete(_____6301_7EED_4F24_5BB3_5B9E_4F8B_8868, id)
    local index = __TS__ArrayIndexOf(_____6301_7EED_4F24_5BB3ID_5217_8868, id)
    if index >= 0 then
        __TS__ArraySplice(_____6301_7EED_4F24_5BB3ID_5217_8868, index, 1)
    end
    if #_____6301_7EED_4F24_5BB3ID_5217_8868 == 0 and _____6301_7EED_4F24_5BB3_56DE_8C03ID ~= 0 then
        removePeriodicCallback(_____6301_7EED_4F24_5BB3_56DE_8C03ID)
        _____6301_7EED_4F24_5BB3_56DE_8C03ID = 0
    end
end
function _____786E_4FDD_6301_7EED_4F24_5BB3_7CFB_7EDF_542F_52A8()
    if _____6301_7EED_4F24_5BB3_56DE_8C03ID ~= 0 then
        return
    end
    _____6301_7EED_4F24_5BB3_56DE_8C03ID = addPeriodicCallback(100, _____6301_7EED_4F24_5BB3_7CFB_7EDFTick)
end
function _____6301_7EED_4F24_5BB3_7CFB_7EDFTick()
    local now = getServerTime()
    local index = 0
    while index < #_____6301_7EED_4F24_5BB3ID_5217_8868 do
        do
            local id = _____6301_7EED_4F24_5BB3ID_5217_8868[index + 1]
            local _____5B9E_4F8B = _____6301_7EED_4F24_5BB3_5B9E_4F8B_8868[id]
            if _____5B9E_4F8B == nil or _____5B9E_4F8B["目标单位"] == nil or _____5B9E_4F8B["目标单位"] == 0 then
                _____79FB_9664_6301_7EED_4F24_5BB3(id)
                goto __continue18
            end
            if GetUnitAbilityLevel(_____5B9E_4F8B["目标单位"], _____5B9E_4F8B.BuffID) <= 0 then
                _____79FB_9664_6301_7EED_4F24_5BB3(id)
                goto __continue18
            end
            if not IsUnitPaused(_____5B9E_4F8B["目标单位"]) and now >= _____5B9E_4F8B["下次伤害时间"] then
                UnitDamageTarget(
                    _____5B9E_4F8B["来源单位"],
                    _____5B9E_4F8B["目标单位"],
                    _____5B9E_4F8B["伤害"],
                    false,
                    false,
                    ATTACK_TYPE_NORMAL,
                    DAMAGE_TYPE_PLANT,
                    WEAPON_TYPE_WHOKNOWS
                )
                _____5B9E_4F8B["下次伤害时间"] = now + _____5B9E_4F8B["伤害间隔毫秒"]
            end
            if index < #_____6301_7EED_4F24_5BB3ID_5217_8868 and _____6301_7EED_4F24_5BB3ID_5217_8868[index + 1] == id then
                index = index + 1
            end
        end
        ::__continue18::
    end
end
local jass = require("jass.common")
UnitDamageTarget = jass.UnitDamageTarget
GetUnitAbilityLevel = jass.GetUnitAbilityLevel
IsUnitPaused = jass.IsUnitPaused
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
local SFB_setEntanglingRoots = ____require_result_1.SFB_setEntanglingRoots
local SFB_setParasite = ____require_result_1.SFB_setParasite
local ____BUFF__7EA0_7F20_6839_987B = 1111844210
local ____BUFF__5BC4_751F = 1112436833
local _____9ED8_8BA4_4F24_5BB3_95F4_9694 = 1
local _____6301_7EED_65F6_95F4_8865_507F = 0.05
_____6301_7EED_4F24_5BB3_5B9E_4F8B_8868 = {}
_____6301_7EED_4F24_5BB3ID_5217_8868 = {}
local _____4E0B_4E00_4E2A_6301_7EED_4F24_5BB3ID = 0
_____6301_7EED_4F24_5BB3_56DE_8C03ID = 0
local function _____8F6C_6570_5B57(value)
    if value == nil or value == false or value == "" then
        return 0
    end
    local n = type(value) == "number" and value or __TS__Number(value)
    return n ~= n and 0 or n
end
local function _____8BFB_53D6_6765_6E90_5355_4F4D(_____53C2_6570)
    local ____53C2_6570__6765_6E90_5355_4F4D_2 = _____53C2_6570["来源单位"]
    if ____53C2_6570__6765_6E90_5355_4F4D_2 == nil then
        ____53C2_6570__6765_6E90_5355_4F4D_2 = _____53C2_6570.BuffSource
    end
    return ____53C2_6570__6765_6E90_5355_4F4D_2
end
local function _____8BFB_53D6_76EE_6807_5355_4F4D(_____53C2_6570)
    local ____53C2_6570__76EE_6807_5355_4F4D_3 = _____53C2_6570["目标单位"]
    if ____53C2_6570__76EE_6807_5355_4F4D_3 == nil then
        ____53C2_6570__76EE_6807_5355_4F4D_3 = _____53C2_6570.BuffTarget
    end
    return ____53C2_6570__76EE_6807_5355_4F4D_3
end
local function _____8BFB_53D6_6301_7EED_65F6_95F4(_____53C2_6570)
    local time = _____8F6C_6570_5B57(_____53C2_6570["持续时间"] or _____53C2_6570.time)
    return time > 0 and time + _____6301_7EED_65F6_95F4_8865_507F or 0
end
local function _____8BFB_53D6_4F24_5BB3_95F4_9694(_____53C2_6570)
    local interval = _____8F6C_6570_5B57(_____53C2_6570["伤害间隔"] or _____53C2_6570.DamageInterval)
    return interval > 0 and interval or _____9ED8_8BA4_4F24_5BB3_95F4_9694
end
local function _____6CE8_518C_6301_7EED_4F24_5BB3(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____4F24_5BB3, _____4F24_5BB3_95F4_9694, BuffID)
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return 0
    end
    if _____4F24_5BB3 <= 0 then
        return 0
    end
    _____4E0B_4E00_4E2A_6301_7EED_4F24_5BB3ID = _____4E0B_4E00_4E2A_6301_7EED_4F24_5BB3ID + 1
    local id = _____4E0B_4E00_4E2A_6301_7EED_4F24_5BB3ID
    local now = getServerTime()
    _____6301_7EED_4F24_5BB3_5B9E_4F8B_8868[id] = {
        ID = id,
        ["来源单位"] = _____6765_6E90_5355_4F4D,
        ["目标单位"] = _____76EE_6807_5355_4F4D,
        ["伤害"] = _____4F24_5BB3,
        ["伤害间隔毫秒"] = _____4F24_5BB3_95F4_9694 * 1000,
        ["下次伤害时间"] = now + _____4F24_5BB3_95F4_9694 * 1000,
        BuffID = BuffID
    }
    _____6301_7EED_4F24_5BB3ID_5217_8868[#_____6301_7EED_4F24_5BB3ID_5217_8868 + 1] = id
    _____786E_4FDD_6301_7EED_4F24_5BB3_7CFB_7EDF_542F_52A8()
    return id
end
____exports["施加禁锢"] = function(_____53C2_6570)
    local _____6765_6E90_5355_4F4D = _____8BFB_53D6_6765_6E90_5355_4F4D(_____53C2_6570)
    local _____76EE_6807_5355_4F4D = _____8BFB_53D6_76EE_6807_5355_4F4D(_____53C2_6570)
    local _____6301_7EED_65F6_95F4 = _____8BFB_53D6_6301_7EED_65F6_95F4(_____53C2_6570)
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 or _____6301_7EED_65F6_95F4 <= 0 then
        return
    end
    SFB_setEntanglingRoots(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____6301_7EED_65F6_95F4)
    _____6CE8_518C_6301_7EED_4F24_5BB3(
        _____6765_6E90_5355_4F4D,
        _____76EE_6807_5355_4F4D,
        _____8F6C_6570_5B57(_____53C2_6570["伤害"] or _____53C2_6570.HitDamage),
        _____8BFB_53D6_4F24_5BB3_95F4_9694(_____53C2_6570),
        ____BUFF__7EA0_7F20_6839_987B
    )
end
____exports["施加寄生"] = function(_____53C2_6570)
    local _____6765_6E90_5355_4F4D = _____8BFB_53D6_6765_6E90_5355_4F4D(_____53C2_6570)
    local _____76EE_6807_5355_4F4D = _____8BFB_53D6_76EE_6807_5355_4F4D(_____53C2_6570)
    local _____6301_7EED_65F6_95F4 = _____8BFB_53D6_6301_7EED_65F6_95F4(_____53C2_6570)
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 or _____6301_7EED_65F6_95F4 <= 0 then
        return
    end
    SFB_setParasite(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____6301_7EED_65F6_95F4)
    _____6CE8_518C_6301_7EED_4F24_5BB3(
        _____6765_6E90_5355_4F4D,
        _____76EE_6807_5355_4F4D,
        _____8F6C_6570_5B57(_____53C2_6570["伤害"] or _____53C2_6570.HitDamage),
        _____8BFB_53D6_4F24_5BB3_95F4_9694(_____53C2_6570),
        ____BUFF__5BC4_751F
    )
end
return ____exports
