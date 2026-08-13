/** @noSelfInFile */
/**
 * 装备采集 - 配置表
 *
 * 扩展方式：在 采集配置列表 中追加新条目即可。
 * 每项可指定：
 *   - 装备名 / 物品ID：用于匹配物品
 *   - 采摘刷新延迟秒：物品被采摘后，重新生成一份物品的等待时间
 *   - 随机换点间隔秒：地面上的同一份采集物品多久随机移动一次
 */

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
export interface 采集配置项 {
  装备名: string;
  物品ID: number;
  采摘刷新延迟秒: number;
  随机换点间隔秒: number;
}

export const 采集配置列表: 采集配置项[] = [
  {
    装备名: "荧光草",
    物品ID: stringToFourCCSafe("shwd"),
    采摘刷新延迟秒: 60,
    随机换点间隔秒: 120,
  },
  {
    装备名: "星露花",
    物品ID: stringToFourCCSafe("I0H4"),
    采摘刷新延迟秒: 60,
    随机换点间隔秒: 120,
  },
  {
    装备名: "晨曦花",
    物品ID: stringToFourCCSafe("I0H5"),
    采摘刷新延迟秒: 60,
    随机换点间隔秒: 120,
  },
  {
    装备名: "月影花",
    物品ID: stringToFourCCSafe("I0H6"),
    采摘刷新延迟秒: 60,
    随机换点间隔秒: 120,
  },
];

export {};
