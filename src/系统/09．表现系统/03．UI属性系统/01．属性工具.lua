local ____lualib = require("lualib_bundle")
local __TS__StringEndsWith = ____lualib.__TS__StringEndsWith
local ____exports = {}
--- UI属性系统 - 属性读取、格式化与派生值更新
-- 
-- 属性读取统一走当前TS正式字段名，优先对齐 TS/系统/02．物品系统/11．装备系统.ts
-- 数据源：玩家->英雄、造成伤害/承受伤害/治疗量 等YDUserData
-- 
-- 依赖：
-- - lib.扩展函数.YDWE函数.index
-- - lib.扩展函数.Star扩展函数.Star扩展库.index
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local round = ____require_result_0.round
local max = ____require_result_0.max
local _____73A9_5BB6_5E38_91CF = require("系统.00．核心系统.00．玩家系统.00．常量")
local ____require_result_1 = require("系统.09．表现系统.03．UI属性系统.00．常量定义")
local MAX_DISPLAY_PLAYERS = ____require_result_1.MAX_DISPLAY_PLAYERS
local ydweIndex = require("lib.扩展函数.YDWE函数.index")
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_2.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_2.YDUserDataSetSafe
local getObjectProperty = ydweIndex.getObjectProperty
local ObjectType = ydweIndex.ObjectType
local YDUserDataGet = YDUserDataGetSafe
local YDUserDataSet = YDUserDataSetSafe
local EMPTY_ICON = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"
local DAMAGE_ATTRS = {"造成伤害", "承受伤害", "治疗量"}
local function maxNum3(a, b, c)
    return max(
        max(a, b),
        c
    )
end
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
function ____exports.isHumanPlayer(player)
    if player == nil then
        return false
    end
    return jass.GetPlayerController(player) ~= jass.MAP_CONTROL_COMPUTER
end
function ____exports.getDisplayPlayers()
    local players = {}
    do
        local i = 0
        while i < MAX_DISPLAY_PLAYERS do
            do
                local player = jass.Player(i)
                if not ____exports.isPlayingPlayer(player) then
                    goto __continue11
                end
                if not ____exports.isHumanPlayer(player) then
                    goto __continue11
                end
                players[#players + 1] = player
            end
            ::__continue11::
            i = i + 1
        end
    end
    return players
end
--- 从玩家级 YDUserData 中读取当前登记的英雄。
-- 英雄来源由“玩家英雄获取桥接”模块注册：
-- 系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接
function ____exports.getPlayerHero(player)
    if player == nil then
        return nil
    end
    return YDUserDataGet("player", player, _____73A9_5BB6_5E38_91CF.YD_ATTR_PLAYER_HERO_UNIT, "unit")
end
function ____exports.getPlayerAttr(player, attrName)
    if player == nil or attrName == "" then
        return 0
    end
    local value = YDUserDataGet("player", player, attrName, "real")
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
--- 从英雄单位状态计算「每秒攻速」「移动速度」并写回玩家级 YDUserData。
-- 与 `JASS/jass复制粘贴/属性查看.j` 的展示数据源一致：表由同步逻辑维护，UI 刷新前回写这两列便于全图读表一致。
-- 注意：仅 Tab 显隐伤害面板、头像悬浮显隐属性框走本机 Frame（见面板里 DzFrameSetScriptByCode 异步位）。
function ____exports.updatePlayerRealtimeStats(player)
    local hero = ____exports.getPlayerHero(player)
    if hero == nil then
        return
    end
    local intervalState = jass.ConvertUnitState(37)
    local speedState = jass.ConvertUnitState(81)
    local baseInterval = japi.GetUnitState(hero, intervalState)
    local speedScale = japi.GetUnitState(hero, speedState)
    local oldAps = ____exports.getPlayerAttr(player, "每秒攻速")
    local oldMoveSpeed = ____exports.getPlayerAttr(player, "移动速度")
    local attackIntervalSafe = baseInterval > 0 and speedScale > 0 and baseInterval / speedScale or 0
    local computedApsSafe = attackIntervalSafe > 0 and 1 / attackIntervalSafe or 0
    local attacksPerSecond = computedApsSafe > 0 and computedApsSafe or oldAps
    local rawMoveSpeed = jass.GetUnitMoveSpeed(hero)
    local ____temp_3
    if rawMoveSpeed > 0 then
        ____temp_3 = rawMoveSpeed
    else
        ____temp_3 = oldMoveSpeed
    end
    local moveSpeed = ____temp_3
    local apsQuant = round(attacksPerSecond * 10000) / 10000
    local moveQuant = round(moveSpeed * 100) / 100
    if apsQuant > 0 then
        YDUserDataSet(
            "player",
            player,
            "每秒攻速",
            "real",
            apsQuant
        )
    end
    if moveQuant > 0 then
        YDUserDataSet(
            "player",
            player,
            "移动速度",
            "real",
            moveQuant
        )
    end
end
--- 英雄头像贴图路径（物编 Art / uico）。
-- 与 `属性查看.j` 一致：**仅在创建 Dz 头像时调用一次**；周期定时器只刷文字，不重复 `DzFrameSetTexture` 头像。
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
    return tostring(round(max(0, value)))
end
function ____exports.formatPercent(value)
    return tostring(round(value * 100)) .. "%"
end
function ____exports.formatRate(value)
    return tostring(round(value * 100) / 100)
end
local function dualLine(leftColor, leftLabel, leftValue, rightColor, rightLabel, rightValue)
    if rightLabel == "" then
        return ((leftColor .. leftLabel) .. leftValue) .. "|r"
    end
    return ((((((leftColor .. leftLabel) .. leftValue) .. "|r ") .. rightColor) .. rightLabel) .. rightValue) .. "|r"
end
local function singleLine(color, label, value)
    return ((color .. label) .. value) .. "|r"
end
--- 将三列属性合并成五列布局（左列、分隔符、中列、分隔符、右列）
-- 每列布局：第1行分隔线、第2行标题、第3行分隔线，从第4行开始显示竖线分隔符
local function linesToColumns(left, mid, right)
    local maxRows = maxNum3(#left, #mid, #right)
    local result = {}
    do
        local i = 0
        while i < maxRows do
            result[#result + 1] = left[i + 1] or ""
            result[#result + 1] = i >= 3 and "|" or ""
            result[#result + 1] = mid[i + 1] or ""
            result[#result + 1] = i >= 3 and "|" or ""
            result[#result + 1] = right[i + 1] or ""
            i = i + 1
        end
    end
    return result
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
-- 与装备系统属性对齐
-- 
-- ============================================================
-- 三列布局对齐规则（重要！后续开发者请务必遵守）
-- ============================================================
-- 
-- 【布局结构】
-- - 左列：基础属性（英雄核心属性）
-- - 中列：常规属性（战斗相关属性）
-- - 右列：特殊属性（元素和吸血属性）
-- 
-- 【行对齐规则】
-- 同一行上的三列属性应该具有关联性，便于玩家对照查看：
-- 
-- 第3-4行：攻速移速 / 物理伤害抗性 / 光属性伤害抗性
-- 第5-6行：生命法力% / 魔法伤害抗性 / 暗属性伤害抗性
-- 第7-8行：生命恢复组 / 技能伤害抗性 / 木属性伤害抗性
-- 第9-10行：生命恢复组 / 普攻伤害抗性 / 火属性伤害抗性
-- 第11-12行：魔法恢复组 / 穿透属性 / 雷属性伤害抗性
-- 第13-14行：【暴击组】暴击率/暴击伤害 ↔ 被暴击率/被暴击伤害 / 水属性伤害抗性
-- 第15-16行：【命中组】命中率/闪避率 ↔ 伤害%/伤害减少% / 金属性伤害抗性
-- 第17-18行：【重伤组】重伤/恢复效率 ↔ 强化伤害/最终伤害 / 召唤物伤害抗性
-- 第19-20行：治疗相关 / 冷却缩减/经验获取率 / 吸血属性
-- 第21行：预留 / 预留 / 伤害吸血
-- 
-- 【关键对齐组】
-- 1. 暴击组（第13-14行）：
--    - 左列：暴击率、暴击伤害（进攻方）
--    - 中列：被暴击率、被暴击伤害（防守方）
--    - 右列：水属性伤害、水属性抗性
-- 
-- 2. 命中组（第15-16行）：
--    - 左列：命中率、闪避率（攻防对）
--    - 中列：伤害%、伤害减少%（攻防对）
--    - 右列：金属性伤害、金属性抗性
-- 
-- 3. 重伤组（第17-18行）：
--    - 左列：重伤、恢复效率（攻防对）
--    - 中列：强化伤害、最终伤害（伤害加成组）
--    - 右列：召唤物伤害、召唤物抗性
-- 
-- 4. 伤害/抗性对（各自行内）：
--    - 物理伤害 ↔ 物理抗性（第3-4行，橙色）
--    - 魔法伤害 ↔ 魔抗（第5-6行，蓝色）
--    - 技能伤害 ↔ 技能抗性（第7-8行，绿色）
--    - 普攻伤害 ↔ 普攻抗性（第9-10行，灰色）
--    - 所有元素属性伤害 ↔ 抗性（第3-18行，右列）
-- 
-- 【颜色统一规则】
-- - 物理系：橙色 |cffc47f4f
-- - 魔法系：蓝色 |cff67d8ff
-- - 技能系：绿色 |cff7bff7b
-- - 普攻系：灰色 |cffb5b5b5
-- - 暴击系：红色 |cffff4b4b
-- 
-- 【修改注意事项】
-- - 新增属性时，确保三列总行数一致
-- - 调整属性位置时，保持关联属性在同一行
-- - 修改后务必运行 npm run build 验证
-- ============================================================
function ____exports.buildDetailTexts(player)
    ____exports.updatePlayerRealtimeStats(player)
    local leftColumn = {
        "|cff000000────────|r",
        singleLine("|cffd8b26a", "【基础属性】", ""),
        "|cff000000────────|r",
        singleLine(
            "|cff8ebfff",
            "攻速：",
            ____exports.formatRate(____exports.getPlayerAttr(player, "每秒攻速")) .. "次/秒"
        ),
        singleLine(
            "|cff8ebfff",
            "移速：",
            number(player, "移动速度")
        ),
        singleLine(
            "|cffc0ff82",
            "生命值%：",
            pct(player, "生命值%")
        ),
        singleLine(
            "|cff8fdfff",
            "法力值%：",
            pct(player, "法力值%")
        ),
        singleLine(
            "|cff96ff9d",
            "生命恢复：",
            number(player, "基础生命恢复") .. "/秒"
        ),
        singleLine(
            "|cff96ff9d",
            "装备生命恢复：",
            number(player, "生命恢复") .. "/秒"
        ),
        singleLine(
            "|cff96ff9d",
            "生命恢复%：",
            pct(player, "生命恢复%")
        ),
        singleLine(
            "|cff96ff9d",
            "总生命恢复：",
            number(player, "总生命恢复") .. "/秒"
        ),
        singleLine(
            "|cff8fdfff",
            "魔法恢复：",
            number(player, "基础魔法恢复") .. "/秒"
        ),
        singleLine(
            "|cff8fdfff",
            "装备魔法恢复：",
            number(player, "魔法恢复") .. "/秒"
        ),
        singleLine(
            "|cff8fdfff",
            "魔法恢复%：",
            pct(player, "魔法恢复%")
        ),
        singleLine(
            "|cff8fdfff",
            "总魔法恢复：",
            number(player, "总魔法恢复") .. "/秒"
        ),
        singleLine(
            "|cffff6d5b",
            "暴击率：",
            pct(player, "暴击率")
        ),
        singleLine(
            "|cffff4b4b",
            "暴击伤害：",
            ____exports.formatPercent((150 + ____exports.getPlayerAttr(player, "暴击伤害") * 100) / 100)
        ),
        singleLine(
            "|cffffa7af",
            "命中率：",
            pctPlus100(player, "命中率")
        ),
        singleLine(
            "|cffd4c7ff",
            "闪避率：",
            pct(player, "闪避率")
        ),
        singleLine(
            "|cffff967d",
            "重伤：",
            pct(player, "重伤")
        ),
        singleLine(
            "|cff96ff9d",
            "恢复效率：",
            pct(player, "生命恢复效率")
        ),
        singleLine(
            "|cffffcc99",
            "技能治疗率：",
            pct(player, "技能治疗率")
        ),
        singleLine(
            "|cffffcc99",
            "受到治疗率：",
            pct(player, "受到的治疗率")
        )
    }
    local midColumn = {
        "|cff000000────────|r",
        singleLine("|cffff9d5c", "【常规属性】", ""),
        "|cff000000────────|r",
        singleLine(
            "|cffc47f4f",
            "物理伤害：",
            pctPlus100(player, "物理伤害")
        ),
        singleLine(
            "|cffc47f4f",
            "物理抗性：",
            pctMinus100(player, "物理抗性")
        ),
        singleLine(
            "|cff67d8ff",
            "魔法伤害：",
            pctPlus100(player, "魔法伤害")
        ),
        singleLine(
            "|cff67d8ff",
            "魔抗：",
            pctMinus100(player, "魔抗")
        ),
        singleLine(
            "|cff7bff7b",
            "技能伤害：",
            pctPlus100(player, "技能伤害")
        ),
        singleLine(
            "|cff7bff7b",
            "技能抗性：",
            pctMinus100(player, "技能抗性")
        ),
        singleLine(
            "|cffb5b5b5",
            "普攻伤害：",
            pctPlus100(player, "普攻伤害")
        ),
        singleLine(
            "|cffb5b5b5",
            "普攻抗性：",
            pctMinus100(player, "普攻抗性")
        ),
        singleLine(
            "|cffffca7e",
            "护甲穿透：",
            pct(player, "护甲穿透")
        ),
        singleLine(
            "|cff77ddff",
            "魔法穿透：",
            pct(player, "魔法穿透")
        ),
        singleLine(
            "|cffff4b4b",
            "被暴击率：",
            pct(player, "被暴击率")
        ),
        singleLine(
            "|cffff4b4b",
            "被暴击伤害：",
            pct(player, "被暴击伤害")
        ),
        singleLine(
            "|cffff00ff",
            "伤害%：",
            pct(player, "伤害%")
        ),
        singleLine(
            "|cffd0d9e1",
            "伤害减少%：",
            pct(player, "伤害减少%")
        ),
        singleLine(
            "|cffd0d9e1",
            "固伤减少：",
            number(player, "伤害减少")
        ),
        singleLine(
            "|cffd0d9e1",
            "物理固伤减少：",
            number(player, "物理固定伤害减少")
        ),
        singleLine(
            "|cffd0d9e1",
            "魔法固伤减少：",
            number(player, "魔法固定伤害减少")
        ),
        singleLine(
            "|cffd0d9e1",
            "技能固伤减少：",
            number(player, "技能固定伤害减少")
        ),
        singleLine(
            "|cffff8b57",
            "强化伤害：",
            pctPlus100(player, "强化伤害")
        ),
        singleLine(
            "|cffff00ff",
            "最终伤害：",
            pct(player, "最终伤害%")
        ),
        singleLine(
            "|cff99ccff",
            "冷却缩减：",
            pct(player, "冷却缩减")
        ),
        singleLine(
            "|cffff00ff",
            "经验获取率：",
            pct(player, "经验获取率")
        )
    }
    local rightColumn = {
        "|cff000000────────|r",
        singleLine("|cff8fd9ff", "【特殊属性】", ""),
        "|cff000000────────|r",
        singleLine(
            "|cffffeb7c",
            "光属性伤害：",
            pctPlus100(player, "光属性伤害")
        ),
        singleLine(
            "|cffffeb7c",
            "光属性抗性：",
            pctMinus100(player, "光属性抗性")
        ),
        singleLine(
            "|cff9e7bff",
            "暗属性伤害：",
            pctPlus100(player, "暗属性伤害")
        ),
        singleLine(
            "|cff9e7bff",
            "暗属性抗性：",
            pctMinus100(player, "暗属性抗性")
        ),
        singleLine(
            "|cff7bff7b",
            "木属性伤害：",
            pctPlus100(player, "木属性伤害")
        ),
        singleLine(
            "|cff7bff7b",
            "木属性抗性：",
            pctMinus100(player, "木属性抗性")
        ),
        singleLine(
            "|cffff7b7b",
            "火属性伤害：",
            pctPlus100(player, "火属性伤害")
        ),
        singleLine(
            "|cffff7b7b",
            "火属性抗性：",
            pctMinus100(player, "火属性抗性")
        ),
        singleLine(
            "|cffffeb3b",
            "雷属性伤害：",
            pctPlus100(player, "雷属性伤害")
        ),
        singleLine(
            "|cffffeb3b",
            "雷属性抗性：",
            pctMinus100(player, "雷属性抗性")
        ),
        singleLine(
            "|cff7bebff",
            "水属性伤害：",
            pctPlus100(player, "水属性伤害")
        ),
        singleLine(
            "|cff7bebff",
            "水属性抗性：",
            pctMinus100(player, "水属性抗性")
        ),
        singleLine(
            "|cffffd700",
            "金属性伤害：",
            pctPlus100(player, "金属性伤害")
        ),
        singleLine(
            "|cffffd700",
            "金属性抗性：",
            pctMinus100(player, "金属性抗性")
        ),
        singleLine(
            "|cffff7c7c",
            "召唤物伤害：",
            pctPlus100(player, "召唤物伤害")
        ),
        singleLine(
            "|cffff7c7c",
            "召唤物抗性：",
            pctMinus100(player, "召唤物抗性")
        ),
        singleLine(
            "|cffff7c7c",
            "普攻吸血：",
            pct(player, "普攻伤害吸血")
        ),
        singleLine(
            "|cffff7c7c",
            "魔法吸血：",
            pct(player, "魔法伤害吸血")
        ),
        singleLine(
            "|cffff7c7c",
            "伤害吸血：",
            pct(player, "伤害吸血")
        )
    }
    return linesToColumns(leftColumn, midColumn, rightColumn)
end
return ____exports
