--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local _____53EF_6E38_73A9_73A9_5BB6_8D77_59CBID = 0
local _____53EF_6E38_73A9_73A9_5BB6_7ED3_675FID = 4
local CreateTrigger = jass.CreateTrigger
local GetPlayerController = jass.GetPlayerController
local GetPlayerId = jass.GetPlayerId
local GetPlayerSlotState = jass.GetPlayerSlotState
local GetTriggerPlayer = jass.GetTriggerPlayer
local Player = jass.Player
local TriggerAddAction = jass.TriggerAddAction
local TriggerRegisterPlayerEvent = jass.TriggerRegisterPlayerEvent
local _____73A9_5BB6_79BB_5F00_89E6_53D1_5668 = nil
local _____5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = 0
local function _____662F_6709_6548_5728_7EBF_73A9_5BB6(whichPlayer)
    if whichPlayer == nil or whichPlayer == 0 then
        return false
    end
    if GetPlayerController(whichPlayer) ~= jass.MAP_CONTROL_USER then
        return false
    end
    return GetPlayerSlotState(whichPlayer) == jass.PLAYER_SLOT_STATE_PLAYING
end
local function _____5199_5165_73A9_5BB6_4EBA_6570_5168_5C40_53D8_91CF(_____73A9_5BB6_4EBA_6570)
    _____5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = _____73A9_5BB6_4EBA_6570
    jglobals.udg_T = _____73A9_5BB6_4EBA_6570
    jglobals.T = _____73A9_5BB6_4EBA_6570
end
____exports["重新统计有效玩家人数"] = function()
    local _____73A9_5BB6_4EBA_6570 = 0
    do
        local playerId = _____53EF_6E38_73A9_73A9_5BB6_8D77_59CBID
        while playerId <= _____53EF_6E38_73A9_73A9_5BB6_7ED3_675FID do
            if _____662F_6709_6548_5728_7EBF_73A9_5BB6(Player(playerId)) then
                _____73A9_5BB6_4EBA_6570 = _____73A9_5BB6_4EBA_6570 + 1
            end
            playerId = playerId + 1
        end
    end
    _____5199_5165_73A9_5BB6_4EBA_6570_5168_5C40_53D8_91CF(_____73A9_5BB6_4EBA_6570)
    return _____73A9_5BB6_4EBA_6570
end
local function ____on_73A9_5BB6_79BB_5F00_66F4_65B0_4EBA_6570()
    local _____79BB_5F00_73A9_5BB6 = GetTriggerPlayer()
    local _____79BB_5F00_73A9_5BB6ID = GetPlayerId(_____79BB_5F00_73A9_5BB6)
    if _____79BB_5F00_73A9_5BB6ID < _____53EF_6E38_73A9_73A9_5BB6_8D77_59CBID or _____79BB_5F00_73A9_5BB6ID > _____53EF_6E38_73A9_73A9_5BB6_7ED3_675FID then
        return
    end
    ____exports["重新统计有效玩家人数"]()
end
____exports["初始化玩家人数监听"] = function()
    ____exports["重新统计有效玩家人数"]()
    if _____73A9_5BB6_79BB_5F00_89E6_53D1_5668 ~= nil then
        return
    end
    _____73A9_5BB6_79BB_5F00_89E6_53D1_5668 = CreateTrigger()
    do
        local playerId = _____53EF_6E38_73A9_73A9_5BB6_8D77_59CBID
        while playerId <= _____53EF_6E38_73A9_73A9_5BB6_7ED3_675FID do
            TriggerRegisterPlayerEvent(
                _____73A9_5BB6_79BB_5F00_89E6_53D1_5668,
                Player(playerId),
                jass.EVENT_PLAYER_LEAVE
            )
            playerId = playerId + 1
        end
    end
    TriggerAddAction(_____73A9_5BB6_79BB_5F00_89E6_53D1_5668, ____on_73A9_5BB6_79BB_5F00_66F4_65B0_4EBA_6570)
end
____exports["取当前有效玩家人数"] = function()
    return _____5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 > 0 and _____5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 or ____exports["重新统计有效玩家人数"]()
end
return ____exports
