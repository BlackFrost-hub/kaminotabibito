/** @noSelfInFile */

import type { 章节额外掉落装备 } from "./00．类型定义";
import { 获取章节普通小怪额外装备池 } from "./01．章节装备池";
import { 获取普通小怪额外掉落资格 } from "./02．小怪强度资格表";

const jass = require("jass.common") as any;
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.创建物品函数") as {
  创建物品并注册排泄监听: (this: void, itemId: number, x: number, y: number) => any;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};

const 总掉落判定分母 = 10000;
const 总掉落命中值 = 100;
let 已初始化普通小怪额外掉落 = false;

function on普通小怪死亡尝试额外掉落(this: void, 死亡单位: any, _击杀者: any): void {
  if (死亡单位 == null || 死亡单位 === 0) return;

  const 资格 = 获取普通小怪额外掉落资格(jass.GetUnitTypeId(死亡单位) as number);
  if (资格 == null) return;
  if ((jass.GetRandomInt(1, 总掉落判定分母) as number) > 总掉落命中值) return;

  const 章节装备池 = 获取章节普通小怪额外装备池(资格.章节);
  const 可掉落装备: 章节额外掉落装备[] = [];
  for (let i = 0; i < 章节装备池.length; i++) {
    const 装备 = 章节装备池[i];
    if (装备.评分 <= 资格.最高可掉评分) 可掉落装备.push(装备);
  }
  if (可掉落装备.length === 0) return;

  const 随机下标 = (jass.GetRandomInt(1, 可掉落装备.length) as number) - 1;
  const 掉落物品类型ID = stringToFourCCSafe(可掉落装备[随机下标].物品ID);
  if (掉落物品类型ID === 0) return;

  创建物品并注册排泄监听(
    掉落物品类型ID,
    jass.GetUnitX(死亡单位) as number,
    jass.GetUnitY(死亡单位) as number,
  );
}

export function 初始化普通小怪额外掉落(this: void): void {
  if (已初始化普通小怪额外掉落) return;
  已初始化普通小怪额外掉落 = true;
  registerDeathListener(on普通小怪死亡尝试额外掉落);
}

初始化普通小怪额外掉落();

