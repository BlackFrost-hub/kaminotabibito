/** @noSelfInFile */
/**
 * 04．仇恨显示
 *
 * 给有仇恨表的敌人显示头顶跟随文字：
 * - 目标：XX
 * - 仇恨值：XXX
 */

const jass = require("jass.common") as any;

const {
  CreateFloatTextOnUnit,
  DestroyFloatText,
} = require("lib.扩展函数.封装函数.03．漂浮文字.index") as {
  CreateFloatTextOnUnit: (this: void, unit: any, text: string, options?: Record<string, any>) => any;
  DestroyFloatText: (this: void, textTag: any) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetUnitName = jass.GetUnitName as (u: any) => string;
const SetTextTagText = (jass as any).SetTextTagText as (tt: any, text: string, height: number) => void;
const SetTextTagPosUnit = (jass as any).SetTextTagPosUnit as (tt: any, unit: any, height: number) => void;
const IsUnitType = jass.IsUnitType as (u: any, whichType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD;
const R2I = jass.R2I as (value: number) => number;

interface 仇恨显示数据 {
  textTag: any;
  跟随单位: any;
}

const 仇恨显示表: Record<number, 仇恨显示数据 | undefined> = {};
const 文字高度 = 50;
const 文字尺寸高度 = 9 * 0.0023;
const 跟随刷新毫秒 = 40;
let 跟随回调ID = 0;
let 已注册死亡清理 = false;

function 取单位ID(u: any): number {
  if (u == null || u === 0) return 0;
  return GetHandleId(u) || 0;
}

function 格式化仇恨值(仇恨值: number): string {
  const 十倍整数 = R2I(仇恨值 * 10 + 0.5);
  const 整数部分 = R2I(十倍整数 / 10);
  const 小数部分 = 十倍整数 - 整数部分 * 10;
  return `${整数部分}.${小数部分}`;
}

function 构建仇恨文本(目标单位: any, 仇恨值: number): string {
  return `目标：${GetUnitName(目标单位)}|n仇恨值：${格式化仇恨值(仇恨值)}`;
}

function 获取或创建仇恨文字(敌人ID: number, 敌人: any): any | null {
  const 现有 = 仇恨显示表[敌人ID];
  if (现有 != null && 现有.textTag != null) {
    现有.跟随单位 = 敌人;
    return 现有.textTag;
  }

  const 新文字 = CreateFloatTextOnUnit(敌人, "", {
    size: 9,
    red: 255,
    green: 150,
    blue: 60,
    alpha: 0,
    duration: 0,
    permanent: true,
    speedX: 0,
    speedY: 0,
    height: 文字高度,
  });
  if (新文字 == null) return null;

  仇恨显示表[敌人ID] = { textTag: 新文字, 跟随单位: 敌人 };
  return 新文字;
}

function on仇恨显示单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const 敌人ID = 取单位ID(dyingUnit);
  if (敌人ID === 0) return;
  清除仇恨显示ById(敌人ID);
}

function on仇恨显示Tick(): void {
  const keys = Object.keys(仇恨显示表);
  let 仍有显示 = false;
  for (let i = 0; i < keys.length; i++) {
    const 敌人ID = parseInt(keys[i], 10);
    if (isNaN(敌人ID)) continue;
    const 数据 = 仇恨显示表[敌人ID];
    if (数据 == null || 数据.textTag == null || 数据.跟随单位 == null || 数据.跟随单位 === 0) {
      清除仇恨显示ById(敌人ID);
      continue;
    }
    if (IsUnitType(数据.跟随单位, UNIT_TYPE_DEAD)) {
      清除仇恨显示ById(敌人ID);
      continue;
    }
    SetTextTagPosUnit(数据.textTag, 数据.跟随单位, 文字高度);
    仍有显示 = true;
  }

  if (!仍有显示 && 跟随回调ID !== 0) {
    const { removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
      removePeriodicCallback: (this: void, id: number) => void;
    };
    removePeriodicCallback(跟随回调ID);
    跟随回调ID = 0;
  }
}

function 确保仇恨显示Tick已启动(): void {
  if (!已注册死亡清理) {
    已注册死亡清理 = true;
    registerDeathListener(on仇恨显示单位死亡);
  }
  if (跟随回调ID !== 0) return;
  const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
    addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  };
  跟随回调ID = addPeriodicCallback(跟随刷新毫秒, on仇恨显示Tick);
}

export function 更新仇恨显示(敌人: any, 目标单位: any, 仇恨值: number): void {
  const 敌人ID = 取单位ID(敌人);
  if (敌人ID === 0) return;
  if (敌人 == null || 敌人 === 0 || 目标单位 == null || 目标单位 === 0) return;
  if (IsUnitType(敌人, UNIT_TYPE_DEAD) || IsUnitType(目标单位, UNIT_TYPE_DEAD)) {
    清除仇恨显示ById(敌人ID);
    return;
  }

  const 文字 = 获取或创建仇恨文字(敌人ID, 敌人);
  if (文字 == null) return;

  SetTextTagText(文字, 构建仇恨文本(目标单位, 仇恨值), 文字尺寸高度);
  SetTextTagPosUnit(文字, 敌人, 文字高度);
  确保仇恨显示Tick已启动();
}

export function 清除仇恨显示ById(敌人ID: number): void {
  if (敌人ID === 0) return;
  const 数据 = 仇恨显示表[敌人ID];
  if (数据 == null) return;
  if (数据.textTag != null) {
    DestroyFloatText(数据.textTag);
  }
  delete 仇恨显示表[敌人ID];
}

export function 清除所有仇恨显示(): void {
  const keys = Object.keys(仇恨显示表);
  for (let i = 0; i < keys.length; i++) {
    const 敌人ID = parseInt(keys[i], 10);
    if (!isNaN(敌人ID)) {
      清除仇恨显示ById(敌人ID);
    }
  }
  if (跟随回调ID !== 0) {
    const { removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
      removePeriodicCallback: (this: void, id: number) => void;
    };
    removePeriodicCallback(跟随回调ID);
    跟随回调ID = 0;
  }
}

export {};
