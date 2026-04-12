/**
 * STES事件测试 — Lua 仅通过事件名 STES_Fire，与 JASS STES_Register 共用 STES___HT
 *
 * 调试输出：遵循 `.cursor/rules/feedback_debug_output.md`，用 print（经 log）而非 DisplayTimedTextToPlayer。
 *
 * 与 GUI「333」一致：YDLocal 变量名由常量 YD_LOCAL_REAL_KEY 与地图 JASS 对齐（可为中文/英文/数字等，非库默认）。
 *
 * 当前：**无延迟**，`boot` 内直接 `runAfterDelay()`。若需等 JASS 绑 STES___HT，可恢复下方 `ENTRY_DELAY_SEC` 与注释掉的定时器。
 *
 * TSTL：模块内局部函数默认带隐式 self，会编成 log(nil,msg)、_print(nil,msg)。
 * 为所有本地函数加 `this: void`，避免多余 nil 与冒号调用错位。
 */

/** 开关：设为 true 启用测试，false 禁用 */
const ENABLED = false;

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
/** 本图 JASS 里 YDLocal5Set/YDLocal1Get 使用的实数变量名字符串（须与触发器里完全一致） */
const YD_LOCAL_REAL_KEY = "实数";

const stesMod = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
    STES_FireWithReal11Step: (name: string, realParamKey: string) => void;
    STES_GetTable: () => any;
    STES_Register: (t: any, name: string) => void;
};
const {
    YDLocal5Get,
    YDLocal7Set,
    clearStar_PIndex,
} = require("lib.扩展函数.YDWE函数.02．YDLocal兼容") as {
    YDLocal5Get: (ty: "real", name: string) => any;
    YDLocal7Set: (ty: "real", name: string, value: any) => void;
    clearStar_PIndex: () => void;
};

const TEST_EVENT = "测试";
// /** 秒；Lua 早于 JASS 绑表时可启用下方 TimerStart */
// const ENTRY_DELAY_SEC = 0.03;

const BOOT_GUARD_KEY = "__syzl_stesTest_booted";
const LUA_STES_REG_KEY = "__syzl_stesTest_luaStesReg";

function skeyIndex(this: void): number {
    const jg = jglobals as any;
    if (typeof jg.STES_skey_index === "number" && jg.STES_skey_index !== 0) {
        return jg.STES_skey_index;
    }
    if (typeof jass.StringHash === "function") {
        return jass.StringHash("index") as number;
    }
    return 0;
}

function log(this: void, msg: string): void {
    const p = (globalThis as any).print as ((m: string) => void) | undefined;
    if (typeof p === "function") {
        p(msg);
    }
}

/**
 * 向「测试」再挂一个 Lua 创建的触发器：JASS 侧用 STES_GetTable 遍历 + TriggerExecute 时会执行到（如聊天 333）。
 */
function tryRegisterLuaListenerForJassStes(this: void): void {
    const g = globalThis as any;
    if (g[LUA_STES_REG_KEY]) return;

    const ht = stesMod.STES_GetTable();
    if (ht == null || ht === 0) return;

    g[LUA_STES_REG_KEY] = true;

    if (typeof jass.CreateTrigger !== "function" || typeof jass.TriggerAddAction !== "function") {
        log("[STES事件测试] 无法 CreateTrigger，跳过 Lua STES 监听注册");
        return;
    }

    const trig = jass.CreateTrigger();
    jass.TriggerAddAction(trig, () => {
        try {
            const from5 = YDLocal5Get("real", YD_LOCAL_REAL_KEY);
            const b = typeof from5 === "number" ? from5 : 0;
            const quad = (b * b + 13 * b + 42) / (b + 1.0001);
            const root = Math.sqrt(Math.max(0, b + 16)) * 2.25;
            const ret = quad + root - Math.min(b, 5) * 0.5 + 3.14159;
            YDLocal7Set("real", YD_LOCAL_REAL_KEY, ret);
            log(
                "[STES事件测试-Lua] YDLocal5Get(real,\"" +
                    YD_LOCAL_REAL_KEY +
                    "\")=" +
                    b +
                    " → YDLocal7Set 写回 real,\"" +
                    YD_LOCAL_REAL_KEY +
                    "\"=" +
                    ret,
            );
        } finally {
            clearStar_PIndex();
        }
    });
    stesMod.STES_Register(trig, TEST_EVENT);

    log(
        "[STES事件测试] 已向「" + TEST_EVENT + "」STES_Register Lua 触发器；与 JASS 注册共用同一张表，输入 333 可测 JASS→Lua",
    );
}

/** 取表 → 注册 Lua 监听 → 有注册则 STES_FireWithReal11Step（亦可包在定时器里延后执行） */
function runAfterDelay(this: void): void {
    const ht = stesMod.STES_GetTable();
    if (ht == null || ht === 0) {
        log(
            "[STES事件测试] STES_GetTable() 仍为空（当前无延迟；若绑表晚于 require 可恢复 boot 内定时器）",
        );
        return;
    }

    tryRegisterLuaListenerForJassStes();

    const hash = jass.StringHash(TEST_EVENT);
    const sk = skeyIndex();
    const count =
        typeof jass.LoadInteger === "function" ? jass.LoadInteger(ht, hash, sk) : 0;

    log(
        "[STES事件测试] 表=" +
            String(ht) +
            " 事件「" +
            TEST_EVENT +
            "」count=" +
            count +
            " skey_index=" +
            sk,
    );

    if (count <= 0) {
        log(
            "[STES事件测试] 计数为 0：事件「" +
                TEST_EVENT +
                "」尚无 STES 注册（检查 JASS 是否已 Register、事件名是否一致）",
        );
        return;
    }

    log(
        "[STES事件测试] 执行 STES_FireWithReal11Step，realParamKey=\"" +
            YD_LOCAL_REAL_KEY +
            "\"（与 GUI 333）",
    );
    stesMod.STES_FireWithReal11Step(TEST_EVENT, YD_LOCAL_REAL_KEY);
    log("[STES事件测试] STES_FireWithReal11Step 已返回");
}

function boot(this: void): void {
    if (!ENABLED) return;
    const g = globalThis as any;
    if (g[BOOT_GUARD_KEY]) return;
    g[BOOT_GUARD_KEY] = true;

    log("[STES事件测试] 无延迟立即执行 STES 测试");
    runAfterDelay();

    // const timer = jass.CreateTimer();
    // jass.TimerStart(timer, ENTRY_DELAY_SEC, false, () => {
    //     runAfterDelay();
    //     if (typeof jass.PauseTimer === "function") {
    //         jass.PauseTimer(timer);
    //     }
    //     if (typeof jass.DestroyTimer === "function") {
    //         jass.DestroyTimer(timer);
    //     }
    // });
}

boot();

export {};
