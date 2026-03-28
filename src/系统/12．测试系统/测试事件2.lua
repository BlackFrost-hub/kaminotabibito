--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local GOLD_R, GOLD_G, GOLD_B
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.封装函数")
local AdjustPlayerStateBJ = ____require_result_0.AdjustPlayerStateBJ
local ____require_result_1 = require("系统.00．核心系统.音效函数")
local Sound3DII_Mp3PlayReuse = ____require_result_1.Sound3DII_Mp3PlayReuse
local ____require_result_2 = require("系统.00．核心系统.漂浮文字函数")
local CreateFloatTextOnUnit = ____require_result_2.CreateFloatTextOnUnit
--- 每条 +1000 各一条漂浮字；duration>0 入队，到期 DestroyTextTag（排泄）
local GOLD_FLOAT_DURATION_SEC = 1.25
local function spawnGoldFloatPlus1000(self)
    local u = g.gg_unit_Hamg_0002
    if u == nil then
        return
    end
    CreateFloatTextOnUnit(nil, u, "+1000", {
        size = 12,
        red = GOLD_R,
        green = GOLD_G,
        blue = GOLD_B,
        alpha = 0,
        duration = GOLD_FLOAT_DURATION_SEC
    })
end
local SOUND_GOLD = "Abilities\\Spells\\Items\\ResourceItems\\ReceiveGold.wav"
GOLD_R = 255
GOLD_G = 215
GOLD_B = 0
--- 2222：1s 内 4 次 → 间隔 0.25s
local GOLD_BURST_TIMES = 4
local GOLD_BURST_INTERVAL_SEC = 0.25
--- 555：1s 内 12 次 → 间隔 1/11s（12 次起播时刻 0～1s）
local GOLD_BURST_555_TIMES = 12
local GOLD_BURST_555_INTERVAL_SEC = 1 / 11
local function onChat2222(self)
    local p0 = jass.Player(0)
    local n = 0
    local step
    step = function()
        if n >= GOLD_BURST_TIMES then
            return
        end
        AdjustPlayerStateBJ(nil, 1000, p0, jass.PLAYER_STATE_RESOURCE_GOLD)
        Sound3DII_Mp3PlayReuse(nil, SOUND_GOLD, p0)
        spawnGoldFloatPlus1000(nil)
        n = n + 1
        if n >= GOLD_BURST_TIMES then
            return
        end
        if type(jass.CreateTimer) ~= "function" or type(jass.TimerStart) ~= "function" then
            return
        end
        local t = jass.CreateTimer()
        jass.TimerStart(
            t,
            GOLD_BURST_INTERVAL_SEC,
            false,
            function()
                if type(jass.DestroyTimer) == "function" and type(jass.GetExpiredTimer) == "function" then
                    jass.DestroyTimer(jass.GetExpiredTimer())
                end
                step(nil)
            end
        )
    end
    step(nil)
    if type(jass.DisplayTimedTextToPlayer) == "function" then
        jass.DisplayTimedTextToPlayer(
            jass.Player(0),
            0,
            0,
            10,
            ("[测试事件2] 1s内4×+1000+4条漂浮字，收金币音复用，间隔" .. tostring(GOLD_BURST_INTERVAL_SEC)) .. "s"
        )
    end
end
local function onChat555(self)
    local p0 = jass.Player(0)
    local n = 0
    local step
    step = function()
        if n >= GOLD_BURST_555_TIMES then
            return
        end
        AdjustPlayerStateBJ(nil, 1000, p0, jass.PLAYER_STATE_RESOURCE_GOLD)
        Sound3DII_Mp3PlayReuse(nil, SOUND_GOLD, p0)
        spawnGoldFloatPlus1000(nil)
        n = n + 1
        if n >= GOLD_BURST_555_TIMES then
            return
        end
        if type(jass.CreateTimer) ~= "function" or type(jass.TimerStart) ~= "function" then
            return
        end
        local t = jass.CreateTimer()
        jass.TimerStart(
            t,
            GOLD_BURST_555_INTERVAL_SEC,
            false,
            function()
                if type(jass.DestroyTimer) == "function" and type(jass.GetExpiredTimer) == "function" then
                    jass.DestroyTimer(jass.GetExpiredTimer())
                end
                step(nil)
            end
        )
    end
    step(nil)
    if type(jass.DisplayTimedTextToPlayer) == "function" then
        jass.DisplayTimedTextToPlayer(
            jass.Player(0),
            0,
            0,
            12,
            "[测试事件2] 555：1s内12×+1000+12条漂浮字+12次音，间隔1/11s；首按可能少1声"
        )
    end
end
local function init(self)
    local tr = jass.CreateTrigger()
    if type(jass.TriggerRegisterPlayerChatEvent) == "function" and type(jass.TriggerAddAction) == "function" and type(jass.Player) == "function" then
        jass.TriggerRegisterPlayerChatEvent(
            tr,
            jass.Player(0),
            "2222",
            true
        )
        jass.TriggerAddAction(tr, onChat2222)
        local tr555 = jass.CreateTrigger()
        jass.TriggerRegisterPlayerChatEvent(
            tr555,
            jass.Player(0),
            "555",
            true
        )
        jass.TriggerAddAction(tr555, onChat555)
    end
end
init(nil)
return ____exports
