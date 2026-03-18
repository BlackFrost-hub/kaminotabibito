--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("系统.00_核心.封装函数")
local AdjustPlayerStateBJ = ____require_result_0.AdjustPlayerStateBJ
local ____require_result_1 = require("系统.00_核心.音效函数")
local Sound3DII_Mp3Play = ____require_result_1.Sound3DII_Mp3Play
local ____require_result_2 = require("系统.00_核心.漂浮文字函数")
local CreateFloatTextOnUnit = ____require_result_2.CreateFloatTextOnUnit
local SOUND_GOLD = "Abilities\\Spells\\Items\\ResourceItems\\ReceiveGold.wav"
local GOLD_R = 255
local GOLD_G = 215
local GOLD_B = 0
local function onChat222(self)
    AdjustPlayerStateBJ(
        nil,
        1000,
        jass.Player(0),
        jass.PLAYER_STATE_RESOURCE_GOLD
    )
    if type(jass.CreateTimer) == "function" and type(jass.TimerStart) == "function" and type(jass.DestroyTimer) == "function" then
        local t = jass.CreateTimer()
        local n = 0
        jass.TimerStart(
            t,
            0.1,
            true,
            function()
                n = n + 1
                Sound3DII_Mp3Play(
                    nil,
                    SOUND_GOLD,
                    jass.Player(0)
                )
                if n >= 10 then
                    jass.DestroyTimer(t)
                end
            end
        )
    else
        Sound3DII_Mp3Play(
            nil,
            SOUND_GOLD,
            jass.Player(0)
        )
    end
    if g.gg_unit_Hamg_0002 ~= nil then
        CreateFloatTextOnUnit(nil, g.gg_unit_Hamg_0002, "+2000", {
            size = 12,
            red = GOLD_R,
            green = GOLD_G,
            blue = GOLD_B,
            alpha = 0
        })
    end
    if type(jass.DisplayTimedTextToPlayer) == "function" then
        jass.DisplayTimedTextToPlayer(
            jass.Player(0),
            0,
            0,
            10,
            "[测试事件2] 已给玩家0增加 1000 金币"
        )
    end
end
local function init(self)
    local tr = jass.CreateTrigger()
    if type(jass.TriggerRegisterPlayerChatEvent) == "function" and type(jass.TriggerAddAction) == "function" and type(jass.Player) == "function" then
        jass.TriggerRegisterPlayerChatEvent(
            tr,
            jass.Player(0),
            "222",
            true
        )
        jass.TriggerAddAction(tr, onChat222)
    end
end
init(nil)
return ____exports
