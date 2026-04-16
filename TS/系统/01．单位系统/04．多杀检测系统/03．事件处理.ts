/**
 * 多杀检测系统 - STES事件处理
 *
 * 功能：处理JASS端触发的STES事件
 *
 * 后续接手者注意：
 * 1. JASS端通过 STES "OnMultiKill" 事件启动监控
 * 2. 参数通过 YDLocal1Get 读取，参数名须与JASS端一致
 */

import {
  MULTI_KILL_SYSTEM_ENABLED,
  MULTI_KILL_EVENT,
} from "./00．常量定义";

import {
  startMultiKillMonitor,
  MultiKillConfig,
} from "./01．核心功能";

const jass = require("jass.common") as any;

const { STES_Register } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_Register: (trg: any, name: string) => void;
};

const { YDLocal1Get } = require("lib.扩展函数.YDWE函数.02．YDLocal兼容") as {
  YDLocal1Get: (ty: string, name: string) => any;
};

// ==========================================================================================
// STES事件触发函数（供JASS端调用）
// ==========================================================================================

/**
 * 触发"OnMultiKill"事件
 * 供JASS端调用，启动多杀监控
 *
 * JASS端参数（通过YDLocal传递）：
 * - effectSource (unit): 效果来源单位
 * - killGroup (group): 击杀组（必传）
 * - DiyEvent (boolean): 是否触发自定义事件
 * - DiyEventString (string): 自定义事件名称
 * - Finish (boolean): 结束时是否显示来源单位
 * - EffectID (integer): 效果ID
 * - HealAmount (real): 治疗量
 * - HealTarget (unit): 治疗目标
 * - HealSource (unit): 治疗来源
 */
export function fireMultiKillEvent(): void {
  const effectSource = YDLocal1Get("unit", "effectSource");
  const killGroup = YDLocal1Get("group", "killGroup");
  const diyEvent = YDLocal1Get("boolean", "DiyEvent") || false;
  const diyEventString = YDLocal1Get("string", "DiyEventString") || "";
  const finish = YDLocal1Get("boolean", "Finish") || false;
  const effectID = YDLocal1Get("integer", "EffectID") || 0;
  const healAmount = YDLocal1Get("real", "HealAmount") || 0;
  const healTarget = YDLocal1Get("unit", "HealTarget");
  const healSource = YDLocal1Get("unit", "HealSource");

  startMultiKillMonitor({
    effectSource,
    killGroup,
    diyEvent,
    diyEventString,
    finish,
    effectID,
    healAmount,
    healTarget,
    healSource,
  });
}

// ==========================================================================================
// STES事件处理
// ==========================================================================================

let multiKillTrigger: any = null;

function onMultiKillEvent(): void {
  fireMultiKillEvent();
}

// ==========================================================================================
// 初始化
// ==========================================================================================

export function initMultiKillSystem(): void {
  if (!MULTI_KILL_SYSTEM_ENABLED) return;
  if (multiKillTrigger != null) return;

  multiKillTrigger = jass.CreateTrigger();
  jass.TriggerAddAction(multiKillTrigger, onMultiKillEvent);
  STES_Register(multiKillTrigger, MULTI_KILL_EVENT);
}

export function isMultiKillSystemInitialized(): boolean {
  return multiKillTrigger != null;
}

export {};
