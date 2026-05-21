/** @noSelfInFile */
const jass = require("jass.common");
const jglobals = require("jass.globals");
const { X_GAFC, X_IsTerrainWalkable, X_IsUnitTerrainWalkable, X_GetAbleX, X_GetAbleY } = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数");
const { 申请单位暂停占用, 释放单位暂停占用, 单位是否存在其他暂停占用, } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统");
const { 零秒后播放单位动作, 零秒后重置单位动画 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待");
const ForGroup = jass["ForGroup"];
const GetEnumUnit = jass["GetEnumUnit"];
const SetUnitAnimation = jass["SetUnitAnimation"];
const SetUnitTimeScale = jass["SetUnitTimeScale"];
export { jass, jglobals, X_GAFC, X_IsTerrainWalkable, X_IsUnitTerrainWalkable, X_GetAbleX, X_GetAbleY };
export { 申请单位暂停占用, 释放单位暂停占用, 单位是否存在其他暂停占用 };
export { 零秒后播放单位动作, 零秒后重置单位动画, SetUnitAnimation, SetUnitTimeScale };
export const BJ_DEGTORAD = jglobals.bj_DEGTORAD ?? 0.017453292519943295;
export const TICK_INTERVAL = 0.02;
export const CENTER_TIMER_TICKS = 2;
export const MAX_SUB_STEP = 31.0;
export const WALKABLE_TOLERANCE = 8.0;
export const UNIT_ALIVE_LIFE = 0.405;
export const DEFAULT_MOVE_EFFECT_MODEL = "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl";
export const DEFAULT_ATTACK_TYPE = jass.ATTACK_TYPE_NORMAL;
export const DEFAULT_DAMAGE_TYPE = jass.DAMAGE_TYPE_NORMAL;
export const DEFAULT_WEAPON_TYPE = jass.WEAPON_TYPE_WHOKNOWS;
export const 活动位移列表 = [];
export const 位移映射 = {};
export const 单位当前位移 = {};
export const 命中记录 = {};
let 枚举组 = null;
let 单位组快照缓存 = [];
let 下一个位移ID = 0;
export function 分配新位移ID() {
    下一个位移ID += 1;
    return 下一个位移ID;
}
export function 取句柄ID(h) {
    return (h != null && h !== 0 ? jass.GetHandleId(h) : 0) || 0;
}
function 收集单位组成员() {
    const 单位 = GetEnumUnit();
    if (单位 != null && 单位 !== 0) {
        单位组快照缓存.push(单位);
    }
}
export function 快照单位组(单位组) {
    if (单位组 == null || 单位组 === 0)
        return [];
    单位组快照缓存 = [];
    ForGroup(单位组, 收集单位组成员);
    const 结果 = 单位组快照缓存;
    单位组快照缓存 = [];
    return 结果;
}
export function 单位存活(u) {
    return u != null && u !== 0 && jass.GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
}
export function 在可玩区域内(x, y) {
    return x >= jass.GetRectMinX(jglobals.bj_mapInitialPlayableArea)
        && y >= jass.GetRectMinY(jglobals.bj_mapInitialPlayableArea)
        && x <= jass.GetRectMaxX(jglobals.bj_mapInitialPlayableArea)
        && y <= jass.GetRectMaxY(jglobals.bj_mapInitialPlayableArea);
}
export function 计算坐标距离(x1, y1, x2, y2) {
    const dx = x2 - x1;
    const dy = y2 - y1;
    return jass.SquareRoot(dx * dx + dy * dy);
}
export function 清理命中记录(位移ID) {
    const 前缀 = `${位移ID}:`;
    for (const key in 命中记录) {
        if (key.indexOf(前缀) === 0) {
            delete 命中记录[key];
        }
    }
}
export function 生成命中键(位移ID, 目标单位) {
    return `${位移ID}:${取句柄ID(目标单位)}`;
}
export function 计算每Tick位移(距离, 持续时间, 每秒速度) {
    if (每秒速度 != null && 每秒速度 > 0) {
        return 每秒速度 * TICK_INTERVAL;
    }
    if (持续时间 != null && 持续时间 > 0) {
        return 距离 / (持续时间 / TICK_INTERVAL);
    }
    return 距离;
}
export function 单位已被暂停(单位) {
    if (单位 == null || 单位 === 0)
        return false;
    return jass.IsUnitPaused(单位) === true;
}
export function 播放位移特效(实例) {
    const 模型 = 实例.位移特效;
    if (模型 == null || 模型 === "")
        return;
    const 特效 = jass.AddSpecialEffect(模型, jass.GetUnitX(实例.单位), jass.GetUnitY(实例.单位));
    if (特效 != null && 特效 !== 0) {
        jass.DestroyEffect(特效);
    }
}
export function 获取枚举组() {
    if (枚举组 == null || 枚举组 === 0) {
        枚举组 = jass.CreateGroup();
    }
    return 枚举组;
}
export function 清空枚举组() {
    const g = 获取枚举组();
    while (true) {
        const u = jass.FirstOfGroup(g);
        if (u == null || u === 0)
            break;
        jass.GroupRemoveUnit(g, u);
    }
}
export function 销毁枚举组() {
    if (枚举组 != null && 枚举组 !== 0) {
        jass.DestroyGroup(枚举组);
        枚举组 = null;
    }
}
