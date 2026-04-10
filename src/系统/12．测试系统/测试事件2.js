// 测试事件2 - 2222：4×+1000 + 4 条漂浮字；555：12×+1000 + 12 条（漂浮字均设 duration，走 漂浮文字函数 回收队列排泄）
const jass = require("jass.common");
const g = require("jass.globals");
const { AdjustPlayerStateBJ } = require("系统.00．核心系统.01．封装函数");
const { Sound3DII_Mp3PlayReuse } = require("系统.00．核心系统.02．音效函数");
const { CreateFloatTextOnUnit } = require("系统.00．核心系统.03．漂浮文字函数");
/** 每条 +1000 各一条漂浮字；duration>0 入队，到期 DestroyTextTag（排泄） */
const GOLD_FLOAT_DURATION_SEC = 1.25;
function spawnGoldFloatPlus1000() {
    const u = g.gg_unit_Hamg_0002;
    if (u == null)
        return;
    CreateFloatTextOnUnit(u, "+1000", {
        size: 12,
        red: GOLD_R,
        green: GOLD_G,
        blue: GOLD_B,
        alpha: 0,
        duration: GOLD_FLOAT_DURATION_SEC
    });
}
const SOUND_GOLD = "Abilities\\Spells\\Items\\ResourceItems\\ReceiveGold.wav";
// 金色 RGB
const GOLD_R = 255;
const GOLD_G = 215;
const GOLD_B = 0;
/** 2222：1s 内 4 次 → 间隔 0.25s */
const GOLD_BURST_TIMES = 4;
const GOLD_BURST_INTERVAL_SEC = 0.25;
/** 555：1s 内 12 次 → 间隔 1/11s（12 次起播时刻 0～1s） */
const GOLD_BURST_555_TIMES = 12;
const GOLD_BURST_555_INTERVAL_SEC = 1 / 11;
function onChat2222() {
    const p0 = jass.Player(0);
    let n = 0;
    const step = () => {
        if (n >= GOLD_BURST_TIMES)
            return;
        AdjustPlayerStateBJ(1000, p0, jass.PLAYER_STATE_RESOURCE_GOLD);
        Sound3DII_Mp3PlayReuse(SOUND_GOLD, p0);
        spawnGoldFloatPlus1000();
        n++;
        if (n >= GOLD_BURST_TIMES)
            return;
        if (typeof jass.CreateTimer !== "function" || typeof jass.TimerStart !== "function")
            return;
        const t = jass.CreateTimer();
        jass.TimerStart(t, GOLD_BURST_INTERVAL_SEC, false, () => {
            if (typeof jass.DestroyTimer === "function" && typeof jass.GetExpiredTimer === "function") {
                jass.DestroyTimer(jass.GetExpiredTimer());
            }
            step();
        });
    };
    step();
    if (typeof jass.DisplayTimedTextToPlayer === "function") {
        jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 10, "[测试事件2] 1s内4×+1000+4条漂浮字，收金币音复用，间隔" + GOLD_BURST_INTERVAL_SEC + "s");
    }
}
function onChat555() {
    const p0 = jass.Player(0);
    let n = 0;
    const step = () => {
        if (n >= GOLD_BURST_555_TIMES)
            return;
        AdjustPlayerStateBJ(1000, p0, jass.PLAYER_STATE_RESOURCE_GOLD);
        Sound3DII_Mp3PlayReuse(SOUND_GOLD, p0);
        spawnGoldFloatPlus1000();
        n++;
        if (n >= GOLD_BURST_555_TIMES)
            return;
        if (typeof jass.CreateTimer !== "function" || typeof jass.TimerStart !== "function")
            return;
        const t = jass.CreateTimer();
        jass.TimerStart(t, GOLD_BURST_555_INTERVAL_SEC, false, () => {
            if (typeof jass.DestroyTimer === "function" && typeof jass.GetExpiredTimer === "function") {
                jass.DestroyTimer(jass.GetExpiredTimer());
            }
            step();
        });
    };
    step();
    if (typeof jass.DisplayTimedTextToPlayer === "function") {
        jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 12, "[测试事件2] 555：1s内12×+1000+12条漂浮字+12次音，间隔1/11s；首按可能少1声");
    }
}
function init() {
    const tr = jass.CreateTrigger();
    if (typeof jass.TriggerRegisterPlayerChatEvent === "function" &&
        typeof jass.TriggerAddAction === "function" &&
        typeof jass.Player === "function") {
        jass.TriggerRegisterPlayerChatEvent(tr, jass.Player(0), "2222", true);
        jass.TriggerAddAction(tr, onChat2222);
        const tr555 = jass.CreateTrigger();
        jass.TriggerRegisterPlayerChatEvent(tr555, jass.Player(0), "555", true);
        jass.TriggerAddAction(tr555, onChat555);
    }
}
init();
export {};
