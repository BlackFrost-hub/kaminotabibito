/** @noSelfInFile */
/**
 * TS 原生弹幕 - 显式改向 / 反弹
 *
 * 说明：
 * - 这个模块不依赖底层自动检测“外部是否改向”。
 * - 调用后会把弹幕切为直线飞行，并立即按指定角度继续移动。
 * - 适合反弹技能、拨转弹道、指定角度续飞。
 */
import { EXSetUnitFacing, GetUnitFacing, GetUnitX, GetUnitY, SetUnitFacing, 标准化角度, } from "../01．共享";
import { 获取原生弹幕实例, 单位到原生弹幕ID } from "../02．注册表";
import { 取句柄ID } from "../01．共享";
function 解析改向速度(实例, 新速度) {
    if (新速度 != null && 新速度 > 0)
        return 新速度;
    if (实例.当前速度 > 0)
        return 实例.当前速度;
    if (实例.参数.速度 > 0)
        return 实例.参数.速度;
    return 400;
}
function 应用原生弹幕改向(实例, 参数) {
    if (实例.已结束)
        return false;
    const 朝向角度 = 标准化角度(参数.朝向角度);
    实例.参数.轨迹采样器 = undefined;
    实例.参数.轨迹类型 = "直线";
    实例.参数.指定目标 = undefined;
    实例.参数.显式改向后锁定方向 = true;
    实例.当前X = GetUnitX(实例.弹幕单位);
    实例.当前Y = GetUnitY(实例.弹幕单位);
    实例.当前方向角 = 朝向角度;
    实例.当前速度 = 解析改向速度(实例, 参数.新速度);
    SetUnitFacing(实例.弹幕单位, 朝向角度);
    if (EXSetUnitFacing != null) {
        EXSetUnitFacing(实例.弹幕单位, 朝向角度 * 0.017453292519943295);
    }
    return true;
}
export function 设置原生弹幕指定角度飞行(弹幕ID, 朝向角度, 新速度) {
    const 实例 = 获取原生弹幕实例(弹幕ID);
    if (实例 == null)
        return false;
    return 应用原生弹幕改向(实例, { 朝向角度, 新速度 });
}
export function 按单位设置原生弹幕指定角度飞行(弹幕单位, 朝向角度, 新速度) {
    const 弹幕ID = 单位到原生弹幕ID[取句柄ID(弹幕单位)] ?? 0;
    if (弹幕ID <= 0)
        return false;
    return 设置原生弹幕指定角度飞行(弹幕ID, 朝向角度, 新速度);
}
export function 按反弹单位面向反弹原生弹幕(弹幕ID, 反弹单位, 新速度, 附加角度 = 0) {
    if (反弹单位 == null || 反弹单位 === 0)
        return false;
    return 设置原生弹幕指定角度飞行(弹幕ID, GetUnitFacing(反弹单位) + 附加角度, 新速度);
}
export function 按单位反弹原生弹幕(弹幕单位, 反弹单位, 新速度, 附加角度 = 0) {
    if (反弹单位 == null || 反弹单位 === 0)
        return false;
    return 按单位设置原生弹幕指定角度飞行(弹幕单位, GetUnitFacing(反弹单位) + 附加角度, 新速度);
}
