local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
--- 为 true 时在屏幕显示装备限制与 DROP 跳过调试；排查完可设为 true
local jass = require("jass.common")
local GetItemTypeId = jass.GetItemTypeId
local GetItemCharges = jass.GetItemCharges
local GetUnitTypeId = jass.GetUnitTypeId
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemPickup = ____require_result_0.onItemPickup
local onItemDrop = ____require_result_0.onItemDrop
local g = require("jass.globals")
local equipLimit = require("系统.02．物品系统.10．装备限制")
local equipShared = equipLimit.equipShared
local equipMovespeed = require("系统.02．物品系统.08．装备移速")
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.01．装备属性应用")
local applyEquipStatsTS = ____require_result_1.applyEquipStatsTS
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.index")
local fourCCToString = ____require_result_3.fourCCToString
local isSpecialUnit = ____require_result_3.isSpecialUnit
local itemRelatedFns = require("lib.扩展函数.物品相关函数.index")
local ____require_result_4 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_4.getRegisteredPlayerHero
local dynamicSkillText = require("系统.03．技能系统.07．动态技能文本.03．核心逻辑")
local ____require_result_5 = require("lib.扩展函数.YDWE函数.index")
local getObjectProperty = ____require_result_5.getObjectProperty
local ObjectType = ____require_result_5.ObjectType
local ____require_result_6 = require("系统.00．核心系统.01．颜色常量")
local _____88C5_5907_7B49_7EA7_989C_8272_4EE3_7801 = ____require_result_6["装备等级颜色代码"]
local _____662F_5426_5F69_8679_88C5_5907_7B49_7EA7 = ____require_result_6["是否彩虹装备等级"]
local _____5F69_8679_989C_8272_6587_672C = ____require_result_6["彩虹颜色文本"]
local _____53BB_9664_989C_8272_4EE3_7801 = ____require_result_6["去除颜色代码"]
local ____require_result_7 = require("系统.02．物品系统.16．装备次数叠加配置")
local _____662F_5426_5141_8BB8_88C5_5907_6B21_6570_53E0_52A0 = ____require_result_7["是否允许装备次数叠加"]
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
local _____88C5_5907_7269_54C1_6D88_606F_9759_9ED8_5C42_6570 = 0
function ____exports.beginEquipItemMessageSilence()
    _____88C5_5907_7269_54C1_6D88_606F_9759_9ED8_5C42_6570 = _____88C5_5907_7269_54C1_6D88_606F_9759_9ED8_5C42_6570 + 1
end
function ____exports.endEquipItemMessageSilence()
    if _____88C5_5907_7269_54C1_6D88_606F_9759_9ED8_5C42_6570 > 0 then
        _____88C5_5907_7269_54C1_6D88_606F_9759_9ED8_5C42_6570 = _____88C5_5907_7269_54C1_6D88_606F_9759_9ED8_5C42_6570 - 1
    end
end
local function isEquipItemMessageSilenced()
    return _____88C5_5907_7269_54C1_6D88_606F_9759_9ED8_5C42_6570 > 0
end
local _____88C5_5907_89C6_91CEBuffID = "C034"
local _____88C5_5907_89C6_91CEBuff_663E_793A_6301_7EED_65F6_95F4 = 999999
local _____4E0D_8D70_88C5_5907_7CFB_7EDF_7269_54C1ID_8868 = {I0FK = true, I0FL = true, I0E5 = true}
local function _____5237_65B0_88C5_5907_89C6_91CE_663E_793ABuff(self, unit, _____5F53_524D_89C6_91CE_52A0_6210)
    if unit == nil or unit == 0 then
        return
    end
    if _____5F53_524D_89C6_91CE_52A0_6210 ~= 0 then
        registerManualBuff(
            unit,
            _____88C5_5907_89C6_91CEBuffID,
            _____88C5_5907_89C6_91CEBuff_663E_793A_6301_7EED_65F6_95F4,
            _____5F53_524D_89C6_91CE_52A0_6210,
            {sourceName = "装备视野"}
        )
    else
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____88C5_5907_89C6_91CEBuffID)
    end
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
            local idx = (string.find(p, "+", nil, true) or 0) - 1
            if idx < 0 then
                goto __continue13
            end
            local name = __TS__StringTrim(__TS__StringSubstring(p, 0, idx))
            local valStr = __TS__StringTrim(__TS__StringSubstring(p, idx + 1))
            local key = itemRelatedFns.NAME_TO_KEY[name]
            if not key then
                goto __continue13
            end
            local isPct = (string.find(valStr, "%", nil, true) or 0) - 1 >= 0
            local num = __TS__ParseFloat(valStr) or 0
            out[key] = (out[key] or 0) + (isPct and num / 100 or num)
        end
        ::__continue13::
    end
    return out
end
--- 合成直接移除物品时，补偿该物品已经由装备系统加入的属性。
____exports["处理合成消耗装备属性"] = function(unit, item, consumedCount)
    if unit == nil or unit == 0 or item == nil or item == 0 or not (consumedCount > 0) then
        return
    end
    if isSpecialUnit(nil, unit) then
        return
    end
    local idStr = fourCCToString(GetItemTypeId(item))
    if _____4E0D_8D70_88C5_5907_7CFB_7EDF_7269_54C1ID_8868[idStr] == true then
        return
    end
    local itemData = itemRelatedFns.getItemDataEntry(item)
    if not itemData then
        return
    end
    local skipType = itemData.type
    if skipType == "任务" or skipType == "药剂" or skipType == "食品" or __TS__StringTrim(tostring(itemData.PowerUP or "")) ~= "" then
        return
    end
    local charges = GetItemCharges(item)
    local itemCount = charges > 0 and charges or 1
    local itemNamePlain = _____53BB_9664_989C_8272_4EE3_7801(tostring(itemData.name or ""))
    local mult = 1
    if _____662F_5426_5141_8BB8_88C5_5907_6B21_6570_53E0_52A0(itemNamePlain) then
        mult = consumedCount < itemCount and consumedCount or itemCount
    elseif consumedCount < itemCount then
        return
    end
    local primaryBonus = itemData.primaryBonus
    local primary = {}
    if primaryBonus then
        local typeId = GetUnitTypeId(unit)
        local unitId = typeId ~= 0 and fourCCToString(typeId) or ""
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
    for ____, e in ipairs(itemRelatedFns.STAT_CONFIG) do
        do
            local value = merged[e.key]
            if value == nil or value == 0 then
                goto __continue28
            end
            playerStats[#playerStats + 1] = {name = e.name, value = -value * mult}
        end
        ::__continue28::
    end
    local tempReadMap = applyEquipStatsTS(unit, playerStats)
    if tempReadMap["视野"] ~= nil then
        _____5237_65B0_88C5_5907_89C6_91CE_663E_793ABuff(
            nil,
            unit,
            __TS__Number(tempReadMap["视野"]) or 0
        )
    end
end
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
    if getRegisteredPlayerHero(player) ~= unit then
        return
    end
    local idStr = fourCCToString(GetItemTypeId(item))
    if _____4E0D_8D70_88C5_5907_7CFB_7EDF_7269_54C1ID_8868[idStr] == true then
        return
    end
    local itemData = itemRelatedFns.getItemDataEntry(item)
    if not itemData then
        if isPickup and not isEquipItemMessageSilenced() then
            local ____temp_13 = type(slk) ~= "nil" and slk.item
            if ____temp_13 then
                local ____opt_11 = slk.item[idStr]
                ____temp_13 = ____opt_11 and ____opt_11.name
            end
            local displayName = ____temp_13 or idStr
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
    if skipType == "任务" or skipType == "药剂" or skipType == "食品" or __TS__StringTrim(tostring(itemData.PowerUP or "")) ~= "" then
        return
    end
    local isConsumable = isDrop and itemData.hot ~= nil
    if isPickup and type(equipLimit.equipLimitWouldAllowPickup) == "function" and not equipLimit.equipLimitWouldAllowPickup(unit, item) then
        return
    end
    local charges = jass.GetItemCharges(item)
    local itemNamePlain = _____53BB_9664_989C_8272_4EE3_7801(tostring(itemData.name or ""))
    local _____662F_5426_5141_8BB8_88C5_5907_6B21_6570_53E0_52A0_result_15
    if _____662F_5426_5141_8BB8_88C5_5907_6B21_6570_53E0_52A0(itemNamePlain) then
        local ____temp_14
        if charges > 0 then
            ____temp_14 = charges
        else
            ____temp_14 = 1
        end
        _____662F_5426_5141_8BB8_88C5_5907_6B21_6570_53E0_52A0_result_15 = ____temp_14
    else
        _____662F_5426_5141_8BB8_88C5_5907_6B21_6570_53E0_52A0_result_15 = 1
    end
    local mult = _____662F_5426_5141_8BB8_88C5_5907_6B21_6570_53E0_52A0_result_15
    local isAdd = isPickup
    local primaryBonus = itemData.primaryBonus
    local primary = {}
    if primaryBonus then
        local typeId = GetUnitTypeId(unit)
        local unitId = typeId ~= 0 and fourCCToString(typeId) or ""
        local primaryStr = unitId ~= "" and getObjectProperty(nil, ObjectType.UNIT, unitId, "Primary") or ""
        primary = parsePrimaryBonus(nil, primaryBonus, primaryStr)
    end
    local merged = {}
    for ____, e in ipairs(itemRelatedFns.STAT_CONFIG) do
        local ____e_key_17 = e.key
        local ____itemData_e_key_16 = itemData[e.key]
        if ____itemData_e_key_16 == nil then
            ____itemData_e_key_16 = 0
        end
        merged[____e_key_17] = ____itemData_e_key_16 + (primary[e.key] or 0)
    end
    local ____itemData_moveSpeed_18 = itemData.moveSpeed
    if ____itemData_moveSpeed_18 == nil then
        ____itemData_moveSpeed_18 = 0
    end
    merged.moveSpeed = ____itemData_moveSpeed_18 + (primary.moveSpeed or 0)
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
    if not isConsumable and not isEquipItemMessageSilenced() then
        local msg = ((((("|cffffff00『系统消息』：|r" .. "|cFF87CEEB【装备】|r ") .. actionText) .. coloredLevel) .. "级装备『") .. coloredName) .. "』"
        for ____, stat in ipairs(playerStats) do
            local sign = stat.value > 0 and "+" or ""
            local isPct = itemRelatedFns["是否百分比装备属性名"](stat.name)
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
    dynamicSkillText["同步刷新英雄技能界面"](unit)
    if tempReadMap["视野"] ~= nil then
        _____5237_65B0_88C5_5907_89C6_91CE_663E_793ABuff(
            nil,
            unit,
            __TS__Number(tempReadMap["视野"]) or 0
        )
    end
    local test5Parts = {}
    do
        local i = 0
        while i < #playerStats do
            do
                local statName = playerStats[i + 1].name
                if statName == "移动速度" then
                    goto __continue55
                end
                local val = tempReadMap[statName] ~= nil and tempReadMap[statName] or 0
                local num = __TS__Number(val)
                local isPct = itemRelatedFns["是否百分比装备属性名"](statName)
                local nearZero = num > -0.000001 and num < 0.000001
                local valStr = isPct and (nearZero and "0%" or tostring(jass.R2I(num * 1000 + 0.5) / 10
                ) .. "%") or (nearZero and "0" or tostring(num))
                test5Parts[#test5Parts + 1] = (statName .. "为：") .. valStr
            end
            ::__continue55::
            i = i + 1
        end
    end
    local hasMovespeed2 = itemData.movespeed2 ~= nil
    if hasMovespeed2 and unit ~= nil and type(equipMovespeed.getMaxMovespeed2Info) == "function" then
        local ____equipMovespeed_getMaxMovespeed2Info_21 = equipMovespeed.getMaxMovespeed2Info
        local ____unit_20 = unit
        local ____isDrop_19
        if isDrop then
            ____isDrop_19 = item
        else
            ____isDrop_19 = nil
        end
        local ms = ____equipMovespeed_getMaxMovespeed2Info_21(equipMovespeed, ____unit_20, ____isDrop_19)
        if ms.value > 0 then
            test5Parts[#test5Parts + 1] = "移动速度为：" .. tostring(ms.value)
        end
        if ms.value > 0 and ms.name ~= "" and ms.count >= 2 and not isEquipItemMessageSilenced() then
            jass.DisplayTimedTextToPlayer(
                owner,
                0,
                0.02,
                5,
                ("|cffffff00『系统提示』：|r有多个不可叠加移速装备，当前只生效|cff00bfff『" .. ms.name) .. "』|r"
            )
        end
    end
    if #test5Parts > 0 and not isEquipItemMessageSilenced() then
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
local function _____5904_7406_88C5_5907_62FE_53D6_4E8B_4EF6(unit, item)
    handleItemEvent(nil, unit, item, true)
end
local function _____5904_7406_88C5_5907_4E22_5F03_4E8B_4EF6(unit, item)
    handleItemEvent(nil, unit, item, false)
end
local function initEvents(self)
    onItemPickup(_____5904_7406_88C5_5907_62FE_53D6_4E8B_4EF6)
    onItemDrop(_____5904_7406_88C5_5907_4E22_5F03_4E8B_4EF6)
end
initEvents(nil)
return ____exports
