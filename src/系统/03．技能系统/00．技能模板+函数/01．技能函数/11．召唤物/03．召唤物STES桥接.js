/**
 * 召唤物系统 - STES / YDLocal 桥接
 */
const jass = require("jass.common");
const jglobals = require("jass.globals");
const { registerStesListener } = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具");
const { ydlStes_syncTriggerStep, ydlStes_finishChildCleanup, ydlStes_readInteger5, ydlStes_readUnitcode5, ydlStes_readReal5, ydlStes_readString5, ydlStes_readUnit5, } = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具");
const { YDLocal7Set } = require("lib.扩展函数.YDWE函数.02．YDLocal兼容");
const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.index");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { 创建召唤物 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口");
export const SUMMON_STES_EVENT = "OnSummonEvent";
const 模块名 = "召唤物桥接";
let summonStesTrigger = null;
const REG_GUARD = "__syzl_summon_registered";
const TRIG_KEY = "__syzl_summon_trig";
const ATTEMPT_KEY = "__syzl_summon_reg_attempt";
const MAX_REG_ATTEMPTS = 30;
const RETRY_SEC = 0.1;
function 读取召唤物事件参数() {
    const moveHeight = ydlStes_readReal5(undefined, "moveHeight");
    const attackInterval = ydlStes_readReal5(undefined, "atkCd");
    const attackIntervalCompat = ydlStes_readReal5(undefined, "MoveHeight");
    const facing = ydlStes_readReal5(undefined, "facing");
    const unitTypeString = ydlStes_readString5(undefined, "unitType");
    const unitTypeUnitcode = ydlStes_readUnitcode5(undefined, "unitType");
    const unitTypeInteger = ydlStes_readInteger5(undefined, "unitType");
    const unitType = unitTypeString.length === 4
        ? unitTypeString
        : (unitTypeUnitcode !== 0 ? unitTypeUnitcode : unitTypeInteger);
    return {
        主人单位: ydlStes_readUnit5(undefined, "Master"),
        召唤物单位: ydlStes_readUnit5(undefined, "Summon"),
        单位类型: unitType,
        单位类型字符串: unitTypeString,
        单位类型unitcode: unitTypeUnitcode,
        x: ydlStes_readReal5(undefined, "x"),
        y: ydlStes_readReal5(undefined, "y"),
        面向: facing !== 0 ? facing : undefined,
        持续时间: ydlStes_readReal5(undefined, "time"),
        模型文件: ydlStes_readString5(undefined, "ModelFileID"),
        飞行高度: moveHeight > 0 ? moveHeight : undefined,
        生命值: ydlStes_readReal5(undefined, "HP"),
        生命恢复: ydlStes_readReal5(undefined, "regenHP"),
        攻击力: ydlStes_readReal5(undefined, "AttackPower"),
        攻击间隔: attackInterval > 0 ? attackInterval : (attackIntervalCompat > 0 ? attackIntervalCompat : undefined),
        护甲: ydlStes_readReal5(undefined, "def"),
        缩放: ydlStes_readReal5(undefined, "size"),
    };
}
export function 根据Stes事件创建召唤物() {
    try {
        ydlStes_syncTriggerStep(undefined);
        const 参数 = 读取召唤物事件参数();
        debugLogForce(模块名, "收到 OnSummonEvent", "Master=", 参数.主人单位, "Summon=", 参数.召唤物单位, "unitType=", 参数.单位类型, "unitTypeString=", 参数.单位类型字符串, "unitTypeUnitcode=", 参数.单位类型unitcode, "x=", 参数.x, "y=", 参数.y, "facing=", 参数.面向, "time=", 参数.持续时间, "HP=", 参数.生命值, "size=", 参数.缩放);
        const 召唤物 = 创建召唤物(参数);
        if (召唤物 != null && 召唤物 !== 0) {
            YDLocal7Set("unit", "Summon", 召唤物);
        }
        debugLogForce(模块名, "OnSummonEvent 处理结果 summon=", 召唤物);
        return 召唤物;
    }
    finally {
        ydlStes_finishChildCleanup(undefined);
    }
}
function onSummonStesEventAction() {
    根据Stes事件创建召唤物();
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
function onRetryRegisterSummonStes() {
    tryRegisterSummonStes();
}
function scheduleRetry() {
    createDelayedCall(RETRY_SEC, onRetryRegisterSummonStes);
}
function tryRegisterSummonStes() {
    const g = globalThis;
    if (g[REG_GUARD])
        return;
    if (g[TRIG_KEY] == null) {
        summonStesTrigger = registerStesListener(SUMMON_STES_EVENT, onSummonStesEventAction);
        g[TRIG_KEY] = summonStesTrigger;
    }
    else {
        summonStesTrigger = g[TRIG_KEY];
    }
    const jCount = countOnJassStesTable(SUMMON_STES_EVENT);
    const attempt = g[ATTEMPT_KEY] || 0;
    g[ATTEMPT_KEY] = attempt + 1;
    debugLogForce(模块名, "注册检查", "attempt=", attempt + 1, "jCount=", jCount, "trigger=", summonStesTrigger);
    if (jCount >= 1) {
        g[REG_GUARD] = true;
        debugLogForce(模块名, "注册成功", "event=", SUMMON_STES_EVENT, "count=", jCount);
        return;
    }
    if (g[ATTEMPT_KEY] >= MAX_REG_ATTEMPTS) {
        debugLogForce(模块名, "注册失败", "event=", SUMMON_STES_EVENT, "最后计数=", jCount);
        return;
    }
    scheduleRetry();
}
export function 注册召唤物Stes桥接() {
    tryRegisterSummonStes();
}
注册召唤物Stes桥接();
