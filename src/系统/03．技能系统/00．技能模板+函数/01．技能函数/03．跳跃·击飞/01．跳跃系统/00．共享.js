/** @noSelfInFile */
/**
 * 跳跃系统 - 共享模块
 *
 * 包含类型定义、常量、工具函数和状态容器。
 */
const jass = require("jass.common");
const jglobals = require("jass.globals");
const { X_GAFC, X_IsTerrainWalkable, X_IsUnitTerrainWalkable, X_GetAbleX, X_GetAbleY } = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数");
const { 申请单位暂停占用, 释放单位暂停占用, 单位是否存在其他暂停占用, } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统");
const { 零秒后重置单位动画 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待");
const GetHandleId = jass["GetHandleId"];
const GetUnitState = jass["GetUnitState"];
const GetRectMinX = jass["GetRectMinX"];
const GetRectMinY = jass["GetRectMinY"];
const GetRectMaxX = jass["GetRectMaxX"];
const GetRectMaxY = jass["GetRectMaxY"];
const UnitAddAbility = jass["UnitAddAbility"];
const UnitRemoveAbility = jass["UnitRemoveAbility"];
const AddSpecialEffect = jass["AddSpecialEffect"];
const DestroyEffect = jass["DestroyEffect"];
const GetRandomReal = jass["GetRandomReal"];
const GetUnitX = jass["GetUnitX"];
const GetUnitY = jass["GetUnitY"];
const GetUnitFlyHeight = jass["GetUnitFlyHeight"];
const SetUnitFlyHeight = jass["SetUnitFlyHeight"];
const SetUnitFacing = jass["SetUnitFacing"];
const SetUnitX = jass["SetUnitX"];
const SetUnitY = jass["SetUnitY"];
const Cos = jass["Cos"];
const Sin = jass["Sin"];
const IsUnitPaused = jass["IsUnitPaused"];
const ForGroup = jass["ForGroup"];
const GetEnumUnit = jass["GetEnumUnit"];
export { jass, jglobals, X_GAFC, X_IsTerrainWalkable, X_IsUnitTerrainWalkable, X_GetAbleX, X_GetAbleY };
export { 申请单位暂停占用, 释放单位暂停占用, 单位是否存在其他暂停占用 };
export { 零秒后重置单位动画 };
export { GetHandleId, GetUnitState, GetRectMinX, GetRectMinY, GetRectMaxX, GetRectMaxY, UnitAddAbility, UnitRemoveAbility, AddSpecialEffect, DestroyEffect, GetRandomReal, GetUnitX, GetUnitY, GetUnitFlyHeight, SetUnitFlyHeight, SetUnitFacing, SetUnitX, SetUnitY, Cos, Sin, IsUnitPaused, ForGroup, GetEnumUnit, };
export const BJ_DEGTORAD = jglobals.bj_DEGTORAD ?? 0.017453292519943295;
export const TICK_INTERVAL = 0.02;
export const CENTER_TIMER_TICKS = 2;
export const MAX_SUB_STEP = 31.0;
export const WALKABLE_TOLERANCE = 8.0;
export const UNIT_ALIVE_LIFE = 0.405;
export const DEFAULT_JUMP_EFFECT_MODEL = "";
export const CROW_FORM_ABILITY_ID = 1097691750;
export const 活动跳跃列表 = [];
export const 跳跃映射 = {};
export const 单位当前跳跃 = {};
let 单位组快照缓存 = [];
let 下一个跳跃ID = 0;
export function 分配新跳跃ID() {
    下一个跳跃ID += 1;
    return 下一个跳跃ID;
}
export function 取句柄ID(h) {
    return (h != null && h !== 0 ? GetHandleId(h) : 0) || 0;
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
    return u != null && u !== 0 && GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
}
export function 在可玩区域内(x, y) {
    return x >= GetRectMinX(jglobals.bj_mapInitialPlayableArea)
        && y >= GetRectMinY(jglobals.bj_mapInitialPlayableArea)
        && x <= GetRectMaxX(jglobals.bj_mapInitialPlayableArea)
        && y <= GetRectMaxY(jglobals.bj_mapInitialPlayableArea);
}
export function 计算坐标距离(x1, y1, x2, y2) {
    const dx = x2 - x1;
    const dy = y2 - y1;
    return jass.SquareRoot(dx * dx + dy * dy);
}
export function 计算每tick位移(距离, 持续时间) {
    if (持续时间 <= 0)
        return 距离;
    return 距离 / (持续时间 / TICK_INTERVAL);
}
export function 确保单位可设置飞行高度(单位) {
    UnitAddAbility(单位, CROW_FORM_ABILITY_ID);
    UnitRemoveAbility(单位, CROW_FORM_ABILITY_ID);
}
export function 限制进度(v) {
    if (v <= 0)
        return 0;
    if (v >= 1)
        return 1;
    return v;
}
export function 计算抛物线高度(进度, 最大高度) {
    const t = 限制进度(进度);
    return 4.0 * 最大高度 * t * (1.0 - t);
}
export function 播放跳跃特效(实例) {
    const 模型 = 实例.跳跃特效;
    if (模型 == null || 模型 === "")
        return;
    const 特效 = AddSpecialEffect(模型, GetUnitX(实例.单位), GetUnitY(实例.单位));
    if (特效 != null && 特效 !== 0) {
        DestroyEffect(特效);
    }
}
export function 单位已被暂停(单位) {
    if (单位 == null || 单位 === 0)
        return false;
    return IsUnitPaused(单位) === true;
}
