local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
--- 单位狂暴：装备掉落表里 berserk 非空的单位死亡时，按默认 6.25% 概率在原地创建指定单位、继承面向，并震动击杀者镜头。
-- 面向与镜头震动通过 JASS 全局 udg_TempUnit/udg_TempReal/udg_TempPlayer 调用 SetUnitFacingAndCameraNoise。
local jass = require("jass.common")
local g = require("jass.globals")
local idData = require("系统.装备.装备掉落表").default or ({})
local function stringToFourCC(self, s)
    local b1 = string.byte(s, 1)
    local b2 = string.byte(s, 2)
    local b3 = string.byte(s, 3)
    local b4 = string.byte(s, 4)
    return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4
end
local function typeIdToUnitId(self, typeId)
    for id in pairs(idData) do
        if stringToFourCC(nil, id) == typeId then
            return id
        end
    end
    return nil
end
local function onDeath(self)
    local dying = jass.GetTriggerUnit()
    if not dying then
        return
    end
    if type(jass.GetUnitTypeId) ~= "function" then
        return
    end
    local typeId = jass.GetUnitTypeId(dying)
    local unitId = typeIdToUnitId(nil, typeId)
    local entry = unitId and idData[unitId] or nil
    local berserkRaw = entry and entry.berserk
    if berserkRaw == nil then
        return
    end
    local berserkId = __TS__StringTrim(tostring(berserkRaw))
    if berserkId == "" then
        return
    end
    local BERSERK_PROC = 0.0625
    if math.random(1, 10000) > BERSERK_PROC * 10000 then
        return
    end
    local x = 0
    local y = 0
    local facingDeg = 270
    if type(jass.GetUnitX) == "function" and type(jass.GetUnitY) == "function" then
        x = jass.GetUnitX(dying)
        y = jass.GetUnitY(dying)
    end
    if type(jass.GetUnitFacingDegrees) == "function" then
        facingDeg = jass.GetUnitFacingDegrees(dying)
    elseif type(jass.GetUnitFacing) == "function" then
        facingDeg = jass.GetUnitFacing(dying) * (180 / 3.14159265359)
    end
    local four = stringToFourCC(
        nil,
        __TS__StringSubstring(berserkId, 0, 4)
    )
    local ____temp_2
    if type(jass.GetOwningPlayer) == "function" then
        ____temp_2 = jass.GetOwningPlayer(dying)
    else
        ____temp_2 = jass.Player(15)
    end
    local owner = ____temp_2
    local created = nil
    if type(jass.CreateUnit) == "function" then
        created = jass.CreateUnit(
            owner,
            four,
            x,
            y,
            facingDeg
        )
    end
    local ____temp_3
    if type(jass.GetKillingUnit) == "function" then
        ____temp_3 = jass.GetKillingUnit()
    else
        ____temp_3 = nil
    end
    local killer = ____temp_3
    local ____temp_4
    if killer and type(jass.GetOwningPlayer) == "function" then
        ____temp_4 = jass.GetOwningPlayer(killer)
    else
        ____temp_4 = nil
    end
    local killerPlayer = ____temp_4
    if created and killerPlayer then
        g.udg_TempUnit = created
        g.udg_TempFacing = facingDeg
        g.udg_TempPlayer = killerPlayer
        jass.ExecuteFunc("UnitBerserk")
    end
end
local function init(self)
    local trig = jass.CreateTrigger()
    local ____jass_EVENT_PLAYER_UNIT_DEATH_5 = jass.EVENT_PLAYER_UNIT_DEATH
    if ____jass_EVENT_PLAYER_UNIT_DEATH_5 == nil then
        ____jass_EVENT_PLAYER_UNIT_DEATH_5 = 52
    end
    local eventId = ____jass_EVENT_PLAYER_UNIT_DEATH_5
    do
        local i = 0
        while i < 16 do
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                eventId,
                nil
            )
            i = i + 1
        end
    end
    local ____this_8
    ____this_8 = jass
    local ____opt_6 = ____this_8.Player
    if ____opt_6 ~= nil then
        local ____jass_PLAYER_NEUTRAL_AGGRESSIVE_7 = jass.PLAYER_NEUTRAL_AGGRESSIVE
        if ____jass_PLAYER_NEUTRAL_AGGRESSIVE_7 == nil then
            ____jass_PLAYER_NEUTRAL_AGGRESSIVE_7 = 12
        end
        ____opt_6 = ____opt_6(____this_8, ____jass_PLAYER_NEUTRAL_AGGRESSIVE_7)
    end
    local neutral = ____opt_6
    if neutral ~= nil then
        jass.TriggerRegisterPlayerUnitEvent(trig, neutral, eventId, nil)
    end
    local ____this_11
    ____this_11 = jass
    local ____opt_9 = ____this_11.Player
    if ____opt_9 ~= nil then
        local ____jass_PLAYER_NEUTRAL_PASSIVE_10 = jass.PLAYER_NEUTRAL_PASSIVE
        if ____jass_PLAYER_NEUTRAL_PASSIVE_10 == nil then
            ____jass_PLAYER_NEUTRAL_PASSIVE_10 = 15
        end
        ____opt_9 = ____opt_9(____this_11, ____jass_PLAYER_NEUTRAL_PASSIVE_10)
    end
    local neutralPassive = ____opt_9
    if neutralPassive ~= nil then
        jass.TriggerRegisterPlayerUnitEvent(trig, neutralPassive, eventId, nil)
    end
    jass.TriggerAddAction(trig, onDeath)
end
init(nil)
return ____exports
