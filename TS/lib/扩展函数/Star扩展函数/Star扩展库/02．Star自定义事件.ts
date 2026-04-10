const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { YDLocalExecuteTrigger, YDTriggerExecuteTrigger } = require("lib.扩展函数.YDWE函数.04．YDWE_trigger") as {
    YDLocalExecuteTrigger: (trg: any) => void;
    YDTriggerExecuteTrigger: (trg: any, flag: boolean) => void;
};

let StarBaseHT: any = null;
let skey_count = 0;
let skey_countEx = 0;
let skey_index = 0;
let skey_indexEx = 0;
let StarVarStr = "";

let initialized = false;

function init(): void {
    if (initialized) return;
    if (typeof jass.InitHashtable !== "function") return;
    if (typeof jass.StringHash !== "function") return;

    StarBaseHT = jass.InitHashtable();
    skey_count = jass.StringHash("count");
    skey_countEx = jass.StringHash("countEx");
    skey_index = jass.StringHash("index");
    skey_indexEx = jass.StringHash("indexEx");
    initialized = true;
}

/**
 * 获取自定义事件系统使用的全局哈希表
 * @returns 哈希表句柄，未初始化时返回 null
 */
export function STES_GetTable(): any {
    init();
    return StarBaseHT;
}

/**
 * 为触发器注册自定义事件
 * @param t 目标触发器
 * @param name 事件名称
 */
export function STES_Register(t: any, name: string): void {
    init();
    if (!StarBaseHT) return;
    if (typeof jass.GetHandleId !== "function") return;

    const hash = jass.StringHash(name);
    const hd = jass.GetHandleId(t);
    const index = jass.LoadInteger(StarBaseHT, hash, skey_index);
    const index2 = jass.LoadInteger(StarBaseHT, hd, skey_index);

    if (typeof jass.SaveTriggerHandle === "function") {
        jass.SaveTriggerHandle(StarBaseHT, hash, index, t);
    }
    jass.SaveInteger(StarBaseHT, hash, skey_index, index + 1);

    jass.SaveStr(StarBaseHT, hd, index2, name);
    jass.SaveInteger(StarBaseHT, hd, skey_index, index2 + 1);
}

/**
 * 触发自定义事件，执行所有注册了该事件名的触发器
 * @param name 事件名称
 */
export function STES_Fire(name: string): void {
    init();
    if (!StarBaseHT) return;
    if (typeof jass.StringHash !== "function") return;
    if (typeof jass.LoadInteger !== "function") return;

    const hash = jass.StringHash(name);
    const loopIndex = jass.LoadInteger(StarBaseHT, hash, skey_index);

    for (let i = 0; i < loopIndex; i++) {
        const trg = jass.LoadTriggerHandle(StarBaseHT, hash, i);
        if (trg) {
            YDLocalExecuteTrigger(trg);
            YDTriggerExecuteTrigger(trg, false);
        }
    }
}

export { StarBaseHT, skey_count, skey_countEx, skey_index, skey_indexEx, StarVarStr };
