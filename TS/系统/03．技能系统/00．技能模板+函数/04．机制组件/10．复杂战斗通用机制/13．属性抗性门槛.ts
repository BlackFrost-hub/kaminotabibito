/** @noSelfInFile */

const { getRealAttr, getRealAttrWithLimit, isPlayerUnit } = require("系统.04．伤害系统.00．伤害计算.01．属性读取") as {
  getRealAttr: (this: void, unit: any, attrName: string, defaultValue: number) => number;
  getRealAttrWithLimit: (this: void, unit: any, attrName: string, isPlayer: boolean) => number;
  isPlayerUnit: (this: void, unit: any) => boolean;
};

export type 属性抗性类型 = "金" | "木" | "水" | "火" | "雷" | "光" | "暗" | "物理" | "魔法" | "技能" | "普攻";

const 抗性属性名表: Record<string, string> = {
  金: "金属性抗性",
  木: "木属性抗性",
  水: "水属性抗性",
  火: "火属性抗性",
  雷: "雷属性抗性",
  光: "光属性抗性",
  暗: "暗属性抗性",
  物理: "物理抗性",
  魔法: "魔抗",
  技能: "技能抗性",
  普攻: "普攻抗性",
};

export function 取单位属性抗性(this: void, 单位: any, 类型: 属性抗性类型, 应用上限: boolean = true): number {
  const attr = 抗性属性名表[类型] ?? "";
  if (attr === "") return 0;
  if (应用上限) return getRealAttrWithLimit(单位, attr, isPlayerUnit(单位));
  return getRealAttr(单位, attr, 0);
}

export function 满足属性抗性门槛(this: void, 单位: any, 类型: 属性抗性类型, 门槛: number, 应用上限: boolean = true): boolean {
  return 取单位属性抗性(单位, 类型, 应用上限) >= 门槛;
}

export function 按抗性门槛选择数值(this: void, 单位: any, 类型: 属性抗性类型, 门槛: number, 达标值: number, 未达标值: number): number {
  return 满足属性抗性门槛(单位, 类型, 门槛) ? 达标值 : 未达标值;
}

