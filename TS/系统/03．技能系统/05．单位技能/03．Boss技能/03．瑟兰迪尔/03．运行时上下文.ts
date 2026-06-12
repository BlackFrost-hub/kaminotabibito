/** @noSelfInFile */

import { 瑟兰迪尔单位技能配置 } from "./00．配置";

const jass = require("jass.common") as any;
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;

export type 瑟兰迪尔阶段 = 1 | 2 | 3;
export type 瑟兰迪尔台词类型 = keyof typeof 瑟兰迪尔单位技能配置.台词;

export interface 瑟兰迪尔运行时上下文 {
  Boss单位: any;
  阶段: 瑟兰迪尔阶段;
  开战时间Ms: number;
  上次执法印记Ms: number;
  上次审判之环Ms: number;
  上次终末审判Ms: number;
  已触发月光灌注: boolean;
}

const 瑟兰迪尔上下文表: Record<number, 瑟兰迪尔运行时上下文 | undefined> = {};

function 取单位ID(unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

export function 获取瑟兰迪尔上下文(this: void, boss: any): 瑟兰迪尔运行时上下文 | undefined {
  const id = 取单位ID(boss);
  if (id === 0) return undefined;
  return 瑟兰迪尔上下文表[id];
}

export function 获取或创建瑟兰迪尔上下文(this: void, boss: any): 瑟兰迪尔运行时上下文 | undefined {
  const id = 取单位ID(boss);
  if (id === 0) return undefined;
  let context = 瑟兰迪尔上下文表[id];
  if (context != null) return context;
  context = {
    Boss单位: boss,
    阶段: 1,
    开战时间Ms: getServerTime(),
    上次执法印记Ms: 0,
    上次审判之环Ms: 0,
    上次终末审判Ms: 0,
    已触发月光灌注: false,
  };
  瑟兰迪尔上下文表[id] = context;
  return context;
}

export function 清理瑟兰迪尔上下文(this: void, boss: any): void {
  const id = 取单位ID(boss);
  if (id === 0) return;
  delete 瑟兰迪尔上下文表[id];
}

export function 播放瑟兰迪尔台词(this: void, boss: any, 类型: 瑟兰迪尔台词类型, index = 0): void {
  const lines = 瑟兰迪尔单位技能配置.台词[类型];
  const text = (lines[index] ?? lines[0]) as string | undefined;
  if (text == null) return;
  广播单位提示(boss, text, 瑟兰迪尔单位技能配置.广播持续时间Ms);
}

export function 注册瑟兰迪尔运行时(this: void): void {
  // 后续接入 Boss 战启动桥接时，只在这里挂阶段 tick / 死亡清理 / 开战台词。
}
