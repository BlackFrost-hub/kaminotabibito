local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
--- 为 true 时在屏幕显示装备限制与 DROP 跳过调试；排查完可设为 true
local jass = require("jass.common")
local g = require("jass.globals")
local items = require("系统.02．物品系统.01．装备数据").default
local equipLimit = require("系统.02．物品系统.10．装备限制")
local equipShared = equipLimit.equipShared
local equipMovespeed = require("系统.02．物品系统.08．装备移速")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.01．装备属性应用")
local applyEquipStatsTS = ____require_result_0.applyEquipStatsTS
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.index")
local fourCCToString = ____require_result_1.fourCCToString
local isSpecialUnit = ____require_result_1.isSpecialUnit
local ____require_result_2 = require("lib.扩展函数.YDWE函数.index")
local getObjectProperty = ____require_result_2.getObjectProperty
local ObjectType = ____require_result_2.ObjectType
--- 属性配置：显示名 -> itemData key。新增属性只需在此加一行，primaryBonus 即可用该显示名
local STAT_CONFIG = {
    {name = "生命值", key = "hp"},
    {name = "魔法值", key = "mp"},
    {name = "攻击力", key = "dmg"},
    {name = "护甲", key = "armor"},
    {name = "攻速", key = "atkSpeed"},
    {name = "叠加移动速度", key = "movespeed"},
    {name = "力量", key = "str"},
    {name = "敏捷", key = "agi"},
    {name = "智力", key = "int"},
    {name = "全属性", key = "all"},
    {name = "暴击率", key = "critRate"},
    {name = "暴击伤害", key = "critDmg"},
    {name = "魔抗", key = "magicResist"},
    {name = "生命恢复", key = "hpRegen"},
    {name = "生命恢复%", key = "hpRegenPct"},
    {name = "生命恢复效率", key = "hpRegenEff"},
    {name = "技能治疗率", key = "skillHeal"},
    {name = "受到的治疗率", key = "healReceived"},
    {name = "重伤", key = "wound"},
    {name = "魔法恢复", key = "mpRegen"},
    {name = "魔法恢复%", key = "mpRegenPct"},
    {name = "魔法消耗", key = "mpCost"},
    {name = "冷却缩减", key = "cdReduction"},
    {name = "命中率", key = "accuracy"},
    {name = "闪避率", key = "dodge"},
    {name = "护甲穿透", key = "armorPierce"},
    {name = "魔法穿透", key = "magicPierce"},
    {name = "技能伤害", key = "skillDmg"},
    {name = "技能抗性", key = "skillResist"},
    {name = "魔法伤害", key = "magicDmg"},
    {name = "物理伤害", key = "physDmg"},
    {name = "物理抗性", key = "physResist"},
    {name = "强化伤害", key = "enhanceDmg"},
    {name = "普攻伤害", key = "atkDmg"},
    {name = "普攻抗性", key = "atkResist"},
    {name = "光属性伤害", key = "lightDmg"},
    {name = "光属性抗性", key = "lightResist"},
    {name = "暗属性伤害", key = "darkDmg"},
    {name = "暗属性抗性", key = "darkResist"},
    {name = "木属性伤害", key = "woodDmg"},
    {name = "木属性抗性", key = "woodResist"},
    {name = "火属性伤害", key = "fireDmg"},
    {name = "火属性抗性", key = "fireResist"},
    {name = "雷属性伤害", key = "thunderDmg"},
    {name = "雷属性抗性", key = "thunderResist"},
    {name = "水属性伤害", key = "waterDmg"},
    {name = "水属性抗性", key = "waterResist"},
    {name = "金属性抗性", key = "metalResist"},
    {name = "金属性伤害", key = "metalDmg"},
    {name = "召唤物伤害", key = "summonDmg"},
    {name = "召唤物抗性", key = "summonResist"},
    {name = "伤害减少", key = "dmgReduction"},
    {name = "伤害减少%", key = "dmgReductionPct"},
    {name = "伤害吸血", key = "lifeSteal"},
    {name = "魔法伤害吸血", key = "magicLifeSteal"},
    {name = "普攻伤害吸血", key = "atkLifeSteal"},
    {name = "被暴击率", key = "critRateTaken"},
    {name = "被暴击伤害", key = "critDmgTaken"},
    {name = "眩晕抗性", key = "stunResist"},
    {name = "魔法普攻伤害", key = "magicAtkDmg"},
    {name = "蝼蚁专精", key = "antMastery"},
    {name = "移动速度", key = "movespeed2"},
    {name = "伤害%", key = "dmgBonus"},
    {name = "最终伤害%", key = "finalDmgBonus"},
    {name = "经验获取率", key = "expGainRate"},
    {name = "最大生命值%", key = "hpPct"},
    {name = "最大法力值%", key = "mpPct"},
    {name = "基础生命值%", key = "baseHpPct"},
    {name = "基础攻击力%", key = "baseDmgPct"},
    {name = "基础护甲%", key = "baseArmorPct"},
    {name = "生命值%", key = "hpPercent"},
    {name = "法力值%", key = "mpPercent"},
    {name = "攻击力%", key = "dmgPercent"},
    {name = "护甲%", key = "armorPercent"}
}
local NAME_TO_KEY = {}
for ____, e in ipairs(STAT_CONFIG) do
    NAME_TO_KEY[e.name] = e.key
end
if not NAME_TO_KEY["移速"] then
    NAME_TO_KEY["移速"] = "moveSpeed"
end
--- 解析 primaryBonus：格式 "力量+7/敏捷+10/智力+5,魔法伤害+5%"，按主属性 STR/AGI/INT 取对应段。返回 key->数值
local function parsePrimaryBonus(self, s, primaryStr)
    local out = {}
    local attrIndex = {STR = 0, AGI = 1, INT = 2}
    local idx = attrIndex[primaryStr]
    if not s or idx == nil then
        return out
    end
    local segments = __TS__StringSplit(s, "/")
    local seg = __TS__StringTrim(segments[idx + 1] or "")
    if not seg then
        return out
    end
    local parts = __TS__StringSplit(seg, ",")
    for ____, p in ipairs(parts) do
        do
            local __continue8
            repeat
                local idx = (string.find(p, "+", nil, true) or 0) - 1
                if idx < 0 then
                    __continue8 = true
                    break
                end
                local name = __TS__StringTrim(__TS__StringSubstring(p, 0, idx))
                local valStr = __TS__StringTrim(__TS__StringSubstring(p, idx + 1))
                local key = NAME_TO_KEY[name]
                if not key then
                    __continue8 = true
                    break
                end
                local isPct = (string.find(valStr, "%", nil, true) or 0) - 1 >= 0
                local num = __TS__ParseFloat(valStr) or 0
                out[key] = (out[key] or 0) + (isPct and num / 100 or num)
                __continue8 = true
            until true
            if not __continue8 then
                break
            end
        end
    end
    return out
end
local percentNames = {
    "暴击率",
    "暴击伤害",
    "命中率",
    "护甲穿透",
    "魔法穿透",
    "技能伤害",
    "闪避率",
    "魔抗",
    "冷却缩减",
    "伤害吸血",
    "魔法伤害吸血",
    "普攻伤害吸血",
    "攻速",
    "生命恢复%",
    "魔法恢复%",
    "技能治疗率",
    "受到的治疗率",
    "魔法消耗",
    "重伤",
    "技能抗性",
    "魔法伤害",
    "物理伤害",
    "物理抗性",
    "强化伤害",
    "普攻伤害",
    "普攻抗性",
    "光属性伤害",
    "光属性抗性",
    "暗属性伤害",
    "暗属性抗性",
    "木属性伤害",
    "木属性抗性",
    "火属性伤害",
    "火属性抗性",
    "雷属性伤害",
    "雷属性抗性",
    "水属性伤害",
    "水属性抗性",
    "金属性抗性",
    "召唤物伤害",
    "召唤物抗性",
    "伤害减少%",
    "被暴击率",
    "被暴击伤害",
    "眩晕抗性",
    "魔法普攻伤害",
    "蝼蚁专精",
    "伤害%",
    "最终伤害%",
    "经验获取率",
    "最大生命值%",
    "最大法力值%",
    "基础生命值%",
    "基础攻击力%",
    "基础护甲%",
    "生命值%",
    "法力值%",
    "攻击力%",
    "护甲%"
}
local function initEvents(self)
    local trig = jass.CreateTrigger()
    do
        local i = 0
        while i <= 7 do
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                jass.EVENT_PLAYER_UNIT_PICKUP_ITEM,
                nil
            )
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                jass.EVENT_PLAYER_UNIT_DROP_ITEM,
                nil
            )
            i = i + 1
        end
    end
    jass.TriggerRegisterPlayerUnitEvent(
        trig,
        jass.Player(13),
        jass.EVENT_PLAYER_UNIT_PICKUP_ITEM,
        nil
    )
    jass.TriggerRegisterPlayerUnitEvent(
        trig,
        jass.Player(13),
        jass.EVENT_PLAYER_UNIT_DROP_ITEM,
        nil
    )
    jass.TriggerAddAction(
        trig,
        function()
            local item = jass.GetManipulatedItem()
            local unit = jass.GetManipulatingUnit()
            if not unit or not item then
                return
            end
            if isSpecialUnit(nil, unit) then
                return
            end
            local player = jass.GetOwningPlayer(unit)
            local itemId = jass.GetItemTypeId(item)
            local event = jass.GetTriggerEventId()
            local isDrop = event == jass.EVENT_PLAYER_UNIT_DROP_ITEM
            local skipFlag = equipShared.skipNextDrop
            if isDrop and skipFlag then
                equipShared.skipNextDrop = false
                return
            end
            local idStr = fourCCToString(nil, itemId)
            local itemData = items[idStr]
            if not itemData then
                if event == jass.EVENT_PLAYER_UNIT_PICKUP_ITEM then
                    local ____temp_5 = type(slk) ~= "nil" and slk.item
                    if ____temp_5 then
                        local ____opt_3 = slk.item[idStr]
                        ____temp_5 = ____opt_3 and ____opt_3.name
                    end
                    local displayName = ____temp_5 or idStr
                    local border = "|cff606060────────────────────────|r"
                    local msg = (((((((border .. "\n|cffffff00『系统消息』：|r") .. "检测到|cFF87CEEB【装备】|r") .. "|cFFFFD700") .. "『") .. displayName) .. "』") .. "|r不在装备数据内，可以的话请加作者|cFF00D7FFQ2376886288|r反馈bug和问题，多谢。\n") .. border
                    jass.DisplayTimedTextToPlayer(
                        player,
                        0,
                        0.01,
                        10,
                        msg
                    )
                end
                return
            end
            local skipType = itemData.type
            if skipType == "任务" or skipType == "药剂" or skipType == "食品" then
                return
            end
            if isDrop and itemData.hot then
                return
            end
            if event == jass.EVENT_PLAYER_UNIT_PICKUP_ITEM and type(equipLimit.equipLimitWouldAllowPickup) == "function" and not equipLimit:equipLimitWouldAllowPickup(unit, item) then
                return
            end
            local charges = jass.GetItemCharges(item)
            local mult = charges > 0 and charges or 1
            local isAdd = event == jass.EVENT_PLAYER_UNIT_PICKUP_ITEM
            local primaryBonus = itemData.primaryBonus
            local primary = {}
            if primaryBonus then
                local ____temp_6
                if type(jass.GetUnitTypeId) == "function" then
                    ____temp_6 = jass.GetUnitTypeId(unit)
                else
                    ____temp_6 = 0
                end
                local typeId = ____temp_6
                local unitId = typeId ~= 0 and fourCCToString(nil, typeId) or ""
                local primaryStr = unitId ~= "" and getObjectProperty(nil, ObjectType.UNIT, unitId, "Primary") or ""
                primary = parsePrimaryBonus(nil, primaryBonus, primaryStr)
            end
            local merged = {}
            for ____, e in ipairs(STAT_CONFIG) do
                local ____e_key_8 = e.key
                local ____itemData_e_key_7 = itemData[e.key]
                if ____itemData_e_key_7 == nil then
                    ____itemData_e_key_7 = 0
                end
                merged[____e_key_8] = ____itemData_e_key_7 + (primary[e.key] or 0)
            end
            merged.moveSpeed = (itemData.moveSpeed or 0) + (primary.moveSpeed or 0)
            local playerStats = {}
            local function addStat(____, val, name)
                if val == nil or val == 0 then
                    return
                end
                local value = val * mult
                if not isAdd then
                    value = -value
                end
                playerStats[#playerStats + 1] = {name = name, value = value}
            end
            for ____, e in ipairs(STAT_CONFIG) do
                addStat(nil, merged[e.key], e.name)
            end
            local owner = jass.GetOwningPlayer(unit)
            local ____temp_9
            if type(jass.GetPlayerName) == "function" then
                ____temp_9 = jass.GetPlayerName(owner)
            else
                ____temp_9 = ""
            end
            local ____temp_9_10 = ____temp_9
            if ____temp_9_10 == nil then
                ____temp_9_10 = ""
            end
            local playerName = ____temp_9_10
            local actionText = isAdd and "获得" or "丢弃"
            local levelText = itemData.level or ""
            local levelColor
            if levelText == "E-" or levelText == "E" then
                levelColor = "|cFF808080"
            elseif levelText == "D" then
                levelColor = "|cFF00FF00"
            elseif levelText == "C" then
                levelColor = "|cFF0000FF"
            elseif levelText == "B" then
                levelColor = "|cFF800080"
            elseif levelText == "A" then
                levelColor = "|cFFFFA500"
            elseif levelText == "S" then
                levelColor = "|cFFFF0000"
            else
                levelColor = "|cFFFFFFFF"
            end
            local coloredLevel = (levelColor .. levelText) .. "|r"
            local coloredName = ("|cFFFFD700" .. (itemData.name or "未知")) .. "|r"
            local msg = (((((((("|cffffff00『系统消息』：|r" .. "|cFF87CEEB【装备】|r ") .. actionText) .. "[") .. coloredLevel) .. "]") .. "级") .. "『") .. coloredName) .. "』"
            for ____, stat in ipairs(playerStats) do
                local sign = stat.value > 0 and "+" or ""
                local isPct = __TS__ArrayIndexOf(percentNames, stat.name) >= 0
                local v = isPct and stat.value * 100 or stat.value
                local nearZero = v > -0.000001 and v < 0.000001
                local vStr = nearZero and "0" or tostring(v)
                msg = msg .. (((" " .. stat.name) .. sign) .. vStr) .. (isPct and "%" or "")
            end
            jass.DisplayTimedTextToPlayer(
                player,
                0,
                0.01,
                5,
                msg
            )
            local tempReadMap = applyEquipStatsTS(nil, unit, playerStats)
            local test5Parts = {}
            do
                local i = 0
                while i < #playerStats do
                    do
                        local __continue42
                        repeat
                            local statName = playerStats[i + 1].name
                            if statName == "移动速度" then
                                __continue42 = true
                                break
                            end
                            local val = tempReadMap[statName] ~= nil and tempReadMap[statName] or 0
                            local num = __TS__Number(val)
                            local isPct = __TS__ArrayIndexOf(percentNames, statName) >= 0
                            local nearZero = num > -0.000001 and num < 0.000001
                            local valStr = isPct and (nearZero and "0%" or tostring(math.floor(num * 1000 + 0.5) / 10
                            ) .. "%") or (nearZero and "0" or tostring(num))
                            test5Parts[#test5Parts + 1] = (statName .. "为：") .. valStr
                            __continue42 = true
                        until true
                        if not __continue42 then
                            break
                        end
                    end
                    i = i + 1
                end
            end
            local hasMovespeed2 = itemData.movespeed2 ~= nil
            if hasMovespeed2 and unit ~= nil and type(equipMovespeed.getMaxMovespeed2Info) == "function" then
                local ____equipMovespeed_getMaxMovespeed2Info_12 = equipMovespeed.getMaxMovespeed2Info
                local ____isDrop_11
                if isDrop then
                    ____isDrop_11 = item
                else
                    ____isDrop_11 = nil
                end
                local ms = ____equipMovespeed_getMaxMovespeed2Info_12(equipMovespeed, unit, ____isDrop_11)
                if ms.value > 0 then
                    test5Parts[#test5Parts + 1] = "移动速度为：" .. tostring(ms.value)
                end
                if ms.value > 0 and ms.name ~= "" and ms.count >= 2 then
                    jass.DisplayTimedTextToPlayer(
                        owner,
                        0,
                        0.02,
                        5,
                        ("|cffffff00『系统提示』：|r有多个不可叠加移速装备，当前只生效|cff00bfff『" .. ms.name) .. "』|r"
                    )
                end
            end
            if #test5Parts > 0 then
                jass.DisplayTimedTextToPlayer(
                    owner,
                    0,
                    0.02,
                    5,
                    (("|cffffff00『系统消息』：|r" .. tostring(playerName)) .. "的当前装备加成") .. table.concat(test5Parts, "，")
                )
            end
        end
    )
end
initEvents(nil)
return ____exports
