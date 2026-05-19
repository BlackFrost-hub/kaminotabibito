/** @noSelfInFile */
const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

let SDR_Index = 0;

function hashHandle(): any {
    const g = globalThis as any;
    const pick = (name: string): any => {
        if (g[name] != null) return g[name];
        if (jglobals && jglobals[name] != null) return jglobals[name];
        if (jass && jass[name] != null) return jass[name];
        return null;
    };
    return pick("StarBaseHT")
        ?? pick("YDHASH_HANDLE")
        ?? pick("YDHT")
        ?? pick("udg_YDHASH_HANDLE")
        ?? pick("udg_YDHT");
}

export function SDR_DebugTimer(t: any, time: number, isloop: boolean, Target: string, trig: string): void {
    const ht = hashHandle();
    if (!ht) return;
    const id = jass.GetHandleId(t);
    (jass as any).SaveTimerHandle(ht, SDR_Index, 0, t);
    jass.SaveInteger(ht, id, 0, SDR_Index);
    jass.SaveReal(ht, id, 1, time);
    jass.SaveBoolean(ht, id, 2, isloop);
    jass.SaveStr(ht, id, 3, Target);
    jass.SaveStr(ht, id, 4, trig);
    SDR_Index += 1;
}

export {};
