/** @noSelfInFile */

import { 欧菲莉亚单位技能配置 } from "./00．配置";
import { 播放欧菲莉亚单位音效 } from "./00A．表现工具";
import { 单位存活 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { 调整玩家属性 } = require("../../../00．技能模板+函数/01．技能函数/20．物品辅助/16．属性位移与指令") as {
  调整玩家属性: (this: void, unit: any, attrName: string, delta: number) => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, caster: any, abilityId: number) => void) => void;
};

const 欧菲莉亚单位类型ID = stringToFourCCSafe(欧菲莉亚单位技能配置.单位类型ID);
const 欧菲莉亚D技能ID = stringToFourCCSafe(欧菲莉亚单位技能配置.D技能ID);
const 欧菲莉亚D原生状态技能ID = stringToFourCCSafe(欧菲莉亚单位技能配置.D.原生状态技能ID);
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;

function 欧菲莉亚D解除(this: void, target: any, _buffID: string, row: any): void {
  if (target == null || target === 0) return;
  const value = typeof row?.effect === "number" && row.effect > 0 ? row.effect : 欧菲莉亚单位技能配置.D.魔抗增加;
  调整玩家属性(target, "魔抗", -value);
}

function 处理欧菲莉亚D(this: void, caster: any, abilityId: number): void {
  if (abilityId !== 欧菲莉亚D技能ID || GetUnitTypeId(caster) !== 欧菲莉亚单位类型ID) return;
  const target = GetSpellTargetUnit();
  if (!单位存活(target)) return;
  const cfg = 欧菲莉亚单位技能配置.D;
  播放欧菲莉亚单位音效(caster, cfg.全局音效键);
  调整玩家属性(target, "魔抗", cfg.魔抗增加);
  jass.UnitAddAbility(target, 欧菲莉亚D原生状态技能ID);
  registerManualBuff(target, cfg.BuffID, cfg.持续秒, cfg.魔抗增加, {
    sourceUnit: caster,
    sourceName: "欧菲莉亚-守护屏障",
    stack: 1,
    nativeBuffAbilityIds: [欧菲莉亚D原生状态技能ID],
    onRemove: 欧菲莉亚D解除,
  });
}

registerSpellEffectListener(处理欧菲莉亚D);

export {};
