/** @noSelfInFile */

export type 单位AI归类 = "杂鱼" | "精英" | "Boss" | "英雄Boss" | "异界Boss";
export type 单位AI模式 = "自动扫描通魔" | "固定技能表";
export type AI目标选择方式 = "最高仇恨" | "自己" | "当前攻击目标" | "最近敌人";
export type AI施法目标类型 = "自动" | "无目标" | "自己" | "单位" | "点" | "单位或点";

export interface AI技能覆盖配置 {
  技能ID?: string;
  技能名: string;
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
