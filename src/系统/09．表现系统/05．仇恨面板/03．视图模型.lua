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
local _____4EC7_6068_6574_8868_8D85_65F6_6BEB_79D2 = ____00_FF0E_4EC7_6068_5B58_50A8["仇恨整表超时毫秒"]
local _____4EC7_6068_6761_76EE_8D85_65F6_6BEB_79D2 = ____00_FF0E_4EC7_6068_5B58_50A8["仇恨条目超时毫秒"]
local getEnemyLastThreatUpdateTimeById = ____00_FF0E_4EC7_6068_5B58_50A8.getEnemyLastThreatUpdateTimeById
local ____01_FF0E_5171_4EAB = require("系统.09．表现系统.05．仇恨面板.01．共享")
local GetHandleId = ____01_FF0E_5171_4EAB.GetHandleId
local GetUnitName = ____01_FF0E_5171_4EAB.GetUnitName
local GetUnitTypeId = ____01_FF0E_5171_4EAB.GetUnitTypeId
local IsUnitType = ____01_FF0E_5171_4EAB.IsUnitType
local R2I = ____01_FF0E_5171_4EAB.R2I
local UNIT_TYPE_DEAD = ____01_FF0E_5171_4EAB.UNIT_TYPE_DEAD
local _nowMs = nil
local function nowMs()
    if _nowMs == nil then
        _nowMs = require("系统.00．核心系统.05．中心计时器").getServerTime
    end
    return _nowMs()
end
local function _____4E00_4F4D_5C0F_6570_6587_672C(value)
    local _____5341_500D_6574_6570 = R2I(value * 10 + 0.5)
    local _____6574_6570_90E8_5206 = R2I(_____5341_500D_6574_6570 / 10)
    local _____5C0F_6570_90E8_5206 = _____5341_500D_6574_6570 - _____6574_6570_90E8_5206 * 10
    return (tostring(_____6574_6570_90E8_5206) .. ".") .. tostring(_____5C0F_6570_90E8_5206)
end
local function _____5269_4F59_8131_79BB_65F6_95F4_6587_672C(_____6700_8FD1_66F4_65B0_65F6_95F4, _____8D85_65F6_6BEB_79D2)
    if _____6700_8FD1_66F4_65B0_65F6_95F4 <= 0 then
        return "0.0s"
    end
    local _____5269_4F59_6BEB_79D2 = _____8D85_65F6_6BEB_79D2 - (nowMs() - _____6700_8FD1_66F4_65B0_65F6_95F4)
    local _____5269_4F59_79D2 = _____5269_4F59_6BEB_79D2 > 0 and _____5269_4F59_6BEB_79D2 / 1000 or 0
    return _____4E00_4F4D_5C0F_6570_6587_672C(_____5269_4F59_79D2) .. "s"
end
local function _____4EC7_6068_4E0E_8131_79BB_65F6_95F4_6587_672C(entry)
    return (_____5341_500D_7CBE_5EA6_6587_672C(entry.threat) .. " / ") .. _____5269_4F59_8131_79BB_65F6_95F4_6587_672C(entry.lastUpdateTime, _____4EC7_6068_6761_76EE_8D85_65F6_6BEB_79D2)
end
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
        summaryText = "|cffffcc66这里会显示当前目标的仇恨和脱离时间|r",
        headerNameText = "|cffc8c8c8目标|r",
        headerPercentText = "|cffc8c8c8占比|r",
        headerThreatText = "|cffc8c8c8仇恨/脱离时间|r",
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
            summaryText = "|cffffcc66当前还没有仇恨记录|r",
            headerNameText = "|cffc8c8c8目标|r",
            headerPercentText = "|cffc8c8c8占比|r",
            headerThreatText = "|cffc8c8c8仇恨/脱离时间|r",
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
                    goto __continue16
                end
                if GetUnitTypeId(entry.targetRef) == 0 then
                    goto __continue16
                end
                if IsUnitType(entry.targetRef, UNIT_TYPE_DEAD) then
                    goto __continue16
                end
                _____6709_6548_5217_8868[#_____6709_6548_5217_8868 + 1] = entry
            end
            ::__continue16::
            i = i + 1
        end
    end
    if #_____6709_6548_5217_8868 == 0 then
        return {
            selectedText = ("|cffffe6a0目标：" .. GetUnitName(_____9009_4E2D_5355_4F4D)) .. "|r",
            summaryText = "|cffffcc66当前没有可显示的仇恨目标|r",
            headerNameText = "|cffc8c8c8目标|r",
            headerPercentText = "|cffc8c8c8占比|r",
            headerThreatText = "|cffc8c8c8仇恨/脱离时间|r",
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
                    goto __continue24
                end
                local entry = _____6392_5E8F_540E_5217_8868[i + 1]
                local _____5355_4F4D_540D = (tostring(i + 1) .. ". ") .. _____622A_65AD_540D_79F0(
                    GetUnitName(entry.targetRef),
                    12
                )
                local _____5360_6BD4_6587_672C = _____767E_5206_6BD4_6587_672C(entry.threat)
                local _____4EC7_6068_6587_672C = _____4EC7_6068_4E0E_8131_79BB_65F6_95F4_6587_672C(entry)
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
            ::__continue24::
            i = i + 1
        end
    end
    local _____654C_4EBAID = GetHandleId(_____9009_4E2D_5355_4F4D) or 0
    local _____6574_8868_8131_79BB_65F6_95F4 = _____5269_4F59_8131_79BB_65F6_95F4_6587_672C(
        getEnemyLastThreatUpdateTimeById(_____654C_4EBAID),
        _____4EC7_6068_6574_8868_8D85_65F6_6BEB_79D2
    )
    return {
        selectedText = ("|cffffe6a0目标：" .. GetUnitName(_____9009_4E2D_5355_4F4D)) .. "|r",
        summaryText = ((((("|cffffcc66总仇恨 " .. _____5341_500D_7CBE_5EA6_6587_672C(_____603B_4EC7_6068)) .. "/1000  目标：") .. tostring(#_____6392_5E8F_540E_5217_8868)) .. "  仇恨脱离：") .. _____6574_8868_8131_79BB_65F6_95F4) .. "|r",
        headerNameText = "|cffc8c8c8目标|r",
        headerPercentText = "|cffc8c8c8占比|r",
        headerThreatText = "|cffc8c8c8仇恨/脱离时间|r",
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
