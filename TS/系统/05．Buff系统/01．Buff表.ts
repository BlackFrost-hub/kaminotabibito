// 自动生成 - Buff数据表
// 生成时间: 2026/3/29 17:41:20

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
    priority: 7,
    canPurge: true,
    tooltip: "该单位受到了『反恢复』，在持续时间秒内每1秒造成damage点精神伤害。"
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
    priority: 5,
    canPurge: true,
    tooltip: "该单位受到了『燃烧』，在持续时间秒内每1秒造成damage点火属性伤害。"
  },
  "D003": {
    buffID: "D003",
    buffName: "中毒",
    icon: "BuffIcon\\Dotzhongdu.blp",
    effect: "Abilities\\Weapons\\PoisonSting\\PoisonStingTarget.mdl",
    type: "Debuff:dot",
    interval: 1,
    maxStack: 1,
    stackRule: 'highest',
    stackRefresh: true,
    dispelLevel: 1,
    priority: 5,
    canPurge: true,
    tooltip: "该单位受到了『中毒』，在持续时间秒内每1秒造成damage点金属性伤害。"
  },
  "D004": {
    buffID: "D004",
    buffName: "巨魔头颅诅咒",
    icon: "BuffIcon\\Dot3jumotoulu.blp",
    effect: "Abilities\\Weapons\\PoisonSting\\PoisonStingTarget.mdl",
    type: "Debuff:dot",
    interval: 1,
    maxStack: 1,
    stackRule: 'highest',
    stackRefresh: true,
    dispelLevel: 1,
    priority: 5,
    canPurge: true,
    tooltip: "该单位受到了『巨魔头颅诅咒』，在持续时间秒内每1秒造成damage点物理伤害。"
  },
};

export default buffs;
