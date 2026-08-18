/** @noSelfInFile */

import { 八云紫单位技能配置 } from "./00．配置";

const jass = require("jass.common") as any;

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

export function 八云紫诊断日志(this: void, 模块: string, ...参数: any[]): void {
  debugLogForce(`八云紫${模块}诊断`, ...参数);
}

export function 八云紫诊断句柄(this: void, handle: any): number {
  return handle == null || handle === 0 ? 0 : jass.GetHandleId(handle);
}

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};

function 监听八云紫全部施法(this: void, caster: any, spellAbilityId: number): void {
  if (caster == null || caster === 0 || jass.GetUnitTypeId(caster) !== 八云紫单位技能配置.单位.英雄类型ID) return;
  八云紫诊断日志("施法事件", "收到SPELL_EFFECT", "英雄", 八云紫诊断句柄(caster), "技能ID", spellAbilityId, "Q", 八云紫单位技能配置.技能.Q.类型ID, "W", 八云紫单位技能配置.技能.W.类型ID, "E", 八云紫单位技能配置.技能.E.类型ID, "E出现", 八云紫单位技能配置.技能.E出现.类型ID, "R", 八云紫单位技能配置.技能.R.类型ID, "D", 八云紫单位技能配置.技能.D.类型ID, "目标单位", 八云紫诊断句柄(jass.GetSpellTargetUnit()), "目标X", jass.GetSpellTargetX(), "目标Y", jass.GetSpellTargetY());
}

八云紫诊断日志("施法事件", "诊断模块已加载", "英雄类型ID", 八云紫单位技能配置.单位.英雄类型ID);
registerSpellEffectListener(监听八云紫全部施法);

export {};
