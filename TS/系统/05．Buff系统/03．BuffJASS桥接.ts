/**
 * Buff 系统 — STES 桥接：注册事件后，由地图 `STES_Fire("添加Buff")` / JASS 遍历触发
 *
 * =============================================================================
 * 传参方式（与 `07．装备提取` 一致：YDLocal5 子触发传参区，中文变量名）
 * =============================================================================
 * 父触发在 `YDLocalExecuteTrigger` + `YDTriggerExecuteTrigger` 之前，对**子触发**写入：
 *
 * | YDLocal 类型 | 变量名（须与地图 GUI/JASS 完全一致） | 说明 |
 * |--------------|--------------------------------------|------|
 * | unit | **Buff来源单位** | 来源单位，可选 |
 * | unit | **Buff目标单位** | 目标单位，必填 |
 * | string | **Buff编号** | 与 `01．Buff表` 中 id 一致 |
 * | string | **Buff特效路径** | 特效模型，可选 |
 * | string | **Buff图标路径** | 图标，可选 |
 * | real | **Buff持续时间** | 秒，须大于 0 |
 * | real | **Buff效果数值** | 单次/每秒伤害等 |
 *
 * Lua 内共用逻辑见 `lib/扩展函数/YDWE函数/05．STES子触发公共工具.ts`。
 *
 * （旧版 udg_TempUnit[3][4] / TempString[21]–[23] / TempReal[5][6] 已不再使用。）
 */

const jass = require("jass.common") as any;
const { STES_Register } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_Register: (t: any, name: string) => void;
};

const {
  ydlStes_syncTriggerStep,
  ydlStes_finishChildCleanup,
  ydlStes_readString5,
  ydlStes_readUnit5,
  ydlStes_readReal5,
  ydlStes_registerAfterGetTable,
} = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具") as {
  ydlStes_syncTriggerStep: (self: any) => void;
  ydlStes_finishChildCleanup: (self: any) => void;
  ydlStes_readString5: (self: any, name: string) => string;
  ydlStes_readUnit5: (self: any, name: string) => any;
  ydlStes_readReal5: (self: any, name: string) => number;
  ydlStes_registerAfterGetTable: (self: any, trig: any, eventName: string) => void;
};

import { registerManualBuff } from "./00．Buff系统";

export const BUFF_ADD_STES_EVENT = "添加Buff";

/** 与地图 YDLocal5Set 对齐的中文变量名 */
const YL_UNIT_SOURCE = "Buff来源单位";
const YL_UNIT_TARGET = "Buff目标单位";
const YL_STR_ID = "Buff编号";
const YL_STR_EFFECT = "Buff特效路径";
const YL_STR_ICON = "Buff图标路径";
const YL_REAL_DURATION = "Buff持续时间";
const YL_REAL_VALUE = "Buff效果数值";

function resolveSourceDisplayName(source: any): string | undefined {
  if (source == null || source === 0) return undefined;
  if (typeof jass.GetUnitName !== "function") return undefined;
  const n = jass.GetUnitName(source);
  return typeof n === "string" && n !== "" ? n : undefined;
}

function playOneShotEffectOnTarget(modelPath: string, target: any): void {
  if (modelPath === "" || target == null || target === 0) return;
  if (typeof jass.AddSpecialEffectTarget !== "function") return;
  const eff = jass.AddSpecialEffectTarget(modelPath, target, "overhead");
  if (eff == null || eff === 0) return;
  if (typeof jass.YDWETimerDestroyEffect === "function") {
    jass.YDWETimerDestroyEffect(2.0, eff);
  } else if (typeof jass.DestroyEffect === "function") {
    jass.DestroyEffect(eff);
  }
}

/**
 * 从 YDLocal5 读参并施加 Buff（地图须在触发子触发前写入上表所列变量名）
 */
export function buffBridgeApplyFromYdlocal(_self: any): void {
  try {
    ydlStes_syncTriggerStep(undefined);

    const source = ydlStes_readUnit5(undefined, YL_UNIT_SOURCE);
    const target = ydlStes_readUnit5(undefined, YL_UNIT_TARGET);
    const buffID = ydlStes_readString5(undefined, YL_STR_ID);
    const effectPath = ydlStes_readString5(undefined, YL_STR_EFFECT);
    const iconPath = ydlStes_readString5(undefined, YL_STR_ICON);
    const duration = ydlStes_readReal5(undefined, YL_REAL_DURATION);
    const effectVal = ydlStes_readReal5(undefined, YL_REAL_VALUE);

    if (target == null || target === 0) return;
    if (buffID === "") return;
    if (duration <= 0) return;

    const srcName = resolveSourceDisplayName(source);
    registerManualBuff(target, buffID, duration, effectVal, {
      sourceName: srcName,
      iconOverride: iconPath !== "" ? iconPath : undefined,
      effectModelOverride: effectPath !== "" ? effectPath : undefined,
    });

    if (effectPath !== "") {
      playOneShotEffectOnTarget(effectPath, target);
    }
  } finally {
    ydlStes_finishChildCleanup(undefined);
  }
}

function init(): void {
  if (typeof jass.CreateTrigger !== "function" || typeof jass.TriggerAddAction !== "function") {
    return;
  }
  if (STES_Register == null) return;
  const trig = jass.CreateTrigger();
  jass.TriggerAddAction(trig, () => {
    buffBridgeApplyFromYdlocal(undefined);
  });
  ydlStes_registerAfterGetTable(undefined, trig, BUFF_ADD_STES_EVENT);
}

init();
