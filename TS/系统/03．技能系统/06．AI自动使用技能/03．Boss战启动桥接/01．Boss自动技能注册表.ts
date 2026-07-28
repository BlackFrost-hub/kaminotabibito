/** @noSelfInFile */

const jass = require("jass.common") as any;
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

export type Boss自动技能来源 = "STES.Boss" | "Boss战.单位" | "Boss战.绑定单位" | "Boss测试";

export interface Boss自动技能启动上下文 {
  Boss单位: any;
  来源: Boss自动技能来源;
  注册时间: number;
}

export interface Boss自动技能启动监听参数 {
  名称: string;
  单位类型ID?: number;
  回放已有?: boolean;
  on启动: (this: void, context: Boss自动技能启动上下文) => void;
}

interface Boss自动技能启动监听记录 extends Boss自动技能启动监听参数 {
  ID: number;
}

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const Boss自动技能上下文表: Record<number, Boss自动技能启动上下文 | undefined> = {};
const Boss自动技能启动监听表: Record<number, Boss自动技能启动监听记录 | undefined> = {};
let 下一个Boss自动技能启动监听ID = 0;

function 启动监听匹配(this: void, 监听: Boss自动技能启动监听记录, context: Boss自动技能启动上下文): boolean {
  if (监听.单位类型ID == null) return true;
  return GetUnitTypeId(context.Boss单位) === 监听.单位类型ID;
}

function 通知Boss自动技能启动(this: void, context: Boss自动技能启动上下文): void {
  for (const key in Boss自动技能启动监听表) {
    const 监听 = Boss自动技能启动监听表[key];
    if (监听 != null && 启动监听匹配(监听, context)) 监听.on启动(context);
  }
}

export function 记录Boss自动技能启动(this: void, unit: any, source: Boss自动技能来源): Boss自动技能启动上下文 | undefined {
  if (unit == null || unit === 0) return undefined;
  const handleId = GetHandleId(unit);
  const context: Boss自动技能启动上下文 = {
    Boss单位: unit,
    来源: source,
    注册时间: getServerTime(),
  };
  Boss自动技能上下文表[handleId] = context;
  通知Boss自动技能启动(context);
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
  for (const key in Boss自动技能上下文表) {
    const context = Boss自动技能上下文表[key];
    if (context != null) result.push(context);
  }
  result.sort((a, b) => a.注册时间 - b.注册时间);
  return result;
}

export function 注册Boss自动技能启动监听(this: void, 参数: Boss自动技能启动监听参数): number {
  const ID = ++下一个Boss自动技能启动监听ID;
  const 监听: Boss自动技能启动监听记录 = { ...参数, ID };
  Boss自动技能启动监听表[ID] = 监听;
  if (参数.回放已有 !== false) {
    const contexts = 获取所有Boss自动技能启动上下文();
    for (let i = 0; i < contexts.length; i++) {
      const context = contexts[i];
      if (context != null && 启动监听匹配(监听, context)) 监听.on启动(context);
    }
  }
  return ID;
}

export function 注销Boss自动技能启动监听(this: void, ID: number): void {
  Boss自动技能启动监听表[ID] = undefined;
}

export function 清理Boss自动技能启动上下文(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  Boss自动技能上下文表[GetHandleId(unit)] = undefined;
}
