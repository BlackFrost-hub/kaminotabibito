/** @noSelfInFile */
/**
 * TS 原生弹幕 - 移动处理
 */
import { CosBJ, GetUnitFacing, GetUnitState, GetUnitX, GetUnitY, IsTerrainPathable, IsUnitPaused, PATHING_TYPE_WALKABILITY, SetUnitFlyHeight, SetUnitX, SetUnitY, SinBJ, UNIT_STATE_LIFE, 标准化角度, 角度差, 计算距离, 取坐标朝向角, 限制范围, GetRandomReal, } from "../01．共享";
const { 立即设置单位朝向 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待");
const UNIT_ALIVE_LIFE = 0.405;
export function 弹幕单位存活(单位) {
    return 单位 != null && 单位 !== 0 && GetUnitState(单位, UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
}
function 更新弹幕单位坐标(实例, x, y, face) {
    SetUnitX(实例.弹幕单位, x);
    SetUnitY(实例.弹幕单位, y);
    立即设置单位朝向(实例.弹幕单位, 标准化角度(face));
    实例.当前X = x;
    实例.当前Y = y;
    实例.当前方向角 = 标准化角度(face);
}
function 更新追踪方向(实例, delta) {
    const 目标 = 实例.参数.指定目标;
    if (目标 == null || 目标 === 0 || !弹幕单位存活(目标))
        return;
    const 目标角 = 取坐标朝向角(实例.当前X, 实例.当前Y, GetUnitX(目标), GetUnitY(目标));
    const 转向速度 = 实例.参数.追踪转向速度 ?? 0;
    if (转向速度 <= 0) {
        实例.当前方向角 = 标准化角度(目标角);
        return;
    }
    const 最大转向 = 转向速度 * delta;
    const diff = 角度差(实例.当前方向角, 目标角);
    实例.当前方向角 = 标准化角度(实例.当前方向角 + 限制范围(diff, -最大转向, 最大转向));
}
function 尝试弹射(实例) {
    if (实例.参数.弹射 !== true)
        return false;
    const 上限 = 实例.参数.弹射次数上限 ?? 0;
    if (上限 > 0 && 实例.弹射次数 >= 上限)
        return false;
    实例.弹射次数 += 1;
    if (实例.参数.随机弹射 === true) {
        实例.当前方向角 = 标准化角度(实例.当前方向角 + GetRandomReal(120, 240));
    }
    else {
        实例.当前方向角 = 标准化角度(实例.当前方向角 + (实例.参数.弹射角度 ?? 180));
    }
    立即设置单位朝向(实例.弹幕单位, 实例.当前方向角);
    const 衰减 = 实例.参数.弹射衰减 ?? 0;
    if (衰减 > 0) {
        const 系数 = 限制范围(1 - 衰减, 0, 1);
        实例.当前速度 = 实例.当前速度 * 系数;
        实例.当前伤害值 = 实例.当前伤害值 * 系数;
    }
    return true;
}
export function 推进弹幕移动(实例, delta) {
    if (IsUnitPaused(实例.弹幕单位))
        return false;
    const 延迟 = 实例.参数.延迟发射 ?? 0;
    if (延迟 > 0 && 实例.已运行时间 < 延迟)
        return false;
    const 采样器 = 实例.参数.轨迹采样器;
    if (采样器 != null) {
        const oldX = 实例.当前X;
        const oldY = 实例.当前Y;
        const 结果 = 采样器(实例, delta);
        实例.已飞行距离 += 计算距离(oldX, oldY, 结果.X, 结果.Y);
        更新弹幕单位坐标(实例, 结果.X, 结果.Y, 结果.方向角 ?? 实例.当前方向角);
        if (结果.Z != null) {
            SetUnitFlyHeight(实例.弹幕单位, 结果.Z, 0);
        }
        return 结果.完成 === true;
    }
    if (实例.参数.轨迹类型 === "追踪") {
        更新追踪方向(实例, delta);
    }
    else {
        if (实例.参数.显式改向后锁定方向 !== true) {
            实例.当前方向角 = 标准化角度(GetUnitFacing(实例.弹幕单位));
        }
    }
    const 距离 = 实例.当前速度 * delta;
    const nextX = 实例.当前X + CosBJ(实例.当前方向角) * 距离;
    const nextY = 实例.当前Y + SinBJ(实例.当前方向角) * 距离;
    if (IsTerrainPathable(nextX, nextY, PATHING_TYPE_WALKABILITY)) {
        return !尝试弹射(实例);
    }
    实例.已飞行距离 += 距离;
    更新弹幕单位坐标(实例, nextX, nextY, 实例.当前方向角);
    return false;
}
