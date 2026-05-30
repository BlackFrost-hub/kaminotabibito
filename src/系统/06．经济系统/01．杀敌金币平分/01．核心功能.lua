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
local _____6F02_6D6E_6587_5B57_6A21_5757 = require("lib.扩展函数.封装函数.03．漂浮文字.index")
local CreateFloatTextOnUnit = _____6F02_6D6E_6587_5B57_6A21_5757.CreateFloatTextOnUnit
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.index")
local getUnitOwnerId = ____require_result_5.getUnitOwnerId
local ____require_result_6 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_6.registerDeathListener
local SOUND_GOLD = "Abilities\\Spells\\Items\\ResourceItems\\ReceiveGold.wav"
local GOLD_R = 255
local GOLD_G = 215
local GOLD_B = 0
local GOLD_FLOAT_DURATION_SEC = 1.25
--- 金币获取回调列表
local goldGainCallbacks = {}
local ______pcall_91D1_5E01_56DE_8C03
local ______pcall_91D1_5E01_53C2_6570
local ______pcall_91D1_5E01_7ED3_679C
local function ______pcall_6267_884C_91D1_5E01_56DE_8C03(self)
    if ______pcall_91D1_5E01_56DE_8C03 == nil or ______pcall_91D1_5E01_53C2_6570 == nil then
        return
    end
    ______pcall_91D1_5E01_7ED3_679C = ______pcall_91D1_5E01_56DE_8C03(______pcall_91D1_5E01_53C2_6570)
end
local function _____6267_884C_91D1_5E01_56DE_8C03_5B89_5168(cb, params)
    ______pcall_91D1_5E01_56DE_8C03 = cb
    ______pcall_91D1_5E01_53C2_6570 = params
    ______pcall_91D1_5E01_7ED3_679C = nil
    pcall(______pcall_6267_884C_91D1_5E01_56DE_8C03)
    local result = ______pcall_91D1_5E01_7ED3_679C
    ______pcall_91D1_5E01_56DE_8C03 = nil
    ______pcall_91D1_5E01_53C2_6570 = nil
    ______pcall_91D1_5E01_7ED3_679C = nil
    return result
end
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
    return jass.IsUnitInGroup(unit, heroGroup) == true
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
    local playerId = getUnitOwnerId(nil, dyingUnit)
    return playerId == 12 or playerId == 7
end
--- 给予玩家金币（带音效和漂浮文字）
local function giveGoldToPlayer(unit, player, baseGold, isShared)
    local params = {unit = unit, player = player, baseGold = baseGold, isShared = isShared}
    for ____, cb in ipairs(goldGainCallbacks) do
        local result = _____6267_884C_91D1_5E01_56DE_8C03_5B89_5168(cb, params)
        if result ~= nil then
            params = result
        end
    end
    local finalGold = params.finalGold or baseGold
    AdjustPlayerStateBJ(nil, finalGold, player, jass.PLAYER_STATE_RESOURCE_GOLD)
    Sound3DII_Mp3PlayReuse(SOUND_GOLD, player)
    local text = "+" .. tostring(finalGold)
    if type(CreateFloatTextOnUnit) == "function" then
        CreateFloatTextOnUnit(unit, text, {
            size = 12,
            red = GOLD_R,
            green = GOLD_G,
            blue = GOLD_B,
            alpha = 0,
            duration = GOLD_FLOAT_DURATION_SEC
        })
    end
end
--- 处理单位死亡事件
local function onUnitDeathHandler(dyingUnit, killer)
    if not isValidDyingUnit(dyingUnit) then
        return
    end
    local dyingUnitType = jass.GetUnitTypeId(dyingUnit)
    if not dyingUnitType then
        return
    end
    local baseBounty = getUnitBounty(dyingUnitType)
    if baseBounty <= 0 then
        return
    end
    if killer ~= nil then
        local killerPlayer = jass.GetOwningPlayer(killer)
        if killerPlayer ~= nil then
            giveGoldToPlayer(killer, killerPlayer, baseBounty, false)
        end
    end
    if not isPlayerHero(killer) then
        return
    end
    local shareGold = jass.R2I(baseBounty / 10) * 4
    if shareGold <= 0 then
        return
    end
    local ____temp_7 = jass.GetUnitX(dyingUnit)
    if ____temp_7 == nil then
        ____temp_7 = 0
    end
    local dyingX = ____temp_7
    local ____temp_8 = jass.GetUnitY(dyingUnit)
    if ____temp_8 == nil then
        ____temp_8 = 0
    end
    local dyingY = ____temp_8
    local killerPlayer = jass.GetOwningPlayer(killer)
    local heroGroup = getHeroGroup()
    if killerPlayer == nil or heroGroup == nil then
        return
    end
    local ____temp_9 = jass.BlzGroupGetSize(heroGroup)
    if ____temp_9 == nil then
        ____temp_9 = 0
    end
    local heroCount = ____temp_9
    do
        local i = 0
        while i < heroCount do
            do
                local hero = jass.BlzGroupUnitAt(heroGroup, i)
                if not hero then
                    goto __continue25
                end
                if hero == killer then
                    goto __continue25
                end
                if jass.IsUnitAlly(hero, killerPlayer) ~= true then
                    goto __continue25
                end
                local ____temp_10 = jass.GetUnitX(hero)
                if ____temp_10 == nil then
                    ____temp_10 = 0
                end
                local heroX = ____temp_10
                local ____temp_11 = jass.GetUnitY(hero)
                if ____temp_11 == nil then
                    ____temp_11 = 0
                end
                local heroY = ____temp_11
                local dx = heroX - dyingX
                local dy = heroY - dyingY
                local dist = jass.SquareRoot(dx * dx + dy * dy)
                if dist > SHARE_RANGE then
                    goto __continue25
                end
                local heroPlayer = jass.GetOwningPlayer(hero)
                if heroPlayer == nil then
                    goto __continue25
                end
                giveGoldToPlayer(hero, heroPlayer, shareGold, true)
            end
            ::__continue25::
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
    registerDeathListener(onUnitDeathHandler)
end
____exports.initGoldShareSystem()
return ____exports
