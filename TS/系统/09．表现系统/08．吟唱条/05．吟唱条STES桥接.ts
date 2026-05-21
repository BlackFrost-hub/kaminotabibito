/** @noSelfInFile */
/**
 * 吟唱条系统 - STES 桥接
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { registerStesListener } = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具") as {
  registerStesListener: (this: void, eventName: string, callback: () => void) => any | null;
};
const {
  ydlStes_syncTriggerStep,
  ydlStes_finishChildCleanup,
  ydlStes_readReal5,
  ydlStes_readInteger5,
  ydlStes_readString5,
} = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具") as {
  ydlStes_syncTriggerStep: (this: void, self: any) => void;
  ydlStes_finishChildCleanup: (this: void, self: any) => void;
  ydlStes_readReal5: (this: void, self: any, name: string) => number;
  ydlStes_readInteger5: (this: void, self: any, name: string) => number;
  ydlStes_readString5: (this: void, self: any, name: string) => string;
};
const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  createDelayedCall: (this: void, delaySec: number, callback: () => void) => { id: number };
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 显示吟唱条: 启动吟唱条, 关闭吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示吟唱条: (this: void, self: any, 参数: any) => void;
  关闭吟唱条: (this: void, self: any) => void;
};

export const 吟唱条STES事件名 = "注册吟唱条";
const 模块名 = "吟唱条桥接";
const 全局已注册标记键 = "__syzl_castbar_registered";
const 全局触发器键 = "__syzl_castbar_trig";
const 全局重试次数键 = "__syzl_castbar_reg_attempt";
const 最大注册尝试次数 = 30;
const 重试间隔秒 = 0.1;

let 吟唱条Stes触发器: any | null = null;

function 读取吟唱条事件参数(this: void): any {
  let sj = ydlStes_readReal5(undefined, "sj");
  if (sj === 0) {
    sj = ydlStes_readReal5(undefined, "总时长");
  }
  if (sj === 0) {
    sj = ydlStes_readReal5(undefined, "time");
  }
  let 颜色ID = ydlStes_readInteger5(undefined, "颜色ID");
  if (颜色ID === 0) {
    颜色ID = ydlStes_readInteger5(undefined, "颜色");
  }
  if (颜色ID === 0) {
    颜色ID = ydlStes_readInteger5(undefined, "棰滆壊ID");
  }
  let 提示字符串 = ydlStes_readString5(undefined, "string");
  if (提示字符串 === "") {
    提示字符串 = ydlStes_readString5(undefined, "提示文本");
  }
  if (提示字符串 === "") {
    提示字符串 = ydlStes_readString5(undefined, "文本");
  }
  return {
    sj,
    颜色ID,
    string: 提示字符串,
  };
}

export function 根据Stes事件启动吟唱条(this: void): void {
  try {
    ydlStes_syncTriggerStep(undefined);
    const 参数 = 读取吟唱条事件参数();

    const 总时长 = 参数.sj;
    const 颜色ID = 参数.颜色ID;
    const 提示文本 = 参数.string !== "" ? 参数.string : undefined;

    启动吟唱条(undefined, {
      总时长,
      颜色ID,
      提示文本,
    });

  } finally {
    ydlStes_finishChildCleanup(undefined);
  }
}

function on吟唱条Stes事件Action(this: void): void {
  根据Stes事件启动吟唱条();
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
  return jass.LoadInteger(ht, jass.StringHash(eventName), jass.StringHash("index"));
}

function 重试注册吟唱条Stes(this: void): void {
  尝试注册吟唱条Stes();
}

function 安排重试注册(this: void): void {
  createDelayedCall(重试间隔秒, 重试注册吟唱条Stes);
}

function 尝试注册吟唱条Stes(this: void): void {
  const g = globalThis as any;
  if (g[全局已注册标记键]) return;

  if (g[全局触发器键] == null) {
    吟唱条Stes触发器 = registerStesListener(吟唱条STES事件名, on吟唱条Stes事件Action);
    g[全局触发器键] = 吟唱条Stes触发器;
  } else {
    吟唱条Stes触发器 = g[全局触发器键];
  }

  const jCount = countOnJassStesTable(吟唱条STES事件名);
  const 已尝试次数 = (g[全局重试次数键] as number) || 0;
  g[全局重试次数键] = 已尝试次数 + 1;

  if (jCount >= 1) {
    g[全局已注册标记键] = true;
    return;
  }

  if (g[全局重试次数键] >= 最大注册尝试次数) {
    debugLogForce(模块名, "注册失败", "event=", 吟唱条STES事件名, "最后计数=", jCount);
    return;
  }

  安排重试注册();
}

export function 确保Stes已注册(this: void): void {
  尝试注册吟唱条Stes();
}

确保Stes已注册();
