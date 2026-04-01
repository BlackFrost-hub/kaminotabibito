--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local japi = require("jass.japi")
____exports.ABILITY_STATE_COOLDOWN = 1
____exports.ABILITY_DATA_TARGS = 100
____exports.ABILITY_DATA_CAST = 101
____exports.ABILITY_DATA_DUR = 102
____exports.ABILITY_DATA_HERODUR = 103
____exports.ABILITY_DATA_COST = 104
____exports.ABILITY_DATA_COOL = 105
____exports.ABILITY_DATA_AREA = 106
____exports.ABILITY_DATA_RNG = 107
____exports.ABILITY_DATA_DATA_A = 108
____exports.ABILITY_DATA_DATA_B = 109
____exports.ABILITY_DATA_DATA_C = 110
____exports.ABILITY_DATA_DATA_D = 111
____exports.ABILITY_DATA_DATA_E = 112
____exports.ABILITY_DATA_DATA_F = 113
____exports.ABILITY_DATA_DATA_G = 114
____exports.ABILITY_DATA_DATA_H = 115
____exports.ABILITY_DATA_DATA_I = 116
____exports.ABILITY_DATA_UNITID = 117
____exports.ABILITY_DATA_HOTKET = 200
____exports.ABILITY_DATA_UNHOTKET = 201
____exports.ABILITY_DATA_RESEARCH_HOTKEY = 202
____exports.ABILITY_DATA_NAME = 203
____exports.ABILITY_DATA_ART = 204
____exports.ABILITY_DATA_TARGET_ART = 205
____exports.ABILITY_DATA_CASTER_ART = 206
____exports.ABILITY_DATA_EFFECT_ART = 207
____exports.ABILITY_DATA_AREAEFFECT_ART = 208
____exports.ABILITY_DATA_MISSILE_ART = 209
____exports.ABILITY_DATA_SPECIAL_ART = 210
____exports.ABILITY_DATA_LIGHTNING_EFFECT = 211
____exports.ABILITY_DATA_BUFF_TIP = 212
____exports.ABILITY_DATA_BUFF_UBERTIP = 213
____exports.ABILITY_DATA_RESEARCH_TIP = 214
____exports.ABILITY_DATA_TIP = 215
____exports.ABILITY_DATA_UNTIP = 216
____exports.ABILITY_DATA_RESEARCH_UBERTIP = 217
____exports.ABILITY_DATA_UBERTIP = 218
____exports.ABILITY_DATA_UNUBERTIP = 219
____exports.ABILITY_DATA_UNART = 220
function ____exports.EXGetUnitAbility(u, abilcode)
    return japi.EXGetUnitAbility(u, abilcode)
end
function ____exports.EXGetUnitAbilityByIndex(u, index)
    return japi.EXGetUnitAbilityByIndex(u, index)
end
function ____exports.EXGetAbilityId(abil)
    return japi.EXGetAbilityId(abil)
end
function ____exports.EXGetAbilityState(abil, state_type)
    return japi.EXGetAbilityState(abil, state_type)
end
function ____exports.EXSetAbilityState(abil, state_type, value)
    return japi.EXSetAbilityState(abil, state_type, value)
end
function ____exports.EXGetAbilityDataReal(abil, level, data_type)
    return japi.EXGetAbilityDataReal(abil, level, data_type)
end
function ____exports.EXSetAbilityDataReal(abil, level, data_type, value)
    return japi.EXSetAbilityDataReal(abil, level, data_type, value)
end
function ____exports.EXGetAbilityDataInteger(abil, level, data_type)
    return japi.EXGetAbilityDataInteger(abil, level, data_type)
end
function ____exports.EXSetAbilityDataInteger(abil, level, data_type, value)
    return japi.EXSetAbilityDataInteger(abil, level, data_type, value)
end
function ____exports.EXGetAbilityDataString(abil, level, data_type)
    return japi.EXGetAbilityDataString(abil, level, data_type)
end
function ____exports.EXSetAbilityDataString(abil, level, data_type, value)
    return japi.EXSetAbilityDataString(abil, level, data_type, value)
end
function ____exports.YDWEGetUnitAbilityState(u, abilcode, state_type)
    return japi.EXGetAbilityState(
        japi.EXGetUnitAbility(u, abilcode),
        state_type
    )
end
function ____exports.YDWEGetUnitAbilityDataInteger(u, abilcode, level, data_type)
    return japi.EXGetAbilityDataInteger(
        japi.EXGetUnitAbility(u, abilcode),
        level,
        data_type
    )
end
function ____exports.YDWEGetUnitAbilityDataReal(u, abilcode, level, data_type)
    return japi.EXGetAbilityDataReal(
        japi.EXGetUnitAbility(u, abilcode),
        level,
        data_type
    )
end
function ____exports.YDWEGetUnitAbilityDataString(u, abilcode, level, data_type)
    return japi.EXGetAbilityDataString(
        japi.EXGetUnitAbility(u, abilcode),
        level,
        data_type
    )
end
function ____exports.YDWESetUnitAbilityState(u, abilcode, state_type, value)
    return japi.EXSetAbilityState(
        japi.EXGetUnitAbility(u, abilcode),
        state_type,
        value
    )
end
function ____exports.YDWESetUnitAbilityDataInteger(u, abilcode, level, data_type, value)
    return japi.EXSetAbilityDataInteger(
        japi.EXGetUnitAbility(u, abilcode),
        level,
        data_type,
        value
    )
end
function ____exports.YDWESetUnitAbilityDataReal(u, abilcode, level, data_type, value)
    return japi.EXSetAbilityDataReal(
        japi.EXGetUnitAbility(u, abilcode),
        level,
        data_type,
        value
    )
end
function ____exports.YDWESetUnitAbilityDataString(u, abilcode, level, data_type, value)
    return japi.EXSetAbilityDataString(
        japi.EXGetUnitAbility(u, abilcode),
        level,
        data_type,
        value
    )
end
function ____exports.EXSetAbilityAEmeDataA(abil, unitid)
    return japi.EXSetAbilityAEmeDataA(abil, unitid)
end
function ____exports.YDWEUnitTransform(u, abilcode, targetid)
    jass.UnitAddAbility(u, abilcode)
    japi.EXSetAbilityDataInteger(
        japi.EXGetUnitAbility(u, abilcode),
        1,
        ____exports.ABILITY_DATA_UNITID,
        jass.GetUnitTypeId(u)
    )
    japi.EXSetAbilityAEmeDataA(
        japi.EXGetUnitAbility(u, abilcode),
        jass.GetUnitTypeId(u)
    )
    jass.UnitRemoveAbility(u, abilcode)
    jass.UnitAddAbility(u, abilcode)
    japi.EXSetAbilityAEmeDataA(
        japi.EXGetUnitAbility(u, abilcode),
        targetid
    )
    jass.UnitRemoveAbility(u, abilcode)
end
function ____exports.YDWEGetItemDataString(itemcode, data_type)
    return japi.EXGetItemDataString(itemcode, data_type)
end
function ____exports.YDWESetItemDataString(itemcode, data_type, value)
    return japi.EXSetItemDataString(itemcode, data_type, value)
end
return ____exports
