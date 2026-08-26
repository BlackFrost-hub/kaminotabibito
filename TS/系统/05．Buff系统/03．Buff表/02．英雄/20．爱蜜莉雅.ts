/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";

/**
 * 爱蜜莉雅 - 英雄 Buff 表（A2/A7 登记）
 * 图标：尚未完成 BLP 迁移，icon 使用项目占位原生图标，不得写 PNG 路径（执行规则 5）。
 */
export const 爱蜜莉雅BuffID = {
  /** 寒意叠层（3 层触发冻结；轻量标记，不创建重型特效） */
  寒意: "E00D",
  /** 冻结（真实控制：具名暂停 + 冰壳表现；与抗性窗口联动） */
  冻结: "E00E",
  /** 霜裂（冻结结束后的短期标记；下一次技能伤害触发碎冰） */
  霜裂: "E00F",
  /** E 冰晶护身（护盾状态） */
  冰晶护身: "E010",
  /** 普攻契约应和（3 次有效普攻触发帕克追击） */
  契约应和: "E011",
  /** D 帕克显现（协战状态与剩余强化次数） */
  帕克显现: "E012",
} as const;

export const 爱蜜莉雅Buff表: Record<string, BuffData> = {
  [爱蜜莉雅BuffID.寒意]: {
    buffID: 爱蜜莉雅BuffID.寒意,
    buffName: "寒意",
    icon: "ReplaceableTextures\\CommandButtons\\BTNFrostNova.blp",
    effect: "Common\\Effect\\Element\\Ice\\sem_shen_du_dong_jie.mdx",
    effectMode: "attach",
    effectAttachPoint: "origin",
    effectScale: 0.4,
    type: "Debuff:magic:skill",
    interval: 0,
    maxStack: 3,
    stackRule: "stack",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 80,
    canPurge: true,
    tooltip: "寒意叠至 3 层时冻结目标。",
  },
  [爱蜜莉雅BuffID.冻结]: {
    buffID: 爱蜜莉雅BuffID.冻结,
    buffName: "冻结",
    icon: "ReplaceableTextures\\CommandButtons\\BTNFreezingBreath.blp",
    effect: "Common\\Effect\\Element\\Ice\\sem_shen_du_dong_jie.mdx",
    effectMode: "attach",
    effectAttachPoint: "origin",
    effectScale: 1,
    type: "Debuff:magic:control",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: false,
    dispelLevel: 3,
    priority: 95,
    canPurge: false,
    tooltip: "目标被冰封，无法行动。",
  },
  [爱蜜莉雅BuffID.霜裂]: {
    buffID: 爱蜜莉雅BuffID.霜裂,
    buffName: "霜裂",
    icon: "ReplaceableTextures\\CommandButtons\\BTNBlizzard.blp",
    effect: "Common\\Effect\\Element\\Ice\\sem_bing_xi_mo_fa.mdx",
    effectMode: "attach",
    effectAttachPoint: "origin",
    effectScale: 0.6,
    type: "Debuff:magic:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: false,
    dispelLevel: 3,
    priority: 85,
    canPurge: true,
    tooltip: "霜裂状态：下一次爱蜜莉雅技能伤害触发碎冰。",
  },
  [爱蜜莉雅BuffID.冰晶护身]: {
    buffID: 爱蜜莉雅BuffID.冰晶护身,
    buffName: "冰晶护身",
    icon: "ReplaceableTextures\\CommandButtons\\BTNIceArmor.blp",
    effect: "Common\\Effect\\Element\\Ice\\BY_Wood_Effect_Kula_3_BingGuan.mdx",
    effectMode: "attach",
    effectAttachPoint: "origin",
    effectScale: 1,
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 90,
    canPurge: false,
    tooltip: "冰晶护身：吸收伤害，结束后冰爆。",
  },
  [爱蜜莉雅BuffID.契约应和]: {
    buffID: 爱蜜莉雅BuffID.契约应和,
    buffName: "契约应和",
    icon: "ReplaceableTextures\\CommandButtons\\BTNWaterElemental.blp",
    effect: "",
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 3,
    stackRule: "stack",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 80,
    canPurge: false,
    tooltip: "第 3 次有效普攻触发帕克追击。",
  },
  [爱蜜莉雅BuffID.帕克显现]: {
    buffID: 爱蜜莉雅BuffID.帕克显现,
    buffName: "帕克显现",
    icon: "ReplaceableTextures\\CommandButtons\\BTNWaterElemental.blp",
    effect: "Common\\Effect\\Element\\Ice\\icespirits.mdx",
    effectMode: "attach",
    effectAttachPoint: "origin",
    effectScale: 1,
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 90,
    canPurge: false,
    tooltip: "帕克协战：获得强化机会，强化 Q/W/E/R。",
  },
};

export {};
