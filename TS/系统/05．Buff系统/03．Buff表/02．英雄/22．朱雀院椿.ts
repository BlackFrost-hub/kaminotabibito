/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";

/**
 * 朱雀院椿 - 英雄 Buff 表（B1 登记）
 * 图标：椿技能图标仍为魔兽原生临时占位（执行计划固定基线），Buff 图标沿用原生占位，不得写 PNG 路径。
 * VF 吸收/姿态规则由私有状态容器与伤害修改入口精确管理；Buff 负责玩家识别与状态查询。
 */
export const 朱雀院椿BuffID = {
  /** VF 场：显示防护完整度（真实吸收由 registerDamageModifier 承担） */
  VF场: "E017",
  /** VF 残缺：防护破裂后的限制与恢复阶段 */
  VF残缺: "E018",
  /** 反击准备：下一次普攻/Q/E 可转化一次反击 */
  反击准备: "E019",
  /** 一刀守势：防守姿态（与二刀攻势互斥） */
  一刀守势: "E01A",
  /** 二刀攻势：攻势姿态（有限 VF 消耗，与一刀守势互斥） */
  二刀攻势: "E01B",
  /** 决斗距离：E 建立的短时距离窗口，供 R 读取 */
  决斗距离: "E01C",
} as const;

export const 朱雀院椿Buff表: Record<string, BuffData> = {
  [朱雀院椿BuffID.VF场]: {
    buffID: 朱雀院椿BuffID.VF场,
    buffName: "VF场",
    icon: "ReplaceableTextures\\CommandButtons\\HeroBuff\\Tsubaki\\BTNTsubakiVFChang.blp",
    effect: "Common\\Effect\\Form\\Shield\\TsubakiVFBarrier.mdx",
    effectMode: "attach",
    effectAttachPoint: "origin",
    effectScale: 1,
    type: "Buff:physical:shield",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 70,
    canPurge: false,
    tooltip: "VF 场按真实值吸收伤害（上限 250）；低于阈值进入 VF 残缺。",
  },
  [朱雀院椿BuffID.VF残缺]: {
    buffID: 朱雀院椿BuffID.VF残缺,
    buffName: "VF残缺",
    icon: "ReplaceableTextures\\CommandButtons\\HeroBuff\\Tsubaki\\BTNTsubakiVFCanQue.blp",
    effect: "Common\\Effect\\Form\\Shield\\TsubakiVFCracked.mdx",
    effectMode: "attach",
    effectAttachPoint: "origin",
    effectScale: 1,
    type: "Debuff:physical:shield",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: false,
    dispelLevel: 3,
    priority: 75,
    canPurge: false,
    tooltip: "VF 场残缺，防护下降；一刀守势下 VF 恢复（每秒 15 点）到阈值后解除。",
  },
  [朱雀院椿BuffID.反击准备]: {
    buffID: 朱雀院椿BuffID.反击准备,
    buffName: "反击准备",
    icon: "ReplaceableTextures\\CommandButtons\\HeroBuff\\Tsubaki\\BTNTsubakiFanJiZhunBei.blp",
    effect: "",
    effectMode: "attach",
    effectAttachPoint: "origin",
    effectScale: 1,
    type: "Buff:physical:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 72,
    canPurge: false,
    tooltip: "下一次普攻/Q/E 触发后转化为反击（攻击力100%物理伤害）。",
  },
  [朱雀院椿BuffID.一刀守势]: {
    buffID: 朱雀院椿BuffID.一刀守势,
    buffName: "一刀守势",
    icon: "ReplaceableTextures\\CommandButtons\\HeroBuff\\Tsubaki\\BTNTsubakiYiDaoShouShi.blp",
    effect: "Common\\Effect\\Form\\Rotate\\TsubakiIchiGuard.mdx",
    effectMode: "attach",
    effectAttachPoint: "origin",
    effectScale: 1,
    type: "Buff:physical:stance",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 80,
    canPurge: false,
    tooltip: "守势：VF 每秒恢复 15 点，受击减半。",
  },
  [朱雀院椿BuffID.二刀攻势]: {
    buffID: 朱雀院椿BuffID.二刀攻势,
    buffName: "二刀攻势",
    icon: "ReplaceableTextures\\CommandButtons\\HeroBuff\\Tsubaki\\BTNTsubakiErDaoGongShi.blp",
    effect: "Common\\Effect\\Form\\Rotate\\TsubakiNitoAssault.mdx",
    effectMode: "attach",
    effectAttachPoint: "origin",
    effectScale: 1,
    type: "Buff:physical:stance",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 80,
    canPurge: false,
    tooltip: "攻势：攻击强化，每秒消耗 4 点 VF，归零自动回一刀守势。",
  },
  // 决斗距离为内部状态（E 建立、R 读取），规划明确不进玩家 Buff 栏，不登记 Buff 表
};
