/** @noSelfInFile */
/**
 * TS 原生弹幕 - 轨迹工具
 */
import { 计算距离, 取坐标朝向角, 限制范围 } from "../01．共享";
export function 线性插值(from, to, progress) {
    return from + (to - from) * progress;
}
export function 取弹幕轨迹进度(实例) {
    const 参数 = 实例.参数;
    if (参数.生命周期 != null && 参数.生命周期 > 0) {
        return 限制范围(实例.已运行时间 / 参数.生命周期, 0, 1);
    }
    if (参数.最大距离 != null && 参数.最大距离 > 0) {
        return 限制范围(实例.已飞行距离 / 参数.最大距离, 0, 1);
    }
    return 0;
}
export function 取采样方向(oldX, oldY, newX, newY, fallback) {
    if (计算距离(oldX, oldY, newX, newY) <= 0.01)
        return fallback;
    return 取坐标朝向角(oldX, oldY, newX, newY);
}
