const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const {
    YDLocalInitialize, YDLocal1Release,
    YDLocal5Set, YDLocal5Get,
    YDLocal7Set, YDLocal7Get,
    YDLocal1Set, YDLocal1Get,
    getG_SIndex, setG_SIndex, getG_LIndex, setG_LIndex, _indexStack
} = require("lib.扩展函数.YDWE函数.02．YDLocal兼容") as any;
const { YDLocalExecuteTrigger, YDTriggerExecuteTrigger, saveParentIndex } = require("lib.扩展函数.YDWE函数.04．YDWE_trigger") as any;

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

function testYDLocalReturn(): void {
    _print("===== 测试中文变量名 =====");

    const trg002 = resolveGgTrgByKey("gg_trg____________________002");
    _print("查找触发器 gg_trg____________________002 = " + (trg002 || "nil"));

    if (trg002) {
        YDLocalInitialize();
        const sIdx = getG_SIndex();
        _print("YDLocalInitialize 后 G_SIndex=" + sIdx);

        YDLocalExecuteTrigger(trg002);
        saveParentIndex(trg002);
        _print("saveParentIndex 完成");

        YDLocal5Set("integer", "分法", 0);
        _print("YDLocal5Set(integer, '分法', 0) 设置参数默认值");

        _print("执行 YDTriggerExecuteTrigger...");
        YDTriggerExecuteTrigger(trg002, false);

        const ret1 = YDLocal1Get("integer", "分法");
        const ret2 = YDLocal1Get("real", "多大的");
        const ret3 = YDLocal1Get("boolean", "你好");

        _print("YDLocal1Get(integer, '分法') = " + ret1);
        _print("YDLocal1Get(real, '多大的') = " + ret2);
        _print("YDLocal1Get(boolean, '你好') = " + ret3);

        let success = true;
        if (ret1 !== 6678678) { _print("❌ integer '分法' 失败，期望 6678678，实际 " + ret1); success = false; }
        if (ret2 !== 78378376) { _print("❌ real '多大的' 失败，期望 78378376，实际 " + ret2); success = false; }
        if (ret3 !== true) { _print("❌ boolean '你好' 失败，期望 true，实际 " + ret3); success = false; }

        if (success) {
            _print("✅ 全部返回值测试成功！");
        }

        YDLocal1Release();
        _print("YDLocal1Release 后 G_SIndex=" + getG_SIndex());
    } else {
        _print("触发器未找到");
    }

    _print("===== 测试结束 =====");
}

if (typeof jass.CreateTimer === "function" && typeof jass.TimerStart === "function") {
    const tm = jass.CreateTimer();
    jass.TimerStart(tm, 1.0, false, () => {
        testYDLocalReturn();
        if (typeof jass.DestroyTimer === "function") jass.DestroyTimer(tm);
    });
}

export {};
