const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { STES_Register, STES_GetTable, STES_Fire } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
    STES_Register: (t: any, name: string) => void;
    STES_GetTable: () => any;
    STES_Fire: (name: string) => void;
};
const _print = (globalThis as any).print as (...args: any[]) => void;

function resolveGgTrgByKey(key: string): any {
    const a = jglobals[key];
    if (a != null && a !== 0) return a;
    const b = jass[key];
    if (b != null && b !== 0) return b;
    const c = (globalThis as any)[key];
    if (c != null && c !== 0) return c;
    return null;
}

const key = "gg_trg____________________001";

if (typeof jass.CreateTimer === "function" && typeof jass.TimerStart === "function") {
    const tm = jass.CreateTimer();
    jass.TimerStart(tm, 1.0, false, () => {
        _print("[任意测试] 延迟1s查找 " + key + " | jglobals=" + (jglobals[key] || "nil") + " | jass=" + (jass[key] || "nil") + " | globalThis=" + ((globalThis as any)[key] || "nil"));
        const trg = resolveGgTrgByKey(key);
        if (trg) {
            STES_Register(trg, "测试");
            const ht = STES_GetTable();
            _print("STES_Register 成功 | HT=" + (ht || "nil") + " | trg=" + (trg || "nil"));
            _print("STES_Fire 开始触发事件 '测试' ...");
            STES_Fire("测试");
            _print("STES_Fire 执行完毕");
        } else {
            _print("STES_Register 失败: " + key + " 在三处来源均为 nil");
        }
        if (typeof jass.DestroyTimer === "function") jass.DestroyTimer(tm);
    });
} else {
    _print("[任意测试] CreateTimer/TimerStart 不可用");
}

export {};
