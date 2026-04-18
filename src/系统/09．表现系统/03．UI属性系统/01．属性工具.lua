local ____lualib = require("lualib_bundle")
local __TS__StringEndsWith = ____lualib.__TS__StringEndsWith
local ____exports = {}
--- UI属性系统 - 属性读取、格式化与派生值更新
local jass = require("jass.common")
local _____73A9_5BB6_5E38_91CF = require("系统.00．核心系统.00．玩家系统.00．常量")
local ____require_result_0 = require("系统.09．表现系统.03．UI属性系统.00．常量定义")
local MAX_DISPLAY_PLAYERS = ____require_result_0.MAX_DISPLAY_PLAYERS
local ____require_result_1 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_1.YDUserDataGet
local YDUserDataSet = ____require_result_1.YDUserDataSet
local getObjectProperty = ____require_result_1.getObjectProperty
local ObjectType = ____require_result_1.ObjectType
local EMPTY_ICON = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"
local DAMAGE_ATTRS = {"造成伤害", "承受伤害", "治疗量"}
local function isTexturePath(path)
    if path == "" then
        return false
    end
    local lower = string.lower(path)
    return __TS__StringEndsWith(lower, ".blp") or __TS__StringEndsWith(lower, ".dds") or __TS__StringEndsWith(lower, ".tga")
end
function ____exports.isPlayingPlayer(player)
    if player == nil then
        return false
    end
    return jass.GetPlayerSlotState(player) == jass.PLAYER_SLOT_STATE_PLAYING
end
function ____exports.getDisplayPlayers()
    local players = {}
    do
        local i = 0
        while i < MAX_DISPLAY_PLAYERS do
            do
                local player = jass.Player(i)
                if not ____exports.isPlayingPlayer(player) then
                    goto __continue8
                end
                players[#players + 1] = player
            end
            ::__continue8::
            i = i + 1
        end
    end
    return players
end
--- 从玩家级 YDUserData 中读取当前登记的英雄。
-- 这套 UI 直接依赖"玩家 -> 英雄"映射，而不是自行遍历单位组兜底。
function ____exports.getPlayerHero(player)
    if player == nil then
        return nil
    end
    return YDUserDataGet(
        nil,
        "player",
        player,
        _____73A9_5BB6_5E38_91CF.YD_ATTR_PLAYER_HERO_UNIT,
        "unit"
    )
end
function ____exports.getPlayerAttr(player, attrName)
    if player == nil or attrName == "" then
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
function ____exports.getDamageValues(player)
    local values = {}
    do
        local i = 0
        while i < #DAMAGE_ATTRS do
            values[#values + 1] = ____exports.getPlayerAttr(player, DAMAGE_ATTRS[i + 1])
            i = i + 1
        end
    end
    return values
end
--- 同步 JASS 原稿依赖的实时派生值。
-- 这里保留 0x25 / 0x51 的攻速算法，并把结果写回玩家属性表，供 UI 文本直接读取。
function ____exports.updatePlayerRealtimeStats(player)
    local hero = ____exports.getPlayerHero(player)
    if hero == nil then
        return
    end
    local intervalState = jass.ConvertUnitState(37)
    local speedState = jass.ConvertUnitState(81)
    local attackBaseInterval = jass.GetUnitState(hero, intervalState)
    local attackSpeedScale = jass.GetUnitState(hero, speedState)
    local attackInterval = attackSpeedScale > 0 and attackBaseInterval / attackSpeedScale or 0
    local attacksPerSecond = attackInterval > 0 and 1 / attackInterval or 0
    local moveSpeed = jass.GetUnitMoveSpeed(hero)
    YDUserDataSet(
        nil,
        "player",
        player,
        "每秒攻速",
        "real",
        attacksPerSecond
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
function ____exports.getHeroIcon(hero)
    if hero == nil then
        return EMPTY_ICON
    end
    local typeId = jass.GetUnitTypeId(hero)
    if typeId == nil or typeId == 0 then
        return EMPTY_ICON
    end
    local art = getObjectProperty(nil, ObjectType.UNIT, typeId, "Art")
    if isTexturePath(art) then
        return art
    end
    local icon = getObjectProperty(nil, ObjectType.UNIT, typeId, "uico")
    if isTexturePath(icon) then
        return icon
    end
    return EMPTY_ICON
end
function ____exports.formatInteger(value)
    return tostring(math.floor(math.max(0, value) + 0.5))
end
function ____exports.formatPercent(value)
    return tostring(math.floor(value * 100 + 0.5)) .. "%"
end
function ____exports.formatRate(value)
    return tostring(math.floor(value * 100 + 0.5) / 100)
end
local function dualLine(leftColor, leftLabel, leftValue, rightColor, rightLabel, rightValue)
    if rightLabel == "" then
        return ((leftColor .. leftLabel) .. leftValue) .. "|r"
    end
    return ((((((leftColor .. leftLabel) .. leftValue) .. "|r ") .. rightColor) .. rightLabel) .. rightValue) .. "|r"
end
local function pctPlus100(player, attr)
    return ____exports.formatPercent((100 + ____exports.getPlayerAttr(player, attr) * 100) / 100)
end
local function pctMinus100(player, attr)
    return ____exports.formatPercent((100 - ____exports.getPlayerAttr(player, attr) * 100) / 100)
end
local function pct(player, attr)
    return ____exports.formatPercent(____exports.getPlayerAttr(player, attr))
end
local function number(player, attr)
    return ____exports.formatInteger(____exports.getPlayerAttr(player, attr))
end
--- 按 `属性查看.j` 的展示顺序拼出属性框每一行文本。
-- 这里统一改为读取当前 TS 正式属性名，不再兼容旧 JASS 字段名。
function ____exports.buildDetailTexts(player)
    ____exports.updatePlayerRealtimeStats(player)
    return {
        dualLine(
            "|cff993300",
            "物理伤害：",
            (pctPlus100(player, "物理伤害") .. "/") .. pctMinus100(player, "物理抗性"),
            "|cff993300",
            "护甲穿透：",
            pct(player, "护甲穿透")
        ),
        dualLine(
            "|cff00ccff",
            "魔法伤害：",
            (pctPlus100(player, "魔法伤害") .. "/") .. pctMinus100(player, "魔抗"),
            "|cff00ccff",
            "魔法穿透：",
            pct(player, "魔法穿透")
        ),
        dualLine(
            "|cffff6800",
            "技能伤害：",
            (pctPlus100(player, "技能伤害") .. "/") .. pctMinus100(player, "技能抗性"),
            "|cffff6600",
            "强化伤害：",
            pctPlus100(player, "强化伤害")
        ),
        dualLine(
            "|cff333333",
            "召唤物伤害：",
            (pctPlus100(player, "召唤物伤害") .. "/") .. pctMinus100(player, "召唤物抗性"),
            "",
            "",
            ""
        ),
        dualLine(
            "|cffff0000",
            "火属性：",
            (pctPlus100(player, "火属性伤害") .. "/") .. pctMinus100(player, "火属性抗性"),
            "|cff00ffff",
            "冰属性：",
            (pctPlus100(player, "水属性伤害") .. "/") .. pctMinus100(player, "水属性抗性")
        ),
        dualLine(
            "|cffccffff",
            "雷属性：",
            (pctPlus100(player, "雷属性伤害") .. "/") .. pctMinus100(player, "雷属性抗性"),
            "|cff99cc00",
            "风属性：",
            (pctPlus100(player, "木属性伤害") .. "/") .. pctMinus100(player, "木属性抗性")
        ),
        dualLine(
            "|cffffff00",
            "光属性：",
            (pctPlus100(player, "光属性伤害") .. "/") .. pctMinus100(player, "光属性抗性"),
            "|cff993366",
            "暗属性：",
            (pctPlus100(player, "暗属性伤害") .. "/") .. pctMinus100(player, "暗属性抗性")
        ),
        dualLine(
            "|cffff0000",
            "暴击率：",
            pct(player, "暴击率"),
            "|cffff0000",
            "暴击伤害：",
            ____exports.formatPercent((150 + ____exports.getPlayerAttr(player, "暴击伤害") * 100) / 100)
        ),
        dualLine(
            "|cffff0000",
            "被暴击率：-",
            pct(player, "被暴击率"),
            "|cffff0000",
            "被暴击伤害：-",
            pct(player, "被暴击伤害")
        ),
        dualLine(
            "|cffff8080",
            "命中率：",
            pct(player, "命中率"),
            "|cffff8080",
            "闪避率：",
            pct(player, "闪避率")
        ),
        dualLine(
            "|cffff8080",
            "冷却缩减：",
            pct(player, "冷却缩减"),
            "|cff99ccff",
            "固定伤害减少：",
            number(player, "伤害减少")
        ),
        dualLine(
            "|cff99ccff",
            "攻击速度：",
            ____exports.formatRate(____exports.getPlayerAttr(player, "每秒攻速")) .. "次/秒",
            "|cff99ccff",
            "移动速度：",
            number(player, "移动速度")
        ),
        dualLine(
            "|cff99ccff",
            "眩晕抗性：",
            pct(player, "眩晕抗性"),
            "",
            "",
            ""
        ),
        dualLine(
            "|cffff0000",
            "普攻吸血：",
            pct(player, "普攻伤害吸血"),
            "|cffff0000",
            "魔法吸血：",
            pct(player, "魔法伤害吸血")
        ),
        dualLine(
            "|cffff0000",
            "伤害吸血：",
            pct(player, "伤害吸血"),
            "",
            "",
            ""
        ),
        dualLine(
            "|cffccffcc",
            "当前回血：",
            number(player, "总生命恢复") .. "/秒",
            "|cffccffcc",
            "基础生命恢复：",
            number(player, "生命恢复") .. "/秒"
        ),
        dualLine(
            "|cffccffcc",
            "百分比回血：",
            pct(player, "生命恢复%") .. "/秒",
            "|cffccffcc",
            "生命恢复效率：",
            pct(player, "生命恢复效率")
        ),
        dualLine(
            "|cffffcc99",
            "技能治疗效率：",
            pct(player, "技能治疗率"),
            "|cffffcc99",
            "受到治疗效率：",
            pct(player, "受到的治疗率")
        ),
        dualLine(
            "|cffccffff",
            "当前回魔：",
            number(player, "总魔法恢复") .. "/秒",
            "|cffccffff",
            "基础魔法恢复：",
            number(player, "魔法恢复") .. "/秒"
        ),
        dualLine(
            "|cffccffff",
            "百分比回魔：",
            pct(player, "魔法恢复%"),
            "|cffccffff",
            "技能消耗减少：",
            pct(player, "魔法消耗")
        )
    }
end
return ____exports
