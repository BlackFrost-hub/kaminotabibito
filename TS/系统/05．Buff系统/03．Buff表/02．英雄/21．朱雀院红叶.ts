/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";

/**
 * 朱雀院红叶 - 英雄 Buff 表（B1 登记）
 * 图标：尚未完成专用 BLP 迁移，icon 使用已迁入的技能图标占位，不得写 PNG 路径（执行规则 5）。
 * 刀势/水镜/秘传的层数与窗口由红叶私有状态容器精确管理；Buff 只负责玩家识别与状态查询。
 */
export const 朱雀院红叶BuffID = {
  /** 破绽：敌方单一标记，允许红叶普攻触发破绽斩（目标身上的朱红断刃标记） */
  破绽: "E013",
  /** 刀势：红叶自身 0~3 层资源（层数变化由私有容器 + 层数特效互斥管理，Buff 层数同步刷新） */
  刀势: "E014",
  /** 水镜招架：W 真实招架窗口（短期自身状态） */
  水镜招架: "E015",
  /** 秘传三式：D 状态与剩余强化次数 */
  秘传三式: "E016",
} as const;

export const 朱雀院红叶Buff表: Record<string, BuffData> = {
  [朱雀院红叶BuffID.破绽]: {
    buffID: 朱雀院红叶BuffID.破绽,
    buffName: "破绽",
    icon: "ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiQ.blp",
    effect: "Common\\Effect\\Form\\Marker\\MomijiWeakPointBlade3D.mdx",
    effectMode: "attach",
    effectAttachPoint: "origin",
    effectScale: 1,
    type: "Debuff:physical:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 60,
    canPurge: true,
    tooltip: "朱雀院红叶普攻命中时触发破绽斩。",
  },
  [朱雀院红叶BuffID.刀势]: {
    buffID: 朱雀院红叶BuffID.刀势,
    buffName: "刀势",
    icon: "ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiQ.blp",
    effect: "",
    effectMode: "attach",
    effectAttachPoint: "origin",
    effectScale: 1,
    type: "Buff:physical:skill",
    interval: 0,
    maxStack: 3,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 70,
    canPurge: false,
    tooltip: "最多 3 层，可强化 Q/W/E/R。",
  },
  [朱雀院红叶BuffID.水镜招架]: {
    buffID: 朱雀院红叶BuffID.水镜招架,
    buffName: "水镜招架",
    icon: "ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiW.blp",
    effect: "",
    effectMode: "attach",
    effectAttachPoint: "origin",
    effectScale: 1,
    type: "Buff:physical:control",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: false,
    dispelLevel: 3,
    priority: 75,
    canPurge: false,
    tooltip: "正面招架窗口。",
  },
  [朱雀院红叶BuffID.秘传三式]: {
    buffID: 朱雀院红叶BuffID.秘传三式,
    buffName: "秘传三式",
    icon: "ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiD.blp",
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
    priority: 80,
    canPurge: false,
    tooltip: "剩余强化次数可强化 Q/W/E/R。",
  },
};
