/**
 * 多杀检测系统 - STES事件处理
 *
 * 功能：处理JASS端触发的STES事件
 *
 * 后续接手者注意：
 * 1. JASS 端通过 STES "OnMultiKill" 事件启动监控
 * 2. 参数通过 YDLocal5Get 读取，键名须与 JASS 端 YDLocal5Set 一致
 * 3. effectSource 的推荐语义：放一只「逻辑锚点」单位（常见为地图里预先放置的隐藏单位），
 *    用于区分多路监控、stopMultiKillMonitor/addToKillGroup 查找，以及 Finish=true 时在组灭后 ShowUnit 的对象。
 *    killGroup 里被清掉的怪不必也不适合当锚点；未传 effectSource 时 Lua 会退化为 killGroup 第一个单位，仅作兜底。
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

const { YDLocal5Get } = require("lib.扩展函数.YDWE函数.02．YDLocal兼容") as {
  YDLocal5Get: (ty: string, name: string) => any;
};

const { ydlStes_syncTriggerStep } = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具") as {
  ydlStes_syncTriggerStep: (_self: any) => void;
};

const { CountUnitsInGroup } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  CountUnitsInGroup: (group: any) => number;
};

// 调试函数
function dbg(msg: string): void {
  const p = (globalThis as any).print as ((m: string) => void) | undefined;
  if (typeof p === "function") p(`[多杀STES] ${msg}`);
}

// ==========================================================================================
// STES事件触发函数（供JASS端调用）
// ==========================================================================================

/**
 * 触发"OnMultiKill"事件
 * 供JASS端调用，启动多杀监控
 *
 * JASS端参数（通过 YDLocal5Set 传递）：
 * - effectSource (unit): 推荐传地图里预先放置的「隐藏锚点单位」——不参与 killGroup 清怪，只作本路监控的唯一键
 *   （stopMultiKillMonitor / addToKillGroup 等均按此句柄查找）。可选；未传时 Lua 退化为 killGroup 内第一个单位，仅兜底。
 * - killGroup (group): 被监控的单位组（必传）
 * - killWindow (real): 伤害计数时间窗（秒），与 killThreshold 配合；缺省由调用方或核心内默认值处理
 * - killThreshold (integer): 时间窗内计几次玩家伤害后放行击杀；缺省同理
 * - DiyEvent (boolean): 是否触发自定义事件
 * - DiyEventString (string): 自定义事件名称
 * - Finish (boolean): 传入核心实例；若后续接「组灭后显示锚点」等表现，应对 effectSource（多为隐藏单位）调用 ShowUnit
 * - EffectID (integer): 效果ID
 * - HealAmount (real): 治疗量
 * - HealTarget (unit): 治疗目标
 * - HealSource (unit): 治疗来源
 */
export function fireMultiKillEvent(): void {
  dbg("========== fireMultiKillEvent 被调用 ==========");
  
  // 同步 ydl_triggerstep，确保 YDLocal5Get 能正确读取 JASS 端传递的参数
  ydlStes_syncTriggerStep(undefined);
  dbg("ydlStes_syncTriggerStep 执行完成");
  
  // JASS 端使用 YDLocal5Set 传参，所以这里用 YDLocal5Get 读取
  const effectSource = YDLocal5Get("unit", "effectSource");
  const killGroup = YDLocal5Get("group", "killGroup");
  const diyEvent = YDLocal5Get("boolean", "DiyEvent") || false;
  const diyEventString = YDLocal5Get("string", "DiyEventString") || "";
  const finish = YDLocal5Get("boolean", "Finish") || false;
  const effectID = YDLocal5Get("integer", "EffectID") || 0;
  const healAmount = YDLocal5Get("real", "HealAmount") || 0;
  const healTarget = YDLocal5Get("unit", "HealTarget");
  const healSource = YDLocal5Get("unit", "HealSource");

  // 地图侧推荐始终 YDLocal5Set(unit,"effectSource",隐藏单位)。仅传组时：用组内首个单位兜底作键，多路并发易撞车
  let resolvedEffectSource = effectSource;
  if (resolvedEffectSource == null || resolvedEffectSource === 0) {
    resolvedEffectSource = jass.FirstOfGroup(killGroup);
    if (resolvedEffectSource != null && resolvedEffectSource !== 0) {
      dbg("effectSource 未传，已用 killGroup 内第一个单位作为 effectSource");
    }
  }

  // 调试输出读取到的参数
  dbg(`参数读取结果:`);
  dbg(
    `  effectSource=${effectSource === 0 || effectSource == null ? "nil/0" : "有效"} → 使用=${resolvedEffectSource === 0 || resolvedEffectSource == null ? "nil/0" : "有效"}`
  );
  dbg(`  killGroup=${killGroup === 0 || killGroup == null ? "nil/0" : "有效"}`);
  dbg(`  diyEvent=${diyEvent}`);
  dbg(`  diyEventString="${diyEventString}"`);
  dbg(`  finish=${finish}`);
  dbg(`  effectID=${effectID}`);
  dbg(`  healAmount=${healAmount}`);
  dbg(`  healTarget=${healTarget === 0 || healTarget == null ? "nil/0" : "有效"}`);
  dbg(`  healSource=${healSource === 0 || healSource == null ? "nil/0" : "有效"}`);
  
  // 重点检查这3个JASS端传递的参数
  const killWindow = YDLocal5Get("real", "killWindow");
  const killThreshold = YDLocal5Get("integer", "killThreshold");
  dbg(`【关键参数检查】`);
  dbg(`  killWindow=${killWindow !== undefined && killWindow !== 0 ? killWindow : "nil/0"}`);
  dbg(`  killThreshold=${killThreshold !== undefined && killThreshold !== 0 ? killThreshold : "nil/0"}`);
  dbg(
    `  killGroup内单位数=${killGroup !== 0 && killGroup != null && typeof jass.CountUnitsInGroup === "function" ? jass.CountUnitsInGroup(killGroup) : "N/A"}`
  );

  if (killGroup == null || killGroup === 0) {
    dbg("错误: killGroup 为空，无法启动监控");
    return;
  }

  dbg("调用 startMultiKillMonitor...");
  startMultiKillMonitor({
    effectSource: resolvedEffectSource,
    killGroup,
    killThreshold: killThreshold !== undefined && killThreshold !== 0 ? killThreshold : 3,
    killWindow: killWindow !== undefined && killWindow !== 0 ? killWindow : 3.0,
    diyEvent,
    diyEventString,
    finish,
    effectID,
    healAmount,
    healTarget,
    healSource,
  });
  dbg("startMultiKillMonitor 调用完成");
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
