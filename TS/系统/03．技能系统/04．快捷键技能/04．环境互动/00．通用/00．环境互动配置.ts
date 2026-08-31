/** @noSelfInFile */

/** 环境互动技能的统一配置入口。 */
export const 环境互动技能ID = "A08E";
export const 环境互动默认触发范围 = 300;

/** 施法后没有任何互动可取时，单独发给施法玩家的反馈。空挥是高频操作，文案保持轻量。 */
export const 环境互动空挥提示文本 = "这里似乎没什么可查的。";
/** 空挥提示的持续时间（毫秒）。 */
export const 环境互动空挥提示持续毫秒 = 2000;
/** 同一玩家的空挥提示冷却（毫秒），避免连续施法时刷屏。 */
export const 环境互动空挥提示冷却毫秒 = 3000;

/** 第二、三章环境互动直接装备奖励的统一成功概率。 */
export const 环境互动装备奖励概率 = 2 / 3;

export interface 环境互动触发点 {
  ID: string;
  X: number;
  Y: number;
  触发范围?: number;
  一次性?: boolean;
  /** 设置后，点位在前置条件满足后只允许判定一次，无论判定成功还是失败。 */
  一次性奖励概率?: number;
  /** 概率判定前执行；未满足时保留点位，不消耗本次判定。 */
  触发前置检查?: (this: void, 玩家ID: number, 施法单位: any, 触发点: 环境互动触发点) => boolean;
  提示文本?: string;
  延迟提示文本?: string;
  奖励物品ID?: string;
  触发回调: (this: void, 玩家ID: number, 施法单位: any, 触发点: 环境互动触发点) => boolean;
}
