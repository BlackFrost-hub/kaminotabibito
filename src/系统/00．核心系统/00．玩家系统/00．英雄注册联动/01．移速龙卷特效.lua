local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
--- 玩家系统 - 英雄注册联动 - 移速龙卷特效
-- 职责：
-- - 移速>阈值时挂载龙卷提示特效，<=阈值时移除
-- - 使用Map(unitHandleId -> effectHandle)避免重复创建/销毁
-- - 单位离开英雄组时自动清理特效
-- 接入：由"玩家英雄获取桥接"在获得英雄时注册，周期同步只处理已注册英雄
-- 这里的安全检查是必须的，无视全局规则，2026年4月21日21:29:21
local jass = require("jass.common")
local japi = require("jass.japi")
local C = require("系统.00．核心系统.00．玩家系统.00．常量")
local trackedHeroes = __TS__New(Map)
local tornadoEffects = __TS__New(Map)
local function isValidHandle(handle)
    return handle ~= nil and handle ~= 0
end
local function getHandleId(handle)
    if not isValidHandle(handle) then
        return 0
    end
    return jass.GetHandleId(handle) or 0
end
local function _____83B7_53D6_6709_5E8F_82F1_96C4ID_5217_8868()
    local result = {}
    for ____, heroId in __TS__Iterator(trackedHeroes:keys()) do
        result[#result + 1] = heroId
    end
    __TS__ArraySort(
        result,
        function(____, a, b) return a - b end
    )
    return result
end
local function createTornadoEffect(whichUnit)
    return jass.AddSpecialEffectTarget(C.TORNADO_EFFECT_MODEL, whichUnit, C.TORNADO_ATTACH_POINT)
end
local function destroyTornadoEffect(effect)
    if not isValidHandle(effect) then
        return
    end
    jass.DestroyEffect(effect)
end
local function removeTrackedHero(heroId)
    trackedHeroes:delete(heroId)
    local effect = tornadoEffects:get(heroId)
    if effect ~= nil then
        destroyTornadoEffect(effect)
        tornadoEffects:delete(heroId)
    end
end
--- 由英雄注册桥接调用。
-- 当某个玩家英雄被确认后，把它加入龙卷特效跟踪表。
function ____exports.registerMoveSpeedTornadoHero(whichHero)
    if not isValidHandle(whichHero) then
        return
    end
    local heroId = getHandleId(whichHero)
    if heroId == 0 then
        return
    end
    trackedHeroes:set(heroId, whichHero)
end
--- 周期同步已注册英雄的移速特效状态。
-- 这里只处理“已被桥接模块确认过”的英雄，不再自己扫描全局英雄组。
function ____exports.syncTornadoSpeedEffectsByRegisteredHeroes()
    local heroIds = _____83B7_53D6_6709_5E8F_82F1_96C4ID_5217_8868()
    do
        local i = 0
        while i < #heroIds do
            do
                local heroId = heroIds[i + 1]
                local hero = trackedHeroes:get(heroId)
                if hero == nil then
                    goto __continue19
                end
                if not isValidHandle(hero) or jass.IsUnitType(hero, jass.UNIT_TYPE_DEAD) == true then
                    removeTrackedHero(heroId)
                    goto __continue19
                end
                local moveSpeed = jass.GetUnitMoveSpeed(hero) or 0
                local shouldHaveEffect = moveSpeed > C.MOVE_SPEED_THRESHOLD
                local currentEffect = tornadoEffects:get(heroId)
                if shouldHaveEffect then
                    if currentEffect == nil then
                        local effect = createTornadoEffect(hero)
                        if effect ~= nil then
                            tornadoEffects:set(heroId, effect)
                        end
                    end
                    goto __continue19
                end
                if currentEffect ~= nil then
                    destroyTornadoEffect(currentEffect)
                    tornadoEffects:delete(heroId)
                end
            end
            ::__continue19::
            i = i + 1
        end
    end
end
return ____exports
