/** @noSelfInFile */
/**
 * 持续治疗效果（HOT）系统
 *
 * 功能：通过中心计时器实现每秒恢复生命和魔法
 *
 * 优化：使用中心计时器的 onSecond 回调，避免为每个单位创建独立计时器
 *
 * 后续接手者注意：
 * 1. 直接调用 doHeal 执行治疗，不需要通过STES事件
 * 2. Buff ID列表可根据需要扩展
 */
const jass = require("jass.common");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统");
const { UnitHasBuffBJ, IsUnitDeadBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄");
const { IsUnitPausedBJ } = require("lib.扩展函数.BJ函数.08．单位BJ扩展");
const { YDUserDataGetSafe, YDUserDataSetSafe, YDUserDataClearSafe, } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版");
const { onSecond, offSecond } = globalThis;
// 导入核心治疗功能
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能");
//=============================================================================
// 一、常量配置
//=============================================================================
/** 持续恢复相关Buff ID（没有这些Buff时效果结束） */
const HOT_BUFF_IDS = [
    0x4249726D, // 'BIrm' - 恢复魔法
    0x42497267, // 'BIrg' - 恢复生命
    0x4249726C, // 'BIrl' - 恢复
    0x4272656A, // 'Brej' - 再生
];
const HOT_BUFF_POOL_IDS = ["C027"];
/** YDUserData属性名 */
const ATTR_COUNTDOWN = "持续恢复倒计时";
const ATTR_TICK_HP = "hotTickHP";
const ATTR_TICK_MP = "hotTickMP";
const ATTR_SOURCE = "hotSource";
const ATTR_BUFF_ID = "hotBuffID";
/** 系统开关 */
const HOT_SYSTEM_ENABLED = true;
//=============================================================================
// 二、辅助函数
//=============================================================================
/**
 * 检查单位是否有任意一个持续恢复Buff
 */
function hasAnyHotBuff(unit) {
    const 指定BuffID = YDUserDataGetSafe("unit", unit, ATTR_BUFF_ID, "string");
    if (指定BuffID != null && 指定BuffID !== "") {
        return getBuffRuntime(unit, 指定BuffID) != null;
    }
    for (const buffID of HOT_BUFF_POOL_IDS) {
        if (getBuffRuntime(unit, buffID) != null)
            return true;
    }
    for (const buffId of HOT_BUFF_IDS) {
        if (UnitHasBuffBJ(unit, buffId))
            return true;
    }
    return false;
}
//=============================================================================
// 三、HOT单位管理
//=============================================================================
/** 正在受HOT效果影响的单位集合 */
const hotUnits = new Set();
/** 是否已注册中心计时器回调 */
let registeredToCenterTimer = false;
/** 中心计时器回调引用（用于注销） */
let hotTickCallback = null;
/**
 * 中心计时器每秒回调
 * 遍历所有HOT单位，执行恢复逻辑
 */
function onHotTick() {
    debugLogForce("持续治疗效果", "onHotTick", "hotUnits:", hotUnits.size);
    const toRemove = [];
    for (const target of hotUnits) {
        debugLogForce("持续治疗效果", "tick开始", "target:", target);
        // 检查单位是否被暂停（暂停则跳过本次）
        if (IsUnitPausedBJ(target)) {
            debugLogForce("持续治疗效果", "跳过暂停单位", "target:", target);
            continue;
        }
        // 减少持续恢复倒计时
        const countdown = YDUserDataGetSafe("unit", target, ATTR_COUNTDOWN, "real") - 1.0;
        YDUserDataSetSafe("unit", target, ATTR_COUNTDOWN, "real", countdown);
        // 获取恢复量和来源
        const tickHP = YDUserDataGetSafe("unit", target, ATTR_TICK_HP, "real");
        const tickMP = YDUserDataGetSafe("unit", target, ATTR_TICK_MP, "real");
        const source = YDUserDataGetSafe("unit", target, ATTR_SOURCE, "unit");
        debugLogForce("持续治疗效果", "读取HOT数据", "target:", target, "countdown:", countdown, "tickHP:", tickHP, "tickMP:", tickMP, "source:", source);
        // 执行生命/魔法恢复（直接调用 doHeal，TS参数传参）
        if (tickHP > 0 || tickMP > 0) {
            const healed = doHeal({
                HealSource: source,
                HealTarget: target,
                HealAmount: tickHP > 0 ? tickHP : 0,
                HealManaAmount: tickMP > 0 ? tickMP : 0,
                ItemHeal: true,
                HealEffect: false, // HOT通常不播放特效
                ManaEffect: false,
                ManaShowText: tickMP > 0,
            });
            debugLogForce("持续治疗效果", "doHeal完成", "target:", target, "healed:", healed);
        }
        else {
            debugLogForce("持续治疗效果", "跳过doHeal", "target:", target, "tickHP:", tickHP, "tickMP:", tickMP);
        }
        // 检查结束条件
        const buffAlive = hasAnyHotBuff(target);
        const dead = IsUnitDeadBJ(target);
        const shouldEnd = !buffAlive ||
            countdown <= 0 ||
            dead;
        debugLogForce("持续治疗效果", "结束判定", "target:", target, "buffAlive:", buffAlive, "countdown:", countdown, "dead:", dead, "shouldEnd:", shouldEnd);
        if (shouldEnd) {
            toRemove.push(target);
        }
    }
    // 清理结束的单位
    for (const target of toRemove) {
        stopHot(target);
    }
}
/**
 * 注册中心计时器回调（延迟注册，只在有HOT单位时才运行）
 */
function ensureCenterTimerRegistered() {
    if (registeredToCenterTimer)
        return;
    hotTickCallback = onHotTick;
    onSecond(hotTickCallback);
    registeredToCenterTimer = true;
}
/**
 * 注销中心计时器回调（没有HOT单位时停止运行）
 */
function unregisterCenterTimerIfNeeded() {
    if (!registeredToCenterTimer)
        return;
    if (hotUnits.size > 0)
        return;
    if (hotTickCallback) {
        offSecond(hotTickCallback);
        hotTickCallback = null;
    }
    registeredToCenterTimer = false;
}
//=============================================================================
// 四、主功能函数
//=============================================================================
/**
 * 启动持续治疗效果
 *
 * @param target 目标单位
 * @param source 来源单位
 * @param tickHP 每秒恢复生命量
 * @param tickMP 每秒恢复魔法量
 * @param duration 持续时间（秒）
 */
export function startHot(target, source, tickHP, tickMP, duration, _intervalOrOptions, extraOptions) {
    if (!HOT_SYSTEM_ENABLED)
        return;
    if (target == null)
        return;
    if (duration <= 0)
        return;
    debugLogForce("持续治疗效果", "startHot", "target:", target, "source:", source, "tickHP:", tickHP, "tickMP:", tickMP, "duration:", duration);
    // 设置倒计时和恢复量
    YDUserDataSetSafe("unit", target, ATTR_COUNTDOWN, "real", duration);
    YDUserDataSetSafe("unit", target, ATTR_TICK_HP, "real", tickHP);
    YDUserDataSetSafe("unit", target, ATTR_TICK_MP, "real", tickMP);
    YDUserDataSetSafe("unit", target, ATTR_SOURCE, "unit", source);
    const options = extraOptions != null ? extraOptions : (typeof _intervalOrOptions === "number" ? null : _intervalOrOptions);
    if (options != null && options.BuffID != null && options.BuffID !== "") {
        YDUserDataSetSafe("unit", target, ATTR_BUFF_ID, "string", options.BuffID);
    }
    else {
        YDUserDataClearSafe("unit", target, ATTR_BUFF_ID, "string");
    }
    // 添加到HOT单位集合
    const isNew = !hotUnits.has(target);
    hotUnits.add(target);
    debugLogForce("持续治疗效果", "加入热集合", "target:", target, "isNew:", isNew, "size:", hotUnits.size);
    // 确保中心计时器回调已注册
    if (isNew) {
        ensureCenterTimerRegistered();
    }
}
/**
 * 停止持续治疗效果
 */
export function stopHot(target) {
    if (target == null)
        return;
    debugLogForce("持续治疗效果", "stopHot", "target:", target, "beforeSize:", hotUnits.size);
    // 从HOT单位集合移除
    hotUnits.delete(target);
    // 清理YDUserData
    YDUserDataClearSafe("unit", target, ATTR_COUNTDOWN, "real");
    YDUserDataClearSafe("unit", target, ATTR_TICK_HP, "real");
    YDUserDataClearSafe("unit", target, ATTR_TICK_MP, "real");
    YDUserDataClearSafe("unit", target, ATTR_SOURCE, "unit");
    YDUserDataClearSafe("unit", target, ATTR_BUFF_ID, "string");
    // 如果没有HOT单位了，注销中心计时器回调
    unregisterCenterTimerIfNeeded();
    debugLogForce("持续治疗效果", "stopHot完成", "target:", target, "afterSize:", hotUnits.size);
}
/**
 * 检查单位是否正在受HOT效果影响
 */
export function isHotActive(target) {
    return hotUnits.has(target);
}
/**
 * 获取当前HOT单位数量
 */
export function getHotUnitCount() {
    return hotUnits.size;
}
//=============================================================================
// 五、STES事件触发函数（供Lua/JASS端调用）
//=============================================================================
const { STES_FireWithParams } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件");
/** STES事件名称 */
export const HOT_EVENT_NAME = "持续治疗效果";
/**
 * 触发"持续治疗效果"事件
 * 供Lua端/JASS端调用，启动持续恢复效果
 *
 * @param target 目标单位
 * @param source 来源单位
 * @param tickHP 每秒恢复生命量
 * @param tickMP 每秒恢复魔法量
 * @param duration 持续时间（秒，可选，默认从YDUserData读取或使用tickHP）
 */
export function fireHotEvent(target, source, tickHP, tickMP, duration) {
    if (duration != null) {
        YDUserDataSetSafe("unit", target, ATTR_COUNTDOWN, "real", duration);
    }
    STES_FireWithParams(HOT_EVENT_NAME, [
        { type: "unit", name: "HealTarget", value: target },
        { type: "unit", name: "HealSource", value: source },
        { type: "real", name: "hotTickHP", value: tickHP },
        { type: "real", name: "hotTickMP", value: tickMP },
    ]);
}
//=============================================================================
// 六、STES事件处理
//=============================================================================
/** 触发器实例 */
let hotTrigger = null;
/**
 * STES事件处理函数
 * 接收参数：HealTarget, HealSource, hotTickHP, hotTickMP
 */
function onHotEvent() {
    const { YDLocal1Get } = require("lib.扩展函数.YDWE函数.02．YDLocal兼容");
    const target = YDLocal1Get("unit", "HealTarget");
    const source = YDLocal1Get("unit", "HealSource");
    const tickHP = YDLocal1Get("real", "hotTickHP");
    const tickMP = YDLocal1Get("real", "hotTickMP");
    // 获取持续时间（从YDUserData读取，或使用tickHP作为默认值）
    let duration = YDUserDataGetSafe("unit", target, ATTR_COUNTDOWN, "real");
    if (duration <= 0) {
        duration = tickHP > 0 ? tickHP : 10; // 默认10秒
    }
    startHot(target, source, tickHP, tickMP, duration);
}
//=============================================================================
// 七、初始化
//=============================================================================
/**
 * 初始化持续治疗效果系统
 */
export function initHotSystem() {
    if (!HOT_SYSTEM_ENABLED)
        return;
    if (hotTrigger != null)
        return;
    const { registerStesListener } = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具");
    hotTrigger = registerStesListener(HOT_EVENT_NAME, onHotEvent);
}
/**
 * 检查系统是否已初始化
 */
export function isHotSystemInitialized() {
    return hotTrigger != null;
}
/** @noSelfInFile */
