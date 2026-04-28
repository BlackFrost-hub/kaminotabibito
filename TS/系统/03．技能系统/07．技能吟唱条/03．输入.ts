/**
 * 技能吟唱条系统 - 输入层
 *
 * 职责：
 * - STES「注册吟唱条」子触发读取（颜色ID / sj / string）
 * - JASS STES 哈希表注册计数重试（与装备提取一致的桥接模式）
 * - 解析到参数后调用渲染层的 startCastBar
 *
 * 不包含：UI 渲染、数据存储。
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  createDelayedCall: (delaySec: number, callback: () => void) => { id: number };
};

const { DEFAULT_COLOR_ID, EVENT_NAME_CAST_BAR } = require("系统.03．技能系统.07．技能吟唱条.00．常量定义") as {
  DEFAULT_COLOR_ID: number;
  EVENT_NAME_CAST_BAR: string;
};

const { startCastBar } = require("系统.03．技能系统.07．技能吟唱条.02．渲染") as {
  startCastBar: (colorId: number, totalTime: number, customString: string) => void;
};

const { STES_Register } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_Register: (t: any, name: string) => void;
};

const {
  ydlStes_syncTriggerStep,
  ydlStes_finishChildCleanup,
  ydlStes_skeyIndex,
  ydlStes_registerAfterGetTable,
  ydlStes_readInteger5,
  ydlStes_readReal5,
  ydlStes_readString5,
} = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具") as {
  ydlStes_syncTriggerStep: (self: any) => void;
  ydlStes_finishChildCleanup: (self: any) => void;
  ydlStes_skeyIndex: (self: any) => number;
  ydlStes_registerAfterGetTable: (self: any, trig: any, eventName: string) => void;
  ydlStes_readInteger5: (self: any, name: string) => number;
  ydlStes_readReal5: (self: any, name: string) => number;
  ydlStes_readString5: (self: any, name: string) => string;
};

// ==========================================================================================
// 常量
// ==========================================================================================

const REG_GUARD = "__syzl_castBar_registered";
const TRIG_KEY = "__syzl_castBar_trig";
const ATTEMPT_KEY = "__syzl_castBarRegAttempt";
const MAX_REG_ATTEMPTS = 30;
const RETRY_SEC = 0.1;

// ==========================================================================================
// 子触发事件处理
// ==========================================================================================

function onCastBarEvent(this: void): void {
  ydlStes_syncTriggerStep(undefined);

  const colorId = ydlStes_readInteger5(undefined, "颜色ID") || DEFAULT_COLOR_ID;
  const totalTime = ydlStes_readReal5(undefined, "sj") || 1.0;
  const customString = ydlStes_readString5(undefined, "string") || "";

  ydlStes_finishChildCleanup(undefined);

  startCastBar(colorId, totalTime, customString);
}

// ==========================================================================================
// JASS 侧 STES 哈希表探测（保留原重试语义）
// ==========================================================================================

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
  const h = jass.StringHash(eventName);
  return jass.LoadInteger(ht, h, ydlStes_skeyIndex(undefined));
}

function scheduleRetry(this: void, fn: () => void): void {
  createDelayedCall(RETRY_SEC, fn);
}

// ==========================================================================================
// 注册：幂等 + 重试
// ==========================================================================================

export function tryRegisterCastBarStes(this: void): void {
  const g = globalThis as any;
  if (g[REG_GUARD]) return;

  if (STES_Register == null) {
    g[REG_GUARD] = true;
    return;
  }

  if (g[TRIG_KEY] == null) {
    const trig = jass.CreateTrigger();
    jass.TriggerAddAction(trig, onCastBarEvent);
    g[TRIG_KEY] = trig;
  }

  const trig = g[TRIG_KEY];
  ydlStes_registerAfterGetTable(undefined, trig, EVENT_NAME_CAST_BAR);

  const jCount = countOnJassStesTable(EVENT_NAME_CAST_BAR);
  const attempt = (g[ATTEMPT_KEY] as number) || 0;
  g[ATTEMPT_KEY] = attempt + 1;

  if (jCount >= 1) {
    g[REG_GUARD] = true;
    return;
  }

  if (g[ATTEMPT_KEY] >= MAX_REG_ATTEMPTS) {
    g[REG_GUARD] = true;
    return;
  }

  scheduleRetry(() => {
    tryRegisterCastBarStes();
  });
}

export {};
