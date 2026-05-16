/** @noSelfInFile */
/**
 * 数值显示 STES 桥接
 *
 * 只作为 JASS 兼容入口使用；TS/Lua 内部请直接调用数值漂浮文字接口。
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { registerStesListener } = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具") as {
  registerStesListener: (this: void, eventName: string, callback: () => void) => any | null;
};
const {
  ydlStes_syncTriggerStep,
  ydlStes_finishChildCleanup,
  ydlStes_readBoolean5,
  ydlStes_readReal5,
  ydlStes_readString5,
  ydlStes_readUnit5,
} = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具") as {
  ydlStes_syncTriggerStep: (this: void, self: any) => void;
  ydlStes_finishChildCleanup: (this: void, self: any) => void;
  ydlStes_readBoolean5: (this: void, self: any, name: string) => boolean;
  ydlStes_readReal5: (this: void, self: any, name: string) => number;
  ydlStes_readString5: (this: void, self: any, name: string) => string;
  ydlStes_readUnit5: (this: void, self: any, name: string) => any;
};
const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.02．计时器") as {
  createDelayedCall: (this: void, delaySec: number, callback: () => void) => { id: number };
};
const { 显示数值漂浮文字 } = require("lib.扩展函数.封装函数.03．漂浮文字.05．数值漂浮文字") as {
  显示数值漂浮文字: (this: void, options: any) => any;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

export const 数值显示STES事件名 = "数值显示";

const 模块名 = "数值显示STES桥接";
const REG_GUARD = "__syzl_value_display_registered";
const TRIG_KEY = "__syzl_value_display_trig";
const ATTEMPT_KEY = "__syzl_value_display_reg_attempt";
const MAX_REG_ATTEMPTS = 30;
const RETRY_SEC = 0.1;

const LoadInteger = jass.LoadInteger as (hashtable: any, parentKey: number, childKey: number) => number;
const StringHash = jass.StringHash as (source: string) => number;

let 数值显示触发器: any | null = null;

function 读取可选字符串(this: void, name: string): string | undefined {
  const value = ydlStes_readString5(undefined, name);
  return value !== "" ? value : undefined;
}

function 读取可选正数(this: void, name: string): number | undefined {
  const value = ydlStes_readReal5(undefined, name);
  return value > 0 ? value : undefined;
}

function 读取可选非负数(this: void, name: string): number | undefined {
  const value = ydlStes_readReal5(undefined, name);
  return value >= 0 ? value : undefined;
}

function 读取数值显示参数(this: void): any {
  const unit = ydlStes_readUnit5(undefined, "单位");
  return {
    单位: unit,
    X: ydlStes_readReal5(undefined, "X"),
    Y: ydlStes_readReal5(undefined, "Y"),
    数值: ydlStes_readReal5(undefined, "数值"),
    后缀: 读取可选字符串("后缀"),
    红: 读取可选正数("红"),
    绿: 读取可选正数("绿"),
    蓝: 读取可选正数("蓝"),
    大小: 读取可选正数("大小"),
    小数位数: 读取可选非负数("小数位数"),
    显示正号: ydlStes_readBoolean5(undefined, "显示正号") ? true : undefined,
    零值隐藏: ydlStes_readBoolean5(undefined, "零值隐藏") ? true : undefined,
  };
}

export function 根据Stes事件显示数值(this: void): void {
  try {
    ydlStes_syncTriggerStep(undefined);
    const 参数 = 读取数值显示参数();
    显示数值漂浮文字(参数);
  } finally {
    ydlStes_finishChildCleanup(undefined);
  }
}

function on数值显示Stes事件Action(this: void): void {
  根据Stes事件显示数值();
}

function jassStesHashtable(this: void): any {
  const jg = jglobals as any;
  const cands = [jg.STES___HT, jg.STES_HT, jg.udg_STES___HT, jg.udg_STES_HT];
  for (let i = 0; i < cands.length; i++) {
    const t = cands[i];
    if (t != null && t !== 0) return t;
  }
  return null;
}

function countOnJassStesTable(this: void, eventName: string): number {
  const ht = jassStesHashtable();
  if (ht == null || ht === 0) return -1;
  return LoadInteger(ht, StringHash(eventName), StringHash("index"));
}

function onRetryRegisterValueDisplayStes(this: void): void {
  tryRegisterValueDisplayStes();
}

function scheduleRetry(this: void): void {
  createDelayedCall(RETRY_SEC, onRetryRegisterValueDisplayStes);
}

function tryRegisterValueDisplayStes(this: void): void {
  const g = globalThis as any;
  if (g[REG_GUARD]) return;

  if (g[TRIG_KEY] == null) {
    数值显示触发器 = registerStesListener(数值显示STES事件名, on数值显示Stes事件Action);
    g[TRIG_KEY] = 数值显示触发器;
  } else {
    数值显示触发器 = g[TRIG_KEY];
  }

  const jCount = countOnJassStesTable(数值显示STES事件名);
  const attempt = g[ATTEMPT_KEY] || 0;
  g[ATTEMPT_KEY] = attempt + 1;

  if (jCount >= 1) {
    g[REG_GUARD] = true;
    debugLogForce(模块名, "注册成功", "event=", 数值显示STES事件名, "count=", jCount);
    return;
  }

  if (g[ATTEMPT_KEY] >= MAX_REG_ATTEMPTS) {
    debugLogForce(模块名, "注册失败", "event=", 数值显示STES事件名, "最后计数=", jCount);
    return;
  }

  scheduleRetry();
}

export function 注册数值显示Stes桥接(this: void): void {
  tryRegisterValueDisplayStes();
}

注册数值显示Stes桥接();
