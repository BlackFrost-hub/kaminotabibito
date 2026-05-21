/**
 * KK扩展API - 工具函数
 */
const japi = require("jass.japi");
/**
 * 计算ARGB颜色值
 * @param a 透明度 (0-255)
 * @param r 红色 (0-255)
 * @param g 绿色 (0-255)
 * @param b 蓝色 (0-255)
 * @returns ARGB颜色整数
 */
export function DzGetColor2(a, r, g, b) {
    return 0x1000000 * a + 0x10000 * r + 0x100 * g + b;
}
/**
 * 打开QQ群链接
 * @param url QQ群链接
 * @returns 是否成功打开
 */
export function DzOpenQQGroupUrl(url) {
    return japi.DzOpenQQGroupUrl(url) || false;
}
/**
 * 异步执行全局函数
 * @param funcName 全局函数名
 */
export function DzExecuteFunc(funcName) {
    japi.DzExecuteFunc(funcName);
}
