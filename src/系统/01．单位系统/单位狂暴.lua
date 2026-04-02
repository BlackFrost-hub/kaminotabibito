local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
--- 单位狂暴：装备掉落表里 `berserkUnit`（旧名 `berserk`）非空的单位死亡时，按默认 6.25% 概率在原地创建该四码单位、继承面向，并震动击杀者镜头。
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．封装函数")
local stringToFourCC = ____require_result_0.stringToFourCC
local ____require_result_1 = require("系统.00．核心系统.12．YDWE函数")
local EXSetUnitFacing = ____require_result_1.EXSetUnitFacing
local ____require_result_2 = require("系统.00．核心系统.13．镜头函数")
local CameraShakeForPlayer = ____require_result_2.CameraShakeForPlayer
local idData = require("系统.02．物品系统.02．装备掉落表").default or ({})
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
    local spawnRaw = entry and entry.berserkUnit or entry and entry.berserk
    if spawnRaw == nil then
        return
    end
    local spawnUnitId = __TS__StringTrim(tostring(spawnRaw))
    if spawnUnitId == "" then
        return
    end
    local BERSERK_PROC = 1
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
        __TS__StringSubstring(spawnUnitId, 0, 4)
    )
    local ____temp_7
    if type(jass.GetOwningPlayer) == "function" then
        ____temp_7 = jass.GetOwningPlayer(dying)
    else
        ____temp_7 = jass.Player(15)
    end
    local owner = ____temp_7
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
    local ____temp_8
    if type(jass.GetKillingUnit) == "function" then
        ____temp_8 = jass.GetKillingUnit()
    else
        ____temp_8 = nil
    end
    local killer = ____temp_8
    local ____temp_9
    if killer and type(jass.GetOwningPlayer) == "function" then
        ____temp_9 = jass.GetOwningPlayer(killer)
    else
        ____temp_9 = nil
    end
    local killerPlayer = ____temp_9
    if created and killerPlayer then
        EXSetUnitFacing(nil, created, facingDeg)
        CameraShakeForPlayer(nil, killerPlayer, 20, 3)
    end
end
local function init(self)
    local trig = jass.CreateTrigger()
    local ____jass_EVENT_PLAYER_UNIT_DEATH_10 = jass.EVENT_PLAYER_UNIT_DEATH
    if ____jass_EVENT_PLAYER_UNIT_DEATH_10 == nil then
        ____jass_EVENT_PLAYER_UNIT_DEATH_10 = 52
    end
    local eventId = ____jass_EVENT_PLAYER_UNIT_DEATH_10
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
    local ____this_13
    ____this_13 = jass
    local ____opt_11 = ____this_13.Player
    if ____opt_11 ~= nil then
        local ____jass_PLAYER_NEUTRAL_AGGRESSIVE_12 = jass.PLAYER_NEUTRAL_AGGRESSIVE
        if ____jass_PLAYER_NEUTRAL_AGGRESSIVE_12 == nil then
            ____jass_PLAYER_NEUTRAL_AGGRESSIVE_12 = 12
        end
        ____opt_11 = ____opt_11(____this_13, ____jass_PLAYER_NEUTRAL_AGGRESSIVE_12)
    end
    local neutral = ____opt_11
    if neutral ~= nil then
        jass.TriggerRegisterPlayerUnitEvent(trig, neutral, eventId, nil)
    end
    local ____this_16
    ____this_16 = jass
    local ____opt_14 = ____this_16.Player
    if ____opt_14 ~= nil then
        local ____jass_PLAYER_NEUTRAL_PASSIVE_15 = jass.PLAYER_NEUTRAL_PASSIVE
        if ____jass_PLAYER_NEUTRAL_PASSIVE_15 == nil then
            ____jass_PLAYER_NEUTRAL_PASSIVE_15 = 15
        end
        ____opt_14 = ____opt_14(____this_16, ____jass_PLAYER_NEUTRAL_PASSIVE_15)
    end
    local neutralPassive = ____opt_14
    if neutralPassive ~= nil then
        jass.TriggerRegisterPlayerUnitEvent(trig, neutralPassive, eventId, nil)
    end
    jass.TriggerAddAction(trig, onDeath)
end
init(nil)
return ____exports
