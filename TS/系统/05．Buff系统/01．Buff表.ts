// 自动生成 - Buff数据表
// 生成时间: 2026/3/28 19:59:38

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
  type: string;
  /** DOT/周期效果的伤害或检测间隔，单位：秒（如 1 表示每 1 秒一跳，需与 dot伤害 等逻辑一致） */
  interval: number;
  maxStack: number;
  /** 同类型并存规则，见文件顶部说明 */
  stackRule: 'stack' | 'independent' | 'highest';
  stackRefresh: boolean;
  dispelLevel: number;
  priority: number;
  canPurge: boolean;
  tooltip: string;
  [key: string]: string | number | boolean;
}

export const buffs: Record<string, BuffData> = {
  "D001": {
    buffID: "D001",
    buffName: "反恢复",
    icon: "ReplaceableTextures\\CommandButtons\\BTNLifeDrain.blp",
    effect: "Abilities\\Spells\\NightElf\\CorrosiveBreath\\ChimaeraAcidTargetArt.mdl",
    type: "Debuff:dot",
    interval: 1,
    maxStack: 1,
    stackRule: 'highest',
    stackRefresh: true,
    dispelLevel: 1,
    priority: 6,
    canPurge: true,
    tooltip: "该单位受到了『反恢复』，在持续时间秒内每interval秒造成damage点精神伤害。"
  },
  "D002": {
    buffID: "D002",
    buffName: "燃烧",
    icon: "BuffIcon\\DotRanShao.blp",
    effect: "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeDamageTarget.mdl",
    type: "Debuff:dot",
    interval: 1,
    maxStack: 1,
    stackRule: 'highest',
    stackRefresh: true,
    dispelLevel: 1,
    priority: 6,
    canPurge: true,
    tooltip: "该单位受到了『燃烧』，在持续时间秒内每interval秒造成damage点火属性伤害。"
  },
};

export default buffs;
