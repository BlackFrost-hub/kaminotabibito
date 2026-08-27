/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";

/**
 * 塞莉亚·克莱尔 - 英雄 Buff 表（A2/A9 登记）
 *
 * Rawcode 取 E01H-E01K：E00D-E01G 已被既有英雄占用，本表为下一段空闲编号。
 * 图标为魔兽原生占位；节点坐标、连接锁与目标去重键保留私有状态不入 Buff。
 */
export const 塞莉亚BuffID = {
  /** 演算魔弹（自身短期增益：下一次普攻将追加演算效果） */
  演算魔弹: "E01H",
  /** 解析结界（自身增益：W 真实保护窗口） */
  解析结界: "E01I",
  /** 锚定魔法阵（区域减益：阵内目标减速标记） */
  锚定魔法阵: "E01J",
  /** 高阶术式蓄力（自身短期状态：R 蓄力与快照锁定阶段） */
  高阶术式蓄力: "E01K",
} as const;

export const 塞莉亚Buff表: Record<string, BuffData> = {
  [塞莉亚BuffID.演算魔弹]: {
    buffID: 塞莉亚BuffID.演算魔弹,
    buffName: "演算魔弹",
    icon: "ReplaceableTextures\\CommandButtons\\BTNOrbOfDarkness.blp",
    effect: "",
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 2,
    stackRule: "stack",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 80,
    canPurge: false,
    tooltip: "下一次普攻将完成一次演算：命中节点或连接附近敌人时追加计算伤害。",
  },
  [塞莉亚BuffID.解析结界]: {
    buffID: 塞莉亚BuffID.解析结界,
    buffName: "解析结界",
    icon: "ReplaceableTextures\\CommandButtons\\BTNHumanArmorUpThree.blp",
    effect: "",
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 90,
    canPurge: false,
    tooltip: "解析结界的保护窗口：解析并削弱一次主要攻击。",
  },
  [塞莉亚BuffID.锚定魔法阵]: {
    buffID: 塞莉亚BuffID.锚定魔法阵,
    buffName: "锚定魔法阵",
    icon: "ReplaceableTextures\\CommandButtons\\BTNFaerieFire.blp",
    effect: "",
    type: "Debuff:magic:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 85,
    canPurge: true,
    tooltip: "处于锚定术式范围内：停留过久将被锁定束缚。",
  },
  [塞莉亚BuffID.高阶术式蓄力]: {
    buffID: 塞莉亚BuffID.高阶术式蓄力,
    buffName: "高阶术式蓄力",
    icon: "ReplaceableTextures\\CommandButtons\\BTNSpellBreakerAura.blp",
    effect: "",
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 92,
    canPurge: false,
    tooltip: "正在展开高阶术式：节点与连接快照已锁定。",
  },
};

export {};
