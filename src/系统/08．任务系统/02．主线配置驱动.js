/** @noSelfInFile */
const jass = require("jass.common");
const g = require("jass.globals");
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具");
const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息");
const { TransmissionFromUnitWithNameBJ } = require("lib.扩展函数.BJ函数.05A．电影函数");
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项");
const { forEachUnitInGroup } = require("lib.扩展函数.封装函数.01．通用工具.index");
const { MAIN_STORY_QUEST_CONFIGS } = require("系统.08．任务系统.00．配置表.06．主线任务配置表");
const { questDB, QuestType, QuestStatus } = require("系统.08．任务系统.01．任务数据");
const { questManager } = require("系统.08．任务系统.01．任务管理器.index");
const { debugLog } = require("lib.扩展函数.自定义扩展函数.index");
const { addPeriodicCallback } = globalThis;
/**
 * 二分开关：关则本模块 **不执行 init**（不注册 0.3s tick、不 ensureRuntimeQuest、不跑缺失函数统计）。
 */
export const ENABLE_MAIN_QUEST_CONFIG_DRIVER = true;
const YDGet = globalThis.YDUserDataGet;
const YDSet = globalThis.YDUserDataSet;
const RUNTIME_QUEST_ID = "main_story_runtime";
let running = false;
let mainQuestTickRegistered = false;
function getStage() {
    if (typeof YDGet === "function") {
        return Number(YDGet("string", "剧情进度", "整数", "integer")) || 0;
    }
    return 0;
}
function setStage(v) {
    if (typeof YDSet === "function") {
        YDSet("string", "剧情进度", "整数", "integer", v);
    }
}
function ensureRuntimeQuest() {
    if (questDB.getQuest(RUNTIME_QUEST_ID))
        return;
    questDB.registerQuest({
        id: RUNTIME_QUEST_ID,
        type: QuestType.MAIN,
        title: "主线任务",
        description: "剧情进行中",
        objectives: [{ id: "stage", description: "推进主线剧情", current: 0, required: 1, completed: false }],
        rewards: [],
        status: QuestStatus.UNDISCOVERED,
        icon: "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",
        createdAt: os.time(),
        updatedAt: os.time(),
    });
    questDB.acceptQuest(0, RUNTIME_QUEST_ID);
}
function refreshQuestUI(desc, msg) {
    const q = questDB.globalData?.quests?.get(RUNTIME_QUEST_ID);
    if (q) {
        if (typeof desc === "string" && desc !== "")
            q.description = desc;
        q.updatedAt = os.time();
    }
    const triggerUIRefresh = questManager.triggerUIRefresh;
    if (typeof triggerUIRefresh === "function") {
        triggerUIRefresh.call(questManager, 0, RUNTIME_QUEST_ID);
    }
    if (typeof msg === "string" && msg !== "") {
        QuestMessageBJ(GetPlayersAll(), g.bj_QUESTMESSAGE_UPDATED, msg);
    }
}
function parseDialogLines(dialogPreview) {
    if (!dialogPreview)
        return [];
    const out = [];
    const rows = dialogPreview.split("\n");
    for (const raw of rows) {
        const line = raw.trim();
        if (line === "")
            continue;
        const dot = line.indexOf(".");
        if (dot <= 0)
            continue;
        const left = line.substring(0, dot).trim();
        if (left === "" || Number(left) <= 0)
            continue;
        const body = line.substring(dot + 1).trim();
        let sep = body.indexOf("：");
        if (sep < 0)
            sep = body.indexOf(":");
        if (sep <= 0)
            continue;
        const speaker = body.substring(0, sep).trim();
        const text = body.substring(sep + 1).trim();
        if (speaker === "" || text === "")
            continue;
        out.push({ speaker, text });
    }
    return out;
}
function calcDialogDuration(text) {
    const n = text.length;
    // 基础 1.0 秒，每 10 个字符 +1.0 秒；下限 2 秒，上限 12 秒
    const t = 1 + jass.R2I(n / 10);
    if (t < 2)
        return 2;
    if (t > 12)
        return 12;
    return t;
}
function playDialog(dialogPreview) {
    const lines = parseDialogLines(dialogPreview);
    for (const line of lines) {
        TransmissionFromUnitWithNameBJ(GetPlayersAll(), null, line.speaker, null, line.text, g.bj_TIMETYPE_SET, calcDialogDuration(line.text), true);
    }
}
function removeInlineBlockComments(s) {
    let out = s;
    while (true) {
        const l = out.indexOf("/*");
        if (l < 0)
            break;
        const r = out.indexOf("*/", l + 2);
        if (r < 0) {
            out = out.substring(0, l);
            break;
        }
        out = out.substring(0, l) + out.substring(r + 2);
    }
    return out;
}
function sanitizeActionCode(raw) {
    let s = removeInlineBlockComments(raw).trim();
    if (s === "")
        return "";
    if (s.indexOf("//") === 0)
        return "";
    if (s.indexOf("call ") === 0)
        s = s.substring(5).trim();
    if (s.indexOf("set ") === 0)
        s = s.substring(4).trim();
    return s;
}
function parseTimelineEntries(timeline) {
    if (!timeline)
        return [];
    const out = [];
    const lines = timeline.split("\n");
    for (const raw of lines) {
        const line = raw.trim();
        if (line === "")
            continue;
        const dot = line.indexOf(".");
        if (dot <= 0)
            continue;
        const left = line.substring(0, dot).trim();
        const delay = Number(left);
        if (delay != delay)
            continue;
        const code = sanitizeActionCode(line.substring(dot + 1));
        if (code === "")
            continue;
        out.push({ delay, code });
    }
    return out;
}
function createEvalEnv(triggerUnit) {
    const gAny = globalThis;
    let cachedLoc = null;
    const local1GetFallback = (ty, key) => {
        if (typeof gAny.YDLocal1Get === "function")
            return gAny.YDLocal1Get(ty, key);
        // 条件里最常见是 YDLocal1Get(location, "单位位置")
        if (ty === "location" && key === "单位位置" && triggerUnit) {
            if (!cachedLoc)
                cachedLoc = jass.GetUnitLoc(triggerUnit);
            return cachedLoc;
        }
        return null;
    };
    const env = {
        __triggerUnit: triggerUnit,
        string: "string",
        integer: "integer",
        real: "real",
        unit: "unit",
        group: "group",
        player: "player",
        boolean: "boolean",
        GetTriggerUnit: () => triggerUnit,
        YDLocal1Get: local1GetFallback,
    };
    if (typeof globalThis.setmetatable === "function") {
        globalThis.setmetatable(env, { __index: globalThis });
    }
    return env;
}
function normalizeConditionExpr(expr) {
    let s = expr;
    s = s.split("\\\"").join("\"");
    s = s.split("GetTriggerUnit()").join("__triggerUnit");
    return s;
}
function evalCondition(expr, triggerUnit) {
    const source = "return (" + normalizeConditionExpr(expr) + ")";
    const loadFn = globalThis.loadstring;
    const setfenvFn = globalThis.setfenv;
    if (typeof loadFn !== "function" || typeof setfenvFn !== "function")
        return false;
    const fn = loadFn(source);
    if (fn == null)
        return false;
    const env = createEvalEnv(triggerUnit);
    setfenvFn(fn, env);
    const ok = pcall(fn);
    if (ok[0] !== true)
        return false;
    return ok[1] === true;
}
function executeActionCode(code, triggerUnit) {
    const loadFn = globalThis.loadstring;
    const setfenvFn = globalThis.setfenv;
    if (typeof loadFn !== "function" || typeof setfenvFn !== "function")
        return;
    const chunk = loadFn(code);
    if (chunk == null) {
        debugLog("主线配置驱动", "action编译失败:", code);
        return;
    }
    const env = createEvalEnv(triggerUnit);
    setfenvFn(chunk, env);
    const ok = pcall(chunk);
    if (ok[0] !== true) {
        debugLog("主线配置驱动", "action执行失败:", code, "| err=" + tostring(ok[1]));
    }
}
const storyActionCtxByTimerHid = {};
function onStoryActionTimerExpire() {
    const t = jass.GetExpiredTimer();
    if (!t)
        return;
    const hid = jass.GetHandleId(t);
    const ctx = storyActionCtxByTimerHid[hid];
    delete storyActionCtxByTimerHid[hid];
    safeDestroyTimer(t);
    if (ctx !== undefined)
        executeActionCode(ctx.code, ctx.triggerUnit);
}
function runActionTimeline(timeline, triggerUnit) {
    const entries = parseTimelineEntries(timeline);
    for (const e of entries) {
        if (e.delay <= 0) {
            executeActionCode(e.code, triggerUnit);
            continue;
        }
        const t = jass.CreateTimer();
        if (t) {
            storyActionCtxByTimerHid[jass.GetHandleId(t)] = { code: e.code, triggerUnit };
            safeTimerStart(t, e.delay, false, onStoryActionTimerExpire);
        }
    }
}
function getHeroes() {
    const group = typeof YDGet === "function" ? YDGet("string", "玩家英雄", "单位组", "group") : null;
    if (!group) {
        return [];
    }
    const arr = [];
    forEachUnitInGroup(group, (u) => {
        if (u)
            arr.push(u);
    });
    return arr;
}
function hitFromStage(cfg, stage) {
    if (cfg.fromStage == null || cfg.fromStage === "*")
        return true;
    return Number(cfg.fromStage) === stage;
}
function tick() {
    if (running)
        return;
    running = true;
    const stage = getStage();
    const heroes = getHeroes();
    for (const cfg of MAIN_STORY_QUEST_CONFIGS) {
        if (cfg.enabled === false)
            continue;
        if (!cfg.condition || cfg.condition === "")
            continue;
        if (!hitFromStage(cfg, stage))
            continue;
        let matchedHero = null;
        for (const hero of heroes) {
            if (evalCondition(cfg.condition, hero)) {
                matchedHero = hero;
                break;
            }
        }
        if (!matchedHero)
            continue;
        const triggerUnit = matchedHero;
        if (typeof cfg.toStage === "number")
            setStage(cfg.toStage);
        runActionTimeline(cfg.actionTimeline, triggerUnit);
        playDialog(cfg.dialogPreview);
        refreshQuestUI(cfg.questDescText, cfg.questMsgText);
        break;
    }
    running = false;
}
function extractFunctionNames(text) {
    const names = [];
    const n = text.length;
    let i = 0;
    while (i < n) {
        const ch = text.charCodeAt(i);
        const isStart = (ch >= 65 && ch <= 90) || (ch >= 97 && ch <= 122) || ch === 95;
        if (!isStart) {
            i++;
            continue;
        }
        const start = i;
        i++;
        while (i < n) {
            const c = text.charCodeAt(i);
            const ok = (c >= 65 && c <= 90) || (c >= 97 && c <= 122) || (c >= 48 && c <= 57) || c === 95;
            if (!ok)
                break;
            i++;
        }
        let j = i;
        while (j < n && (text.charAt(j) === " " || text.charAt(j) === "\t"))
            j++;
        if (j < n && text.charAt(j) === "(") {
            names.push(text.substring(start, i));
        }
    }
    return names;
}
function isKnownFunction(name) {
    const gAny = globalThis;
    if (typeof gAny[name] === "function")
        return true;
    if (typeof jass[name] === "function")
        return true;
    return false;
}
function reportMissingFunctions() {
    const missCond = new Set();
    const missAction = new Set();
    for (const cfg of MAIN_STORY_QUEST_CONFIGS) {
        const cond = cfg.condition || "";
        const act = cfg.actionTimeline || "";
        for (const fn of extractFunctionNames(cond))
            if (!isKnownFunction(fn))
                missCond.add(fn);
        for (const fn of extractFunctionNames(act))
            if (!isKnownFunction(fn))
                missAction.add(fn);
    }
    globalThis.__mainQuestMissingReport = {
        condition: Array.from(missCond).sort(),
        actionTimeline: Array.from(missAction).sort(),
    };
    debugLog("主线配置驱动", "缺失函数统计 - condition:", tostring(globalThis.__mainQuestMissingReport.condition.length));
    debugLog("主线配置驱动", "缺失函数统计 - actionTimeline:", tostring(globalThis.__mainQuestMissingReport.actionTimeline.length));
}
function init() {
    if (!ENABLE_MAIN_QUEST_CONFIG_DRIVER)
        return;
    ensureRuntimeQuest();
    reportMissingFunctions();
    if (mainQuestTickRegistered)
        return;
    mainQuestTickRegistered = true;
    addPeriodicCallback(300, tick);
}
if (ENABLE_MAIN_QUEST_CONFIG_DRIVER)
    init();
