local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local jglobals = require("jass.globals")
local slk = require("jass.slk")
local GetHandleId = jass.GetHandleId
local StringHash = jass.StringHash
local LoadReal = jass.LoadReal
local SaveReal = jass.SaveReal
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local UnitAddAbility = jass.UnitAddAbility
local IncUnitAbilityLevel = jass.IncUnitAbilityLevel
local DecUnitAbilityLevel = jass.DecUnitAbilityLevel
local GetUnitState = jass.GetUnitState
local SetUnitStateJass = jass.SetUnitState
local SetUnitStateJapi = japi.SetUnitState
local EXGetUnitAbility = japi.EXGetUnitAbility
local EXSetAbilityDataReal = japi.EXSetAbilityDataReal
local function hashHandle()
    local g = _G
    local function pick(name)
        if g[name] ~= nil then
            return g[name]
        end
        if jglobals and jglobals[name] ~= nil then
            return jglobals[name]
        end
        if jass and jass[name] ~= nil then
            return jass[name]
        end
        return nil
    end
    local ____pick_result_0 = pick("StarBaseHT")
    if ____pick_result_0 == nil then
        ____pick_result_0 = pick("YDHASH_HANDLE")
    end
    local ____pick_result_0_1 = ____pick_result_0
    if ____pick_result_0_1 == nil then
        ____pick_result_0_1 = pick("YDHT")
    end
    local ____pick_result_0_1_2 = ____pick_result_0_1
    if ____pick_result_0_1_2 == nil then
        ____pick_result_0_1_2 = pick("udg_YDHASH_HANDLE")
    end
    local ____pick_result_0_1_2_3 = ____pick_result_0_1_2
    if ____pick_result_0_1_2_3 == nil then
        ____pick_result_0_1_2_3 = pick("udg_YDHT")
    end
    return ____pick_result_0_1_2_3
end
local function h2i(u)
    return GetHandleId(u) or 0
end
local function sh(name)
    return StringHash(name) or 0
end
local function loadReal(u, key)
    local hh = hashHandle()
    if not hh then
        return 0
    end
    return LoadReal(
        hh,
        h2i(u),
        key
    ) or 0
end
local function saveReal(u, key, value)
    local hh = hashHandle()
    if not hh then
        return
    end
    SaveReal(
        hh,
        h2i(u),
        key,
        value
    )
end
local function resolveAbilityCode(raw)
    local ____temp_4
    if slk and slk.ability then
        ____temp_4 = slk.ability[raw]
    else
        ____temp_4 = nil
    end
    local abilityTable = ____temp_4
    if abilityTable then
        local fromId = __TS__Number(abilityTable.id)
        if not __TS__NumberIsNaN(__TS__Number(fromId)) and fromId > 0 then
            return fromId
        end
        local fromObj = __TS__Number(abilityTable._id)
        if not __TS__NumberIsNaN(__TS__Number(fromObj)) and fromObj > 0 then
            return fromObj
        end
    end
    if #raw == 4 then
        return (string.byte(raw, 1) or 0 / 0) * 16777216 + (string.byte(raw, 2) or 0 / 0) * 65536 + (string.byte(raw, 3) or 0 / 0) * 256 + (string.byte(raw, 4) or 0 / 0)
    end
    return 0
end
local function setAbilityDataA(u, raw, value)
    local code = resolveAbilityCode(raw)
    if not u or code == 0 then
        return
    end
    if GetUnitAbilityLevel(u, code) == 0 then
        UnitAddAbility(u, code)
    end
    local abil = EXGetUnitAbility(u, code)
    if abil then
        EXSetAbilityDataReal(abil, 1, 108, value)
    end
    IncUnitAbilityLevel(u, code)
    DecUnitAbilityLevel(u, code)
end
local function setAbilityDataABC(u, raw, a, b, c)
    local code = resolveAbilityCode(raw)
    if not u or code == 0 then
        return
    end
    if GetUnitAbilityLevel(u, code) == 0 then
        UnitAddAbility(u, code)
    end
    local abil = EXGetUnitAbility(u, code)
    if abil then
        EXSetAbilityDataReal(abil, 1, 110, a)
        EXSetAbilityDataReal(abil, 1, 108, b)
        EXSetAbilityDataReal(abil, 1, 109, c)
    end
    IncUnitAbilityLevel(u, code)
    DecUnitAbilityLevel(u, code)
end
local function setAtk(u, v)
    local key = sh("攻击")
    local next = loadReal(u, key) + v
    setAbilityDataA(u, "ASG1", next)
    saveReal(u, key, next)
end
local function setArmor(u, v)
    local key = sh("护甲")
    local next = loadReal(u, key) + v
    setAbilityDataA(u, "ASG2", next)
    saveReal(u, key, next)
end
local function setState3(u, s, a, i)
    local ks = sh("力量")
    local ka = sh("敏捷")
    local ki = sh("智力")
    local ns = loadReal(u, ks) + s
    local na = loadReal(u, ka) + a
    local ni = loadReal(u, ki) + i
    setAbilityDataABC(
        u,
        "ASG3",
        ns,
        na,
        ni
    )
    saveReal(u, ks, ns)
    saveReal(u, ka, na)
    saveReal(u, ki, ni)
end
local function setHp(u, v)
    local key = sh("生命")
    local oldAdd = loadReal(u, key)
    local oldMax = GetUnitState(u, jass.UNIT_STATE_MAX_LIFE)
    local oldLife = GetUnitState(u, jass.UNIT_STATE_LIFE)
    local ratio = oldMax > 0.405 and oldLife / oldMax or 1
    local newAdd = oldAdd + v
    local newMax = oldMax - oldAdd + newAdd
    SetUnitStateJapi(u, jass.UNIT_STATE_MAX_LIFE, newMax)
    if oldLife > 0.405 then
        SetUnitStateJass(u, jass.UNIT_STATE_LIFE, newMax * ratio)
    end
    saveReal(u, key, newAdd)
end
local function setMp(u, v)
    local key = sh("法力")
    local oldAdd = loadReal(u, key)
    local oldMax = GetUnitState(u, jass.UNIT_STATE_MAX_MANA)
    local oldMana = GetUnitState(u, jass.UNIT_STATE_MANA)
    local ratio = oldMax > 0 and oldMana / oldMax or 1
    local newAdd = oldAdd + v
    local newMax = oldMax - oldAdd + newAdd
    SetUnitStateJapi(u, jass.UNIT_STATE_MAX_MANA, newMax)
    SetUnitStateJass(u, jass.UNIT_STATE_MANA, newMax * ratio)
    saveReal(u, key, newAdd)
end
local function setMove(u, v)
    local key = sh("移速")
    local next = loadReal(u, key) + v
    setAbilityDataA(u, "ASG6", next)
    saveReal(u, key, next)
end
local function setAtkSpeed(u, v)
    local key = sh("攻速")
    local next = loadReal(u, key) + v
    setAbilityDataA(u, "ASG7", next)
    saveReal(u, key, next)
end
function ____exports.SGSS_SetState(u, id, v)
    if id == 1 then
        setAtk(u, v)
    elseif id == 2 then
        setArmor(u, v)
    elseif id == 3 then
        setState3(u, v, 0, 0)
    elseif id == 4 then
        setState3(u, 0, v, 0)
    elseif id == 5 then
        setState3(u, 0, 0, v)
    elseif id == 6 then
        setState3(u, v, v, v)
    elseif id == 7 then
        setHp(u, v)
    elseif id == 8 then
        setMp(u, v)
    elseif id == 9 then
        setMove(u, v)
    elseif id == 10 then
        setAtkSpeed(u, v)
    end
end
function ____exports.SGSS_SetStatePercentumEX2(u, id, v)
    local hpPct = sh("生命值百分比加成")
    local hpAdd = sh("生命值百分比加成增值")
    local mpPct = sh("法力值百分比加成")
    local mpAdd = sh("法力值百分比加成增值")
    if id == 7 then
        local pv = loadReal(u, hpPct)
        local av = loadReal(u, hpAdd)
        local base = GetUnitState(u, jass.UNIT_STATE_MAX_LIFE) - av
        local npv = pv + v
        local nav = base * npv
        if av ~= nav then
            setHp(u, -av)
            saveReal(u, hpPct, npv)
            saveReal(u, hpAdd, nav)
            setHp(u, nav)
        end
    elseif id == 8 then
        local pv = loadReal(u, mpPct)
        local av = loadReal(u, mpAdd)
        local base = GetUnitState(u, jass.UNIT_STATE_MAX_MANA) - av
        local npv = pv + v
        local nav = base * npv
        if av ~= nav then
            setMp(u, -av)
            saveReal(u, mpPct, npv)
            saveReal(u, mpAdd, nav)
            setMp(u, nav)
        end
    end
end
return ____exports
