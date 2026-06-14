/** @noSelfInFile */

export const 首领奖励最少选项数 = 1;
export const 首领奖励最多选项数 = 7;

export interface 首领奖励选项配置 {
  /** 装备数据里的 name，运行时再走物品名反查，不手写 raw id。 */
  装备名: string;
  排序: number;
  图标: string;
  描述: string;
  特效: string;
}

export interface 首领奖励池配置 {
  奖励池ID: string;
  标题: string;
  可选数量: number;
  选项: 首领奖励选项配置[];
}

export interface 首领奖励领取记录 {
  奖励池ID: string;
  玩家ID: number;
  已选装备名: string[];
}

export const 首领奖励发放结果 = {
  成功: "成功",
  奖励池不存在: "奖励池不存在",
  选项数量越界: "选项数量越界",
  可选数量无效: "可选数量无效",
  选择数量无效: "选择数量无效",
  选择不在奖励池: "选择不在奖励池",
  已领取: "已领取",
} as const;

export type 首领奖励发放结果 =
  typeof 首领奖励发放结果[keyof typeof 首领奖励发放结果];
