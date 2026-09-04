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
    icon: "ReplaceableTextures\\CommandButtons\\HeroBuff\\Celia\\BTNCeliaYanSuanMoDan.blp",
    effect: "",
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 2,
    stackRule: "stack",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 80,
    canPurge: false,
    tooltip: "下一次普攻为演算魔弹：命中节点或连接附近敌人时追加最高攻击力 60% 的魔法伤害。",
  },
  [塞莉亚BuffID.解析结界]: {
    buffID: 塞莉亚BuffID.解析结界,
    buffName: "解析结界",
    icon: "ReplaceableTextures\\CommandButtons\\HeroBuff\\Celia\\BTNCeliaJieXiJieJie.blp",
    effect: "",
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 90,
    canPurge: false,
    tooltip: "解析结界 4 秒：化解一次主要攻击并反冲来源；结束时减速。",
  },
  [塞莉亚BuffID.锚定魔法阵]: {
    buffID: 塞莉亚BuffID.锚定魔法阵,
    buffName: "锚定魔法阵",
    icon: "ReplaceableTextures\\CommandButtons\\HeroBuff\\Celia\\BTNCeliaMaoDingFaFaZhen.blp",
    effect: "",
    type: "Debuff:magic:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 85,
    canPurge: true,
    tooltip: "锚定术式 4 秒：范围内停留 1.8 秒被定身 1.2 秒（减速 35%、持续 2 秒）。",
  },
  // 高阶术式蓄力为内部状态（R 蓄力窗口），规划明确不进玩家 Buff 栏，蓄力由读条与充能 UI 表达
};

export {};
