/** @noSelfInFile */
/**
 * 装备采集 - 配置表
 *
 * 扩展方式：在 采集配置列表 中追加新条目即可。
 * 每项可指定：
 *   - 装备名 / 物品ID：用于匹配物品
 *   - 刷新区域Rect名：地图编辑器中的 rect 变量名
 *   - 刷新延迟秒
 */

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};

function 取物品ID(this: void, 装备名: string): number {
  return stringToFourCCSafe(按名字反查物品ID(装备名));
}

export interface 采集配置项 {
  装备名: string;
  物品ID: number;
  /** 地图编辑器中的 rect 变量名，如 "gg_rct______________039" */
  刷新区域Rect名: string;
  刷新延迟秒: number;
}

export const 采集配置列表: 采集配置项[] = [
  {
    装备名: "荧光草",
    物品ID: 取物品ID("荧光草"),
    刷新区域Rect名: "gg_rct______________039",
    刷新延迟秒: 15,
  },
];

export {};
