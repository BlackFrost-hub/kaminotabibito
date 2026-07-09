--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local CreateTrigger = jass.CreateTrigger
local TriggerAddAction = jass.TriggerAddAction
local TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent
local Player = jass.Player
local GetTriggerPlayer = jass.GetTriggerPlayer
local DisplayTextToPlayer = jass.DisplayTextToPlayer
local ____require_result_0 = require("系统.12．测试系统.00．Boss测试系统.02．Boss测试单位")
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_0["获取Boss测试玩家基准英雄"]
local ____require_result_1 = require("lib.扩展函数.封装函数.02．音效系统.index")
local Sound3DII_UnitPlayReuse = ____require_result_1.Sound3DII_UnitPlayReuse
local TEST_COMMAND = "testvoice"
local TEST_VOICE_PATH = "Sound\\Boss\\Thranduil\\Voice\\thranduil_opening_law_warning_jude_02_v3_64k.mp3"
local TEST_VOICE_CUTOFF = 4000
local initialized = false
local function playExternalVoiceForPlayer()
    local player = GetTriggerPlayer()
    local hero = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    if hero == nil or hero == 0 then
        DisplayTextToPlayer(player, 0, 0, "[testvoice] 未找到大法师/玩家英雄，无法在单位位置播放 3D 外置语音。")
        return
    end
    DisplayTextToPlayer(player, 0, 0, "[testvoice] 在大法师位置播放 3D 外置语音: " .. TEST_VOICE_PATH)
    Sound3DII_UnitPlayReuse(TEST_VOICE_PATH, hero, TEST_VOICE_CUTOFF)
end
local function initExternalVoicePackTest()
    if initialized then
        return
    end
    initialized = true
    local trig = CreateTrigger()
    TriggerAddAction(trig, playExternalVoiceForPlayer)
    do
        local i = 0
        while i <= 15 do
            TriggerRegisterPlayerChatEvent(
                trig,
                Player(i),
                TEST_COMMAND,
                true
            )
            i = i + 1
        end
    end
end
initExternalVoicePackTest()
return ____exports
