--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 杀敌金币平分系统 - 核心功能
-- 
-- 功能：
-- 1. 击杀者获得金币
-- 2. 范围内友方英雄平分40%金币
-- 3. 播放金币音效、显示漂浮文字
-- 
-- 触发条件：死亡单位属于中立敌对(玩家12)或玩家8(粉色)
local jass = require("jass.common")
local ____require_result_0 = require("系统.06．经济系统.01．杀敌金币平分.00．常量定义")
local SHARE_RANGE = ____require_result_0.SHARE_RANGE
local ____require_result_1 = require("lib.扩展函数.YDWE函数.index")
local getObjectPropertyInteger = ____require_result_1.getObjectPropertyInteger
local ____require_result_2 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataGet = ____require_result_2.YDUserDataGet
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.index")
local AdjustPlayerStateBJ = ____require_result_3.AdjustPlayerStateBJ
local ____require_result_4 = require("lib.扩展函数.封装函数.02．音效系统.index")
local Sound3DII_Mp3PlayReuse = ____require_result_4.Sound3DII_Mp3PlayReuse
local ____require_result_5 = require("lib.扩展函数.封装函数.03．漂浮文字.index")
local CreateFloatTextOnUnit = ____require_result_5.CreateFloatTextOnUnit
local ____require_result_6 = require("系统.01．单位系统.03．单位死亡事件.01．核心功能")
local registerDeathListener = ____require_result_6.registerDeathListener
local SOUND_GOLD = "Abilities\\Spells\\Items\\ResourceItems\\ReceiveGold.wav"
local GOLD_R = 255
local GOLD_G = 215
local GOLD_B = 0
local GOLD_FLOAT_DURATION_SEC = 1.25
--- 金币获取回调列表
local goldGainCallbacks = {}
--- 获取单位赏金
local function getUnitBounty(unitType)
    return getObjectPropertyInteger(nil, 2, unitType, "bountyplus")
end
--- 检查单位是否为玩家英雄
local function isPlayerHero(unit)
    local heroGroup = YDUserDataGet(
        nil,
        "string",
        "玩家英雄",
        "单位组",
        "group"
    )
    if not heroGroup or not unit then
        return false
    end
    local ____opt_7 = jass.IsUnitInGroup
    if ____opt_7 ~= nil then
        ____opt_7 = ____opt_7(jass, unit, heroGroup)
    end
    return ____opt_7 == true
end
--- 获取英雄单位组
local function getHeroGroup()
    return YDUserDataGet(
        nil,
        "string",
        "玩家英雄",
        "单位组",
        "group"
    )
end
--- 检查死亡单位是否触发金币平分（中立敌对或玩家8）
local function isValidDyingUnit(dyingUnit)
    local ____opt_9 = jass.GetOwningPlayer
    if ____opt_9 ~= nil then
        ____opt_9 = ____opt_9(jass, dyingUnit)
    end
    local owner = ____opt_9
    if owner == nil then
        return false
    end
    local ____opt_11 = jass.GetPlayerId
    if ____opt_11 ~= nil then
        ____opt_11 = ____opt_11(jass, owner)
    end
    local playerId = ____opt_11
    return playerId == 12 or playerId == 7
end
--- 给予玩家金币（带音效和漂浮文字）
local function giveGoldToPlayer(unit, player, baseGold, isShared)
    local params = {unit = unit, player = player, baseGold = baseGold, isShared = isShared}
    for ____, cb in ipairs(goldGainCallbacks) do
        local result = pcall(function () return cb(params) end
        )
        if result ~= nil then
            params = result
        end
    end
    local finalGold = params.finalGold or baseGold
    AdjustPlayerStateBJ(nil, finalGold, player, jass.PLAYER_STATE_RESOURCE_GOLD)
    Sound3DII_Mp3PlayReuse(nil, SOUND_GOLD, player)
    local text = "+" .. tostring(finalGold)
    CreateFloatTextOnUnit(nil, unit, text, {
        size = 12,
        red = GOLD_R,
        green = GOLD_G,
        blue = GOLD_B,
        alpha = 0,
        duration = GOLD_FLOAT_DURATION_SEC
    })
end
--- 处理单位死亡事件
local function onUnitDeathHandler(dyingUnit, killer)
    if not isValidDyingUnit(dyingUnit) then
        return
    end
    local ____opt_13 = jass.GetUnitTypeId
    if ____opt_13 ~= nil then
        ____opt_13 = ____opt_13(jass, dyingUnit)
    end
    local dyingUnitType = ____opt_13
    if not dyingUnitType then
        return
    end
    local baseBounty = getUnitBounty(dyingUnitType)
    if baseBounty <= 0 then
        return
    end
    if killer ~= nil then
        local ____opt_15 = jass.GetOwningPlayer
        if ____opt_15 ~= nil then
            ____opt_15 = ____opt_15(jass, killer)
        end
        local killerPlayer = ____opt_15
        if killerPlayer ~= nil then
            giveGoldToPlayer(killer, killerPlayer, baseBounty, false)
        end
    end
    if not isPlayerHero(killer) then
        return
    end
    local shareGold = math.floor(baseBounty / 10) * 4
    if shareGold <= 0 then
        return
    end
    local ____opt_17 = jass.GetUnitX
    if ____opt_17 ~= nil then
        ____opt_17 = ____opt_17(jass, dyingUnit)
    end
    local ____opt_17_19 = ____opt_17
    if ____opt_17_19 == nil then
        ____opt_17_19 = 0
    end
    local dyingX = ____opt_17_19
    local ____opt_20 = jass.GetUnitY
    if ____opt_20 ~= nil then
        ____opt_20 = ____opt_20(jass, dyingUnit)
    end
    local ____opt_20_22 = ____opt_20
    if ____opt_20_22 == nil then
        ____opt_20_22 = 0
    end
    local dyingY = ____opt_20_22
    local ____opt_23 = jass.GetOwningPlayer
    if ____opt_23 ~= nil then
        ____opt_23 = ____opt_23(jass, killer)
    end
    local killerPlayer = ____opt_23
    local heroGroup = getHeroGroup()
    if killerPlayer == nil or heroGroup == nil then
        return
    end
    local ____opt_25 = jass.BlzGroupGetSize
    if ____opt_25 ~= nil then
        ____opt_25 = ____opt_25(jass, heroGroup)
    end
    local ____opt_25_27 = ____opt_25
    if ____opt_25_27 == nil then
        ____opt_25_27 = 0
    end
    local heroCount = ____opt_25_27
    do
        local i = 0
        while i < heroCount do
            do
                local ____opt_28 = jass.BlzGroupUnitAt
                if ____opt_28 ~= nil then
                    ____opt_28 = ____opt_28(jass, heroGroup, i)
                end
                local hero = ____opt_28
                if not hero then
                    goto __continue23
                end
                if hero == killer then
                    goto __continue23
                end
                local ____opt_30 = jass.IsUnitAlly
                if ____opt_30 ~= nil then
                    ____opt_30 = ____opt_30(jass, hero, killerPlayer)
                end
                if ____opt_30 ~= true then
                    goto __continue23
                end
                local ____opt_32 = jass.GetUnitX
                if ____opt_32 ~= nil then
                    ____opt_32 = ____opt_32(jass, hero)
                end
                local ____opt_32_34 = ____opt_32
                if ____opt_32_34 == nil then
                    ____opt_32_34 = 0
                end
                local heroX = ____opt_32_34
                local ____opt_35 = jass.GetUnitY
                if ____opt_35 ~= nil then
                    ____opt_35 = ____opt_35(jass, hero)
                end
                local ____opt_35_37 = ____opt_35
                if ____opt_35_37 == nil then
                    ____opt_35_37 = 0
                end
                local heroY = ____opt_35_37
                local dx = heroX - dyingX
                local dy = heroY - dyingY
                local dist = math.sqrt(dx * dx + dy * dy)
                if dist > SHARE_RANGE then
                    goto __continue23
                end
                local ____opt_38 = jass.GetOwningPlayer
                if ____opt_38 ~= nil then
                    ____opt_38 = ____opt_38(jass, hero)
                end
                local heroPlayer = ____opt_38
                if heroPlayer == nil then
                    goto __continue23
                end
                giveGoldToPlayer(hero, heroPlayer, shareGold, true)
            end
            ::__continue23::
            i = i + 1
        end
    end
end
--- 注册金币获取回调
-- 回调可以返回更新后的params传递给下一个回调
-- 
-- @param cb 回调函数
function ____exports.registerGoldGainCallback(cb)
    goldGainCallbacks[#goldGainCallbacks + 1] = cb
end
local _initialized = false
--- 初始化杀敌金币平分系统
function ____exports.initGoldShareSystem()
    if _initialized then
        return
    end
    _initialized = true
    registerDeathListener(nil, onUnitDeathHandler)
end
____exports.initGoldShareSystem()
return ____exports
