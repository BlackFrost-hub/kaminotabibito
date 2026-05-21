/** @noSelfInFile */
/**
 * 充能系统
 *
 * 说明：
 * 1. 使用中心计时器按 0.02 秒推进充能
 * 2. 默认显示“进度条特效”，它是单位头顶的施法进度条，不是附着骨骼特效
 * 3. 过程特效 / 完成特效统一使用坐标特效，不使用 `AddSpecialEffectTarget`
 * 4. 命中硬控制效果合集时，当前充能会按“中断”结束
 */
const jass = require("jass.common");
const japi = require("jass.japi");
const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器");
const { YDWETimerDestroyEffect } = require("lib.扩展函数.YDWE函数.00．YDWE函数");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index");
import { 创建进度条特效, 销毁单位进度条特效 } from "./进度条特效";
import { 单位是否处于硬控制效果合集 } from "../../02．通用函数/01．控制与Buff";
const 调试模块名 = "充能系统";
const GetHandleId = jass.GetHandleId;
const GetUnitTypeId = jass.GetUnitTypeId;
const GetUnitState = jass.GetUnitState;
const IsUnitType = jass.IsUnitType;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitFlyHeight = jass.GetUnitFlyHeight;
const AddSpecialEffect = jass.AddSpecialEffect;
const Location = jass.Location;
const MoveLocation = jass.MoveLocation;
const GetLocationZ = jass.GetLocationZ;
const RemoveLocation = jass.RemoveLocation;
const EXSetEffectZ = japi.EXSetEffectZ;
const TICK_INTERVAL = 0.02;
const CENTER_TIMER_TICKS = 2;
const UNIT_ALIVE_LIFE = 0.405;
const DEFAULT_EFFECT_INTERVAL = 0.1;
const DEFAULT_EFFECT_DURATION = 1.0;
const 活动充能列表 = [];
const 充能映射 = {};
const 单位当前充能 = {};
const 充能打断回调列表 = [];
let 下一个充能ID = 1;
let 已注册到中心计时器 = false;
let tick计数 = 0;
let 地形采样点 = null;
function 取句柄ID(h) {
    return h != null && h !== 0 ? GetHandleId(h) : 0;
}
function 单位存活(u) {
    if (u == null || u === 0)
        return false;
    if (GetUnitTypeId(u) === 0)
        return false;
    if (IsUnitType(u, jass.UNIT_TYPE_DEAD))
        return false;
    return GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
}
function 获取地形高度(x, y) {
    if (地形采样点 == null) {
        地形采样点 = Location(x, y);
    }
    else {
        MoveLocation(地形采样点, x, y);
    }
    return GetLocationZ(地形采样点) || 0;
}
function 归一化时间(value, defaultValue) {
    if (value != null && value > 0)
        return value;
    return defaultValue;
}
function 计算过程特效间隔(持续时间, 参数) {
    const 播放次数 = 参数.过程特效播放次数;
    if (播放次数 != null && 播放次数 > 0) {
        return 归一化时间(持续时间 / 播放次数, DEFAULT_EFFECT_INTERVAL);
    }
    return 归一化时间(参数.过程特效间隔, DEFAULT_EFFECT_INTERVAL);
}
function 计算进度条动画速度(持续时间, 参数) {
    if (参数.进度条特效动画速度 != null && 参数.进度条特效动画速度 > 0) {
        return 参数.进度条特效动画速度;
    }
    if (持续时间 > 0) {
        return 1 / 持续时间;
    }
    return 1;
}
function 计算充能进度(实例) {
    if (实例.总持续时间 <= 0)
        return 0;
    const 已进行时间 = 实例.总持续时间 - 实例.剩余时间;
    const 百分比 = 已进行时间 / 实例.总持续时间;
    if (百分比 <= 0)
        return 0;
    if (百分比 >= 1)
        return 1;
    return 百分比;
}
function 播放单位坐标特效(单位, 模型, 生命周期) {
    if (!单位存活(单位) || 模型 == null || 模型 === "")
        return;
    const x = GetUnitX(单位);
    const y = GetUnitY(单位);
    const effect = AddSpecialEffect(模型, x, y);
    if (effect == null || effect === 0)
        return;
    if (typeof EXSetEffectZ === "function") {
        EXSetEffectZ(effect, 获取地形高度(x, y) + GetUnitFlyHeight(单位));
    }
    YDWETimerDestroyEffect(生命周期, effect);
}
function 从中心计时器注销() {
    if (!已注册到中心计时器)
        return;
    已注册到中心计时器 = false;
    offTick10ms(on充能系统Tick);
}
function 注册到中心计时器() {
    if (已注册到中心计时器)
        return;
    已注册到中心计时器 = true;
    tick计数 = 0;
    onTick10ms(on充能系统Tick);
}
function 尝试关闭中心计时器() {
    if (活动充能列表.length > 0)
        return;
    从中心计时器注销();
}
function 触发充能打断回调(单位, 原因, 充能ID) {
    for (const 回调 of 充能打断回调列表) {
        回调(单位, 原因, 充能ID);
    }
}
function 结束充能实例(实例, 原因) {
    delete 充能映射[实例.id];
    if (单位当前充能[实例.单位ID] === 实例.id) {
        delete 单位当前充能[实例.单位ID];
    }
    const index = 活动充能列表.indexOf(实例);
    if (index >= 0) {
        活动充能列表.splice(index, 1);
    }
    if (实例.显示进度条特效) {
        销毁单位进度条特效(实例.单位);
    }
    if (原因 === "完成" && 单位存活(实例.单位)) {
        播放单位坐标特效(实例.单位, 实例.完成特效, 实例.完成特效生命周期);
        if (typeof 实例.充能完成回调 === "function") {
            实例.充能完成回调(实例.单位, 实例.id);
        }
    }
    if (typeof 实例.结束回调 === "function") {
        实例.结束回调(实例.单位, 原因, 实例.id);
    }
    if (原因 !== "完成") {
        触发充能打断回调(实例.单位, 原因, 实例.id);
    }
}
export function 停止充能(充能ID) {
    const 实例 = 充能映射[充能ID];
    if (实例 == null)
        return false;
    结束充能实例(实例, "中断");
    尝试关闭中心计时器();
    return true;
}
export function 停止单位充能(单位) {
    const 单位ID = 取句柄ID(单位);
    if (单位ID === 0)
        return false;
    const 充能ID = 单位当前充能[单位ID];
    if (充能ID == null)
        return false;
    return 停止充能(充能ID);
}
export function 单位是否正在充能(单位) {
    const 单位ID = 取句柄ID(单位);
    if (单位ID === 0)
        return false;
    return 单位当前充能[单位ID] != null;
}
export function 获取单位当前充能ID(单位) {
    const 单位ID = 取句柄ID(单位);
    if (单位ID === 0)
        return 0;
    return 单位当前充能[单位ID] ?? 0;
}
export function 获取活跃充能数量() {
    return 活动充能列表.length;
}
export function 获取充能进度(充能ID) {
    const 实例 = 充能映射[充能ID];
    if (实例 == null || 实例.总持续时间 <= 0)
        return 0;
    const 已进行时间 = 实例.总持续时间 - 实例.剩余时间;
    const 百分比 = 已进行时间 / 实例.总持续时间;
    if (百分比 <= 0)
        return 0;
    if (百分比 >= 1)
        return 1;
    return 百分比;
}
export function 注册充能打断回调(回调) {
    if (回调 == null)
        return;
    if (充能打断回调列表.indexOf(回调) >= 0)
        return;
    充能打断回调列表.push(回调);
}
export function 取消注册充能打断回调(回调) {
    const 索引 = 充能打断回调列表.indexOf(回调);
    if (索引 < 0)
        return;
    充能打断回调列表.splice(索引, 1);
}
export function 开始充能(单位, 参数) {
    debugLogForce(调试模块名, "开始充能被调用");
    if (!单位存活(单位) || 参数.持续时间 <= 0) {
        debugLogForce(调试模块名, "单位不存在或持续时间无效");
        return 0;
    }
    停止单位充能(单位);
    const 单位ID = 取句柄ID(单位);
    const 持续时间 = 参数.持续时间;
    const 充能ID = 下一个充能ID++;
    const 显示进度条特效 = 参数.显示进度条特效 !== false;
    const 过程特效 = 参数.过程特效;
    const 过程特效生命周期 = 归一化时间(参数.过程特效生命周期, DEFAULT_EFFECT_DURATION);
    const 完成特效 = 参数.完成特效;
    const 完成特效生命周期 = 归一化时间(参数.完成特效生命周期, DEFAULT_EFFECT_DURATION);
    const 周期回调间隔 = 归一化时间(参数.周期回调间隔, TICK_INTERVAL);
    const 新实例 = {
        id: 充能ID,
        单位,
        单位ID,
        主单位: 参数.主单位,
        主单位死亡时中断: 参数.主单位死亡时中断 !== false,
        总持续时间: 持续时间,
        剩余时间: 持续时间,
        显示进度条特效,
        过程特效,
        过程特效间隔: 计算过程特效间隔(持续时间, 参数),
        过程特效生命周期,
        完成特效,
        完成特效生命周期,
        下次过程特效倒计时: 0,
        周期回调: 参数.周期回调,
        周期回调间隔,
        下次周期回调倒计时: 0,
        开始回调: 参数.开始回调,
        充能完成回调: 参数.充能完成回调,
        结束回调: 参数.结束回调,
    };
    活动充能列表.push(新实例);
    充能映射[充能ID] = 新实例;
    单位当前充能[单位ID] = 充能ID;
    if (显示进度条特效) {
        创建进度条特效(单位, {
            高度偏移: 参数.进度条特效高度偏移 ?? 275,
            动画序号: 参数.进度条特效动画序号 ?? 0,
            动画速度: 计算进度条动画速度(持续时间, 参数),
        });
    }
    if (typeof 新实例.开始回调 === "function") {
        新实例.开始回调(单位, 充能ID);
    }
    注册到中心计时器();
    return 充能ID;
}
function on充能系统Tick() {
    tick计数 += 1;
    if (tick计数 < CENTER_TIMER_TICKS)
        return;
    tick计数 = 0;
    let i = 0;
    while (i < 活动充能列表.length) {
        const 实例 = 活动充能列表[i];
        if (!单位存活(实例.单位)) {
            结束充能实例(实例, "死亡");
            continue;
        }
        if (单位是否处于硬控制效果合集(实例.单位)) {
            结束充能实例(实例, "中断");
            continue;
        }
        if (实例.主单位死亡时中断 && 实例.主单位 != null && !单位存活(实例.主单位)) {
            结束充能实例(实例, "主单位死亡");
            continue;
        }
        实例.剩余时间 -= TICK_INTERVAL;
        实例.下次过程特效倒计时 -= TICK_INTERVAL;
        实例.下次周期回调倒计时 -= TICK_INTERVAL;
        if (实例.过程特效 != null && 实例.过程特效 !== "" && 实例.下次过程特效倒计时 <= 0) {
            播放单位坐标特效(实例.单位, 实例.过程特效, 实例.过程特效生命周期);
            实例.下次过程特效倒计时 = 实例.过程特效间隔;
        }
        if (typeof 实例.周期回调 === "function" && 实例.下次周期回调倒计时 <= 0) {
            const 已进行时间 = 实例.总持续时间 - 实例.剩余时间;
            实例.周期回调(实例.单位, 实例.id, 已进行时间, 实例.剩余时间, 计算充能进度(实例));
            实例.下次周期回调倒计时 = 实例.周期回调间隔;
        }
        if (实例.剩余时间 <= 0) {
            结束充能实例(实例, "完成");
            continue;
        }
        i += 1;
    }
    尝试关闭中心计时器();
}
const g = globalThis;
if (typeof g.开始充能 !== "function") {
    g.开始充能 = 开始充能;
}
