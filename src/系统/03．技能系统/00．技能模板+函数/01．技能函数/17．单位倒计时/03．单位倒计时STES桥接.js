/** @noSelfInFile */
/**
 * 单位倒计时系统 - STES / YDLocal 桥接
 */
const jass = require("jass.common");
const jglobals = require("jass.globals");
const { registerStesListener } = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具");
const { ydlStes_syncTriggerStep, ydlStes_finishChildCleanup, ydlStes_readInteger5, ydlStes_readUnitcode5, ydlStes_readReal5, ydlStes_readString5, ydlStes_readUnit5, } = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具");
const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.index");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { 启动单位倒计时 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.17．单位倒计时.04．对外接口");
export const 单位倒计时STES事件名 = "UnitTimer";
const 模块名 = "单位倒计时桥接";
const REG_GUARD = "__syzl_unit_timer_registered";
const TRIG_KEY = "__syzl_unit_timer_trig";
const ATTEMPT_KEY = "__syzl_unit_timer_reg_attempt";
const MAX_REG_ATTEMPTS = 30;
const RETRY_SEC = 0.1;
let 单位倒计时Stes触发器 = null;
function 读取单位类型参数(name) {
    const text = ydlStes_readString5(undefined, name);
    if (text.length === 4)
        return text;
    const unitcode = ydlStes_readUnitcode5(undefined, name);
    if (unitcode !== 0)
        return unitcode;
    const integer = ydlStes_readInteger5(undefined, name);
    return integer !== 0 ? integer : undefined;
}
function 读取单位倒计时事件参数() {
    const 参数 = {
        Unit: ydlStes_readUnit5(undefined, "Unit"),
        time: ydlStes_readReal5(undefined, "time"),
        x: ydlStes_readReal5(undefined, "x"),
        y: ydlStes_readReal5(undefined, "y"),
        EffectID: ydlStes_readInteger5(undefined, "EffectID"),
        PowerUPtime: ydlStes_readReal5(undefined, "PowerUPtime"),
        PowerUPHP: ydlStes_readReal5(undefined, "PowerUPHP"),
        PowerUPModel: ydlStes_readString5(undefined, "PowerUPModel"),
        PowerUPunitType: 读取单位类型参数("PowerUPunitType"),
    };
    const 红 = ydlStes_readReal5(undefined, "红");
    const 绿 = ydlStes_readReal5(undefined, "绿");
    const 蓝 = ydlStes_readReal5(undefined, "蓝");
    const 透明度 = ydlStes_readReal5(undefined, "透明度");
    if (红 !== 0 || 绿 !== 0 || 蓝 !== 0 || 透明度 !== 0) {
        参数.红 = 红;
        参数.绿 = 绿;
        参数.蓝 = 蓝;
        参数.透明度 = 透明度 !== 0 ? 透明度 : 255;
    }
    return 参数;
}
export function 根据Stes事件启动单位倒计时() {
    try {
        ydlStes_syncTriggerStep(undefined);
        const 参数 = 读取单位倒计时事件参数();
        const id = 启动单位倒计时(参数);
        debugLogForce(模块名, "收到 UnitTimer", "id=", id, "unit=", 参数.Unit, "time=", 参数.time, "effectID=", 参数.EffectID);
        return id;
    }
    finally {
        ydlStes_finishChildCleanup(undefined);
    }
}
function on单位倒计时Stes事件Action() {
    根据Stes事件启动单位倒计时();
}
function jassStesHashtable() {
    const jg = jglobals;
    const cands = [jg.STES___HT, jg.STES_HT, jg.udg_STES___HT, jg.udg_STES_HT];
    for (let i = 0; i < cands.length; i++) {
        const t = cands[i];
        if (t != null && t !== 0)
            return t;
    }
    return null;
}
function countOnJassStesTable(eventName) {
    const ht = jassStesHashtable();
    if (ht == null || ht === 0)
        return -1;
    return jass.LoadInteger(ht, jass.StringHash(eventName), jass.StringHash("index"));
}
function onRetryRegisterUnitTimerStes() {
    tryRegisterUnitTimerStes();
}
function scheduleRetry() {
    createDelayedCall(RETRY_SEC, onRetryRegisterUnitTimerStes);
}
function tryRegisterUnitTimerStes() {
    const g = globalThis;
    if (g[REG_GUARD])
        return;
    if (g[TRIG_KEY] == null) {
        单位倒计时Stes触发器 = registerStesListener(单位倒计时STES事件名, on单位倒计时Stes事件Action);
        g[TRIG_KEY] = 单位倒计时Stes触发器;
    }
    else {
        单位倒计时Stes触发器 = g[TRIG_KEY];
    }
    const jCount = countOnJassStesTable(单位倒计时STES事件名);
    const attempt = g[ATTEMPT_KEY] || 0;
    g[ATTEMPT_KEY] = attempt + 1;
    if (jCount >= 1) {
        g[REG_GUARD] = true;
        debugLogForce(模块名, "注册成功", "event=", 单位倒计时STES事件名, "count=", jCount);
        return;
    }
    if (g[ATTEMPT_KEY] >= MAX_REG_ATTEMPTS) {
        debugLogForce(模块名, "注册失败", "event=", 单位倒计时STES事件名, "最后计数=", jCount);
        return;
    }
    scheduleRetry();
}
export function 注册单位倒计时Stes桥接() {
    tryRegisterUnitTimerStes();
}
注册单位倒计时Stes桥接();
