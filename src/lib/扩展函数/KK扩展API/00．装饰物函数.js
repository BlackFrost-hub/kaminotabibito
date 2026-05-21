/**
 * KK扩展API - 装饰物相关函数
 *
 * 注意：这些函数只有KK平台才有，其他平台（如YDWE、WE）不支持
 */
const japi = require("jass.japi");
/**
 * 创建装饰物
 */
export function DzDoodadCreate(id, varId, x, y, z, rotate, scale) {
    return japi.DzDoodadCreate(id, varId, x, y, z, rotate, scale) || 0;
}
/**
 * 获取装饰物类型ID
 */
export function DzDoodadGetTypeId(doodad) {
    return japi.DzDoodadGetTypeId(doodad) || 0;
}
/**
 * 设置装饰物模型
 */
export function DzDoodadSetModel(doodad, modelFile) {
    japi.DzDoodadSetModel(doodad, modelFile);
}
/**
 * 设置装饰物队伍颜色
 */
export function DzDoodadSetTeamColor(doodad, color) {
    japi.DzDoodadSetTeamColor(doodad, color);
}
/**
 * 设置装饰物颜色
 */
export function DzDoodadSetColor(doodad, color) {
    japi.DzDoodadSetColor(doodad, color);
}
/**
 * 获取装饰物X坐标
 */
export function DzDoodadGetX(doodad) {
    return japi.DzDoodadGetX(doodad) || 0;
}
/**
 * 获取装饰物Y坐标
 */
export function DzDoodadGetY(doodad) {
    return japi.DzDoodadGetY(doodad) || 0;
}
/**
 * 获取装饰物Z坐标
 */
export function DzDoodadGetZ(doodad) {
    return japi.DzDoodadGetZ(doodad) || 0;
}
/**
 * 设置装饰物位置
 */
export function DzDoodadSetPosition(doodad, x, y, z) {
    japi.DzDoodadSetPosition(doodad, x, y, z);
}
/**
 * 设置装饰物方向矩阵旋转
 */
export function DzDoodadSetOrientMatrixRotate(doodad, angle, axisX, axisY, axisZ) {
    japi.DzDoodadSetOrientMatrixRotate(doodad, angle, axisX, axisY, axisZ);
}
/**
 * 设置装饰物方向矩阵缩放
 */
export function DzDoodadSetOrientMatrixScale(doodad, x, y, z) {
    japi.DzDoodadSetOrientMatrixScale(doodad, x, y, z);
}
/**
 * 设置装饰物方向矩阵重置大小
 */
export function DzDoodadSetOrientMatrixResize(doodad) {
    japi.DzDoodadSetOrientMatrixResize(doodad);
}
/**
 * 设置装饰物可见性
 */
export function DzDoodadSetVisible(doodad, enable) {
    japi.DzDoodadSetVisible(doodad, enable);
}
/**
 * 设置装饰物动画
 */
export function DzDoodadSetAnimation(doodad, animName, animRandom) {
    japi.DzDoodadSetAnimation(doodad, animName, animRandom);
}
/**
 * 设置装饰物时间缩放
 */
export function DzDoodadSetTimeScale(doodad, scale) {
    japi.DzDoodadSetTimeScale(doodad, scale);
}
/**
 * 获取装饰物时间缩放
 */
export function DzDoodadGetTimeScale(doodad) {
    return japi.DzDoodadGetTimeScale(doodad) || 0;
}
/**
 * 获取装饰物当前动画索引
 */
export function DzDoodadGetCurrentAnimationIndex(doodad) {
    return japi.DzDoodadGetCurrentAnimationIndex(doodad) || 0;
}
/**
 * 获取装饰物动画数量
 */
export function DzDoodadGetAnimationCount(doodad) {
    return japi.DzDoodadGetAnimationCount(doodad) || 0;
}
/**
 * 获取装饰物动画名称
 */
export function DzDoodadGetAnimationName(doodad, index) {
    return japi.DzDoodadGetAnimationName(doodad, index) || "";
}
/**
 * 获取装饰物动画时间
 */
export function DzDoodadGetAnimationTime(doodad, index) {
    return japi.DzDoodadGetAnimationTime(doodad, index) || 0;
}
