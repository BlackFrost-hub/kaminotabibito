/** @noSelfInFile */

import { 创建机制清理篮子, 机制清理篮子 } from "../../../00．技能模板+函数/04．机制组件/06．机制清理";
import { 创建召唤物组状态, 召唤物组状态 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/03．召唤物组状态管理";
import { 设置单位技能壳普通提示 } from "../../../00．技能模板+函数/02．通用函数/15．单位技能壳提示";
import { 树魔首领单位技能配置 } from "./00．配置";

const jass = require("jass.common") as any;
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;

export type 树魔首领阶段 = 1 | 2 | 3;

export interface 树魔首领运行时上下文 {
  Boss单位: any;
  阶段: 树魔首领阶段;
  开战时间Ms: number;
  清理: 机制清理篮子;
  随从组: 召唤物组状态;
  随从特性已初始化: boolean;
  当前随从数量: number;
  当前兽群层数: number;
  无从暴怒中: boolean;
  暴怒攻速增量: number;
  暴怒移速增量: number;
  下一次召唤Ms: number;
  已初始化: boolean;
}

const 树魔首领上下文表: Record<number, 树魔首领运行时上下文 | undefined> = {};

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

export function 获取树魔首领上下文(this: void, boss: any): 树魔首领运行时上下文 | undefined {
  const id = 取单位ID(boss);
  return id === 0 ? undefined : 树魔首领上下文表[id];
}

export function 获取或创建树魔首领上下文(this: void, boss: any): 树魔首领运行时上下文 | undefined {
  const id = 取单位ID(boss);
  if (id === 0) return undefined;
  let context = 树魔首领上下文表[id];
  if (context != null) return context;
  const 清理 = 创建机制清理篮子("树魔首领");
  context = {
    Boss单位: boss,
    阶段: 1,
    开战时间Ms: getServerTime(),
    清理,
    随从组: 创建召唤物组状态({
      清理,
      名称: "树魔首领随从组",
      全灭延迟秒: 0,
      全灭后保留死亡记录: false,
    }),
    随从特性已初始化: false,
    当前随从数量: 0,
    当前兽群层数: 0,
    无从暴怒中: false,
    暴怒攻速增量: 0,
    暴怒移速增量: 0,
    下一次召唤Ms: 0,
    已初始化: false,
  };
  设置单位技能壳普通提示(boss, 树魔首领单位技能配置.主动技能提示);
  树魔首领上下文表[id] = context;
  return context;
}

export function 清理树魔首领上下文(this: void, boss: any): void {
  const id = 取单位ID(boss);
  if (id === 0) return;
  const context = 树魔首领上下文表[id];
  if (context == null) return;
  context.清理.清理全部();
  delete 树魔首领上下文表[id];
}

export function 获取全部树魔首领上下文(this: void): 树魔首领运行时上下文[] {
  const list: 树魔首领运行时上下文[] = [];
  for (const key in 树魔首领上下文表) {
    const context = 树魔首领上下文表[key];
    if (context != null) list.push(context);
  }
  return list;
}

export function 注册树魔首领运行时(this: void): void {
  // 结构占位：后续接入 Boss 战启动、阶段推进和死亡清理。
}
