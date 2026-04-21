local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
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
local function isValidHandle(self, handle)
    return handle ~= nil and handle ~= 0
end
local function getHandleId(self, handle)
    if not isValidHandle(nil, handle) then
        return 0
    end
    return jass.GetHandleId(handle) or 0
end
local function createTornadoEffect(self, whichUnit)
    return jass.AddSpecialEffectTarget(C.TORNADO_EFFECT_MODEL, whichUnit, C.TORNADO_ATTACH_POINT)
end
local function destroyTornadoEffect(self, effect)
    if not isValidHandle(nil, effect) then
        return
    end
    if type(japi.DzUnbindEffect) == "function" then
        japi.DzUnbindEffect(effect)
    end
    jass.DestroyEffect(effect)
end
local function removeTrackedHero(self, heroId)
    trackedHeroes:delete(heroId)
    local effect = tornadoEffects:get(heroId)
    if effect ~= nil then
        destroyTornadoEffect(nil, effect)
        tornadoEffects:delete(heroId)
    end
end
--- 由英雄注册桥接调用。
-- 当某个玩家英雄被确认后，把它加入龙卷特效跟踪表。
function ____exports.registerMoveSpeedTornadoHero(self, whichHero)
    if not isValidHandle(nil, whichHero) then
        return
    end
    local heroId = getHandleId(nil, whichHero)
    if heroId == 0 then
        return
    end
    trackedHeroes:set(heroId, whichHero)
end
--- 周期同步已注册英雄的移速特效状态。
-- 这里只处理“已被桥接模块确认过”的英雄，不再自己扫描全局英雄组。
function ____exports.syncTornadoSpeedEffectsByRegisteredHeroes(self)
    for ____, ____value in __TS__Iterator(trackedHeroes) do
        local heroId = ____value[1]
        local hero = ____value[2]
        do
            if not isValidHandle(nil, hero) or jass.IsUnitType(hero, jass.UNIT_TYPE_DEAD) == true then
                removeTrackedHero(nil, heroId)
                goto __continue15
            end
            local moveSpeed = jass.GetUnitMoveSpeed(hero) or 0
            local shouldHaveEffect = moveSpeed > C.MOVE_SPEED_THRESHOLD
            local currentEffect = tornadoEffects:get(heroId)
            if shouldHaveEffect then
                if currentEffect == nil then
                    local effect = createTornadoEffect(nil, hero)
                    if effect ~= nil then
                        tornadoEffects:set(heroId, effect)
                    end
                end
                goto __continue15
            end
            if currentEffect ~= nil then
                destroyTornadoEffect(nil, currentEffect)
                tornadoEffects:delete(heroId)
            end
        end
        ::__continue15::
    end
end
return ____exports
