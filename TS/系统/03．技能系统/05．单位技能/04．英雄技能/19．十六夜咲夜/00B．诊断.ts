/** @noSelfInFile */

import { 十六夜咲夜基础技能配置 } from "./00．配置";

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (
    this: void,
    callback: (this: void, castingUnit: any, spellAbilityId: number) => void,
  ) => void;
};

const 技能名称表: Record<number, string> = {
  [十六夜咲夜基础技能配置.技能.Q.类型ID]: "Q",
  [十六夜咲夜基础技能配置.技能.W.类型ID]: "W",
  [十六夜咲夜基础技能配置.技能.E.类型ID]: "E",
  [十六夜咲夜基础技能配置.技能.R魔法书.类型ID]: "R魔法书",
  [十六夜咲夜基础技能配置.技能.D.类型ID]: "D",
  [十六夜咲夜基础技能配置.技能.RR.类型ID]: "RR",
  [十六夜咲夜基础技能配置.技能.RR.二段类型ID]: "RR二段",
  [十六夜咲夜基础技能配置.技能.RQ.类型ID]: "RQ",
  [十六夜咲夜基础技能配置.技能.RW.类型ID]: "RW",
  [十六夜咲夜基础技能配置.技能.RA.类型ID]: "RA",
  [十六夜咲夜基础技能配置.技能.RE.类型ID]: "RE",
  [十六夜咲夜基础技能配置.技能.RS.类型ID]: "RS",
  [十六夜咲夜基础技能配置.技能.RD.类型ID]: "RD",
  [十六夜咲夜基础技能配置.技能.RF.类型ID]: "RF",
  [十六夜咲夜基础技能配置.技能.RC.类型ID]: "RC",
  [十六夜咲夜基础技能配置.技能.RZ.类型ID]: "RZ",
  [十六夜咲夜基础技能配置.技能.RX.类型ID]: "RX",
};

export function 十六夜咲夜诊断日志(this: void, 模块: string, ...参数: any[]): void {
  debugLogForce(`十六夜咲夜${模块}诊断`, ...参数);
}

export function 十六夜咲夜诊断句柄(this: void, handle: any): number {
  return handle == null || handle === 0 ? 0 : GetHandleId(handle);
}

function 获取技能名称(this: void, spellAbilityId: number): string {
  return 技能名称表[spellAbilityId] != null ? 技能名称表[spellAbilityId] : "未知技能";
}

function 监听十六夜咲夜施法(this: void, caster: any, spellAbilityId: number): void {
  if (caster == null || caster === 0 || GetUnitTypeId(caster) !== 十六夜咲夜基础技能配置.英雄单位类型ID) return;

  const target = GetSpellTargetUnit();
  十六夜咲夜诊断日志(
    "施法事件",
    "收到SPELL_EFFECT",
    "施法者",
    十六夜咲夜诊断句柄(caster),
    "技能",
    获取技能名称(spellAbilityId),
    "技能ID",
    spellAbilityId,
    "英雄X",
    GetUnitX(caster),
    "英雄Y",
    GetUnitY(caster),
    "目标单位",
    十六夜咲夜诊断句柄(target),
    "目标X",
    GetSpellTargetX(),
    "目标Y",
    GetSpellTargetY(),
  );
}

十六夜咲夜诊断日志("施法事件", "诊断模块已加载", "英雄类型ID", 十六夜咲夜基础技能配置.英雄单位类型ID);
registerSpellEffectListener(监听十六夜咲夜施法);

export {};
