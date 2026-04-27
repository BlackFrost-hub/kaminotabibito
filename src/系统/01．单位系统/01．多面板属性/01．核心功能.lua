local ____lualib = require("lualib_bundle")
local __TS__NumberToFixed = ____lualib.__TS__NumberToFixed
local ____exports = {}
local multiboardSetItemValue, getPlayerAttr, formatPercent, formatNumber, formatReal, updateMultiboard, updatePlayerSpeed, onRefreshTick, onRefresh, registerToCenterTimer, jass, getGameTimeFormatted, getGameDifficulty, onTick10ms, YDUserDataGet, YDUserDataSet, multiboards, _registered, _refreshCounter
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.01．单位系统.01．多面板属性.00．常量定义")
local MULTIBOARD_SYSTEM_ENABLED = ____00_FF0E_5E38_91CF_5B9A_4E49.MULTIBOARD_SYSTEM_ENABLED
local MULTIBOARD_ROWS = ____00_FF0E_5E38_91CF_5B9A_4E49.MULTIBOARD_ROWS
local MULTIBOARD_COLS = ____00_FF0E_5E38_91CF_5B9A_4E49.MULTIBOARD_COLS
local DISPLAY_PLAYER_COUNT = ____00_FF0E_5E38_91CF_5B9A_4E49.DISPLAY_PLAYER_COUNT
function multiboardSetItemValue(self, mb, col, row, val)
    if mb == nil then
        return
    end
    local item = jass:MultiboardGetItem(mb, row - 1, col - 1)
    if item ~= nil then
        jass:MultiboardSetItemValue(item, val)
        jass:MultiboardReleaseItem(item)
    end
end
function getPlayerAttr(self, playerId, attrName)
    local player = jass:Player(playerId - 1)
    if player == nil then
        return 0
    end
    local value = YDUserDataGet(
        nil,
        "player",
        player,
        attrName,
        "real"
    )
    return type(value) == "number" and value or 0
end
function formatPercent(self, value)
    local pct = math.floor(value * 100 + 0.5)
    return tostring(pct) .. "%"
end
function formatNumber(self, value)
    return tostring(math.floor(value + 0.5))
end
function formatReal(self, value)
    return __TS__NumberToFixed(value, 2)
end
function updateMultiboard(self, mb, playerId)
    if mb == nil then
        return
    end
    local ____getGameTimeFormatted_result_2 = getGameTimeFormatted(nil)
    local timeH = ____getGameTimeFormatted_result_2.hours
    local timeM = ____getGameTimeFormatted_result_2.minutes
    local timeS = ____getGameTimeFormatted_result_2.seconds
    local difficulty = getGameDifficulty(nil)
    local title = ((((((("属性面板（难度：" .. tostring(difficulty)) .. "）游戏时间：") .. tostring(timeH)) .. "小时") .. tostring(timeM)) .. "分") .. tostring(timeS)) .. "秒"
    jass:MultiboardSetTitleText(mb, title)
    local physDmg = 100 + getPlayerAttr(nil, playerId, "物理伤害") * 100
    local physResist = 100 - getPlayerAttr(nil, playerId, "物理抗性") * 100
    multiboardSetItemValue(
        nil,
        mb,
        1,
        1,
        (("物理伤害：" .. formatPercent(nil, physDmg / 100)) .. "/") .. formatPercent(nil, physResist / 100)
    )
    local armorPierce = getPlayerAttr(nil, playerId, "护甲穿透") * 100
    multiboardSetItemValue(
        nil,
        mb,
        2,
        1,
        "护甲穿透：" .. formatPercent(nil, armorPierce / 100)
    )
    local magicDmg = 100 + getPlayerAttr(nil, playerId, "魔法伤害") * 100
    local magicResist = 100 - getPlayerAttr(nil, playerId, "魔抗") * 100
    multiboardSetItemValue(
        nil,
        mb,
        3,
        1,
        (("魔法伤害：" .. formatPercent(nil, magicDmg / 100)) .. "/") .. formatPercent(nil, magicResist / 100)
    )
    local magicPierce = getPlayerAttr(nil, playerId, "魔法穿透") * 100
    multiboardSetItemValue(
        nil,
        mb,
        4,
        1,
        "魔法穿透：" .. formatPercent(nil, magicPierce / 100)
    )
    local skillDmg = 100 + getPlayerAttr(nil, playerId, "技能伤害") * 100
    local skillResist = 100 - getPlayerAttr(nil, playerId, "技能抗性") * 100
    multiboardSetItemValue(
        nil,
        mb,
        2,
        2,
        (("技能伤害：" .. formatPercent(nil, skillDmg / 100)) .. "/") .. formatPercent(nil, skillResist / 100)
    )
    local enhanceDmg = 100 + getPlayerAttr(nil, playerId, "强化伤害") * 100
    local enhanceResist = 100 - getPlayerAttr(nil, playerId, "强化抗性") * 100
    multiboardSetItemValue(
        nil,
        mb,
        3,
        2,
        (("强化伤害：" .. formatPercent(nil, enhanceDmg / 100)) .. "/") .. formatPercent(nil, enhanceResist / 100)
    )
    local summonDmg = 100 + getPlayerAttr(nil, playerId, "召唤物伤害") * 100
    local summonResist = 100 - getPlayerAttr(nil, playerId, "召唤物抗性") * 100
    multiboardSetItemValue(
        nil,
        mb,
        4,
        2,
        (("召唤物伤害：" .. formatPercent(nil, summonDmg / 100)) .. "/") .. formatPercent(nil, summonResist / 100)
    )
    local metalDmg = 100 + getPlayerAttr(nil, playerId, "金属性伤害") * 100
    local metalResist = 100 - getPlayerAttr(nil, playerId, "金属性抗性") * 100
    multiboardSetItemValue(
        nil,
        mb,
        1,
        3,
        (("金属性伤害：" .. formatPercent(nil, metalDmg / 100)) .. "/") .. formatPercent(nil, metalResist / 100)
    )
    local woodDmg = 100 + getPlayerAttr(nil, playerId, "木属性伤害") * 100
    local woodResist = 100 - getPlayerAttr(nil, playerId, "木属性抗性") * 100
    multiboardSetItemValue(
        nil,
        mb,
        2,
        3,
        (("风属性伤害：" .. formatPercent(nil, woodDmg / 100)) .. "/") .. formatPercent(nil, woodResist / 100)
    )
    local waterDmg = 100 + getPlayerAttr(nil, playerId, "水属性伤害") * 100
    local waterResist = 100 - getPlayerAttr(nil, playerId, "水属性抗性") * 100
    multiboardSetItemValue(
        nil,
        mb,
        3,
        3,
        (("冰属性伤害：" .. formatPercent(nil, waterDmg / 100)) .. "/") .. formatPercent(nil, waterResist / 100)
    )
    local fireDmg = 100 + getPlayerAttr(nil, playerId, "火属性伤害") * 100
    local fireResist = 100 - getPlayerAttr(nil, playerId, "火属性抗性") * 100
    multiboardSetItemValue(
        nil,
        mb,
        4,
        3,
        (("火属性伤害：" .. formatPercent(nil, fireDmg / 100)) .. "/") .. formatPercent(nil, fireResist / 100)
    )
    local earthDmg = 100 + getPlayerAttr(nil, playerId, "土属性伤害") * 100
    local earthResist = 100 - getPlayerAttr(nil, playerId, "土属性抗性") * 100
    multiboardSetItemValue(
        nil,
        mb,
        1,
        4,
        (("土属性伤害：" .. formatPercent(nil, earthDmg / 100)) .. "/") .. formatPercent(nil, earthResist / 100)
    )
    local thunderDmg = 100 + getPlayerAttr(nil, playerId, "雷属性伤害") * 100
    local thunderResist = 100 - getPlayerAttr(nil, playerId, "雷属性抗性") * 100
    multiboardSetItemValue(
        nil,
        mb,
        2,
        4,
        (("雷属性伤害：" .. formatPercent(nil, thunderDmg / 100)) .. "/") .. formatPercent(nil, thunderResist / 100)
    )
    local lightDmg = 100 + getPlayerAttr(nil, playerId, "光属性伤害") * 100
    local lightResist = 100 - getPlayerAttr(nil, playerId, "光属性抗性") * 100
    multiboardSetItemValue(
        nil,
        mb,
        3,
        4,
        (("光属性伤害：" .. formatPercent(nil, lightDmg / 100)) .. "/") .. formatPercent(nil, lightResist / 100)
    )
    local darkDmg = 100 + getPlayerAttr(nil, playerId, "暗属性伤害") * 100
    local darkResist = 100 - getPlayerAttr(nil, playerId, "暗属性抗性") * 100
    multiboardSetItemValue(
        nil,
        mb,
        4,
        4,
        (("暗属性伤害：" .. formatPercent(nil, darkDmg / 100)) .. "/") .. formatPercent(nil, darkResist / 100)
    )
    local critRate = getPlayerAttr(nil, playerId, "暴击率") * 100
    multiboardSetItemValue(
        nil,
        mb,
        1,
        5,
        "暴击率：" .. formatPercent(nil, critRate / 100)
    )
    local critDmg = 150 + getPlayerAttr(nil, playerId, "暴击伤害") * 100
    multiboardSetItemValue(
        nil,
        mb,
        2,
        5,
        "暴击伤害：" .. formatPercent(nil, critDmg / 100)
    )
    local critTaken = getPlayerAttr(nil, playerId, "被暴击率") * 100
    multiboardSetItemValue(
        nil,
        mb,
        3,
        5,
        "被暴击率：-" .. formatPercent(nil, critTaken / 100)
    )
    local critDmgTaken = getPlayerAttr(nil, playerId, "被暴击伤害") * 100
    multiboardSetItemValue(
        nil,
        mb,
        4,
        5,
        "被暴击伤害：-" .. formatPercent(nil, critDmgTaken / 100)
    )
    local accuracy = 100 + getPlayerAttr(nil, playerId, "命中率") * 100
    multiboardSetItemValue(
        nil,
        mb,
        1,
        6,
        "命中率：" .. formatPercent(nil, accuracy / 100)
    )
    local dodge = getPlayerAttr(nil, playerId, "闪避率") * 100
    multiboardSetItemValue(
        nil,
        mb,
        2,
        6,
        "闪避率：" .. formatPercent(nil, dodge / 100)
    )
    local cdReduction = getPlayerAttr(nil, playerId, "冷却缩减") * 100
    multiboardSetItemValue(
        nil,
        mb,
        3,
        6,
        "冷却缩减：" .. formatPercent(nil, cdReduction / 100)
    )
    local dmgReduction = getPlayerAttr(nil, playerId, "伤害减少")
    multiboardSetItemValue(
        nil,
        mb,
        4,
        6,
        "伤害固定减少：" .. formatNumber(nil, dmgReduction)
    )
    local atkSpeed = getPlayerAttr(nil, playerId, "每秒攻速") or 1
    multiboardSetItemValue(
        nil,
        mb,
        1,
        7,
        ("攻击速度：" .. formatReal(nil, atkSpeed)) .. "次/秒"
    )
    local moveSpeed = getPlayerAttr(nil, playerId, "移动速度") or 0
    multiboardSetItemValue(
        nil,
        mb,
        2,
        7,
        "移动速度：" .. formatReal(nil, moveSpeed)
    )
    local stunResist = getPlayerAttr(nil, playerId, "眩晕抗性") * 100
    multiboardSetItemValue(
        nil,
        mb,
        3,
        7,
        "眩晕抗性：" .. formatPercent(nil, stunResist / 100)
    )
    local atkLifesteal = getPlayerAttr(nil, playerId, "普攻伤害吸血") * 100
    multiboardSetItemValue(
        nil,
        mb,
        1,
        8,
        "普攻伤害吸血：" .. formatPercent(nil, atkLifesteal / 100)
    )
    local magicLifesteal = getPlayerAttr(nil, playerId, "魔法伤害吸血") * 100
    multiboardSetItemValue(
        nil,
        mb,
        2,
        8,
        "魔法伤害吸血：" .. formatPercent(nil, magicLifesteal / 100)
    )
    local lifesteal = getPlayerAttr(nil, playerId, "伤害吸血") * 100
    multiboardSetItemValue(
        nil,
        mb,
        3,
        8,
        "伤害吸血：" .. formatPercent(nil, lifesteal / 100)
    )
    local totalHpRegen = getPlayerAttr(nil, playerId, "总生命恢复")
    multiboardSetItemValue(
        nil,
        mb,
        1,
        9,
        ("当前生命恢复：" .. formatNumber(nil, totalHpRegen)) .. "/秒"
    )
    local baseHpRegen = getPlayerAttr(nil, playerId, "生命恢复")
    multiboardSetItemValue(
        nil,
        mb,
        2,
        9,
        ("基础生命恢复：" .. formatNumber(nil, baseHpRegen)) .. "/秒"
    )
    local pctHpRegen = getPlayerAttr(nil, playerId, "生命恢复%") * 100
    multiboardSetItemValue(
        nil,
        mb,
        3,
        9,
        ("百分比生命恢复：" .. formatPercent(nil, pctHpRegen / 100)) .. "/秒"
    )
    local hpRegenEff = getPlayerAttr(nil, playerId, "生命恢复效率") * 100
    multiboardSetItemValue(
        nil,
        mb,
        4,
        9,
        "生命恢复效率：" .. formatPercent(nil, hpRegenEff / 100)
    )
    local skillHeal = 100 + getPlayerAttr(nil, playerId, "技能治疗率") * 100
    multiboardSetItemValue(
        nil,
        mb,
        1,
        10,
        "技能治疗效率：" .. formatPercent(nil, skillHeal / 100)
    )
    local healReceived = 100 + getPlayerAttr(nil, playerId, "受到的治疗率") * 100
    multiboardSetItemValue(
        nil,
        mb,
        2,
        10,
        "受到治疗效率：" .. formatPercent(nil, healReceived / 100)
    )
    local totalMpRegen = getPlayerAttr(nil, playerId, "总魔法恢复")
    multiboardSetItemValue(
        nil,
        mb,
        1,
        11,
        ("当前魔法恢复：" .. formatNumber(nil, totalMpRegen)) .. "/秒"
    )
    local baseMpRegen = getPlayerAttr(nil, playerId, "魔法恢复")
    multiboardSetItemValue(
        nil,
        mb,
        2,
        11,
        ("基础魔法恢复：" .. formatNumber(nil, baseMpRegen)) .. "/秒"
    )
    local pctMpRegen = getPlayerAttr(nil, playerId, "魔法恢复%") * 100
    multiboardSetItemValue(
        nil,
        mb,
        3,
        11,
        ("百分比魔法恢复：" .. formatPercent(nil, pctMpRegen / 100)) .. "/秒"
    )
    local mpCost = getPlayerAttr(nil, playerId, "魔法消耗") * 100
    multiboardSetItemValue(
        nil,
        mb,
        4,
        11,
        "技能消耗减少：" .. formatPercent(nil, mpCost / 100)
    )
end
function updatePlayerSpeed(self, playerId)
    local heroGroup = YDUserDataGet(
        nil,
        "string",
        "玩家英雄",
        "单位组",
        "group"
    )
    if heroGroup == nil then
        return
    end
    local player = jass:Player(playerId - 1)
    local foundUnit = nil
    jass:ForGroup(
        heroGroup,
        function()
            local u = jass:GetEnumUnit()
            if u ~= nil and jass:GetOwningPlayer(u) == player then
                foundUnit = u
            end
        end
    )
    if foundUnit == nil then
        return
    end
    local attackInterval = jass:GetUnitState(
        foundUnit,
        jass:ConvertUnitState(37)
    )
    local attacksPerSec = attackInterval > 0 and 1 / attackInterval or 0
    local moveSpeed = jass:GetUnitMoveSpeed(foundUnit)
    YDUserDataSet(
        nil,
        "player",
        player,
        "每秒攻速",
        "real",
        attacksPerSec
    )
    YDUserDataSet(
        nil,
        "player",
        player,
        "移动速度",
        "real",
        moveSpeed
    )
end
function onRefreshTick(self)
    _refreshCounter = _refreshCounter + 1
    if _refreshCounter >= 50 then
        _refreshCounter = 0
        onRefresh(nil)
    end
end
function onRefresh(self)
    do
        local i = 0
        while i < DISPLAY_PLAYER_COUNT do
            do
                local mb = multiboards[i + 1]
                if mb == nil then
                    goto __continue27
                end
                if not jass:IsMultiboardDisplayed(mb) then
                    goto __continue27
                end
                updatePlayerSpeed(nil, i + 1)
                updateMultiboard(nil, mb, i + 1)
            end
            ::__continue27::
            i = i + 1
        end
    end
end
function registerToCenterTimer(self)
    if _registered then
        return
    end
    _registered = true
    onTick10ms(nil, onRefreshTick)
end
jass = require("jass.common")
local ____G_0 = _G
getGameTimeFormatted = ____G_0.getGameTimeFormatted
getGameDifficulty = ____G_0.getGameDifficulty
onTick10ms = ____G_0.onTick10ms
local ____require_result_1 = require("lib.扩展函数.YDWE函数.index")
YDUserDataGet = ____require_result_1.YDUserDataGet
YDUserDataSet = ____require_result_1.YDUserDataSet
multiboards = {}
--- 是否已初始化
local _initialized = false
_registered = false
_refreshCounter = 0
--- 设置多面板项目图标
local function multiboardSetItemIcon(self, mb, col, row, icon)
    if mb == nil then
        return
    end
    local item = jass:MultiboardGetItem(mb, row - 1, col - 1)
    if item ~= nil then
        jass:MultiboardSetItemIcon(item, icon)
        jass:MultiboardReleaseItem(item)
    end
end
--- 设置多面板项目样式
local function multiboardSetItemStyle(self, mb, col, row, showValue, showIcon)
    if mb == nil then
        return
    end
    local item = jass:MultiboardGetItem(mb, row - 1, col - 1)
    if item ~= nil then
        jass:MultiboardSetItemStyle(item, showValue, showIcon)
        jass:MultiboardReleaseItem(item)
    end
end
--- 创建单个多面板
local function createMultiboard(self, playerId)
    local player = jass:Player(playerId - 1)
    local slotState = jass:GetPlayerSlotState(player)
    local PLAYER_SLOT_STATE_PLAYING = jass.PLAYER_SLOT_STATE_PLAYING
    if slotState ~= PLAYER_SLOT_STATE_PLAYING then
        return nil
    end
    local mb = jass:CreateMultiboard()
    if mb == nil then
        return nil
    end
    jass:MultiboardSetTitleText(mb, "属性面板")
    jass:MultiboardSetTitleTextColor(
        mb,
        255,
        215,
        0,
        255
    )
    jass:MultiboardSetItemsWidth(mb, 0.08)
    jass:MultiboardSetRowCount(mb, MULTIBOARD_ROWS)
    jass:MultiboardSetColumnCount(mb, MULTIBOARD_COLS)
    do
        local row = 1
        while row <= MULTIBOARD_ROWS do
            do
                local col = 1
                while col <= MULTIBOARD_COLS do
                    multiboardSetItemValue(
                        nil,
                        mb,
                        col,
                        row,
                        ""
                    )
                    col = col + 1
                end
            end
            row = row + 1
        end
    end
    multiboardSetItemIcon(
        nil,
        mb,
        1,
        1,
        "ReplaceableTextures\\CommandButtons\\BTNArcaniteMelee.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        2,
        1,
        "ReplaceableTextures\\CommandButtons\\BTNSteelRanged.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        3,
        1,
        "ReplaceableTextures\\CommandButtons\\BTNNecromancerMaster.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        4,
        1,
        "ReplaceableTextures\\CommandButtons\\BTNTheBlackArrow.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        1,
        2,
        "ReplaceableTextures\\CommandButtons\\BTNSteelMelee.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        2,
        2,
        "ReplaceableTextures\\CommandButtons\\BTNWitchDoctorMaster.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        3,
        2,
        "ReplaceableTextures\\CommandButtons\\BTNCorpseExplode.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        4,
        2,
        "ReplaceableTextures\\CommandButtons\\BTNGrizzlyBear.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        1,
        3,
        "ReplaceableTextures\\CommandButtons\\BTNTransmute.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        2,
        3,
        "ReplaceableTextures\\CommandButtons\\BTNHumanLumberUpgrade1.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        3,
        3,
        "ReplaceableTextures\\CommandButtons\\BTNCrushingWave.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        4,
        3,
        "ReplaceableTextures\\CommandButtons\\BTNFireForTheCannon.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        1,
        4,
        "ReplaceableTextures\\CommandButtons\\BTNGatherGold.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        2,
        4,
        "ReplaceableTextures\\CommandButtons\\BTNMonsoon.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        3,
        4,
        "ReplaceableTextures\\CommandButtons\\BTNResurrection.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        4,
        4,
        "ReplaceableTextures\\CommandButtons\\BTNSoulGem.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        1,
        5,
        "ReplaceableTextures\\CommandButtons\\BTNCriticalStrike.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        2,
        5,
        "ReplaceableTextures\\CommandButtons\\BTNSmash.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        3,
        5,
        "ReplaceableTextures\\CommandButtons\\BTNHumanArmorUpThree.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        4,
        5,
        "ReplaceableTextures\\CommandButtons\\BTNLightningShield.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        1,
        6,
        "ReplaceableTextures\\CommandButtons\\BTNMarksmanship.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        2,
        6,
        "ReplaceableTextures\\PassiveButtons\\PASBTNEvasion.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        3,
        6,
        "ReplaceableTextures\\CommandButtons\\BTNStarWand.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        4,
        6,
        "ReplaceableTextures\\PassiveButtons\\PASBTNResistantSkin.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        1,
        7,
        "ReplaceableTextures\\CommandButtons\\BTNGlove.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        2,
        7,
        "ReplaceableTextures\\CommandButtons\\BTNBootsOfSpeed.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        3,
        7,
        "ReplaceableTextures\\CommandButtons\\BTNStun.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        1,
        8,
        "ReplaceableTextures\\CommandButtons\\BTNMaskOfDeath.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        2,
        8,
        "ReplaceableTextures\\CommandButtons\\BTNManaDrain.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        3,
        8,
        "ReplaceableTextures\\CommandButtons\\BTNDevourMagic.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        1,
        9,
        "ReplaceableTextures\\CommandButtons\\BTNRejuvenation.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        2,
        9,
        "ReplaceableTextures\\CommandButtons\\BTNRingSkull.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        3,
        9,
        "ReplaceableTextures\\CommandButtons\\BTNHealOn.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        4,
        9,
        "ReplaceableTextures\\CommandButtons\\BTNReplenishHealthOff.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        1,
        10,
        "ReplaceableTextures\\CommandButtons\\BTNHealingWave.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        2,
        10,
        "ReplaceableTextures\\CommandButtons\\BTNHealingSpray.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        1,
        11,
        "ReplaceableTextures\\CommandButtons\\BTNVialFull.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        2,
        11,
        "ReplaceableTextures\\CommandButtons\\BTNSobiMask.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        3,
        11,
        "ReplaceableTextures\\CommandButtons\\BTNBrilliance.blp"
    )
    multiboardSetItemIcon(
        nil,
        mb,
        4,
        11,
        "ReplaceableTextures\\CommandButtons\\BTNPriestAdept.blp"
    )
    multiboardSetItemStyle(
        nil,
        mb,
        4,
        7,
        true,
        false
    )
    multiboardSetItemStyle(
        nil,
        mb,
        4,
        8,
        true,
        false
    )
    multiboardSetItemStyle(
        nil,
        mb,
        3,
        10,
        true,
        false
    )
    multiboardSetItemStyle(
        nil,
        mb,
        4,
        10,
        true,
        false
    )
    if player == jass:GetLocalPlayer() then
        jass:MultiboardDisplay(mb, true)
    end
    return mb
end
--- 初始化多面板属性系统
function ____exports.initMultiboardSystem(self)
    if not MULTIBOARD_SYSTEM_ENABLED then
        return
    end
    if _initialized then
        return
    end
    _initialized = true
    do
        local i = 0
        while i < DISPLAY_PLAYER_COUNT do
            multiboards[i + 1] = createMultiboard(nil, i + 1)
            i = i + 1
        end
    end
    registerToCenterTimer(nil)
end
--- 检查系统是否启用
function ____exports.isMultiboardSystemEnabled(self)
    return MULTIBOARD_SYSTEM_ENABLED
end
--- 延迟初始化（游戏开始后执行）
local function delayedInit(self)
    ____exports.initMultiboardSystem(nil)
end
if MULTIBOARD_SYSTEM_ENABLED then
    local initTimer = jass:CreateTimer()
    jass:TimerStart(
        initTimer,
        2,
        false,
        function()
            delayedInit(nil)
            jass:DestroyTimer(initTimer)
        end
    )
end
return ____exports
