/** @noSelfInFile */

const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { applyEquipStatsTS } = require("lib.扩展函数.Star扩展函数.01．装备属性应用") as {
  applyEquipStatsTS: (this: void, unit: any, stats: { name: string; value: number }[]) => Record<string, number>;
};
const { 单位升级属性加成配置表 } = require("系统.02．物品系统.15．装备技能.09．物品升级.02．物品升级配置表") as {
  单位升级属性加成配置表: readonly import("./00．类型定义").升级属性加成配置[];
};

function 读取升级加成数值(this: void, 单位: any, 配置: import("./00．类型定义").升级属性加成配置): number {
  const 值 = Number(YDUserDataGetSafe("unit", 单位, 配置.属性名, 配置.数值类型)) || 0;
  return 值;
}

export function 处理单位升级属性加成(this: void, 单位: any): void {
  if (单位 == null || 单位 === 0) return;

  const 待应用属性: Array<{ name: string; value: number }> = [];
  for (let i = 0; i < 单位升级属性加成配置表.length; i++) {
    const 配置 = 单位升级属性加成配置表[i];
    const 数值 = 读取升级加成数值(单位, 配置);
    if (数值 === 0) continue;
    待应用属性.push({ name: 配置.应用属性名, value: 数值 });
  }

  if (待应用属性.length === 0) return;
  applyEquipStatsTS(单位, 待应用属性);
}

export {};
