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
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_3.registerDeathListener
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_4["创建单位并登记排泄安全"]
local idData = require("系统.02．物品系统.02．装备掉落表").default or ({})
local function typeIdToUnitId(typeId)
    for id in pairs(idData) do
        if stringToFourCC(id) == typeId then
            return id
        end
    end
    return nil
end
local function onDeath(dying, killer)
    if dying == nil then
        return
    end
    local typeId = jass.GetUnitTypeId(dying)
    local unitId = typeIdToUnitId(typeId)
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
    if jass.GetRandomInt(1, 10000) > BERSERK_PROC * 10000 then
        return
    end
    local x = 0
    local y = 0
    local facingDeg = 270
    x = jass.GetUnitX(dying)
    y = jass.GetUnitY(dying)
    facingDeg = jass.GetUnitFacing(dying) * (180 / 3.14159265359)
    local four = stringToFourCC(__TS__StringSubstring(spawnUnitId, 0, 4))
    local owner = jass.GetOwningPlayer(dying)
    local created = nil
    created = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        owner,
        four,
        x,
        y,
        facingDeg
    )
    local ____killer_9
    if killer then
        ____killer_9 = jass.GetOwningPlayer(killer)
    else
        ____killer_9 = nil
    end
    local killerPlayer = ____killer_9
    if created and killerPlayer then
        EXSetUnitFacing(nil, created, facingDeg)
        CameraShakeForPlayer(killerPlayer, 20, 3)
    end
end
registerDeathListener(onDeath)
return ____exports
