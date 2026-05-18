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
local itemEventCenter = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local g = require("jass.globals")
local equipLimit = require("系统.02．物品系统.10．装备限制")
local equipShared = equipLimit.equipShared
local equipMovespeed = require("系统.02．物品系统.08．装备移速")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.01．装备属性应用")
local applyEquipStatsTS = ____require_result_0.applyEquipStatsTS
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.index")
local fourCCToString = ____require_result_1.fourCCToString
local isSpecialUnit = ____require_result_1.isSpecialUnit
local itemRelatedFns = require("lib.扩展函数.物品相关函数.index")
local ____require_result_2 = require("lib.扩展函数.YDWE函数.index")
local getObjectProperty = ____require_result_2.getObjectProperty
local ObjectType = ____require_result_2.ObjectType
local ____require_result_3 = require("系统.00．核心系统.01．颜色常量")
local _____88C5_5907_7B49_7EA7_989C_8272_4EE3_7801 = ____require_result_3["装备等级颜色代码"]
local _____662F_5426_5F69_8679_88C5_5907_7B49_7EA7 = ____require_result_3["是否彩虹装备等级"]
local _____5F69_8679_989C_8272_6587_672C = ____require_result_3["彩虹颜色文本"]
local _____53BB_9664_989C_8272_4EE3_7801 = ____require_result_3["去除颜色代码"]
local EQUIP_EVENT_PLAYER_IDS = {
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    13
}
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
            local idx = (string.find(p, "+", nil, true) or 0) - 1
            if idx < 0 then
                goto __continue5
            end
            local name = __TS__StringTrim(__TS__StringSubstring(p, 0, idx))
            local valStr = __TS__StringTrim(__TS__StringSubstring(p, idx + 1))
            local key = itemRelatedFns.NAME_TO_KEY[name]
            if not key then
                goto __continue5
            end
            local isPct = (string.find(valStr, "%", nil, true) or 0) - 1 >= 0
            local num = __TS__ParseFloat(valStr) or 0
            out[key] = (out[key] or 0) + (isPct and num / 100 or num)
        end
        ::__continue5::
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
--- 处理物品拾取/丢弃的核心逻辑
local function handleItemEvent(self, unit, item, isPickup)
    if unit == nil or unit == 0 or item == nil or item == 0 then
        return
    end
    if isSpecialUnit(nil, unit) then
        return
    end
    local player = jass.GetOwningPlayer(unit)
    local isDrop = not isPickup
    local skipFlag = equipShared.skipNextDrop
    if isDrop and skipFlag then
        equipShared.skipNextDrop = false
        return
    end
    local idStr = fourCCToString(
        nil,
        jass.GetItemTypeId(item)
    )
    local itemData = itemRelatedFns.getItemDataEntry(item)
    if not itemData then
        if isPickup then
            local ____temp_6 = type(slk) ~= "nil" and slk.item
            if ____temp_6 then
                local ____opt_4 = slk.item[idStr]
                ____temp_6 = ____opt_4 and ____opt_4.name
            end
            local displayName = ____temp_6 or idStr
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
    local isConsumable = isDrop and itemData.hot ~= nil
    if isPickup and type(equipLimit.equipLimitWouldAllowPickup) == "function" and not equipLimit:equipLimitWouldAllowPickup(unit, item) then
        return
    end
    local charges = jass.GetItemCharges(item)
    local ____temp_7
    if charges > 0 then
        ____temp_7 = charges
    else
        ____temp_7 = 1
    end
    local mult = ____temp_7
    local isAdd = isPickup
    local primaryBonus = itemData.primaryBonus
    local primary = {}
    if primaryBonus then
        local typeId = jass.GetUnitTypeId(unit)
        local unitId = typeId ~= 0 and fourCCToString(nil, typeId) or ""
        local primaryStr = unitId ~= "" and getObjectProperty(nil, ObjectType.UNIT, unitId, "Primary") or ""
        primary = parsePrimaryBonus(nil, primaryBonus, primaryStr)
    end
    local merged = {}
    for ____, e in ipairs(itemRelatedFns.STAT_CONFIG) do
        local ____e_key_9 = e.key
        local ____itemData_e_key_8 = itemData[e.key]
        if ____itemData_e_key_8 == nil then
            ____itemData_e_key_8 = 0
        end
        merged[____e_key_9] = ____itemData_e_key_8 + (primary[e.key] or 0)
    end
    local ____itemData_moveSpeed_10 = itemData.moveSpeed
    if ____itemData_moveSpeed_10 == nil then
        ____itemData_moveSpeed_10 = 0
    end
    merged.moveSpeed = ____itemData_moveSpeed_10 + (primary.moveSpeed or 0)
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
    for ____, e in ipairs(itemRelatedFns.STAT_CONFIG) do
        addStat(nil, merged[e.key], e.name)
    end
    local owner = jass.GetOwningPlayer(unit)
    local playerName = jass.GetPlayerName(owner) or ""
    local actionText = isAdd and "获得" or "丢弃"
    local levelText = __TS__StringTrim(tostring(itemData.level or ""))
    local _____88C5_5907_539F_540D = itemData.name or "未知"
    local _____88C5_5907_989C_8272_4EE3_7801 = _____88C5_5907_7B49_7EA7_989C_8272_4EE3_7801(nil, levelText)
    local coloredLevel = _____662F_5426_5F69_8679_88C5_5907_7B49_7EA7(nil, levelText) and _____5F69_8679_989C_8272_6587_672C(nil, levelText) or (_____88C5_5907_989C_8272_4EE3_7801 .. levelText) .. "|r"
    local coloredName = _____662F_5426_5F69_8679_88C5_5907_7B49_7EA7(nil, levelText) and _____5F69_8679_989C_8272_6587_672C(nil, _____88C5_5907_539F_540D) or (_____88C5_5907_989C_8272_4EE3_7801 .. tostring(_____88C5_5907_539F_540D)) .. "|r"
    if not isConsumable then
        local msg = ((((("|cffffff00『系统消息』：|r" .. "|cFF87CEEB【装备】|r ") .. actionText) .. coloredLevel) .. "级装备『") .. coloredName) .. "』"
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
    end
    local tempReadMap = applyEquipStatsTS(unit, playerStats)
    local test5Parts = {}
    do
        local i = 0
        while i < #playerStats do
            do
                local statName = playerStats[i + 1].name
                if statName == "移动速度" then
                    goto __continue29
                end
                local val = tempReadMap[statName] ~= nil and tempReadMap[statName] or 0
                local num = __TS__Number(val)
                local isPct = __TS__ArrayIndexOf(percentNames, statName) >= 0
                local nearZero = num > -0.000001 and num < 0.000001
                local valStr = isPct and (nearZero and "0%" or tostring(jass.R2I(num * 1000 + 0.5) / 10
                ) .. "%") or (nearZero and "0" or tostring(num))
                test5Parts[#test5Parts + 1] = (statName .. "为：") .. valStr
            end
            ::__continue29::
            i = i + 1
        end
    end
    local hasMovespeed2 = itemData.movespeed2 ~= nil
    if hasMovespeed2 and unit ~= nil and type(equipMovespeed.getMaxMovespeed2Info) == "function" then
        local ____equipMovespeed_getMaxMovespeed2Info_13 = equipMovespeed.getMaxMovespeed2Info
        local ____unit_12 = unit
        local ____isDrop_11
        if isDrop then
            ____isDrop_11 = item
        else
            ____isDrop_11 = nil
        end
        local ms = ____equipMovespeed_getMaxMovespeed2Info_13(equipMovespeed, ____unit_12, ____isDrop_11)
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
            (("|cffffff00『系统消息』：|r" .. playerName) .. "的当前装备加成") .. table.concat(test5Parts, "，")
        )
    end
end
--- 初始化事件：使用物品事件中心统一注册
local function initEvents(self)
    itemEventCenter:onItemPickup(function(____, unit, item)
        handleItemEvent(nil, unit, item, true)
    end)
    itemEventCenter:onItemDrop(function(____, unit, item)
        handleItemEvent(nil, unit, item, false)
    end)
end
initEvents(nil)
return ____exports
