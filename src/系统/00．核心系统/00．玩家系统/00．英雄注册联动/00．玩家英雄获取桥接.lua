local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
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
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local createDelayedCall = ____require_result_0.createDelayedCall
local C = require("系统.00．核心系统.00．玩家系统.00．常量")
local ____require_result_1 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataSet = ____require_result_1.YDUserDataSet
local ____require_result_2 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local YDLocal5Get = ____require_result_2.YDLocal5Get
local helper = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
local moveTornado = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.01．移速龙卷特效")
local outOfCombat = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.02．脱战计时")
local petItemHandoff = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.03．背包满移交宠物")
local chestSystem = require("系统.06．经济系统.00．宝箱系统.02．事件注册")
local dynamicSkillTipSystem = require("系统.03．技能系统.05．动态技能说明.index")
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.index")
local debugLog = ____require_result_3.debugLog
local REG_GUARD = "__syzl_playerHeroRegister_registered"
local TRIG_KEY = "__syzl_playerHeroRegister_trig"
local ATTEMPT_KEY = "__syzl_playerHeroRegister_attempt"
local MAX_REG_ATTEMPTS = 30
local RETRY_SEC = 0.1
local function jassStesHashtable()
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
local function countOnJassStesTable(eventName)
    local ht = jassStesHashtable()
    if ht == nil or ht == 0 then
        return -1
    end
    return jass.LoadInteger(
        ht,
        jass.StringHash(eventName),
        helper:ydlStes_skeyIndex(nil)
    )
end
--- 只接受玩家 1-5 当前操作的英雄，且排除电脑玩家。
-- 这里是整条"英雄注册联动"链路的第一层筛选。
local function isPlayableHero(whichUnit)
    if whichUnit == nil or whichUnit == 0 then
        return false
    end
    if jass.IsUnitType(whichUnit, jass.UNIT_TYPE_HERO) ~= true then
        return false
    end
    local owner = jass.GetOwningPlayer(whichUnit)
    if owner == nil or owner == 0 then
        return false
    end
    if jass.GetPlayerController(owner) == jass.MAP_CONTROL_COMPUTER then
        return false
    end
    local playerId = jass.GetPlayerId(owner) or -1
    return playerId >= 0 and playerId <= 4
end
--- 经局部变量再调，避免 TSTL 编成 `mod:fn(...)`；`onPlayerHeroRegistered` 在面板模块已标 `this: void`，勿再注入 nil 首参
local function invokeUiAttrOnPlayerHeroRegistered(whichPlayer, whichHero)
    local mod = require("系统.09．表现系统.03．UI属性系统.02．面板渲染")
    local cb = mod.onPlayerHeroRegistered
    if type(cb) ~= "function" then
        return
    end
    cb(whichPlayer, whichHero)
end
local uiRegisteredPlayers = __TS__New(Set)
local dialogSystem = require("系统.09．表现系统.02．对话框系统.00．对话框渲染核心")
local buffUISystem = require("系统.05．Buff系统.02．BuffUI")
local taskUISystem = require("系统.08．任务系统.02．任务UI拆分.11．任务UI管理器")
local selectionCenterSystem = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心")
local initPlayerSelectionCenter = selectionCenterSystem.initPlayerSelectionCenter
local seedSoleSelectedUnitForPlayer = selectionCenterSystem.seedSoleSelectedUnitForPlayer
local function invokeSelectionCenterInit(whichPlayer)
    if type(initPlayerSelectionCenter) ~= "function" then
        return
    end
    initPlayerSelectionCenter(whichPlayer)
end
local function invokeSelectionCenterSeed(whichPlayer, whichUnit)
    if type(seedSoleSelectedUnitForPlayer) ~= "function" then
        return
    end
    seedSoleSelectedUnitForPlayer(whichPlayer, whichUnit)
end
--- 在英雄登记完成后，把它继续分发给依赖英雄注册结果的子模块。
local function registerHeroDependents(whichHero)
    if type(moveTornado.registerMoveSpeedTornadoHero) == "function" then
        moveTornado:registerMoveSpeedTornadoHero(whichHero)
    end
    if type(petItemHandoff.registerPetItemHandoffHero) == "function" then
        petItemHandoff:registerPetItemHandoffHero(whichHero)
    end
    if type(chestSystem.registerChestSystemHero) == "function" then
        chestSystem:registerChestSystemHero(whichHero)
    end
    local owner = jass.GetOwningPlayer(whichHero)
    if owner ~= nil and owner ~= 0 then
        if type(dynamicSkillTipSystem.onPlayerHeroRegistered) == "function" then
            dynamicSkillTipSystem.onPlayerHeroRegistered(owner, whichHero)
        end
        local playerId = jass.GetPlayerId(owner)
        debugLog(
            nil,
            "Bridge",
            (("registerHeroDependents pid=" .. tostring(playerId)) .. " has=") .. tostring(uiRegisteredPlayers:has(playerId))
        )
        invokeSelectionCenterInit(owner)
        invokeSelectionCenterSeed(owner, whichHero)
        if not uiRegisteredPlayers:has(playerId) then
            local taskUiReady = true
            invokeUiAttrOnPlayerHeroRegistered(owner, whichHero)
            if type(dialogSystem.onPlayerHeroRegistered) == "function" then
                dialogSystem.onPlayerHeroRegistered(owner, whichHero)
            end
            if type(buffUISystem.onPlayerHeroRegistered) == "function" then
                buffUISystem.onPlayerHeroRegistered(owner, whichHero)
            end
            if type(taskUISystem.onPlayerHeroRegistered) == "function" then
                taskUiReady = taskUISystem.onPlayerHeroRegistered(owner, whichHero) == true
            end
            if taskUiReady then
                uiRegisteredPlayers:add(playerId)
            end
        end
    end
end
--- 为单个玩家登记英雄：
-- 1. 写入玩家侧 YDUserData
-- 2. 触发后续联动模块注册
local function registerPlayerHero(whichPlayer, whichHero)
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
    registerHeroDependents(whichHero)
end
--- 从 JASS 传入的单个英雄单位完成一次登记。
-- 现在桥接的粒度改为“每次 STES 只注册一个英雄”，避免重复扫组。
local function registerSingleHero(whichHero)
    if not isPlayableHero(whichHero) then
        return
    end
    local owner = jass.GetOwningPlayer(whichHero)
    if owner == nil or owner == 0 then
        return
    end
    registerPlayerHero(owner, whichHero)
end
--- STES 子触发真正执行的核心入口。
local function runRegisterPlayerHero()
    helper:ydlStes_syncTriggerStep(nil)
    do
        pcall(function()
            registerSingleHero(YDLocal5Get(nil, "unit", C.STES_PARAM_HERO_UNIT))
        end)
        do
            helper:ydlStes_finishChildCleanup(nil)
        end
    end
end
local function runRegisterPlayerHeroTriggerAction()
    runRegisterPlayerHero()
end
--- 由于 STES 表绑定时机可能晚于 Lua 模块加载，这里用短延迟重试注册。
local function scheduleRetry(fn)
    createDelayedCall(RETRY_SEC, fn)
end
--- 向 JASS 侧 STES 表注册“玩家英雄注册”监听。
local function tryRegisterPlayerHeroStes()
    local g = _G
    if g[REG_GUARD] then
        return
    end
    if g[TRIG_KEY] == nil then
        local trig = jass.CreateTrigger()
        jass.TriggerAddAction(trig, runRegisterPlayerHeroTriggerAction)
        g[TRIG_KEY] = trig
    end
    helper:ydlStes_registerAfterGetTable(nil, g[TRIG_KEY], C.STES_EVENT_REGISTER_PLAYER_HERO)
    local count = countOnJassStesTable(C.STES_EVENT_REGISTER_PLAYER_HERO)
    local attempt = (g[ATTEMPT_KEY] or 0) + 1
    g[ATTEMPT_KEY] = attempt
    if count >= 1 or attempt >= MAX_REG_ATTEMPTS then
        g[REG_GUARD] = true
        return
    end
    scheduleRetry(function()
        tryRegisterPlayerHeroStes()
    end)
end
--- 玩家系统初始化时调用，建立 JASS -> Lua 的玩家英雄注册桥接。
function ____exports.initPlayerHeroGetBridge()
    if type(outOfCombat.initOutOfCombat) == "function" then
        outOfCombat:initOutOfCombat()
    end
    tryRegisterPlayerHeroStes()
end
return ____exports
