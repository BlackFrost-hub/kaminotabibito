/** @noSelfInFile */

import { 安斯艾尔单位技能配置 } from "./00．配置";
import { 安斯艾尔BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/16．安斯艾尔";

const jass = require("jass.common") as any;
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, unit: any, abilityId: number) => void) => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};

const 安斯艾尔单位类型ID = stringToFourCCSafe(安斯艾尔单位技能配置.单位类型ID);
const R技能类型ID = stringToFourCCSafe(安斯艾尔单位技能配置.R技能ID);
const 原生无双BuffID = stringToFourCCSafe("B01X");

function on安斯艾尔R(this: void, caster: any, abilityId: number): void {
  if (caster == null || caster === 0) return;
  if (jass.GetUnitTypeId(caster) !== 安斯艾尔单位类型ID || abilityId !== R技能类型ID) return;
  const level = jass.GetUnitAbilityLevel(caster, R技能类型ID) as number;
  if (!(level > 0)) return;

  // 攻速和移速由原生 Afzy/Bfzy 技能处理；这里仅登记自定义 Buff UI。
  registerManualBuff(caster, 安斯艾尔BuffID.无双, 安斯艾尔单位技能配置.R.持续秒, level, {
    sourceUnit: caster,
    sourceName: "无双",
    stack: level,
    nativeBuffAbilityIds: [原生无双BuffID],
  });
}

registerSpellEffectListener(on安斯艾尔R);

export {};
