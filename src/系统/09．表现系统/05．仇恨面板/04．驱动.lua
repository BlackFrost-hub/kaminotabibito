--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.09．表现系统.05．仇恨面板.00．常量定义")
local THREAT_PANEL_PLAYER_SLOTS = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_PLAYER_SLOTS
local THREAT_PANEL_ROW_COUNT = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_ROW_COUNT
local ____01_FF0E_5171_4EAB = require("系统.09．表现系统.05．仇恨面板.01．共享")
local DzFrameSetText = ____01_FF0E_5171_4EAB.DzFrameSetText
local DzFrameShow = ____01_FF0E_5171_4EAB.DzFrameShow
local GetLocalPlayer = ____01_FF0E_5171_4EAB.GetLocalPlayer
local GetPlayerId = ____01_FF0E_5171_4EAB.GetPlayerId
local EMPTY_ROW = ____01_FF0E_5171_4EAB.EMPTY_ROW
local _____73A9_5BB6_9762_677F_8868 = ____01_FF0E_5171_4EAB["玩家面板表"]
local _____73A9_5BB6_89C6_56FE_6A21_578B_8868 = ____01_FF0E_5171_4EAB["玩家视图模型表"]
local ____03_FF0E_89C6_56FE_6A21_578B = require("系统.09．表现系统.05．仇恨面板.03．视图模型")
local _____91CD_5EFA_5168_90E8_89C6_56FE_6A21_578B = ____03_FF0E_89C6_56FE_6A21_578B["重建全部视图模型"]
local _____672C_5730_73A9_5BB6_9762_677F_663E_793A_72B6_6001_8868 = {}
function ____exports.initLocalThreatPanelVisibilityState()
    do
        local playerId = 0
        while playerId < THREAT_PANEL_PLAYER_SLOTS do
            if _____672C_5730_73A9_5BB6_9762_677F_663E_793A_72B6_6001_8868[playerId] == nil then
                _____672C_5730_73A9_5BB6_9762_677F_663E_793A_72B6_6001_8868[playerId] = false
            end
            playerId = playerId + 1
        end
    end
end
function ____exports.toggleLocalThreatPanelVisibility(playerId)
    if playerId < 0 or playerId >= THREAT_PANEL_PLAYER_SLOTS then
        return
    end
    _____672C_5730_73A9_5BB6_9762_677F_663E_793A_72B6_6001_8868[playerId] = _____672C_5730_73A9_5BB6_9762_677F_663E_793A_72B6_6001_8868[playerId] ~= true
end
function ____exports.showLocalThreatPanel(playerId)
    if playerId < 0 or playerId >= THREAT_PANEL_PLAYER_SLOTS then
        return
    end
    _____672C_5730_73A9_5BB6_9762_677F_663E_793A_72B6_6001_8868[playerId] = true
end
local function _____5BF9_79F0_5199_5165_5168_90E8_9762_677F_6587_672C()
    do
        local playerId = 0
        while playerId < THREAT_PANEL_PLAYER_SLOTS do
            do
                local panel = _____73A9_5BB6_9762_677F_8868[playerId]
                local vm = _____73A9_5BB6_89C6_56FE_6A21_578B_8868[playerId]
                if panel == nil or vm == nil then
                    goto __continue12
                end
                DzFrameSetText(panel.selected, vm.selectedText)
                DzFrameSetText(panel.summary, vm.summaryText)
                DzFrameSetText(panel.headerName, vm.headerNameText)
                DzFrameSetText(panel.headerPercent, vm.headerPercentText)
                DzFrameSetText(panel.headerThreat, vm.headerThreatText)
                do
                    local i = 0
                    while i < THREAT_PANEL_ROW_COUNT do
                        DzFrameSetText(panel.rowNames[i + 1], vm.rowNameTexts[i + 1] or EMPTY_ROW)
                        DzFrameSetText(panel.rowPercents[i + 1], vm.rowPercentTexts[i + 1] or EMPTY_ROW)
                        DzFrameSetText(panel.rowThreats[i + 1], vm.rowThreatTexts[i + 1] or EMPTY_ROW)
                        i = i + 1
                    end
                end
            end
            ::__continue12::
            playerId = playerId + 1
        end
    end
end
local function _____5E94_7528_672C_5730_53EF_89C1_6027()
    local _____672C_673A_73A9_5BB6 = GetLocalPlayer()
    if _____672C_673A_73A9_5BB6 == nil or _____672C_673A_73A9_5BB6 == 0 then
        return
    end
    local _____672C_673A_73A9_5BB6ID = GetPlayerId(_____672C_673A_73A9_5BB6)
    do
        local playerId = 0
        while playerId < THREAT_PANEL_PLAYER_SLOTS do
            do
                local panel = _____73A9_5BB6_9762_677F_8868[playerId]
                if panel == nil then
                    goto __continue19
                end
                local visible = playerId == _____672C_673A_73A9_5BB6ID and _____672C_5730_73A9_5BB6_9762_677F_663E_793A_72B6_6001_8868[playerId] == true
                DzFrameShow(panel.root, visible)
                if panel.inner ~= 0 then
                    DzFrameShow(panel.inner, visible)
                end
                if panel.title ~= 0 then
                    DzFrameShow(panel.title, visible)
                end
                if panel.selected ~= 0 then
                    DzFrameShow(panel.selected, visible)
                end
                if panel.summary ~= 0 then
                    DzFrameShow(panel.summary, visible)
                end
                if panel.headerName ~= 0 then
                    DzFrameShow(panel.headerName, visible)
                end
                if panel.headerPercent ~= 0 then
                    DzFrameShow(panel.headerPercent, visible)
                end
                if panel.headerThreat ~= 0 then
                    DzFrameShow(panel.headerThreat, visible)
                end
                do
                    local i = 0
                    while i < #panel.rowNames do
                        if panel.rowNames[i + 1] ~= 0 then
                            DzFrameShow(panel.rowNames[i + 1], visible)
                        end
                        if panel.rowPercents[i + 1] ~= 0 then
                            DzFrameShow(panel.rowPercents[i + 1], visible)
                        end
                        if panel.rowThreats[i + 1] ~= 0 then
                            DzFrameShow(panel.rowThreats[i + 1], visible)
                        end
                        i = i + 1
                    end
                end
            end
            ::__continue19::
            playerId = playerId + 1
        end
    end
end
____exports["on仇恨面板刷新Tick"] = function()
    _____91CD_5EFA_5168_90E8_89C6_56FE_6A21_578B()
    _____5BF9_79F0_5199_5165_5168_90E8_9762_677F_6587_672C()
    _____5E94_7528_672C_5730_53EF_89C1_6027()
end
return ____exports
