local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local spawnGoldFloatPlus1000, playGoldBurstStep, onGoldBurstTimerExpire, jass, g, AdjustPlayerStateBJ, Sound3DII_Mp3PlayReuse, CreateFloatTextOnUnit, GOLD_FLOAT_DURATION_SEC, SOUND_GOLD, GOLD_R, GOLD_G, GOLD_B, goldBurstCtxByTimerHid
function spawnGoldFloatPlus1000(self)
    local u = g.gg_unit_Hamg_0002
    if u == nil or type(CreateFloatTextOnUnit) ~= "function" then
        return
    end
    CreateFloatTextOnUnit(u, "+1000", {
        size = 12,
        red = GOLD_R,
        green = GOLD_G,
        blue = GOLD_B,
        alpha = 0,
        duration = GOLD_FLOAT_DURATION_SEC
    })
end
function playGoldBurstStep(ctx, p0)
    if ctx.count >= ctx.times then
        return
    end
    AdjustPlayerStateBJ(nil, 1000, p0, jass.PLAYER_STATE_RESOURCE_GOLD)
    Sound3DII_Mp3PlayReuse(SOUND_GOLD, p0)
    spawnGoldFloatPlus1000(nil)
    ctx.count = ctx.count + 1
    if ctx.count >= ctx.times then
        return
    end
    local t = jass.CreateTimer()
    if not t then
        return
    end
    goldBurstCtxByTimerHid[jass.GetHandleId(t)] = ctx
    jass.TimerStart(t, ctx.interval, false, onGoldBurstTimerExpire)
end
function onGoldBurstTimerExpire()
    local t = jass.GetExpiredTimer()
    if not t then
        return
    end
    local hid = jass.GetHandleId(t)
    local ctx = goldBurstCtxByTimerHid[hid]
    __TS__Delete(goldBurstCtxByTimerHid, hid)
    jass.DestroyTimer(t)
    if not ctx then
        return
    end
    playGoldBurstStep(
        ctx,
        jass.Player(0)
    )
end
jass = require("jass.common")
g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
AdjustPlayerStateBJ = ____require_result_0.AdjustPlayerStateBJ
local ____require_result_1 = require("lib.扩展函数.封装函数.02．音效系统.index")
Sound3DII_Mp3PlayReuse = ____require_result_1.Sound3DII_Mp3PlayReuse
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_2["注册聊天命令监听"]
local _____6F02_6D6E_6587_5B57_6A21_5757 = require("lib.扩展函数.封装函数.03．漂浮文字.index")
CreateFloatTextOnUnit = _____6F02_6D6E_6587_5B57_6A21_5757.CreateFloatTextOnUnit
GOLD_FLOAT_DURATION_SEC = 1.25
SOUND_GOLD = "Abilities\\Spells\\Items\\ResourceItems\\ReceiveGold.wav"
GOLD_R = 255
GOLD_G = 215
GOLD_B = 0
--- 2222：1s 内 4 次 → 间隔 0.25s
local GOLD_BURST_TIMES = 4
local GOLD_BURST_INTERVAL_SEC = 0.25
--- 555：1s 内 12 次 → 间隔 1/11s（12 次起播时刻 0～1s）
local GOLD_BURST_555_TIMES = 12
local GOLD_BURST_555_INTERVAL_SEC = 1 / 11
goldBurstCtxByTimerHid = {}
local function onChat2222(self)
    local p0 = jass.Player(0)
    local ctx = {kind = "2222", times = GOLD_BURST_TIMES, interval = GOLD_BURST_INTERVAL_SEC, count = 0}
    playGoldBurstStep(ctx, p0)
    jass.DisplayTimedTextToPlayer(
        jass.Player(0),
        0,
        0,
        10,
        ("[测试事件2] 1s内4×+1000+4条漂浮字，收金币音复用，间隔" .. tostring(GOLD_BURST_INTERVAL_SEC)) .. "s"
    )
end
local function onChat555(self)
    local p0 = jass.Player(0)
    local ctx = {kind = "555", times = GOLD_BURST_555_TIMES, interval = GOLD_BURST_555_INTERVAL_SEC, count = 0}
    playGoldBurstStep(ctx, p0)
    jass.DisplayTimedTextToPlayer(
        jass.Player(0),
        0,
        0,
        12,
        "[测试事件2] 555：1s内12×+1000+12条漂浮字+12次音，间隔1/11s；首按可能少1声"
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("2222", onChat2222)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("555", onChat555)
return ____exports
