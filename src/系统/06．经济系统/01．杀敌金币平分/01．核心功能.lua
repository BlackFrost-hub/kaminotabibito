--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 杀敌金币平分系统 - 核心功能
-- 
-- 功能：
-- 1. 击杀者获得金币
-- 2. 范围内友方英雄平分40%金币
-- 3. 播放金币音效、显示漂浮文字
-- 
-- 触发条件：死亡单位属于中立敌对(玩家12)或玩家8(粉色)，且由正在游戏的真人玩家单位击杀
local jass = require("jass.common")
local ____require_result_0 = require("系统.06．经济系统.01．杀敌金币平分.00．常量定义")
local SHARE_RANGE = ____require_result_0.SHARE_RANGE
local _____6740_654C_91D1_5E01_5E73_5206_7CFB_7EDF_542F_7528 = ____require_result_0["杀敌金币平分系统启用"]
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
local _____5E73_5206_6B7B_4EA1X = 0
local _____5E73_5206_6B7B_4EA1Y = 0
local _____5E73_5206_51FB_6740_73A9_5BB6 = nil
local _____5E73_5206_51FB_6740_8005 = nil
local _____5E73_5206_91D1_5E01_503C = 0
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
--- 获取击杀单位所属的在线真人玩家；非玩家单位不参与任何金币结算。
local function getActiveUserPlayerForUnit(unit)
    if unit == nil or unit == 0 then
        return nil
    end
    local owner = jass:GetOwningPlayer(unit)
    if owner == nil then
        return nil
    end
    if jass:GetPlayerController(owner) ~= jass.MAP_CONTROL_USER then
        return nil
    end
    if jass:GetPlayerSlotState(owner) ~= jass.PLAYER_SLOT_STATE_PLAYING then
        return nil
    end
    return owner
end
--- 检查死亡单位是否触发金币平分（中立敌对或玩家8）
local function isValidDyingUnit(dyingUnit)
    if jass:IsUnitType(dyingUnit, jass.UNIT_TYPE_SUMMONED) == true then
        return false
    end
    local playerId = getUnitOwnerId(nil, dyingUnit)
    return playerId == 12 or playerId == 7
end
--- 仅播放金币音效并显示漂浮文字，不修改玩家金币。
____exports["显示金币获得反馈"] = function(unit, player, gold)
    if unit == nil or unit == 0 or player == nil or player == 0 or gold == 0 then
        return
    end
    Sound3DII_Mp3PlayReuse(SOUND_GOLD, player)
    if type(CreateFloatTextOnUnit) == "function" then
        CreateFloatTextOnUnit(
            unit,
            (gold > 0 and "+" or "") .. tostring(gold),
            {
                size = 12,
                red = GOLD_R,
                green = GOLD_G,
                blue = GOLD_B,
                alpha = 0,
                duration = GOLD_FLOAT_DURATION_SEC
            }
        )
    end
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
    ____exports["显示金币获得反馈"](unit, player, finalGold)
end
local function _____5904_7406_5E73_5206_82F1_96C4(hero)
    if not hero then
        return
    end
    if hero == _____5E73_5206_51FB_6740_8005 then
        return
    end
    if jass:IsUnitAlly(hero, _____5E73_5206_51FB_6740_73A9_5BB6) ~= true then
        return
    end
    local ____temp_7 = jass:GetUnitX(hero)
    if ____temp_7 == nil then
        ____temp_7 = 0
    end
    local heroX = ____temp_7
    local ____temp_8 = jass:GetUnitY(hero)
    if ____temp_8 == nil then
        ____temp_8 = 0
    end
    local heroY = ____temp_8
    local dx = heroX - _____5E73_5206_6B7B_4EA1X
    local dy = heroY - _____5E73_5206_6B7B_4EA1Y
    local dist = jass:SquareRoot(dx * dx + dy * dy)
    if dist > SHARE_RANGE then
        return
    end
    local heroPlayer = jass:GetOwningPlayer(hero)
    if heroPlayer == nil then
        return
    end
    giveGoldToPlayer(hero, heroPlayer, _____5E73_5206_91D1_5E01_503C, true)
end
local function _____904D_5386_5355_4F4D_7EC4_5E76_6062_590D(group)
    if group == nil or group == 0 then
        return
    end
    local scratch = jass:CreateGroup()
    while true do
        local unit = jass:FirstOfGroup(group)
        if not unit or unit == 0 then
            break
        end
        jass:GroupRemoveUnit(group, unit)
        jass:GroupAddUnit(scratch, unit)
        _____5904_7406_5E73_5206_82F1_96C4(unit)
    end
    while true do
        local unit = jass:FirstOfGroup(scratch)
        if not unit or unit == 0 then
            break
        end
        jass:GroupRemoveUnit(scratch, unit)
        jass:GroupAddUnit(group, unit)
    end
    jass:DestroyGroup(scratch)
end
--- 处理单位死亡事件
local function onUnitDeathHandler(dyingUnit, killer)
    if not isValidDyingUnit(dyingUnit) then
        return
    end
    local killerPlayer = getActiveUserPlayerForUnit(killer)
    if killerPlayer == nil then
        return
    end
    local dyingUnitType = jass:GetUnitTypeId(dyingUnit)
    if not dyingUnitType then
        return
    end
    local baseBounty = getUnitBounty(dyingUnitType)
    if baseBounty <= 0 then
        return
    end
    giveGoldToPlayer(killer, killerPlayer, baseBounty, false)
    local shareGold = jass:R2I(baseBounty / 10) * 4
    if shareGold <= 0 then
        return
    end
    local ____temp_9 = jass:GetUnitX(dyingUnit)
    if ____temp_9 == nil then
        ____temp_9 = 0
    end
    local dyingX = ____temp_9
    local ____temp_10 = jass:GetUnitY(dyingUnit)
    if ____temp_10 == nil then
        ____temp_10 = 0
    end
    local dyingY = ____temp_10
    local heroGroup = getHeroGroup()
    if heroGroup == nil then
        return
    end
    _____5E73_5206_6B7B_4EA1X = dyingX
    _____5E73_5206_6B7B_4EA1Y = dyingY
    _____5E73_5206_51FB_6740_73A9_5BB6 = killerPlayer
    _____5E73_5206_51FB_6740_8005 = killer
    _____5E73_5206_91D1_5E01_503C = shareGold
    _____904D_5386_5355_4F4D_7EC4_5E76_6062_590D(heroGroup)
    _____5E73_5206_51FB_6740_73A9_5BB6 = nil
    _____5E73_5206_51FB_6740_8005 = nil
    _____5E73_5206_91D1_5E01_503C = 0
end
--- 注册金币获取回调
-- 回调可以返回更新后的params传递给下一个回调
-- 
-- @param cb 回调函数
function ____exports.registerGoldGainCallback(cb)
    if not _____6740_654C_91D1_5E01_5E73_5206_7CFB_7EDF_542F_7528 then
        return
    end
    goldGainCallbacks[#goldGainCallbacks + 1] = cb
end
local _initialized = false
--- 初始化杀敌金币平分系统
function ____exports.initGoldShareSystem()
    if _initialized then
        return
    end
    _initialized = true
    if not _____6740_654C_91D1_5E01_5E73_5206_7CFB_7EDF_542F_7528 then
        return
    end
    registerDeathListener(onUnitDeathHandler)
end
____exports.initGoldShareSystem()
return ____exports
