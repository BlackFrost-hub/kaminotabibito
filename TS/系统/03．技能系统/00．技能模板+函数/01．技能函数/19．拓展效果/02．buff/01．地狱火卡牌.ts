/** @noSelfInFile */

const jass = require("jass.common") as any;

const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: {
    sourceName?: string;
    iconOverride?: string;
    effectModelOverride?: string;
  }) => void;
};
const { startHot } = require("系统.04．伤害系统.02．治疗系统.04．持续治疗效果") as {
  startHot: (
    this: void,
    target: any,
    source: any,
    tickHP: number,
    tickMP: number,
    duration: number,
    intervalOrOptions?: number | any,
    extraOptions?: any
  ) => void;
};

const GetUnitName = jass.GetUnitName as (unit: any) => string;

export interface 地狱火卡牌持续恢复参数 {
  BuffID: string;
  图标路径: string;
  特效路径: string;
  特效挂点: string;
  特效键: string;
  持续时间: number;
  间隔: number;
  每跳生命恢复: number;
}

function 地狱火卡牌结束条件恒真(this: void, _目标单位: any): boolean {
  return true;
}

export function 施加地狱火卡牌持续恢复(this: void, 来源单位: any, 目标单位: any, 参数: 地狱火卡牌持续恢复参数): void {
  if (来源单位 == null || 来源单位 === 0) return;
  if (目标单位 == null || 目标单位 === 0) return;

  registerManualBuff(目标单位, 参数.BuffID, 参数.持续时间, 参数.每跳生命恢复, {
    sourceName: GetUnitName(来源单位),
    iconOverride: 参数.图标路径,
    effectModelOverride: 参数.特效路径,
  });

  startHot(目标单位, 来源单位, 参数.每跳生命恢复, 0, 参数.持续时间, 参数.间隔, {
    结束条件检测: 地狱火卡牌结束条件恒真,
    特效: {
      特效路径: 参数.特效路径,
      特效挂点: 参数.特效挂点,
      是否绑定单位: true,
      特效键: 参数.特效键,
    },
  });
}

export {};
