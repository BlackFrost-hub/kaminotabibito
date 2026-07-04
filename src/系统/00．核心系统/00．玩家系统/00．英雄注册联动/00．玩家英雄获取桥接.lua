local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local invokeUiAttrOnPlayerHeroRegistered, invokeSelectionCenterInit, invokeSelectionCenterSeed, _____505C_6B62_82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217, _____5904_7406_82F1_96C4_4F9D_8D56_6CE8_518C_4EFB_52A1_4E00_6B65, ____on_82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217Tick, _____8C03_5EA6_82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217_4E0B_4E00_6B65, jass, centerTimer, registerMoveSpeedTornadoHero, petItemHandoff, chestSystem, heroVoiceSystem, debugLog, _____82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217_95F4_9694_6BEB_79D2, uiRegisteredPlayers, _____82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217, _____82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217_4E0B_4E00_6B65_5EF6_8FDFID, dialogSystem, buffUISystem, threatPanelSystem, initPlayerSelectionCenter, seedSoleSelectedUnitForPlayer
function invokeUiAttrOnPlayerHeroRegistered(whichPlayer, whichHero)
    local mod = require("系统.09．表现系统.03．UI属性系统.02．面板渲染")
    local cb = mod.onPlayerHeroRegistered
    if type(cb) ~= "function" then
        return
    end
    cb(whichPlayer, whichHero)
end
function invokeSelectionCenterInit(whichPlayer)
    if type(initPlayerSelectionCenter) ~= "function" then
        return
    end
    initPlayerSelectionCenter(whichPlayer)
end
function invokeSelectionCenterSeed(whichPlayer, whichUnit)
    if type(seedSoleSelectedUnitForPlayer) ~= "function" then
        return
    end
    seedSoleSelectedUnitForPlayer(whichPlayer, whichUnit)
end
function _____505C_6B62_82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217()
    if _____82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217_4E0B_4E00_6B65_5EF6_8FDFID == nil then
        return
    end
    centerTimer.removeDelayedCallback(_____82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217_4E0B_4E00_6B65_5EF6_8FDFID)
    _____82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217_4E0B_4E00_6B65_5EF6_8FDFID = nil
end
function _____5904_7406_82F1_96C4_4F9D_8D56_6CE8_518C_4EFB_52A1_4E00_6B65(_____4EFB_52A1)
    local owner = _____4EFB_52A1.owner
    local whichHero = _____4EFB_52A1.hero
    if owner == nil or owner == 0 or whichHero == nil or whichHero == 0 then
        return true
    end
    local playerId = jass.GetPlayerId(owner)
    repeat
        local ____switch19 = _____4EFB_52A1.stage
        local ____cond19 = ____switch19 == 0
        if ____cond19 then
            if type(registerMoveSpeedTornadoHero) == "function" then
                registerMoveSpeedTornadoHero(whichHero)
            end
            break
        end
        ____cond19 = ____cond19 or ____switch19 == 1
        if ____cond19 then
            if type(petItemHandoff["注册宠物移交英雄"]) == "function" then
                petItemHandoff["注册宠物移交英雄"](whichHero)
            end
            break
        end
        ____cond19 = ____cond19 or ____switch19 == 2
        if ____cond19 then
            if type(chestSystem.registerChestSystemHero) == "function" then
                chestSystem.registerChestSystemHero(whichHero)
            end
            break
        end
        ____cond19 = ____cond19 or ____switch19 == 3
        if ____cond19 then
            break
        end
        ____cond19 = ____cond19 or ____switch19 == 4
        if ____cond19 then
            debugLog(
                nil,
                "Bridge",
                (("registerHeroDependents pid=" .. tostring(playerId)) .. " has=") .. tostring(uiRegisteredPlayers:has(playerId))
            )
            invokeSelectionCenterInit(owner)
            invokeSelectionCenterSeed(owner, whichHero)
            if type(heroVoiceSystem.onPlayerHeroRegistered) == "function" then
                heroVoiceSystem.onPlayerHeroRegistered(owner, whichHero)
            end
            break
        end
        ____cond19 = ____cond19 or ____switch19 == 5
        if ____cond19 then
            if not uiRegisteredPlayers:has(playerId) then
                invokeUiAttrOnPlayerHeroRegistered(owner, whichHero)
            end
            break
        end
        ____cond19 = ____cond19 or ____switch19 == 6
        if ____cond19 then
            if not uiRegisteredPlayers:has(playerId) and type(dialogSystem.onPlayerHeroRegistered) == "function" then
                dialogSystem.onPlayerHeroRegistered(owner, whichHero)
            end
            break
        end
        ____cond19 = ____cond19 or ____switch19 == 7
        if ____cond19 then
            if not uiRegisteredPlayers:has(playerId) and type(buffUISystem.onPlayerHeroRegistered) == "function" then
                buffUISystem.onPlayerHeroRegistered(owner, whichHero)
            end
            break
        end
        ____cond19 = ____cond19 or ____switch19 == 8
        if ____cond19 then
            if not uiRegisteredPlayers:has(playerId) then
                if type(threatPanelSystem.onPlayerHeroRegistered) == "function" then
                    threatPanelSystem.onPlayerHeroRegistered(owner, whichHero)
                end
                uiRegisteredPlayers:add(playerId)
            end
            return true
        end
        do
            return true
        end
    until true
    _____4EFB_52A1.stage = _____4EFB_52A1.stage + 1
    return false
end
function ____on_82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217Tick()
    _____82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217_4E0B_4E00_6B65_5EF6_8FDFID = nil
    if #_____82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217 <= 0 then
        _____505C_6B62_82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217()
        return
    end
    local _____5F53_524D_4EFB_52A1 = _____82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217[1]
    local _____5DF2_5B8C_6210 = _____5904_7406_82F1_96C4_4F9D_8D56_6CE8_518C_4EFB_52A1_4E00_6B65(_____5F53_524D_4EFB_52A1)
    if _____5DF2_5B8C_6210 then
        table.remove(_____82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217, 1)
    end
    if #_____82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217 <= 0 then
        _____505C_6B62_82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217()
        return
    end
    _____8C03_5EA6_82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217_4E0B_4E00_6B65(_____82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217_95F4_9694_6BEB_79D2)
end
function _____8C03_5EA6_82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217_4E0B_4E00_6B65(_____5EF6_8FDF_6BEB_79D2)
    if _____82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217_4E0B_4E00_6B65_5EF6_8FDFID ~= nil then
        return
    end
    _____82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217_4E0B_4E00_6B65_5EF6_8FDFID = centerTimer.addDelayedCallback(_____5EF6_8FDF_6BEB_79D2, ____on_82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217Tick)
end
jass = require("jass.common")
centerTimer = require("系统.00．核心系统.05．中心计时器")
local C = require("系统.00．核心系统.00．玩家系统.00．常量")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local YDUserDataSet = ____require_result_0.YDUserDataSet
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local moveTornado = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.01．移速龙卷特效")
registerMoveSpeedTornadoHero = moveTornado.registerMoveSpeedTornadoHero
petItemHandoff = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.03．背包满移交宠物")
chestSystem = require("系统.06．经济系统.00．宝箱系统.02．事件注册")
heroVoiceSystem = require("系统.09．表现系统.10．英雄语音.05．指令音效.index")
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.index")
debugLog = ____require_result_2.debugLog
_____82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217_95F4_9694_6BEB_79D2 = 150
local _____82F1_96C4_4F9D_8D56_6CE8_518C_542F_52A8_5EF6_8FDF_6BEB_79D2 = 800
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
uiRegisteredPlayers = __TS__New(Set)
_____82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217 = {}
local _____82F1_96C4_4F9D_8D56_6CE8_518C_542F_52A8_5EF6_8FDFID
dialogSystem = require("系统.09．表现系统.02．对话框系统.00．对话框渲染核心")
buffUISystem = require("系统.05．Buff系统.02．BuffUI")
threatPanelSystem = require("系统.09．表现系统.05．仇恨面板.index")
local selectionCenterSystem = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心")
initPlayerSelectionCenter = selectionCenterSystem.initPlayerSelectionCenter
seedSoleSelectedUnitForPlayer = selectionCenterSystem.seedSoleSelectedUnitForPlayer
local playerCountSystem = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
local _____521D_59CB_5316_73A9_5BB6_4EBA_6570_76D1_542C = playerCountSystem["初始化玩家人数监听"]
local function _____6E05_7406_82F1_96C4_4F9D_8D56_6CE8_518C_542F_52A8_5EF6_8FDF()
    if _____82F1_96C4_4F9D_8D56_6CE8_518C_542F_52A8_5EF6_8FDFID == nil then
        return
    end
    centerTimer.removeDelayedCallback(_____82F1_96C4_4F9D_8D56_6CE8_518C_542F_52A8_5EF6_8FDFID)
    _____82F1_96C4_4F9D_8D56_6CE8_518C_542F_52A8_5EF6_8FDFID = nil
end
local function ____on_542F_52A8_82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217()
    _____82F1_96C4_4F9D_8D56_6CE8_518C_542F_52A8_5EF6_8FDFID = nil
    if #_____82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217 <= 0 then
        return
    end
    _____8C03_5EA6_82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217_4E0B_4E00_6B65(0)
end
local function registerHeroDependents(whichHero)
    local owner = jass.GetOwningPlayer(whichHero)
    if owner == nil or owner == 0 then
        return
    end
    _____82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217[#_____82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217 + 1] = {owner = owner, hero = whichHero, stage = 0}
    if _____82F1_96C4_4F9D_8D56_6CE8_518C_542F_52A8_5EF6_8FDFID == nil then
        _____82F1_96C4_4F9D_8D56_6CE8_518C_542F_52A8_5EF6_8FDFID = centerTimer.addDelayedCallback(_____82F1_96C4_4F9D_8D56_6CE8_518C_542F_52A8_5EF6_8FDF_6BEB_79D2, ____on_542F_52A8_82F1_96C4_4F9D_8D56_6CE8_518C_961F_5217)
    end
end
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
function ____exports.directRegisterPlayerHero(whichPlayer, whichHero)
    registerPlayerHero(whichPlayer, whichHero)
end
function ____exports.getRegisteredPlayerHero(whichPlayer)
    if whichPlayer == nil or whichPlayer == 0 then
        return nil
    end
    return YDUserDataGet(
        nil,
        "player",
        whichPlayer,
        C.YD_ATTR_PLAYER_HERO_UNIT,
        "unit"
    )
end
____exports["获取玩家英雄单位组"] = function()
    return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
end
____exports["是玩家英雄组单位"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 = ____exports["获取玩家英雄单位组"]()
    if _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 ~= 0 then
        return jass.IsUnitInGroup(unit, _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4) == true
    end
    local owner = jass.GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return false
    end
    return ____exports.getRegisteredPlayerHero(owner) == unit
end
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
function ____exports.directRegisterPlayableHero(whichHero)
    registerSingleHero(whichHero)
end
local function initOutOfCombatSystem()
    local outOfCombat = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.02．脱战计时")
    local init = outOfCombat["初始化脱战系统"]
    if type(init) == "function" then
        init()
    end
end
function ____exports.initPlayerHeroGetBridge()
    _____6E05_7406_82F1_96C4_4F9D_8D56_6CE8_518C_542F_52A8_5EF6_8FDF()
    _____521D_59CB_5316_73A9_5BB6_4EBA_6570_76D1_542C()
    initOutOfCombatSystem()
end
return ____exports
