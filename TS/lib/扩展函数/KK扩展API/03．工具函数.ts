/**
 * KK扩展API - 工具函数
 */

const japi = require("jass.japi") as any;

/**
 * 计算ARGB颜色值
 * @param a 透明度 (0-255)
 * @param r 红色 (0-255)
 * @param g 绿色 (0-255)
 * @param b 蓝色 (0-255)
 * @returns ARGB颜色整数
 */
export function DzGetColor2(a: number, r: number, g: number, b: number): number {
  return 0x1000000 * a + 0x10000 * r + 0x100 * g + b;
}

/**
 * 打开QQ群链接
 * @param url QQ群链接
 * @returns 是否成功打开
 */
export function DzOpenQQGroupUrl(url: string): boolean {
  return (japi.DzOpenQQGroupUrl(url) as boolean) || false;
}

export {};
