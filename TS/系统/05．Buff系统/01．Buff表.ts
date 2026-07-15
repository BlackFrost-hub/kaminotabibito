// 自动生成 - Buff数据表
// 生成时间: 2026/3/29 17:41:20

import { 分类Buff表 } from "./03．Buff表";

/**
 * stackRule（同类型 Buff 并存时的规则）——表意与实现需一致：
 * - **stack**：叠加层数。多个同类型 Buff 合并层数，效果按层数/规则累加（配合 maxStack）。
 * - **independent**：独立生效。多个同类型 Buff 各自独立计时/触发，互不影响。
 * - **highest**：取最高值。多个同类型 Buff 只保留效果最强的那一条（其余按业务覆盖或忽略）。
 */
export interface BuffData {
  buffID: string;
  buffName: string;
  icon: string;
  effect: string;
  effectMode?: 'attach' | 'point';
  effectAttachPoint?: string;
  effectScale?: number;
  type: string;
  interval: number;
  maxStack: number;
  /** 同类型并存规则，见文件顶部说明 */
  stackRule: 'stack' | 'independent' | 'highest';
  stackRefresh: boolean;
  dispelLevel: number;
  priority: number;
  canPurge: boolean;
  /** 为 true 时，该 Buff 会阻止冲锋、跳跃、闪烁等自身位移技能。 */
  禁止位移?: boolean;
  tooltip: string;
  [key: string]: string | number | boolean | undefined;
}

export const buffs: Record<string, BuffData> = {
  ...分类Buff表,
};

export default buffs;
