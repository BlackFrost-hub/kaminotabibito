/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 取装备冷却键, 装备冷却中, 进入装备冷却并显示 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.08．装备识别与冷却") as {
  取装备冷却键: (this: void, unit: any, tag: string, 前缀?: string) => string;
  装备冷却中: (this: void, key: string) => boolean;
  进入装备冷却并显示: (this: void, key: string, 秒数: number, unit: any, 装备名: string) => void;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;

const 执行中记录: Record<string, boolean> = {};

function 获取句柄ID(this: void, 单位: any): number {
  if (单位 == null || 单位 === 0) return 0;
  return GetHandleId(单位) || 0;
}

function 生成状态键(this: void, 名称: string, 单位: any): string {
  const id = 获取句柄ID(单位);
  if (id <= 0) return "";
  return `${名称}:${id}`;
}

export function 攻击效果是否在冷却中(this: void, 名称: string, 单位: any, 冷却毫秒: number): boolean {
  if (!名称 || 冷却毫秒 <= 0) return false;
  const 键 = 取装备冷却键(单位, 名称, "攻击效果");
  if (键 === "") return false;
  return 装备冷却中(键);
}

export function 攻击效果进入冷却(this: void, 名称: string, 单位: any, 冷却毫秒: number = 0): void {
  if (!(冷却毫秒 > 0)) return;
  const 键 = 取装备冷却键(单位, 名称, "攻击效果");
  if (键 === "") return;
  进入装备冷却并显示(键, 冷却毫秒 / 1000, 单位, 名称);
}

export function 攻击效果清除冷却(this: void, 名称: string, 单位: any): void {
  // 公共装备冷却表不暴露按 key 清除；保留此接口兼容旧调用。
}

export function 攻击效果是否正在执行(this: void, 名称: string, 单位: any): boolean {
  const 键 = 生成状态键(名称, 单位);
  if (键 === "") return false;
  return 执行中记录[键] === true;
}

export function 攻击效果开始执行(this: void, 名称: string, 单位: any): boolean {
  const 键 = 生成状态键(名称, 单位);
  if (键 === "") return false;
  if (执行中记录[键] === true) return false;
  执行中记录[键] = true;
  return true;
}

export function 攻击效果结束执行(this: void, 名称: string, 单位: any): void {
  const 键 = 生成状态键(名称, 单位);
  if (键 === "") return;
  delete 执行中记录[键];
}

export {};
