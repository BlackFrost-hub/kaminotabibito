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
function ____exports.EXGetUnitAbility(____self, u, abilcode)
    return japi.EXGetUnitAbility(u, abilcode)
end
function ____exports.EXGetUnitAbilityByIndex(____self, u, index)
    return japi.EXGetUnitAbilityByIndex(u, index)
end
function ____exports.EXGetAbilityId(____self, abil)
    return japi.EXGetAbilityId(abil)
end
function ____exports.EXGetAbilityState(____self, abil, state_type)
    return japi.EXGetAbilityState(abil, state_type)
end
function ____exports.EXSetAbilityState(____self, abil, state_type, value)
    return japi.EXSetAbilityState(abil, state_type, value)
end
function ____exports.EXGetAbilityDataReal(____self, abil, level, data_type)
    return japi.EXGetAbilityDataReal(abil, level, data_type)
end
function ____exports.EXSetAbilityDataReal(____self, abil, level, data_type, value)
    return japi.EXSetAbilityDataReal(abil, level, data_type, value)
end
function ____exports.EXGetAbilityDataInteger(____self, abil, level, data_type)
    return japi.EXGetAbilityDataInteger(abil, level, data_type)
end
function ____exports.EXSetAbilityDataInteger(____self, abil, level, data_type, value)
    return japi.EXSetAbilityDataInteger(abil, level, data_type, value)
end
function ____exports.EXGetAbilityDataString(____self, abil, level, data_type)
    return japi.EXGetAbilityDataString(abil, level, data_type)
end
function ____exports.EXSetAbilityDataString(____self, abil, level, data_type, value)
    return japi.EXSetAbilityDataString(abil, level, data_type, value)
end
function ____exports.EXSetAbilityAEmeDataA(____self, abil, unitid)
    return japi.EXSetAbilityAEmeDataA(abil, unitid)
end
function ____exports.YDWEGetUnitAbilityState(____self, u, abilcode, state_type)
    local a = japi.EXGetUnitAbility(u, abilcode)
    return japi.EXGetAbilityState(a, state_type)
end
function ____exports.YDWEGetUnitAbilityDataInteger(____self, u, abilcode, level, data_type)
    local a = japi.EXGetUnitAbility(u, abilcode)
    return japi.EXGetAbilityDataInteger(a, level, data_type)
end
function ____exports.YDWEGetUnitAbilityDataReal(____self, u, abilcode, level, data_type)
    local a = japi.EXGetUnitAbility(u, abilcode)
    return japi.EXGetAbilityDataReal(a, level, data_type)
end
function ____exports.YDWEGetUnitAbilityDataString(____self, u, abilcode, level, data_type)
    local a = japi.EXGetUnitAbility(u, abilcode)
    return japi.EXGetAbilityDataString(a, level, data_type)
end
function ____exports.YDWESetUnitAbilityState(____self, u, abilcode, state_type, value)
    local a = japi.EXGetUnitAbility(u, abilcode)
    return japi.EXSetAbilityState(a, state_type, value)
end
function ____exports.YDWESetUnitAbilityDataInteger(____self, u, abilcode, level, data_type, value)
    local a = japi.EXGetUnitAbility(u, abilcode)
    return japi.EXSetAbilityDataInteger(a, level, data_type, value)
end
function ____exports.YDWESetUnitAbilityDataReal(____self, u, abilcode, level, data_type, value)
    local a = japi.EXGetUnitAbility(u, abilcode)
    return japi.EXSetAbilityDataReal(a, level, data_type, value)
end
function ____exports.YDWESetUnitAbilityDataString(____self, u, abilcode, level, data_type, value)
    local a = japi.EXGetUnitAbility(u, abilcode)
    return japi.EXSetAbilityDataString(a, level, data_type, value)
end
function ____exports.YDWEUnitTransform(____self, u, abilcode, targetid)
    jass.UnitAddAbility(u, abilcode)
    local a = japi.EXGetUnitAbility(u, abilcode)
    japi.EXSetAbilityDataInteger(
        a,
        1,
        ____exports.ABILITY_DATA_UNITID,
        jass.GetUnitTypeId(u)
    )
    japi.EXSetAbilityAEmeDataA(
        a,
        jass.GetUnitTypeId(u)
    )
    jass.UnitRemoveAbility(u, abilcode)
    jass.UnitAddAbility(u, abilcode)
    local a2 = japi.EXGetUnitAbility(u, abilcode)
    japi.EXSetAbilityAEmeDataA(a2, targetid)
    jass.UnitRemoveAbility(u, abilcode)
end
function ____exports.YDWEGetItemDataString(____self, itemcode, data_type)
    return japi.EXGetItemDataString(itemcode, data_type)
end
function ____exports.YDWESetItemDataString(____self, itemcode, data_type, value)
    return japi.EXSetItemDataString(itemcode, data_type, value)
end
return ____exports
