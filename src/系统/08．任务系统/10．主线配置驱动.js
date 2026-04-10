const jass = require("jass.common");
const g = require("jass.globals");
const { MAIN_STORY_QUEST_CONFIGS } = require("系统.08．任务系统.00．配置表.06．主线任务配置表");
const { questDB, QuestType, QuestStatus } = require("系统.08．任务系统.01．任务数据");
const { questManager } = require("系统.08．任务系统.02．任务管理器");
const YDGet = globalThis.YDUserDataGet;
const YDSet = globalThis.YDUserDataSet;
const RUNTIME_QUEST_ID = "main_story_runtime";
let running = false;
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
    if (typeof msg === "string" && msg !== "" && typeof jass.QuestMessageBJ === "function" && typeof jass.GetPlayersAll === "function") {
        jass.QuestMessageBJ(jass.GetPlayersAll(), jass.bj_QUESTMESSAGE_UPDATED, msg);
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
    // 基础 1.0 秒，每 6 个字符 +1.0 秒；下限 2 秒，上限 12 秒
    const t = 1 + math.floor(n / 6);
    if (t < 2)
        return 2;
    if (t > 12)
        return 12;
    return t;
}
function playDialog(dialogPreview) {
    if (typeof jass.TransmissionFromUnitWithNameBJ !== "function" || typeof jass.GetPlayersAll !== "function")
        return;
    const lines = parseDialogLines(dialogPreview);
    for (const line of lines) {
        jass.TransmissionFromUnitWithNameBJ(jass.GetPlayersAll(), null, line.speaker, null, line.text, jass.bj_TIMETYPE_SET, calcDialogDuration(line.text), true);
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
    const local1GetFallback = (ty, key) => {
        if (typeof gAny.YDLocal1Get === "function")
            return gAny.YDLocal1Get(ty, key);
        // 条件里最常见是 YDLocal1Get(location, "单位位置")
        if (ty === "location" && key === "单位位置" && triggerUnit && typeof jass.GetUnitLoc === "function") {
            return jass.GetUnitLoc(triggerUnit);
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
        const p = globalThis.print;
        if (typeof p === "function")
            p("[主线配置驱动] action编译失败: " + code);
        return;
    }
    const env = createEvalEnv(triggerUnit);
    setfenvFn(chunk, env);
    const ok = pcall(chunk);
    if (ok[0] !== true) {
        const p = globalThis.print;
        if (typeof p === "function")
            p("[主线配置驱动] action执行失败: " + code + " | err=" + tostring(ok[1]));
    }
}
function runActionTimeline(timeline, triggerUnit) {
    const entries = parseTimelineEntries(timeline);
    for (const e of entries) {
        if (e.delay <= 0 || typeof jass.CreateTimer !== "function" || typeof jass.TimerStart !== "function") {
            executeActionCode(e.code, triggerUnit);
            continue;
        }
        const t = jass.CreateTimer();
        jass.TimerStart(t, e.delay, false, () => {
            executeActionCode(e.code, triggerUnit);
            if (typeof jass.DestroyTimer === "function")
                jass.DestroyTimer(t);
        });
    }
}
function getHeroes() {
    const group = typeof YDGet === "function" ? YDGet("string", "玩家英雄", "单位组", "group") : null;
    if (!group || typeof jass.FirstOfGroup !== "function" || typeof jass.GroupRemoveUnit !== "function" || typeof jass.GroupAddUnit !== "function") {
        return [];
    }
    const arr = [];
    const temp = [];
    while (true) {
        const u = jass.FirstOfGroup(group);
        if (!u)
            break;
        arr.push(u);
        temp.push(u);
        jass.GroupRemoveUnit(group, u);
    }
    for (const u of temp)
        jass.GroupAddUnit(group, u);
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
        let matched = false;
        for (const hero of heroes) {
            if (evalCondition(cfg.condition, hero)) {
                matched = true;
                break;
            }
        }
        if (!matched)
            continue;
        const triggerUnit = heroes.length > 0 ? heroes[0] : null;
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
    const p = globalThis.print;
    if (typeof p === "function") {
        p("[主线配置驱动] 缺失函数统计 - condition: " + tostring(globalThis.__mainQuestMissingReport.condition.length));
        p("[主线配置驱动] 缺失函数统计 - actionTimeline: " + tostring(globalThis.__mainQuestMissingReport.actionTimeline.length));
    }
}
function init() {
    ensureRuntimeQuest();
    reportMissingFunctions();
    if (typeof jass.CreateTimer === "function" && typeof jass.TimerStart === "function") {
        const t = jass.CreateTimer();
        jass.TimerStart(t, 0.30, true, tick);
    }
}
init();
export {};
