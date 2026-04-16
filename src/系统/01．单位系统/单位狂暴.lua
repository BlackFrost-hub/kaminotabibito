local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
--- 单位狂暴：装备掉落表里 `berserkUnit`（旧名 `berserk`）非空的单位死亡时，按默认 6.25% 概率在原地创建该四码单位、继承面向，并震动击杀者镜头。
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_0.stringToFourCC
local ____require_result_1 = require("lib.扩展函数.YDWE函数.index")
local EXSetUnitFacing = ____require_result_1.EXSetUnitFacing
local ____require_result_2 = require("lib.扩展函数.封装函数.07．镜头函数.index")
local CameraShakeForPlayer = ____require_result_2.CameraShakeForPlayer
local ____require_result_3 = require("系统.01．单位系统.03．单位死亡事件.01．核心功能")
local registerDeathListener = ____require_result_3.registerDeathListener
local idData = require("系统.02．物品系统.02．装备掉落表").default or ({})
local function typeIdToUnitId(self, typeId)
    for id in pairs(idData) do
        if stringToFourCC(nil, id) == typeId then
            return id
        end
    end
    return nil
end
local function onDeath(self, dying, killer)
    if dying == nil then
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
    local ____temp_8
    if type(jass.GetOwningPlayer) == "function" then
        ____temp_8 = jass.GetOwningPlayer(dying)
    else
        ____temp_8 = jass.Player(15)
    end
    local owner = ____temp_8
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
registerDeathListener(nil, onDeath)
return ____exports
