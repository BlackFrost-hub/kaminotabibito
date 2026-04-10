// 输入 233 时：打印 jass.japi keys，并附带键盘事件/类型测试
const jass = require("jass.common");
function dumpJapiKeys() {
    const pr = globalThis.print;
    if (!pr)
        return;
    try {
        const japi = require("jass.japi");
        pr("[japi] typeof=" + tostring(typeof japi));
        const keys = [];
        for (const k in japi) {
            if (typeof k === "string")
                keys.push(k);
        }
        pr("[japi] keys=" + tostring(keys.length));
        pr("[japi] list=" + keys.join(", "));
    }
    catch (e) {
        globalThis.print?.("[japi] require failed: " + tostring(e));
    }
}
function dumpDzKeyEventTrgType() {
    const pr = globalThis.print;
    if (!pr)
        return;
    const g = globalThis;
    let t0 = "nil";
    let t1 = "nil";
    let t2 = "nil";
    let tP0 = "nil";
    let tP1 = "nil";
    let tBy0 = "nil";
    let tBy1 = "nil";
    let tBy2 = "nil";
    try {
        t0 = tostring(typeof g.DzTriggerRegisterKeyEventTrg);
    }
    catch (_e) { }
    try {
        t1 = tostring(typeof require("jass.common").DzTriggerRegisterKeyEventTrg);
    }
    catch (_e) { }
    try {
        t2 = tostring(typeof require("jass.globals").DzTriggerRegisterKeyEventTrg);
    }
    catch (_e) { }
    pr("[type] _G.DzTriggerRegisterKeyEventTrg=" + t0);
    pr("[type] jass.common.DzTriggerRegisterKeyEventTrg=" + t1);
    pr("[type] jass.globals.DzTriggerRegisterKeyEventTrg=" + t2);
    try {
        tP0 = tostring(typeof require("jass.common").DzGetTriggerKeyPlayer);
    }
    catch (_e) { }
    try {
        tP1 = tostring(typeof require("jass.japi").DzGetTriggerKeyPlayer);
    }
    catch (_e) { }
    pr("[type] jass.common.DzGetTriggerKeyPlayer=" + tP0);
    pr("[type] jass.japi.DzGetTriggerKeyPlayer=" + tP1);
    try {
        tBy0 = tostring(typeof g.DzTriggerRegisterKeyEventByCode);
    }
    catch (_e) { }
    try {
        tBy1 = tostring(typeof require("jass.common").DzTriggerRegisterKeyEventByCode);
    }
    catch (_e) { }
    try {
        tBy2 = tostring(typeof require("jass.japi").DzTriggerRegisterKeyEventByCode);
    }
    catch (_e) { }
    pr("[type] _G.DzTriggerRegisterKeyEventByCode=" + tBy0);
    pr("[type] jass.common.DzTriggerRegisterKeyEventByCode=" + tBy1);
    pr("[type] jass.japi.DzTriggerRegisterKeyEventByCode=" + tBy2);
    // Dz 鼠标：对比 _G vs jass.japi
    let tMx0 = "nil";
    let tMx1 = "nil";
    try {
        tMx0 = tostring(typeof g.DzGetMouseX);
    }
    catch (_e) { }
    try {
        tMx1 = tostring(typeof require("jass.japi").DzGetMouseX);
    }
    catch (_e) { }
    pr("[type] _G.DzGetMouseX=" + tMx0);
    pr("[type] jass.japi.DzGetMouseX=" + tMx1);
}
function bindKeyBN_once_min() {
    const pr = globalThis.print;
    if (!pr)
        return;
    const g = globalThis;
    if (g.__keytest_bound) {
        pr("[keytest] already bound");
        return;
    }
    g.__keytest_bound = true;
    const japi = require("jass.japi");
    if (typeof jass.CreateTrigger !== "function" ||
        typeof jass.DisplayTimedTextToPlayer !== "function" ||
        typeof jass.Player !== "function") {
        pr("[keytest] missing basic jass funcs");
        return;
    }
    const f = japi.DzTriggerRegisterKeyEventByCode;
    if (typeof f !== "function") {
        pr("[keytest] DzTriggerRegisterKeyEventByCode not function");
        return;
    }
    const bind = (key, label) => {
        const trig = jass.CreateTrigger();
        f(trig, key, 1, false, () => {
            const msg = `[KEYOK] ${label} key=${tostring(key)} sync=false`;
            for (let i = 0; i < 12; i++) {
                jass.DisplayTimedTextToPlayer(jass.Player(i), 0, 0, 5, msg);
            }
        });
    };
    pr("[keytest] bind B/N (sync=false, key=66/78)");
    bind(66, "B");
    bind(78, "N");
}
function onChat233() {
    dumpJapiKeys();
    dumpDzKeyEventTrgType();
    bindKeyBN_once_min();
    if (typeof jass.DisplayTimedTextToPlayer === "function" && typeof jass.Player === "function") {
        jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 6, "[japi] 已打印 jass.japi keys");
    }
}
function init() {
    if (typeof jass.CreateTrigger !== "function" ||
        typeof jass.TriggerAddAction !== "function" ||
        typeof jass.TriggerRegisterPlayerChatEvent !== "function" ||
        typeof jass.Player !== "function")
        return;
    const tr = jass.CreateTrigger();
    jass.TriggerRegisterPlayerChatEvent(tr, jass.Player(0), "233", true);
    jass.TriggerAddAction(tr, onChat233);
}
init();
export {};
