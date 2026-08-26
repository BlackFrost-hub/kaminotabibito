/** @noSelfInFile */

/** 环境互动技能的统一配置入口。 */
export const 环境互动技能ID = "A08E";
export const 环境互动默认触发范围 = 300;

export interface 环境互动触发点 {
  ID: string;
  X: number;
  Y: number;
  触发范围?: number;
  一次性?: boolean;
  提示文本?: string;
  延迟提示文本?: string;
  奖励物品ID?: string;
  触发回调: (this: void, 玩家ID: number, 施法单位: any, 触发点: 环境互动触发点) => boolean;
}
