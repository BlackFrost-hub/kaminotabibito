/** @noSelfInFile */

export type 单位AI归类 = "杂鱼" | "精英" | "Boss" | "英雄Boss" | "异界Boss";
export type 单位AI模式 = "自动扫描通魔" | "固定技能表";
export type AI目标选择方式 = "最高仇恨" | "自己" | "当前攻击目标" | "最近敌人";
export type AI施法目标类型 = "自动" | "无目标" | "自己" | "单位" | "点" | "单位或点";
export type AI运行时状态 = string | number;
export type AI运行时状态读取器 = (this: void, unit: any) => AI运行时状态 | undefined;
export type AI技能运行时可用条件 = (this: void, unit: any) => boolean;
export type AI技能冷却读取器 = (this: void, unit: any) => number | undefined;

export interface AI技能覆盖配置 {
  技能ID?: string;
  技能名: string;
  /** 技能生效后通过平台 API 写入的真实冷却；未配置时沿用物编冷却。 */
  冷却秒?: number;
  /** 阶段、难度等动态冷却；存在时优先于固定冷却。 */
  冷却秒读取器?: AI技能冷却读取器;
  目标选择方式?: AI目标选择方式;
  施法目标类型?: AI施法目标类型;
  最小施法距离?: number;
  最大施法距离?: number;
  最低生命百分比?: number;
  最高生命百分比?: number;
  最低魔法百分比?: number;
  最高魔法百分比?: number;
  权重?: number;
  禁用?: boolean;
  运行时可用条件?: AI技能运行时可用条件;
  说明?: string;
}

export interface 单位AI配置 {
  AI配置ID: string;
  单位ID?: string;
  单位名: string;
  归类: 单位AI归类;
  AI模式: 单位AI模式;
  检查间隔Ms?: number;
  公共施法间隔Ms?: number;
  默认施法距离?: number;
  扫描槽位数?: number;
  默认目标选择方式?: AI目标选择方式;
  技能覆盖?: AI技能覆盖配置[];
  说明?: string;
}
