local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local ____exports = {}
local jass = require("jass.common")
local japi = require("jass.japi")
local jglobals = require("jass.globals")
local slk = require("jass.slk")
local function hashHandle(self)
    local g = _G
    local function pick(____, name)
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
    local ____pick_result_0 = pick(nil, "StarBaseHT")
    if ____pick_result_0 == nil then
        ____pick_result_0 = pick(nil, "YDHASH_HANDLE")
    end
    local ____pick_result_0_1 = ____pick_result_0
    if ____pick_result_0_1 == nil then
        ____pick_result_0_1 = pick(nil, "YDHT")
    end
    local ____pick_result_0_1_2 = ____pick_result_0_1
    if ____pick_result_0_1_2 == nil then
        ____pick_result_0_1_2 = pick(nil, "udg_YDHASH_HANDLE")
    end
    local ____pick_result_0_1_2_3 = ____pick_result_0_1_2
    if ____pick_result_0_1_2_3 == nil then
        ____pick_result_0_1_2_3 = pick(nil, "udg_YDHT")
    end
    return ____pick_result_0_1_2_3
end
local function h2i(self, u)
    return type(jass.GetHandleId) == "function" and (jass.GetHandleId(u) or 0) or 0
end
local function sh(self, name)
    return type(jass.StringHash) == "function" and (jass.StringHash(name) or 0) or 0
end
local function loadReal(self, u, key)
    local hh = hashHandle(nil)
    if not hh or type(jass.LoadReal) ~= "function" then
        return 0
    end
    return jass.LoadReal(
        hh,
        h2i(nil, u),
        key
    ) or 0
end
local function saveReal(self, u, key, value)
    local hh = hashHandle(nil)
    if not hh or type(jass.SaveReal) ~= "function" then
        return
    end
    jass.SaveReal(
        hh,
        h2i(nil, u),
        key,
        value
    )
end
local function resolveAbilityCode(self, raw)
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
    local g = _G
    if type(g.FourCC) == "function" then
        return g:FourCC(raw) or 0
    end
    if type(jass.FourCC) == "function" then
        return jass.FourCC(raw) or 0
    end
    if #raw == 4 then
        return (string.byte(raw, 1) or 0 / 0) * 16777216 + (string.byte(raw, 2) or 0 / 0) * 65536 + (string.byte(raw, 3) or 0 / 0) * 256 + (string.byte(raw, 4) or 0 / 0)
    end
    return 0
end
local function setAbilityDataA(self, u, raw, value)
    local code = resolveAbilityCode(nil, raw)
    if not u or code == 0 then
        return
    end
    if type(jass.GetUnitAbilityLevel) == "function" and type(jass.UnitAddAbility) == "function" and jass.GetUnitAbilityLevel(u, code) == 0 then
        jass.UnitAddAbility(u, code)
    end
    if type(japi.EXGetUnitAbility) == "function" and type(japi.EXSetAbilityDataReal) == "function" then
        local abil = japi.EXGetUnitAbility(u, code)
        if abil then
            japi.EXSetAbilityDataReal(abil, 1, 108, value)
        end
    end
    if type(jass.IncUnitAbilityLevel) == "function" then
        jass.IncUnitAbilityLevel(u, code)
    end
    if type(jass.DecUnitAbilityLevel) == "function" then
        jass.DecUnitAbilityLevel(u, code)
    end
end
local function setAbilityDataABC(self, u, raw, a, b, c)
    local code = resolveAbilityCode(nil, raw)
    if not u or code == 0 then
        return
    end
    if type(jass.GetUnitAbilityLevel) == "function" and type(jass.UnitAddAbility) == "function" and jass.GetUnitAbilityLevel(u, code) == 0 then
        jass.UnitAddAbility(u, code)
    end
    if type(japi.EXGetUnitAbility) == "function" and type(japi.EXSetAbilityDataReal) == "function" then
        local abil = japi.EXGetUnitAbility(u, code)
        if abil then
            japi.EXSetAbilityDataReal(abil, 1, 110, a)
            japi.EXSetAbilityDataReal(abil, 1, 108, b)
            japi.EXSetAbilityDataReal(abil, 1, 109, c)
        end
    end
    if type(jass.IncUnitAbilityLevel) == "function" then
        jass.IncUnitAbilityLevel(u, code)
    end
    if type(jass.DecUnitAbilityLevel) == "function" then
        jass.DecUnitAbilityLevel(u, code)
    end
end
local function setAtk(self, u, v)
    local key = sh(nil, "攻击")
    local next = loadReal(nil, u, key) + v
    setAbilityDataA(nil, u, "ASG1", next)
    saveReal(nil, u, key, next)
end
local function setArmor(self, u, v)
    local key = sh(nil, "护甲")
    local next = loadReal(nil, u, key) + v
    setAbilityDataA(nil, u, "ASG2", next)
    saveReal(nil, u, key, next)
end
local function setState3(self, u, s, a, i)
    local ks = sh(nil, "力量")
    local ka = sh(nil, "敏捷")
    local ki = sh(nil, "智力")
    local ns = loadReal(nil, u, ks) + s
    local na = loadReal(nil, u, ka) + a
    local ni = loadReal(nil, u, ki) + i
    if type(jass.IsUnitType) == "function" and type(jass.UNIT_TYPE_HERO) ~= "nil" and jass.IsUnitType(u, jass.UNIT_TYPE_HERO) then
        if type(jass.GetHeroStr) == "function" and type(jass.SetHeroStr) == "function" then
            local cur = jass.GetHeroStr(u, true) or 0
            jass.SetHeroStr(u, cur + s, true)
        end
        if type(jass.GetHeroAgi) == "function" and type(jass.SetHeroAgi) == "function" then
            local cur = jass.GetHeroAgi(u, true) or 0
            jass.SetHeroAgi(u, cur + a, true)
        end
        if type(jass.GetHeroInt) == "function" and type(jass.SetHeroInt) == "function" then
            local cur = jass.GetHeroInt(u, true) or 0
            jass.SetHeroInt(u, cur + i, true)
        end
    else
        setAbilityDataABC(
            nil,
            u,
            "ASG3",
            ns,
            na,
            ni
        )
    end
    saveReal(nil, u, ks, ns)
    saveReal(nil, u, ka, na)
    saveReal(nil, u, ki, ni)
end
local function setHp(self, u, v)
    if type(jass.GetUnitState) ~= "function" or type(jass.SetUnitState) ~= "function" then
        return
    end
    local key = sh(nil, "生命")
    local oldAdd = loadReal(nil, u, key)
    local oldMax = jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE)
    local oldLife = jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    local ratio = oldMax > 0.405 and oldLife / oldMax or 1
    local newAdd = oldAdd + v
    local newMax = oldMax - oldAdd + newAdd
    jass.SetUnitState(u, jass.UNIT_STATE_MAX_LIFE, newMax)
    if oldLife > 0.405 then
        jass.SetUnitState(u, jass.UNIT_STATE_LIFE, newMax * ratio)
    end
    saveReal(nil, u, key, newAdd)
end
local function setMp(self, u, v)
    if type(jass.GetUnitState) ~= "function" or type(jass.SetUnitState) ~= "function" then
        return
    end
    local key = sh(nil, "法力")
    local oldAdd = loadReal(nil, u, key)
    local oldMax = jass.GetUnitState(u, jass.UNIT_STATE_MAX_MANA)
    local oldMana = jass.GetUnitState(u, jass.UNIT_STATE_MANA)
    local ratio = oldMax > 0 and oldMana / oldMax or 1
    local newAdd = oldAdd + v
    local newMax = oldMax - oldAdd + newAdd
    jass.SetUnitState(u, jass.UNIT_STATE_MAX_MANA, newMax)
    jass.SetUnitState(u, jass.UNIT_STATE_MANA, newMax * ratio)
    saveReal(nil, u, key, newAdd)
end
local function setMove(self, u, v)
    local key = sh(nil, "移速")
    local next = loadReal(nil, u, key) + v
    setAbilityDataA(nil, u, "ASG6", next)
    saveReal(nil, u, key, next)
end
local function setAtkSpeed(self, u, v)
    local key = sh(nil, "攻速")
    local next = loadReal(nil, u, key) + v
    setAbilityDataA(nil, u, "ASG7", next)
    saveReal(nil, u, key, next)
end
function ____exports.SGSS_SetState(self, u, id, v)
    if id == 1 then
        setAtk(nil, u, v)
    elseif id == 2 then
        setArmor(nil, u, v)
    elseif id == 3 then
        setState3(
            nil,
            u,
            v,
            0,
            0
        )
    elseif id == 4 then
        setState3(
            nil,
            u,
            0,
            v,
            0
        )
    elseif id == 5 then
        setState3(
            nil,
            u,
            0,
            0,
            v
        )
    elseif id == 6 then
        setState3(
            nil,
            u,
            v,
            v,
            v
        )
    elseif id == 7 then
        setHp(nil, u, v)
    elseif id == 8 then
        setMp(nil, u, v)
    elseif id == 9 then
        setMove(nil, u, v)
    elseif id == 10 then
        setAtkSpeed(nil, u, v)
    end
end
function ____exports.SGSS_SetStatePercentumEX2(self, u, id, v)
    local hpPct = sh(nil, "生命值百分比加成")
    local hpAdd = sh(nil, "生命值百分比加成增值")
    local mpPct = sh(nil, "法力值百分比加成")
    local mpAdd = sh(nil, "法力值百分比加成增值")
    if id == 7 and type(jass.GetUnitState) == "function" then
        local pv = loadReal(nil, u, hpPct)
        local av = loadReal(nil, u, hpAdd)
        local base = jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE) - av
        local npv = pv + v
        local nav = base * npv
        if av ~= nav then
            setHp(nil, u, -av)
            saveReal(nil, u, hpPct, npv)
            saveReal(nil, u, hpAdd, nav)
            setHp(nil, u, nav)
        end
    elseif id == 8 and type(jass.GetUnitState) == "function" then
        local pv = loadReal(nil, u, mpPct)
        local av = loadReal(nil, u, mpAdd)
        local base = jass.GetUnitState(u, jass.UNIT_STATE_MAX_MANA) - av
        local npv = pv + v
        local nav = base * npv
        if av ~= nav then
            setMp(nil, u, -av)
            saveReal(nil, u, mpPct, npv)
            saveReal(nil, u, mpAdd, nav)
            setMp(nil, u, nav)
        end
    end
end
return ____exports
