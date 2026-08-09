/** @noSelfInFile */

const jass = require("jass.common") as any;
const UnitAddItemById = jass.UnitAddItemById as (this: void, unit: any, itemId: number) => any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, rawId: string | undefined | null) => number;
};

export function 发放任务物品(this: void, unit: any, itemConfig: string | undefined): number {
  if (unit == null || unit === 0 || !itemConfig || itemConfig === "") return 0;
  let 发放数量 = 0;
  const 配置列表 = itemConfig.split("|");
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i].trim();
    if (配置 === "") continue;
    const 数量分隔位置 = 配置.indexOf("*");
    const 物品代码 = (数量分隔位置 >= 0 ? 配置.substring(0, 数量分隔位置) : 配置).trim();
    let 数量 = 数量分隔位置 >= 0 ? parseInt(配置.substring(数量分隔位置 + 1), 10) || 0 : 1;
    if (数量 < 1) 数量 = 1;
    const 物品类型ID = stringToFourCCSafe(物品代码);
    if (物品类型ID === 0) continue;
    for (let j = 0; j < 数量; j++) {
      const 物品 = UnitAddItemById(unit, 物品类型ID);
      if (物品 != null && 物品 !== 0) 发放数量 += 1;
    }
  }
  return 发放数量;
}

export {};
