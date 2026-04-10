const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const STEP_KEY = 0xCFDE6C76;

function findYDLOC(): any {
    const g = globalThis as any;
    const pick = (name: string): any => {
        if (g[name] != null) return g[name];
        if (jglobals && jglobals[name] != null) return jglobals[name];
        if (jass && jass[name] != null) return jass[name];
        return null;
    };
    return pick("YDLOC")
        ?? pick("YDHASH_HANDLE")
        ?? pick("YDHT")
        ?? pick("udg_YDHASH_HANDLE")
        ?? pick("udg_YDHT");
}

/**
 * 设置触发器的局部变量上下文（YDWE 传参索引）
 * 对应 JASS 宏 YDLocalExecuteTrigger(trg)
 * @param trg 目标触发器
 */
export function YDLocalExecuteTrigger(trg: any): void {
    if (!trg) return;
    if (typeof jass.GetHandleId !== "function") return;
    const YDLOC = findYDLOC();
    if (!YDLOC) return;
    const hd = jass.GetHandleId(trg);
    const step = jass.LoadInteger(YDLOC, hd, STEP_KEY);
    (globalThis as any).ydl_triggerstep = hd * (step + 3);
}

/**
 * 执行触发器
 * 对应 JASS 函数 YDTriggerExecuteTrigger(trg, flag)
 * @param trg 目标触发器
 * @param flag true=先评估条件再执行，false=直接执行动作
 */
export function YDTriggerExecuteTrigger(trg: any, flag: boolean): void {
    if (!trg) return;
    if (flag) {
        if (typeof jass.ConditionalTriggerExecute === "function") {
            jass.ConditionalTriggerExecute(trg);
        }
    } else {
        if (typeof jass.TriggerExecute === "function") {
            jass.TriggerExecute(trg);
        }
    }
}

export {};
