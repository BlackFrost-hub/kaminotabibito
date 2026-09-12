/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 创建物品并注册排泄监听, 给予单位物品 } = require("lib.扩展函数.物品相关函数.创建物品函数") as {
  创建物品并注册排泄监听: (this: void, itemId: number, x: number, y: number) => any;
  给予单位物品: (this: void, unit: any, item: any) => boolean;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, rawId: string | undefined | null) => number;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;

export function 发放任务物品(this: void, unit: any, itemConfig: string | undefined): number {
  if (unit == null || unit === 0 || !itemConfig || itemConfig === "") return 0;
  let 发放数量 = 0;
  let 有掉落 = false;
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
      const item = 创建物品并注册排泄监听(物品类型ID, GetUnitX(unit), GetUnitY(unit));
      if (item == null || item === 0) continue;
      if (给予单位物品(unit, item)) {
        发放数量 += 1;
      } else {
        // 物品栏已满：物品保留在英雄脚下，不销毁、不判失败。
        发放数量 += 1;
        有掉落 = true;
      }
    }
  }
  if (有掉落) {
    广播单位提示(unit, "物品栏已满，部分奖励物品掉落在脚下，请注意拾取。", 4000);
  }
  return 发放数量;
}

export {};
