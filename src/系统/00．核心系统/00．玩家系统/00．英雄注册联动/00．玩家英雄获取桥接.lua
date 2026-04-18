--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 玩家系统 - 英雄注册联动 - 玩家英雄获取桥接
-- 
-- JASS 侧：
-- - 传参：YDLocal5Set(unit, "英雄", someHero)
-- - 触发：STES_Fire("玩家英雄注册")
-- 
-- Lua 侧职责：
-- - 从传入单位中筛选玩家 1-5 操作的英雄
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
local moveTornado = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.01．移速龙卷特效")
local outOfCombat = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.02．脱战计时")
local petItemHandoff = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.03．背包满移交宠物")
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
    if type(outOfCombat.registerOutOfCombatHero) == "function" then
        outOfCombat:registerOutOfCombatHero(whichHero)
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
--- 从 JASS 传入的单个英雄单位完成一次登记。
-- 现在桥接的粒度改为“每次 STES 只注册一个英雄”，避免重复扫组。
local function registerSingleHero(self, whichHero)
    if not isPlayableHero(nil, whichHero) then
        return
    end
    if type(jass.GetOwningPlayer) ~= "function" then
        return
    end
    local owner = jass.GetOwningPlayer(whichHero)
    if owner == nil or owner == 0 then
        return
    end
    registerPlayerHero(nil, owner, whichHero)
end
--- STES 子触发真正执行的核心入口。
local function runRegisterPlayerHero(self)
    helper:ydlStes_syncTriggerStep(nil)
    do
        pcall(function()
            registerSingleHero(
                nil,
                YDLocal5Get(nil, "unit", C.STES_PARAM_HERO_UNIT)
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
    if type(outOfCombat.initOutOfCombat) == "function" then
        outOfCombat:initOutOfCombat()
    end
    tryRegisterPlayerHeroStes(nil)
end
return ____exports
