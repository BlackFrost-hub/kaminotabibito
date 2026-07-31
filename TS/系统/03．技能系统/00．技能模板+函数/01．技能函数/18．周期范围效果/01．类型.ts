/** @noSelfInFile */

export interface 周期范围效果参数 {
  来源单位?: any;
  EffectSourceUnit?: any;
  AoeEffectFileID?: string;
  特效模型?: string;
  EffectID?: number;
  效果ID?: number;
  EffectInterval?: number;
  间隔?: number;
  EffectTime?: number;
  持续时间?: number;
  r?: number;
  半径?: number;
  x?: number;
  X?: number;
  y?: number;
  Y?: number;
}

export interface 腐败层数参数 {
  TargetUnit?: any;
  目标单位?: any;
  Stacks?: number;
  层数?: number;
  腐败值?: boolean;
}

export interface 持续伤害组件 {
  伤害: number;
  伤害类型: any;
}

export type 每跳伤害计算器 = (this: void, 来源单位: any, 目标单位: any) => 持续伤害组件[];

export interface 持续原生效果参数 {
  BuffSource?: any;
  来源单位?: any;
  BuffTarget?: any;
  目标单位?: any;
  HitDamage?: number;
  伤害?: number;
  DamageType?: any;
  伤害类型?: any;
  DamageInterval?: number;
  伤害间隔?: number;
  每跳伤害计算器?: 每跳伤害计算器;
  time?: number;
  持续时间?: number;
}

export interface 周期范围效果实例 {
  ID: number;
  来源单位: any;
  特效模型: string;
  特效持续时间: number;
  效果ID: number;
  区域实例: any;
}

export {};
