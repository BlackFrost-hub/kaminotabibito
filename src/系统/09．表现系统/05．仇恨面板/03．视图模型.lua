--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.09．表现系统.05．仇恨面板.00．常量定义")
local THREAT_PANEL_PLAYER_SLOTS = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_PLAYER_SLOTS
local THREAT_PANEL_ROW_COUNT = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_ROW_COUNT
local ____01_FF0E_5171_4EAB = require("系统.09．表现系统.05．仇恨面板.01．共享")
local EMPTY_ROW = ____01_FF0E_5171_4EAB.EMPTY_ROW
local _____83B7_53D6_7528_4E8E_663E_793A_7684_76EE_6807_5355_4F4D = ____01_FF0E_5171_4EAB["获取用于显示的目标单位"]
local _____5355_4F4D_662F_6709_6548_602A_7269_5355_4F4D = ____01_FF0E_5171_4EAB["单位是有效怪物单位"]
local _____622A_65AD_540D_79F0 = ____01_FF0E_5171_4EAB["截断名称"]
local _____5341_500D_7CBE_5EA6_6587_672C = ____01_FF0E_5171_4EAB["十倍精度文本"]
local _____767E_5206_6BD4_6587_672C = ____01_FF0E_5171_4EAB["百分比文本"]
local _____6309_4EC7_6068_964D_5E8F_6392_5E8F = ____01_FF0E_5171_4EAB["按仇恨降序排序"]
local _____73A9_5BB6_89C6_56FE_6A21_578B_8868 = ____01_FF0E_5171_4EAB["玩家视图模型表"]
local ____00_FF0E_4EC7_6068_5B58_50A8 = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储")
local getEnemyThreatCount = ____00_FF0E_4EC7_6068_5B58_50A8.getEnemyThreatCount
local getEnemyThreats = ____00_FF0E_4EC7_6068_5B58_50A8.getEnemyThreats
local ____01_FF0E_5171_4EAB = require("系统.09．表现系统.05．仇恨面板.01．共享")
local GetUnitName = ____01_FF0E_5171_4EAB.GetUnitName
local GetUnitTypeId = ____01_FF0E_5171_4EAB.GetUnitTypeId
local IsUnitType = ____01_FF0E_5171_4EAB.IsUnitType
local UNIT_TYPE_DEAD = ____01_FF0E_5171_4EAB.UNIT_TYPE_DEAD
local function _____6784_5EFA_7A7A_9762_677F_6A21_578B(_____63D0_793A)
    local rowNames = {}
    local rowPercents = {}
    local rowThreats = {}
    do
        local i = 0
        while i < THREAT_PANEL_ROW_COUNT do
            rowNames[#rowNames + 1] = EMPTY_ROW
            rowPercents[#rowPercents + 1] = EMPTY_ROW
            rowThreats[#rowThreats + 1] = EMPTY_ROW
            i = i + 1
        end
    end
    return {
        selectedText = ("|cffd8d8d8" .. _____63D0_793A) .. "|r",
        summaryText = "|cff8f8f8f这里会显示当前所选敌人的仇恨池摘要|r",
        headerNameText = "|cffc8c8c8目标|r",
        headerPercentText = "|cffc8c8c8占比|r",
        headerThreatText = "|cffc8c8c8仇恨|r",
        rowNameTexts = rowNames,
        rowPercentTexts = rowPercents,
        rowThreatTexts = rowThreats
    }
end
local function _____6784_5EFA_73A9_5BB6_4EC7_6068_9762_677F_6A21_578B(playerId)
    local _____9009_4E2D_5355_4F4D = _____83B7_53D6_7528_4E8E_663E_793A_7684_76EE_6807_5355_4F4D(playerId)
    if _____9009_4E2D_5355_4F4D == nil or _____9009_4E2D_5355_4F4D == 0 then
        return _____6784_5EFA_7A7A_9762_677F_6A21_578B("请选择 1 个敌方单位")
    end
    if not _____5355_4F4D_662F_6709_6548_602A_7269_5355_4F4D(_____9009_4E2D_5355_4F4D) then
        return _____6784_5EFA_7A7A_9762_677F_6A21_578B("请选择 1 个敌方单位")
    end
    local _____539F_59CB_5217_8868 = getEnemyThreats(_____9009_4E2D_5355_4F4D)
    if #_____539F_59CB_5217_8868 == 0 or getEnemyThreatCount(_____9009_4E2D_5355_4F4D) <= 0 then
        return {
            selectedText = ("|cffffe6a0目标：" .. GetUnitName(_____9009_4E2D_5355_4F4D)) .. "|r",
            summaryText = "|cff8f8f8f当前还没有仇恨数据|r",
            headerNameText = "|cffc8c8c8目标|r",
            headerPercentText = "|cffc8c8c8占比|r",
            headerThreatText = "|cffc8c8c8仇恨|r",
            rowNameTexts = {
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW
            },
            rowPercentTexts = {
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW
            },
            rowThreatTexts = {
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW
            }
        }
    end
    local _____6709_6548_5217_8868 = {}
    do
        local i = 0
        while i < #_____539F_59CB_5217_8868 do
            do
                local entry = _____539F_59CB_5217_8868[i + 1]
                if entry == nil or entry.targetRef == nil or entry.targetRef == 0 then
                    goto __continue10
                end
                if GetUnitTypeId(entry.targetRef) == 0 then
                    goto __continue10
                end
                if IsUnitType(entry.targetRef, UNIT_TYPE_DEAD) then
                    goto __continue10
                end
                _____6709_6548_5217_8868[#_____6709_6548_5217_8868 + 1] = entry
            end
            ::__continue10::
            i = i + 1
        end
    end
    if #_____6709_6548_5217_8868 == 0 then
        return {
            selectedText = ("|cffffe6a0目标：" .. GetUnitName(_____9009_4E2D_5355_4F4D)) .. "|r",
            summaryText = "|cff8f8f8f仇恨表存在，但当前没有有效目标|r",
            headerNameText = "|cffc8c8c8目标|r",
            headerPercentText = "|cffc8c8c8占比|r",
            headerThreatText = "|cffc8c8c8仇恨|r",
            rowNameTexts = {
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW
            },
            rowPercentTexts = {
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW
            },
            rowThreatTexts = {
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW,
                EMPTY_ROW
            }
        }
    end
    local _____6392_5E8F_540E_5217_8868 = _____6309_4EC7_6068_964D_5E8F_6392_5E8F(_____6709_6548_5217_8868)
    local _____603B_4EC7_6068 = 0
    do
        local i = 0
        while i < #_____6392_5E8F_540E_5217_8868 do
            _____603B_4EC7_6068 = _____603B_4EC7_6068 + _____6392_5E8F_540E_5217_8868[i + 1].threat
            i = i + 1
        end
    end
    local rowNames = {}
    local rowPercents = {}
    local rowThreats = {}
    do
        local i = 0
        while i < THREAT_PANEL_ROW_COUNT do
            do
                if i >= #_____6392_5E8F_540E_5217_8868 then
                    rowNames[#rowNames + 1] = EMPTY_ROW
                    rowPercents[#rowPercents + 1] = EMPTY_ROW
                    rowThreats[#rowThreats + 1] = EMPTY_ROW
                    goto __continue18
                end
                local entry = _____6392_5E8F_540E_5217_8868[i + 1]
                local _____5355_4F4D_540D = (tostring(i + 1) .. ". ") .. _____622A_65AD_540D_79F0(
                    GetUnitName(entry.targetRef),
                    12
                )
                local _____5360_6BD4_6587_672C = _____767E_5206_6BD4_6587_672C(entry.threat)
                local _____4EC7_6068_6587_672C = _____5341_500D_7CBE_5EA6_6587_672C(entry.threat)
                if i == 0 then
                    rowNames[#rowNames + 1] = ("|cffffcc33" .. _____5355_4F4D_540D) .. "|r"
                    rowPercents[#rowPercents + 1] = ("|cffffcc33" .. _____5360_6BD4_6587_672C) .. "|r"
                    rowThreats[#rowThreats + 1] = ("|cffffcc33" .. _____4EC7_6068_6587_672C) .. "|r"
                else
                    rowNames[#rowNames + 1] = ("|cffd8d8d8" .. _____5355_4F4D_540D) .. "|r"
                    rowPercents[#rowPercents + 1] = ("|cffd8d8d8" .. _____5360_6BD4_6587_672C) .. "|r"
                    rowThreats[#rowThreats + 1] = ("|cffd8d8d8" .. _____4EC7_6068_6587_672C) .. "|r"
                end
            end
            ::__continue18::
            i = i + 1
        end
    end
    return {
        selectedText = ("|cffffe6a0目标：" .. GetUnitName(_____9009_4E2D_5355_4F4D)) .. "|r",
        summaryText = ((("|cffb8b8b8总仇恨 " .. _____5341_500D_7CBE_5EA6_6587_672C(_____603B_4EC7_6068)) .. "/1000  目标数 ") .. tostring(#_____6392_5E8F_540E_5217_8868)) .. "|r",
        headerNameText = "|cffc8c8c8目标|r",
        headerPercentText = "|cffc8c8c8占比|r",
        headerThreatText = "|cffc8c8c8仇恨|r",
        rowNameTexts = rowNames,
        rowPercentTexts = rowPercents,
        rowThreatTexts = rowThreats
    }
end
____exports["重建全部视图模型"] = function()
    do
        local playerId = 0
        while playerId < THREAT_PANEL_PLAYER_SLOTS do
            _____73A9_5BB6_89C6_56FE_6A21_578B_8868[playerId] = _____6784_5EFA_73A9_5BB6_4EC7_6068_9762_677F_6A21_578B(playerId)
            playerId = playerId + 1
        end
    end
end
return ____exports
