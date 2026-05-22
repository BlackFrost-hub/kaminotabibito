/** @noSelfInFile */

export type 单位技能归类 = "杂鱼" | "精英" | "Boss" | "英雄";
export type 单位技能触发方式 = "初始化" | "被动" | "主动" | "周期" | "受伤" | "攻击" | "死亡" | "阶段";

export interface 单位技能配置 {
  技能ID: string;
  技能名: string;
  归类: 单位技能归类;
  触发方式: 单位技能触发方式;
  说明?: string;
  单位类型列表?: Array<string | number>;
  初始化函数?: string;
  配置数据?: Record<string, any>;
}
