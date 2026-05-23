/** @noSelfInFile */

const jass = require("jass.common") as any;
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

export type Boss自动技能来源 = "STES.Boss" | "Boss战.单位" | "Boss战.绑定单位";

export interface Boss自动技能启动上下文 {
  Boss单位: any;
  来源: Boss自动技能来源;
  注册时间: number;
}

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const Boss自动技能上下文表: Record<number, Boss自动技能启动上下文 | undefined> = {};

export function 记录Boss自动技能启动(this: void, unit: any, source: Boss自动技能来源): Boss自动技能启动上下文 | undefined {
  if (unit == null || unit === 0) return undefined;
  const handleId = GetHandleId(unit);
  const context: Boss自动技能启动上下文 = {
    Boss单位: unit,
    来源: source,
    注册时间: getServerTime(),
  };
  Boss自动技能上下文表[handleId] = context;
  return context;
}

export function 读取Boss自动技能启动上下文(this: void, unit: any): Boss自动技能启动上下文 | undefined {
  if (unit == null || unit === 0) return undefined;
  return Boss自动技能上下文表[GetHandleId(unit)];
}

export function 是否已登记Boss自动技能(this: void, unit: any): boolean {
  return 读取Boss自动技能启动上下文(unit) != null;
}

export function 获取所有Boss自动技能启动上下文(this: void): Boss自动技能启动上下文[] {
  const result: Boss自动技能启动上下文[] = [];
  const ids = Object.keys(Boss自动技能上下文表);
  for (let i = 0; i < ids.length; i++) {
    const context = Boss自动技能上下文表[Number(ids[i]) || 0];
    if (context != null) {
      result.push(context);
    }
  }
  result.sort((a, b) => a.注册时间 - b.注册时间);
  return result;
}

export function 清理Boss自动技能启动上下文(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  Boss自动技能上下文表[GetHandleId(unit)] = undefined;
}
