--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 玩家系统 - 英雄注册联动 - 玩家英雄获取桥接
-- 
-- JASS 侧：
-- - 传参：YDLocal5Set(group, "dwz", someGroup)
-- - 触发：STES_Fire("玩家英雄注册")
-- 
-- Lua 侧职责：
-- - 从传入单位组中筛选玩家 1-5 操作的英雄
-- - 写入 YDUserData("player", whichPlayer, "英雄", "unit")
-- - 在拿到英雄时，把英雄注册到各个依赖它的联动模块
local jass = require("jass.common")
local jglobals = require("jass.globals")
local C = require("系统.00．核心系统.00．玩家系统.00．常量")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataSet = ____require_result_0.YDUserDataSet
local ____require_result_1 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local YDLocal5Get = ____require_result_1.YDLocal5Get
local helper = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
local moveTornado = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．移速龙卷特效")
local petItemHandoff = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.02．背包满移交宠物")
local REG_GUARD = "__syzl_playerHeroRegister_registered"
local TRIG_KEY = "__syzl_playerHeroRegister_trig"
local ATTEMPT_KEY = "__syzl_playerHeroRegister_attempt"
local MAX_REG_ATTEMPTS = 30
local RETRY_SEC = 0.1
local function jassStesHashtable(self)
    local candidates = {jglobals.STES___HT, jglobals.STES_HT, jglobals.udg_STES___HT, jglobals.udg_STES_HT}
    do
        local i = 0
        while i < #candidates do
            local ____table = candidates[i + 1]
            if ____table ~= nil and ____table ~= 0 then
                return ____table
            end
            i = i + 1
        end
    end
    return nil
end
local function countOnJassStesTable(self, eventName)
    local ht = jassStesHashtable(nil)
    if ht == nil or ht == 0 then
        return -1
    end
    if type(jass.StringHash) ~= "function" or type(jass.LoadInteger) ~= "function" then
        return -1
    end
    return jass.LoadInteger(
        ht,
        jass.StringHash(eventName),
        helper:ydlStes_skeyIndex(nil)
    )
end
--- 只接受玩家 1-5 当前操作的英雄。
-- 这里是整条“英雄注册联动”链路的第一层筛选。
local function isPlayableHero(self, whichUnit)
    if whichUnit == nil or whichUnit == 0 then
        return false
    end
    if type(jass.IsUnitType) ~= "function" or type(jass.GetOwningPlayer) ~= "function" or type(jass.GetPlayerId) ~= "function" then
        return false
    end
    if jass.IsUnitType(whichUnit, jass.UNIT_TYPE_HERO) ~= true then
        return false
    end
    local owner = jass.GetOwningPlayer(whichUnit)
    if owner == nil or owner == 0 then
        return false
    end
    local playerId = jass.GetPlayerId(owner) or -1
    return playerId >= 0 and playerId <= 4
end
--- 在英雄登记完成后，把它继续分发给依赖英雄注册结果的子模块。
local function registerHeroDependents(self, whichHero)
    if type(moveTornado.registerMoveSpeedTornadoHero) == "function" then
        moveTornado:registerMoveSpeedTornadoHero(whichHero)
    end
    if type(petItemHandoff.registerPetItemHandoffHero) == "function" then
        petItemHandoff:registerPetItemHandoffHero(whichHero)
    end
end
--- 为单个玩家登记英雄：
-- 1. 写入玩家侧 YDUserData
-- 2. 触发后续联动模块注册
local function registerPlayerHero(self, whichPlayer, whichHero)
    if whichPlayer == nil or whichPlayer == 0 or whichHero == nil or whichHero == 0 then
        return
    end
    YDUserDataSet(
        nil,
        "player",
        whichPlayer,
        C.YD_ATTR_PLAYER_HERO_UNIT,
        "unit",
        whichHero
    )
    registerHeroDependents(nil, whichHero)
end
--- 从 JASS 传入的单位组里找出玩家 1-5 的英雄，并逐个完成登记。
local function registerHeroesFromGroup(self, heroGroup)
    if heroGroup == nil or heroGroup == 0 then
        return
    end
    if type(jass.ForGroup) ~= "function" or type(jass.GetEnumUnit) ~= "function" then
        return
    end
    if type(jass.GetOwningPlayer) ~= "function" or type(jass.GetPlayerId) ~= "function" or type(jass.Player) ~= "function" then
        return
    end
    local heroByPlayer = {}
    jass.ForGroup(
        heroGroup,
        function()
            local whichUnit = jass.GetEnumUnit()
            if not isPlayableHero(nil, whichUnit) then
                return
            end
            local owner = jass.GetOwningPlayer(whichUnit)
            local playerId = jass.GetPlayerId(owner) or -1
            if playerId < 0 or playerId > 4 then
                return
            end
            if heroByPlayer[playerId] == nil then
                heroByPlayer[playerId] = whichUnit
            end
        end
    )
    do
        local playerId = 0
        while playerId <= 4 do
            do
                local hero = heroByPlayer[playerId]
                if hero == nil then
                    goto __continue28
                end
                registerPlayerHero(
                    nil,
                    jass.Player(playerId),
                    hero
                )
            end
            ::__continue28::
            playerId = playerId + 1
        end
    end
end
--- STES 子触发真正执行的核心入口。
local function runRegisterPlayerHero(self)
    helper:ydlStes_syncTriggerStep(nil)
    do
        pcall(function()
            registerHeroesFromGroup(
                nil,
                YDLocal5Get(nil, "group", C.STES_PARAM_HERO_GROUP)
            )
        end)
        do
            helper:ydlStes_finishChildCleanup(nil)
        end
    end
end
--- 由于 STES 表绑定时机可能晚于 Lua 模块加载，这里用短延迟重试注册。
local function scheduleRetry(self, fn)
    if type(jass.CreateTimer) ~= "function" or type(jass.TimerStart) ~= "function" then
        fn(nil)
        return
    end
    local timer = jass.CreateTimer()
    jass.TimerStart(
        timer,
        RETRY_SEC,
        false,
        function()
            if type(jass.DestroyTimer) == "function" then
                jass.DestroyTimer(timer)
            end
            fn(nil)
        end
    )
end
--- 向 JASS 侧 STES 表注册“玩家英雄注册”监听。
local function tryRegisterPlayerHeroStes(self)
    local g = _G
    if g[REG_GUARD] then
        return
    end
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" then
        g[REG_GUARD] = true
        return
    end
    if g[TRIG_KEY] == nil then
        local trig = jass.CreateTrigger()
        jass.TriggerAddAction(
            trig,
            function()
                runRegisterPlayerHero(nil)
            end
        )
        g[TRIG_KEY] = trig
    end
    helper:ydlStes_registerAfterGetTable(nil, g[TRIG_KEY], C.STES_EVENT_REGISTER_PLAYER_HERO)
    local count = countOnJassStesTable(nil, C.STES_EVENT_REGISTER_PLAYER_HERO)
    local attempt = (g[ATTEMPT_KEY] or 0) + 1
    g[ATTEMPT_KEY] = attempt
    if count >= 1 or attempt >= MAX_REG_ATTEMPTS then
        g[REG_GUARD] = true
        return
    end
    scheduleRetry(
        nil,
        function()
            tryRegisterPlayerHeroStes(nil)
        end
    )
end
--- 玩家系统初始化时调用，建立 JASS -> Lua 的玩家英雄注册桥接。
function ____exports.initPlayerHeroGetBridge(self)
    tryRegisterPlayerHeroStes(nil)
end
return ____exports
